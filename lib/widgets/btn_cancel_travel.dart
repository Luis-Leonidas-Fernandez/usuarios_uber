// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:usuario_inri/blocs/address/address_bloc.dart';
import 'package:usuario_inri/blocs/map/map_bloc.dart';
import 'package:usuario_inri/service/addresses_service.dart';
import 'package:usuario_inri/service/storage_service.dart';
import 'package:usuario_inri/widgets/button_options.dart';



class BtnCancelTravel extends StatelessWidget {

  const BtnCancelTravel({super.key});
  
  bool get mounted => true;

  @override
  Widget build(BuildContext context) {

    late AddressService addressService = AddressService();    
    final addressBloc =  BlocProvider.of<AddressBloc>(context);
   
    final alto = MediaQuery.sizeOf(context).height;
    
    return  alto >= 860?

    BigButton(
    addressService: addressService,
    addressBloc: addressBloc)

    : SmallButton(
    addressService: addressService,
    addressBloc: addressBloc);
  }
}

class SmallButton extends StatelessWidget {
  const SmallButton({
    super.key,
    required this.addressService,
    required this.addressBloc,
  });

  final AddressService addressService;
  final AddressBloc addressBloc;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 600,
      left: 220,
      right: 20,
      child: BlocBuilder<MapBloc, MapState>(
        builder: (context, state) {
          return ButtonOptions(iconData: Icons.free_cancellation_outlined,
                 buttonText: 'Cancelar Viaje',
                 onTap: () async {

                  // Eliminando viaje de base de datos
                  await  addressService.finishTravel(); 

                  await StorageService.instance.deleteIdDriver();
                  await StorageService.instance.deleteIdOrder();                     
                  
                  // Clear Hydrated storage

                  
                  // intentando emitir un evento 
                  addressBloc.add(const OnClearStateEvent());

                 
                  Navigator.pushReplacementNamed(context, 'notification');
                 
                                          

                 },
                   
           );
        }, 
        
      ),
      
    );
  }
}

class BigButton extends StatelessWidget {
  const BigButton({
    super.key,
    required this.addressService,
    required this.addressBloc,
  });

  final AddressService addressService;
  final AddressBloc addressBloc;

  @override
  Widget build(BuildContext context) {
    return Positioned(
                top: 790,
                left: 220,
                right: 20,
                child: BlocBuilder<MapBloc, MapState>(
                  builder: (context, state) {
                    return ButtonOptions(iconData: Icons.free_cancellation_outlined,
                           buttonText: 'Cancelar Viaje',
                           onTap: () async {

                            // Eliminando viaje de base de datos
                            await  addressService.finishTravel(); 

                            await StorageService.instance.deleteIdDriver();
                            await StorageService.instance.deleteIdOrder();                  
                                                                             
                            // intentando emitir un evento 
                            addressBloc.add(const OnClearStateEvent()); 

                            Navigator.pushReplacementNamed(context, 'notification');                           
                           
                                                    

                           },
                             
                     );
                  }, 
                  
                ),
                
              );
  }
}
