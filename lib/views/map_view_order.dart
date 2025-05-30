import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:provider/provider.dart';
import 'package:latlong2/latlong.dart';
import 'package:usuario_inri/animation/onda_class.dart';
import 'package:usuario_inri/blocs/blocs.dart';
import 'package:usuario_inri/blocs/searchBar/search_bar_bloc.dart';
import 'package:usuario_inri/blocs/tarifario/tarifario_bloc.dart';
import 'package:usuario_inri/service/calcular_precio.dart';
import 'dart:math' as math;
import 'package:usuario_inri/service/reverse_geocoding.dart';
import 'package:usuario_inri/widgets/buttons/profile.dart';
import 'dart:async';
import 'package:usuario_inri/widgets/searchBar/search_bar.dart';


class MapViewOrder extends StatefulWidget {
  final LatLng initialLocation;

  const MapViewOrder({
    super.key,
    required this.initialLocation,
  });

  @override
  State<MapViewOrder> createState() => _MapViewOrderState();
}

class _MapViewOrderState extends State<MapViewOrder> {
  late final MapController _mapController;
  LatLng? selectedDestination;
  bool showDestinationPin = false;
  bool destinationConfirmed = false;
  double? distanceInKm;
  Timer? _debounceTimer;
  LatLng? _lastDestination;

  final _precioService = CalcularPrecioService();
  double? precioDelViaje;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    context.read<MapBloc>().add(OnMapInitializeEvent(_mapController));
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //USUARIO BLOC
    final usuario = Provider.of<AuthBloc>(context).state.usuario;
    if (usuario == null) return Container();

    //MAP BLOC
    final mapBloc = BlocProvider.of<MapBloc>(context);
    //LOCATION BLOC
    final locationBloc = BlocProvider.of<LocationBloc>(context);
    final myLocation = locationBloc.state.lastKnownLocation!;
    //ADDRESS BLOC
    final driverCoordinates = context.select<AddressBloc, List<double>?>(
      (bloc) => bloc.state.orderUser?.mensaje?.coordinates,
    );

    final driverlocation = driverCoordinates ?? [0.0, 0.0];

    final center = (() {
      final LatLng calculated = mapBloc.bounds(driverlocation);
      return calculated;
    })();

    final isDriverAssigned = context.read<AddressBloc>().state.isTripActive;
    final size = MediaQuery.of(context).size;

    return SizedBox(
      width: size.width,
      height: size.height,
      child: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: center,
              minZoom: 1.0,
              maxZoom: 20.0,
              onTap: (tapPosition, point) async {
                final addressState = context.read<AddressBloc>().state;
                final order = addressState.orderUser;

                final yaTieneConductor = order?.idDriver?.isNotEmpty == true;
                final esperandoConductor = addressState.isWaitingDriver == true;

                if (yaTieneConductor || esperandoConductor) {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          yaTieneConductor
                              ? 'Ya tienes un conductor asignado. Si quieres cambiar el destino, debes cancelar el viaje'
                              : 'Estás esperando un conductor. Si quieres cambiar el destino, cancela el viaje',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.normal),
                        ),
                        backgroundColor: Colors.black,
                      ),
                    );
                  }
                  return;
                }

                if (_lastDestination == null || _lastDestination != point) {
                  final distance = await getDistanceFromMapbox(
                    origin: myLocation,
                    destination: point,
                    accessToken: usuario.tokenMapBox,
                  );

                  _lastDestination = point;

                  if (mounted) {
                    setState(() {
                      selectedDestination = point;
                      showDestinationPin = true;
                      destinationConfirmed = false;
                      distanceInKm = distance;
                    });
                  }
                }
              },
            ),
            children: [
              TileLayer(
                urlTemplate: usuario.urlMapbox,
                additionalOptions: {
                  'accessToken': usuario.tokenMapBox,
                  'id': usuario.idMapBox,
                },
              ),
              MarkerLayer(
                markers: [
                  RippleMarker(
                    position: myLocation,
                    iconPath: 'assets/icon.webp',
                    size: 70,
                  ).build(),
                  if (driverlocation.isNotEmpty && isDriverAssigned)
                    RippleMarker(
                      position: LatLng(driverlocation[1], driverlocation[0]),
                      iconPath: 'assets/driver.webp',
                      size: 90,
                    ).build(),
                  if (showDestinationPin && selectedDestination != null)
                    Marker(
                      point: selectedDestination!,
                      width: 200,
                      height: destinationConfirmed ? 110 : 140,
                      child: Builder(
                        builder: (context) {
                          return Column(
                            children: [
                              if (!destinationConfirmed)
                                GestureDetector(
                                  onTap: () {
                                    showModalBottomSheet(
                                      context: context,
                                      builder: (modalContext) => Padding(
                                        padding: const EdgeInsets.all(20.0),
                                        child: Builder(builder: (modalContext) {
                                          return Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              const Text(
                                                  '¿Confirmar este destino?'),
                                              const SizedBox(height: 10),
                                              ElevatedButton.icon(
                                                icon: const Icon(Icons.check),
                                                label:
                                                    const Text('Sí, confirmar'),
                                                onPressed: () async {
                                                  final tarifarioState =
                                                      modalContext
                                                          .read<TarifarioBloc>()
                                                          .state;
                                                  try {
                                                    double? distance;

                                                    if (_lastDestination ==
                                                            null ||
                                                        _lastDestination !=
                                                            selectedDestination) {
                                                      distance =
                                                          await getDistanceFromMapbox(
                                                        origin: myLocation,
                                                        destination:
                                                            selectedDestination!,
                                                        accessToken:
                                                            usuario.tokenMapBox,
                                                      );

                                                      _lastDestination =
                                                          selectedDestination;
                                                    } else {
                                                      distance = distanceInKm;
                                                    }
                                                    if (!modalContext.mounted) return;

                                                    if (selectedDestination !=
                                                        null) {
                                                      modalContext
                                                          .read<AddressBloc>()
                                                          .add(OnGuardarDestinoEvent(
                                                              selectedDestination!));
                                                    }

                                                    if (!mounted) return;

                                                    if (tarifarioState
                                                            is TarifarioLoaded &&
                                                        distance != null) {
                                                      final tarifas =
                                                          tarifarioState
                                                              .tarifas;

                                                      final precio =
                                                          _precioService
                                                              .calcularPrecio(
                                                        distanciaKm: distance,
                                                        tarifas: tarifas,
                                                      );

                                                      setState(() {
                                                        destinationConfirmed =
                                                            true;
                                                        distanceInKm = distance;
                                                        precioDelViaje =
                                                            precio.toDouble();
                                                      });

                                                      if (!modalContext.mounted) return;

                                                      modalContext
                                                          .read<AddressBloc>()
                                                          .add(
                                                            OnGuardarResumenViajeEvent(
                                                              distanciaKm:
                                                                  distance,
                                                              precio: precio
                                                                  .toDouble(),
                                                            ),
                                                          );
                                                    }

                                                    Navigator.of(modalContext)
                                                        .pop();
                                                  } catch (e) {
                                                    if (mounted) {
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                        const SnackBar(
                                                          content: Text(
                                                              'Error al confirmar destino'),
                                                        ),
                                                      );
                                                    }
                                                  }
                                                },
                                              ),
                                            ],
                                          );
                                        }),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 5),
                                    margin: const EdgeInsets.only(bottom: 5),
                                    decoration: BoxDecoration(
                                      color: const Color.fromARGB(
                                          255, 92, 36, 247),
                                      borderRadius: BorderRadius.circular(15),
                                      boxShadow: const [
                                        BoxShadow(
                                          color:
                                              Color.fromARGB(255, 52, 51, 51),
                                          blurRadius: 4,
                                          offset: Offset(0, 2),
                                        )
                                      ],
                                    ),
                                    child: const Text(
                                      'Confirmar destino',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              if (destinationConfirmed && distanceInKm != null)
                                Stack(
                                  clipBehavior: Clip.none,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 6),
                                      margin: const EdgeInsets.only(bottom: 5),
                                      constraints: BoxConstraints(
                                        maxWidth:
                                            MediaQuery.of(context).size.width *
                                                0.6,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.black87,
                                        borderRadius: BorderRadius.circular(15),
                                        boxShadow: const [
                                          BoxShadow(
                                            color: Colors.black45,
                                            blurRadius: 4,
                                            offset: Offset(0, 2),
                                          )
                                        ],
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Distancia: ${distanceInKm!.toStringAsFixed(2)} km',
                                            style: const TextStyle(
                                                color: Colors.white),
                                          ),
                                          if (precioDelViaje != null)
                                            Text(
                                              'Precio estimado: \$${precioDelViaje!.toStringAsFixed(0)}',
                                              style: const TextStyle(
                                                  color: Colors.white),
                                            ),
                                        ],
                                      ),
                                    ),
                                    Positioned(
                                      top: -8,
                                      right: -8,
                                      child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            selectedDestination = null;
                                            showDestinationPin = false;
                                            destinationConfirmed = false;
                                            distanceInKm = null;
                                            _lastDestination = null;
                                          });
                                        },
                                        child: Container(
                                          decoration: const BoxDecoration(
                                            color: Colors.redAccent,
                                            shape: BoxShape.circle,
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black38,
                                                blurRadius: 3,
                                              ),
                                            ],
                                          ),
                                          padding: const EdgeInsets.all(4),
                                          child: const Icon(
                                            Icons.close,
                                            color: Colors.white,
                                            size: 14,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              GestureDetector(
                                onPanUpdate: (details) {
                                  if (selectedDestination == null) return;

                                  final map = _mapController.camera;
                                  final currentPoint = map.latLngToScreenPoint(
                                      selectedDestination!);
                                  final offsetAsPoint = math.Point<double>(
                                    currentPoint.x + details.delta.dx,
                                    currentPoint.y + details.delta.dy,
                                  );
                                  final newPoint =
                                      map.pointToLatLng(offsetAsPoint);

                                  setState(() {
                                    selectedDestination = newPoint;
                                  });

                                  _debounceTimer?.cancel();
                                  _debounceTimer = Timer(
                                    const Duration(milliseconds: 500),
                                    () async {
                                      if (_lastDestination == null ||
                                          _lastDestination != newPoint) {
                                        try {
                                          final distance =
                                              await getDistanceFromMapbox(
                                            origin: myLocation,
                                            destination: newPoint,
                                            accessToken: usuario.tokenMapBox,
                                          );

                                          _lastDestination = newPoint;

                                          if (mounted && destinationConfirmed) {
                                            setState(() {
                                              distanceInKm = distance;
                                            });
                                          }
                                        } catch (e) {
                                          if (context.mounted) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                  content: Text(
                                                      'Error al calcular distancia')),
                                            );
                                          }
                                        }
                                      }
                                    },
                                  );
                                },
                                child: const Icon(
                                  Icons.location_on,
                                  size: 45,
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                ],
              ),
            ],
          ),
         BlocProvider(
          create: (_) => SearchBarBloc(authBloc: context.read<AuthBloc>()),
          child: SearchBarWidget(
          onSearch: (direccion, coords) {
          // Ejemplo de uso
          showModalBottomSheet(
    context: context,
    builder: (modalContext) => Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('¿Confirmar este destino?'),
          const SizedBox(height: 10),
          ElevatedButton.icon(
            icon: const Icon(Icons.check),
            label: const Text('Sí, confirmar'),
            onPressed: () async {
              final tarifarioState = modalContext.read<TarifarioBloc>().state;

              context.read<AddressBloc>().add(OnGuardarDestinoEvent(coords));

              if (!mounted) return;

              if (tarifarioState is TarifarioLoaded) {
                final tarifas = tarifarioState.tarifas;

                final distance = await getDistanceFromMapbox(
                  origin: context.read<LocationBloc>().state.lastKnownLocation!,
                  destination: coords,
                  accessToken: context.read<AuthBloc>().state.usuario!.tokenMapBox,
                );
                if (!context.mounted) return;
                final precio = CalcularPrecioService().calcularPrecio(
                  distanciaKm: distance,
                  tarifas: tarifas,
                );

                context.read<AddressBloc>().add(OnGuardarResumenViajeEvent(
                  distanciaKm: distance,
                  precio: precio.toDouble(),
                ));

                // Actualiza el mapa con animación
                _mapController.move(coords, _mapController.camera.zoom);
              }

              Navigator.of(modalContext).pop();
            },
          ),
        ],
      ),
    ),
  );
         },
        
          )
         ),

         Positioned(
         top: 30,
         left: 10,
         child: Material(
           elevation: 8,
           child: Container(
             height: 30,
             width: 32,
             decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(4.5),
             ),
             child: IconButton(
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
             icon: const Icon(Icons.menu, size: 24, color: Colors.black87),
             onPressed: () {
             ProfileMenuModal.show(context);
              },
           
           
             ),
           ),
         ),
         ), 

        ],
      ),
    );
  }


}
