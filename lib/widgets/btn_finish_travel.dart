
// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:usuario_inri/blocs/address/address_bloc.dart';
import 'package:usuario_inri/blocs/map/map_bloc.dart';
import 'package:usuario_inri/service/addresses_service.dart';
import 'package:usuario_inri/service/storage_service.dart';
import 'package:usuario_inri/widgets/button_options.dart';



class BtnFinishTravel extends StatelessWidget {

  const BtnFinishTravel({super.key});
  
  bool get mounted => true;

  @override
  Widget build(BuildContext context) {

    late AddressService addressService = AddressService();    
    final addressBloc =  BlocProvider.of<AddressBloc>(context);

    final alto = MediaQuery.sizeOf(context).height;
    

    return alto >= 860 ?

    MyBigButton(
    addressService: addressService,
    addressBloc: addressBloc)

    : MySmallButton(
    addressService: addressService,
    addressBloc: addressBloc);

  }
}

class MySmallButton extends StatelessWidget {
  const MySmallButton({
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
      left: 30,
      right: 210,
      child: BlocBuilder<MapBloc, MapState>(
        builder: (context, state) {
          return ButtonOptions(iconData: Icons.free_cancellation_outlined,
                 buttonText: 'Finalizar Viaje',
                 onTap: () async {

                 
                  // Eliminando viaje de base de datos
                  await  addressService.finishTravel();

                  await StorageService.instance.deleteIdDriver();
                  await StorageService.instance.deleteIdOrder();
                  
                  //Limpiando el State
                  // EXIST ORDER = FALSE -- IS ACCEPTED = FALSE
                  addressBloc.add(const OnClearStateEvent());

                  Navigator.pushReplacementNamed(context, 'notification');
                 
                   
        }
        );
        }, 
        
      ),
      
    );
  }
}

class MyBigButton extends StatelessWidget {
  const MyBigButton({
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
                left: 30,
                right: 210,
                child: BlocBuilder<MapBloc, MapState>(
                  builder: (context, state) {
                    return ButtonOptions(iconData: Icons.free_cancellation_outlined,
                           buttonText: 'Finalizar Viaje',
                           onTap: () async {

                           
                           
                            // Eliminando viaje de base de datos
                            await  addressService.finishTravel();

                            await StorageService.instance.deleteIdDriver();
                            await StorageService.instance.deleteIdOrder(); 
                           
                            
                            // Limpiando el State
                            addressBloc.add(const OnClearStateEvent()); 

                            Navigator.pushReplacementNamed(context, 'notification');                         
                            
                                                    

                           },
                             
                     );
                  }, 
                  
                ),
                
              );
  }
}

