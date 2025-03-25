import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:latlong2/latlong.dart';
import 'package:usuario_inri/blocs/blocs.dart';
import 'package:usuario_inri/constants/app_bar.dart';

import 'package:usuario_inri/models/address.dart';
import 'package:usuario_inri/models/usuario.dart';
import 'package:usuario_inri/service/message_service.dart';

import 'package:usuario_inri/views/circular_progress_view.dart';
import 'package:usuario_inri/views/map_view_order.dart';
import 'package:usuario_inri/widgets/booking_card.dart';
import 'package:usuario_inri/widgets/custom_message_error.dart';
import 'package:usuario_inri/widgets/custom_message_success.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  AddressBloc? addressBloc;
  LocationBloc? locationBloc;
  AuthBloc? usuarioBloc;
  Usuario? usuario;
  final MessageService messageService = MessageService();

  @override
  void initState() {
    super.initState();

    final locationBloc = BlocProvider.of<LocationBloc>(context);
    locationBloc.startFollowingUser();
    final addressBloc = BlocProvider.of<AddressBloc>(context);
    addressBloc.state.loading;
    addressBloc.startLoadingAddress();
    BlocProvider.of<AuthBloc>(context);
  }

  @override
  void dispose() {
    locationBloc?.stopFollowingUser();
    addressBloc?.stopLoadingAddress();
    usuarioBloc?.deleteUser();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final addressBloc = BlocProvider.of<AddressBloc>(context);
    final usuarioBloc = BlocProvider.of<AuthBloc>(context);

    final usuario = usuarioBloc.state.usuario;
    addressBloc.state.loading;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBarConstants.customAppBar(context),
      body: BlocBuilder<LocationBloc, LocationState>(builder: (context, state) {
        if (state.lastKnownLocation == null || usuario == null)return CircularProgress();

        final long = (state.lastKnownLocation!.longitude);
        final lat = state.lastKnownLocation!.latitude;

        return StreamBuilder(
            stream: addressBloc.getOrderUser(),
            builder: (context, AsyncSnapshot<OrderUser> snapshot) {
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
                        context.read<AddressBloc>().add(ClearMessageEvent());
                      },
                      child: const BookingCard(),
                    ),
                  ],
                ),
              );
            });
      }),
    );
  }
}
