import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:usuario_inri/blocs/blocs.dart';
import 'package:usuario_inri/responsive/responsive_ui.dart';
import 'package:usuario_inri/service/addresses_service.dart';
import 'package:usuario_inri/service/message_service.dart';
import 'package:usuario_inri/widgets/button_options.dart';
import 'package:usuario_inri/widgets/custom_message_error.dart';
import 'package:usuario_inri/widgets/custom_message_success.dart';

class ReservarButton extends StatelessWidget {

  final MessageService messageService; 
  const ReservarButton({super.key, required this.messageService});

  bool get mounted => true;

  @override
  Widget build(BuildContext context) {
    
    late ResponsiveUtil responsiveUtil = ResponsiveUtil(context);
    late AddressService addressService = AddressService(); 
    final authBloc = BlocProvider.of<AuthBloc>(context);   
    final addressBloc = BlocProvider.of<AddressBloc>(context);
    final locationBloc = BlocProvider.of<LocationBloc>(context);

    double responsiveTop = responsiveUtil.getResponsiveHeight(0.83);
    double responsiveLeft = responsiveUtil.getResponsiveWidth(0.18); // Adjust the value to fit your design
    double responsiveRight = responsiveUtil.getResponsiveWidth(0.18);
    

    return Positioned(
        top: responsiveTop,
        left: responsiveLeft,
        right: responsiveRight,
        child: BlocBuilder<MapBloc, MapState>(
          builder: (context, state) {
            return ButtonOptions(
                iconData: Icons.thumb_up_alt_outlined,
                buttonText: 'SOLICITAR CONDUCTOR',
                onTap: () async {
                  
                  //extrae token y idUser del State
                  final String? token = authBloc.state.usuario?.token; 
                  final String? idUser = authBloc.state.usuario?.uid;                     
                  
                  //Se reservo un conductor
                  final myLocation = locationBloc.state.lastKnownLocation!;                       
                  final idOrder = await  addressService.postAddresses(myLocation, token!, idUser!);                                     
                  
                  //activa y muestra mensajes con el estatus de la address
                  messageService.initPeriodicMessage();    
                 
                   if (!mounted) return;

                    if(idOrder == null){
                                             
                    //Mostramos mensaje de error 
                    // ignore: use_build_context_synchronously
                    ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: CustomSnackBarContentError(),
                      behavior: SnackBarBehavior.floating,
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      duration: Duration(seconds: 5),
                    ),
                  );

                  }else{

                  //Mostramos mensaje de exito 
                   // ignore: use_build_context_synchronously
                   ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: CustomSnackBarContentSuccess(),
                      behavior: SnackBarBehavior.floating,
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      duration: Duration(seconds: 5),
                    ),
                  );

                  // eventos que manejan la visibilidad de botones
                  //IS ACCEPTED= TRUE
                  addressBloc.add(OnIsAcceptedTravel());  
                    
                  }   

                });
          },
        ),
      );
  }
}










