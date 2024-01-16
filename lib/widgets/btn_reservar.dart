// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:usuario_inri/blocs/blocs.dart';
import 'package:usuario_inri/service/addresses_service.dart';
import 'package:usuario_inri/widgets/button_options.dart';
import 'package:usuario_inri/widgets/custom_message_error.dart';
import 'package:usuario_inri/widgets/custom_message_success.dart';

class ReservarButton extends StatelessWidget {
  const ReservarButton({super.key});

  bool get mounted => true;

  @override
  Widget build(BuildContext context) {
    
    
    late AddressService addressService = AddressService();

    
    final addressBloc = BlocProvider.of<AddressBloc>(context);
    final locationBloc = BlocProvider.of<LocationBloc>(context);

    final alto = MediaQuery.sizeOf(context).height;
    

    return alto >= 860 ?
     LargeButton(
     locationBloc: locationBloc,
     addressService: addressService,
     mounted: mounted,
     addressBloc: addressBloc)

     : ShortButton(
     locationBloc: locationBloc,
     addressService: addressService,
     mounted: mounted,
     addressBloc: addressBloc);
  }
}

class ShortButton extends StatelessWidget {
  const ShortButton({
    super.key,
    required this.locationBloc,
    required this.addressService,
    required this.mounted,
    required this.addressBloc,
  });

  final LocationBloc locationBloc;
  final AddressService addressService;
  final bool mounted;
  final AddressBloc addressBloc;

  @override
  Widget build(BuildContext context) {
    return Positioned(
        top: 600,
        left: 90,
        right: 90,
        child: BlocBuilder<MapBloc, MapState>(
          builder: (context, state) {
            return ButtonOptions(
                iconData: Icons.thumb_up_alt_outlined,
                buttonText: 'SOLICITAR CONDUCTOR',
                onTap: () async {


                  //Se reservo un conductor
                  final myLocation = locationBloc.state.lastKnownLocation!;                       
                  final idOrder = await  addressService.postAddresses(myLocation);                                     
                  
                 
                   if (!mounted) return;

                    if(idOrder == null){
                                             
                    
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

class LargeButton extends StatelessWidget {
  const LargeButton({
    super.key,
    required this.locationBloc,
    required this.addressService,
    required this.mounted,
    required this.addressBloc,
  });

  final LocationBloc locationBloc;
  final AddressService addressService;
  final bool mounted;
  final AddressBloc addressBloc;

  @override
  Widget build(BuildContext context) {
    return Positioned(
           top: 780,
           left: 90,
           right: 90,
           child: BlocBuilder<MapBloc, MapState>(
             builder: (context, state) {
               return ButtonOptions(
                   iconData: Icons.thumb_up_alt_outlined,
                   buttonText: 'SOLICITAR CONDUCTOR',
                   onTap: () async {


                     //Se reservo un conductor
                     final myLocation = locationBloc.state.lastKnownLocation!;
                    
                     final idOrder = await  addressService.postAddresses(myLocation);                                         
                     

                       if (!mounted) return;

                       if(idOrder== null){
                                                
                       
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
                     addressBloc.add(OnIsAcceptedTravel());                      
                       
                     }   
                     

                   });
             },
           ),
         );
  }
}


