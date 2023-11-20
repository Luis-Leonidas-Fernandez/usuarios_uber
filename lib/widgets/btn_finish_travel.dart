
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:usuario_inri/blocs/address/address_bloc.dart';
import 'package:usuario_inri/blocs/map/map_bloc.dart';
import 'package:usuario_inri/service/addresses_service.dart';
import 'package:usuario_inri/service/storage_service.dart';
import 'package:usuario_inri/widgets/button_options.dart';



class BtnFinishTravel extends StatelessWidget {

  const BtnFinishTravel({Key? key}) : super(key: key);
  
  bool get mounted => true;

  @override
  Widget build(BuildContext context) {

    late AddressService addressService = AddressService();    
    final addressBloc =  BlocProvider.of<AddressBloc>(context);

    final size = MediaQuery.sizeOf(context);
    final alto = size.height;

    return alto >= 890 ?

    Positioned(
                top: 750,
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
                            
                                                    

                           },
                             
                     );
                  }, 
                  
                ),
                
              )
              : Positioned(
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
                           
                             
                  }
                  );
                  }, 
                  
                ),
                
              );
  }
}

