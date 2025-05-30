import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:latlong2/latlong.dart';
import 'package:usuario_inri/blocs/blocs.dart';
import 'package:usuario_inri/blocs/tarifario/tarifario_bloc.dart';

import 'package:usuario_inri/models/usuario.dart';
import 'package:usuario_inri/service/message_service.dart';

import 'package:usuario_inri/views/map_view_order.dart';
import 'package:usuario_inri/widgets/cards/booking_card.dart';
import 'package:usuario_inri/widgets/custom_message_error.dart';
import 'package:usuario_inri/widgets/custom_message_success.dart';
import 'package:usuario_inri/widgets/loading/shimmer.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  TarifarioBloc? tarifarioBloc;
  AddressBloc? addressBloc;
  LocationBloc? locationBloc;
  AuthBloc? usuarioBloc;
  Usuario? usuario;
  final MessageService messageService = MessageService();

  @override
  void initState() {
    super.initState();
    
    WidgetsBinding.instance.addObserver(this);
    final locationBloc = BlocProvider.of<LocationBloc>(context);
    final addressBloc = BlocProvider.of<AddressBloc>(context);
    BlocProvider.of<TarifarioBloc>(context);

    locationBloc.startFollowingUser();
    addressBloc.state.loading;   
    addressBloc.startPollingOrderUser();
    BlocProvider.of<AuthBloc>(context);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    locationBloc?.stopFollowingUser();    
    usuarioBloc?.deleteUser();
    addressBloc?.stopPollingOrderUser();
    super.dispose();
  }

   @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
   

    if (state == AppLifecycleState.paused) {
     
      context.read<LocationBloc>().stopFollowingUser();
    }

    if (state == AppLifecycleState.resumed) {
     
      context.read<LocationBloc>().startFollowingUser();
    }
  }

  @override
  Widget build(BuildContext context) {
    final addressBloc = BlocProvider.of<AddressBloc>(context);
    final usuarioBloc = BlocProvider.of<AuthBloc>(context);
    final tarifarioState = context.watch<TarifarioBloc>().state;
    usuarioBloc.state.usuario?.nombre ?? '';   

    if (tarifarioState is TarifarioLoaded) {
      tarifarioState.tarifas;
      
    }

    final usuario = usuarioBloc.state.usuario;
    addressBloc.state.loading;

    return BlocBuilder<LocationBloc, LocationState>(
      builder: (context, state) {        
        return Scaffold(
          body: BlocBuilder<LocationBloc, LocationState>(
              builder: (context, state) {
            if (state.lastKnownLocation == null || usuario == null) return ShimmerLoadingHome();

            final long = (state.lastKnownLocation!.longitude);
            final lat = state.lastKnownLocation!.latitude;

            return SingleChildScrollView(
              child: Stack(
                children: [
                  usuarioBloc.state.usuario != null
                      ? MapViewOrder(
                          initialLocation:
                              LatLng(lat, long)) // IS ACCEPTED = TRUE
                      : Container(),
                  BlocListener<AddressBloc, AddressState>(
                    listenWhen: (previous, current) =>
                        previous.message != current.message,
                    listener: (context, state) {
                      if (state.message == 'orden_creada') {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: CustomSnackBarContentSuccess(),
                            backgroundColor: Colors.transparent,
                            behavior: SnackBarBehavior.floating,
                            elevation: 0,
                            duration: Duration(seconds: 5),
                          ),
                        );
                      } else if (state.message == 'fuera_cobertura') {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: CustomSnackBarContentError(),
                            backgroundColor: Colors.transparent,
                            behavior: SnackBarBehavior.floating,
                            elevation: 0,
                            duration: Duration(seconds: 5),
                          ),
                        );
                      }
            
                      // Limpia el mensaje una vez mostrado
                      context
                          .read<AddressBloc>()
                          .add(ClearMessageEvent());
                    },
                    child: const BookingCard(),
                  ),
                ],
              ),
            );
          }),
        );
      },
    );
  }
}
