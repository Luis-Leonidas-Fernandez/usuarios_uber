// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:usuario_inri/blocs/address/address_bloc.dart';
import 'package:usuario_inri/blocs/blocs.dart';
import 'package:usuario_inri/blocs/map/map_bloc.dart';
import 'package:usuario_inri/responsive/responsive_ui.dart';
import 'package:usuario_inri/service/addresses_service.dart';
import 'package:usuario_inri/service/message_service.dart';
import 'package:usuario_inri/service/storage_service.dart';
import 'package:usuario_inri/widgets/button_options.dart';



class BtnCancelTravel extends StatelessWidget {
  
  final MessageService messageService; 
  const BtnCancelTravel({super.key, required this.messageService});
  
  bool get mounted => true;

  @override
  Widget build(BuildContext context) {


    late ResponsiveUtil responsiveUtil = ResponsiveUtil(context);
    late AddressService addressService = AddressService();    
    final addressBloc =  BlocProvider.of<AddressBloc>(context);
    final authBloc = BlocProvider.of<AuthBloc>(context);

    double responsiveTop = responsiveUtil.getResponsiveHeight(0.83);
    double responsiveLeft = responsiveUtil.getResponsiveWidth(0.52); // Adjust the value to fit your design
    double responsiveRight = responsiveUtil.getResponsiveWidth(0.04);
   
    
    return  Positioned(
      top: responsiveTop,
      left: responsiveLeft,
      right: responsiveRight,
      child: BlocBuilder<MapBloc, MapState>(
        builder: (context, state) {
          return ButtonOptions(iconData: Icons.free_cancellation_outlined,
                 buttonText: 'Cancelar Viaje',
                 onTap: () async {
                  
                  //extrae token y idUser del State
                  final String? token = authBloc.state.usuario?.token; 
                  final String? idUser = authBloc.state.usuario?.uid;  

                  // Eliminando viaje de base de datos
                  await  addressService.finishTravel(token!, idUser!); 

                  await StorageService.instance.deleteIdDriver();
                  await StorageService.instance.deleteIdOrder();

                  //desactiva mensajes de la address
                  messageService.cancelPeriodicMessage();                     
                  
                  // Clear Hydrated storage
                                    
                  //Limpiando el State
                  // EXIST ORDER = FALSE -- IS ACCEPTED = FALSE 
                  addressBloc.add(const OnClearStateEvent());
                 
                  Navigator.pushReplacementNamed(context, 'notification');
              },                   
          );
        },         
      ),
      
    );
  }
}

