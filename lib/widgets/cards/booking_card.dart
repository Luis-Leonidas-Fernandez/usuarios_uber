import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:usuario_inri/animation/dragable_card.dart';
import 'package:usuario_inri/blocs/blocs.dart';
import 'package:usuario_inri/constants/constants.dart';
import 'package:usuario_inri/service/message_service.dart';
import 'package:usuario_inri/widgets/buttons/btn_reusable.dart';
import 'package:usuario_inri/widgets/car.dart';
import 'package:usuario_inri/widgets/cards/container_detail.dart';
import 'package:usuario_inri/widgets/chronometre/cronometro.dart';
import 'package:usuario_inri/widgets/cards/presentation_container.dart';
import 'package:usuario_inri/widgets/widgets.dart';

class BookingCard extends StatefulWidget {
  const BookingCard({super.key});

  @override
  State<BookingCard> createState() => _BookingCardState();
}

class _BookingCardState extends State<BookingCard> {
  final MessageService messageService = MessageService();

  @override
  Widget build(BuildContext context) {
    //final screenWidth = MediaQuery.of(context).size.width;
    //final screenHeight = MediaQuery.of(context).size.height;
    //final isSmallScreen = screenHeight <= 780;

    //final sectionSpacing = isSmallScreen ? 6.0 : 10.0;
    //final horizontalPadding = screenWidth < 375 ? 15.0 : 20.0;

    final locationBloc = BlocProvider.of<LocationBloc>(context);

    return DraggableCard(
      startTopFactor: 0.47,
      dragPercent: 0.35,
      child: LayoutBuilder(
        
          builder: (BuildContext context, BoxConstraints constraints) { 
            final screenWidth = constraints.maxWidth; 
            final screenHeight = constraints.maxHeight;
            final isSmallScreen = screenHeight <= 780;

            final sectionSpacing = isSmallScreen ? 6.0 : 10.0;
            final horizontalPadding = screenWidth < 375 ? 15.0 : 20.0;

            return Container(
          constraints: const BoxConstraints(maxHeight: 550),
          decoration: _decorationContainerBookingCard(),
          child: BlocListener<LocationBloc, LocationState>(
            listenWhen: (previous, current) =>
                previous.lastKnownLocation != current.lastKnownLocation,
            listener: (context, state) {
              final ubicacion = state.lastKnownLocation;
              final addressState = context.read<AddressBloc>().state;
              final hasDriverArrived =
                  addressState.orderUser?.order == 'llego-conductor';
        
              if (ubicacion != null && hasDriverArrived) {
                context.read<PrecioDistanciaBloc>().add(
                      ActualizarUbicacionEvent(ubicacion: ubicacion),
                    );
              }
            },
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                // Fondo degradado inferior
                Positioned(
                  top: 290,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 260,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppConstants.cardColor.withAlpha(2),
                          AppConstants.cardColor,
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.center,
                      ),
                    ),
                  ),
                ),
        
                const Positioned(
                  top: -60,
                  left: 0,
                  right: 0,
                  child: AbsorbPointer(
                    absorbing: false,
                    child: SizedBox(
                      height: 110,
                      child: CarImage(),
                    ),
                  ),
                ),
                Positioned(
                  top: 80,
                  left: 20,
                  child: BlocListener<AddressBloc, AddressState>(
                    listenWhen: (previous, current) {
                      final prevInicio =
                          previous.orderUser?.horaEsperaInicio?.toIso8601String();
                      final currInicio =
                          current.orderUser?.horaEsperaInicio?.toIso8601String();
        
                      final prevFin =
                          previous.orderUser?.horaEsperaFin?.toIso8601String();
                      final currFin =
                          current.orderUser?.horaEsperaFin?.toIso8601String();
        
                      return prevInicio != currInicio || prevFin != currFin;
                    },
                    listener: (context, state) {
                      final horaInicio = state.orderUser?.horaEsperaInicio;
                      final cronometroBloc = context.read<CronometroBloc>();
                      final order = state.orderUser;
                      //final horaFin = order?.horaEsperaFin;
        
                      // Si ya es "llego-conductor" pero no hay hora, arrancamos igualmente
                      if (order != null &&
                          order.order == 'llego-conductor' &&
                          horaInicio != null &&
                          state.orderUser?.horaEsperaInicio != null) {
                        cronometroBloc
                            .add(StartCronometroEvent(horaInicio: horaInicio));
                      }
        
                      if (order?.horaEsperaFin != null) {
                        context
                            .read<CronometroBloc>()
                            .add(const StopCronometroEvent());
                      }
                    },
                    child: const CronometroWidget(),
                  ),
                ),
        
                // Título y cupón
                Positioned(
                  top: 50,
                  left: 20,
                  child: BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, stateAuth) {
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Detalle Viaje',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(width: screenWidth <= 370 ? 55 : 90),
                          Row(
                            children: const [
                              Icon(Icons.discount_rounded, color: Colors.white),
                              SizedBox(width: 10),
                              Text(
                                'Cupon',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(width: 5),
                              Text(
                                '\$ 0',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                  ),
                ),
        
                // Contenido dinámico
                Positioned(
                  top: sectionSpacing * 12.0,
                  left: horizontalPadding,
                  right: horizontalPadding,
                  bottom: 20,
                  child: SizedBox(
                    height: screenHeight * 0.5,
                    child: ListView(padding: EdgeInsets.zero, children: [
                      const SizedBox(height: 10),
                      BlocBuilder<AddressBloc, AddressState>(
                        builder: (context, stateAddress) {

        
                          final order = stateAddress.orderUser;
        
                          if (stateAddress.isWaitingDriver == true &&
                              order?.id?.isNotEmpty == true) {
                            return TimeLineAddress();
                          }
        
                          if (stateAddress.isTripActive == true &&
                              order?.id?.isNotEmpty == true) {
                            return ContainerDetail();
                          }
        
                          if (stateAddress.isTripFinished == true ) {
                            return PresentationContainer();
                          }
        
                          return const SizedBox.shrink();
                        },
                      ),
        
                      const SizedBox(height: 18),
                      // Botón dinámico
                      _buttonsPedirFinalizar(
                          screenHeight, isSmallScreen, locationBloc),
                    ]),
                  ),
                ),
              ],
            ),
          ),
        );
           },
      ),
    );
  }

  Widget _buttonsPedirFinalizar(
      double screenHeight, bool isSmallScreen, LocationBloc locationBloc) {
    return BlocBuilder<AddressBloc, AddressState>(
      builder: (context, stateAddress) {
        const horizontalMargin = 0.0;

        // 🔴 No hay viaje activo
        if (stateAddress.isTripFinished == true &&
            stateAddress.orderUser?.distanciaKm != null &&
            stateAddress.orderUser?.precio != null ) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: horizontalMargin),
            child: ButtonReusable(
              text: 'Pedir Ahora',
              onPressed: () async {
                final myLocation = locationBloc.state.lastKnownLocation;
                if (myLocation == null) return;

                context
                    .read<CronometroBloc>()
                    .add(const ResetCronometroEvent());

                context
                    .read<AddressBloc>()
                    .add(CreateOrderUserEvent(myLocation));
                messageService.initPeriodicMessage();
              },
            ),
          );
        }

        

        // 🟡 Orden recién creada, esperando conductor
        // if (stateAddress.isWaitingDriver == true) {
        //   return Padding(
        //     padding: const EdgeInsets.symmetric(horizontal: horizontalMargin),
        //     child: ButtonReusable(
        //       text: 'Finalizar Viaje',
        //       onPressed: () async {
        //         // 🔁 Reiniciamos el cronómetro ANTES de finalizar viaje
        //         context.read<CronometroBloc>().add(const ResetCronometroEvent());
        //         context.read<AddressBloc>().add(FinishOrderEvent());
        //         context.read<AddressBloc>().add(OnClearStateEvent());
        //         messageService.cancelPeriodicMessage();
        //       },
        //     ),
        //   );
        // }

        // 🟢 Viaje en curso con conductor
        // if (stateAddress.isTripActive == true) {
        //   return Padding(
        //     padding: const EdgeInsets.symmetric(horizontal: horizontalMargin),
        //     child: ButtonReusable(
        //       text: 'Finalizar Viaje',
        //       onPressed: () async {
        //         // 🔁 Reiniciamos el cronómetro ANTES de finalizar viaje
        //         context
        //             .read<CronometroBloc>()
        //             .add(const ResetCronometroEvent());
        //         context.read<AddressBloc>().add(FinishOrderEvent());
        //         context.read<AddressBloc>().add(OnClearStateEvent());
        //         context.read<PrecioDistanciaBloc>().add(ResetearPrecioDistanciaEvent());

        //         messageService.cancelPeriodicMessage();
        //       },
        //     ),
        //   );
        // }

        return const SizedBox.shrink();
      },
    );
  }

  BoxDecoration _decorationContainerBookingCard() {
    return BoxDecoration(
      image: const DecorationImage(
        image: AssetImage('assets/background_image.webp'),
        fit: BoxFit.cover,
        opacity: 0.8,
      ),
      gradient: AppConstants.backgroundCard,
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(30),
        topRight: Radius.circular(30),
      ),
      boxShadow: const [
        BoxShadow(
          color: Color.fromARGB(255, 192, 191, 191),
          blurRadius: 25,
          spreadRadius: 1.0,
          offset: Offset(5, 0),
        ),
      ],
    );
  }
}
