import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:usuario_inri/blocs/address/address_bloc.dart';
import 'package:usuario_inri/blocs/map/map_bloc.dart';
import 'package:usuario_inri/service/addresses_service.dart';
import 'package:usuario_inri/service/storage_service.dart';
import 'package:usuario_inri/widgets/button_options.dart';



class BtnCancelTravel extends StatelessWidget {

  const BtnCancelTravel({Key? key}) : super(key: key);
  
  bool get mounted => true;

  @override
  Widget build(BuildContext context) {

    late AddressService addressService = AddressService();    
    final addressBloc =  BlocProvider.of<AddressBloc>(context);
   
     final size = MediaQuery.sizeOf(context);
    final alto = size.height;


    return  alto >= 890?

    Positioned(
                top: 750,
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
                            

                            // ocultando boton finalizar
                            //addressBloc.add(OnIsDeclinedTravel());
                            
                            // intentando emitir un evento 
                            addressBloc.add(const OnClearStateEvent());

                           
                                                    

                           },
                             
                     );
                  }, 
                  
                ),
                
              )
              : Positioned(
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
                            
                            
                            // intentando emitir un evento 
                            addressBloc.add(const OnClearStateEvent());
                            
                                                    

                           },
                             
                     );
                  }, 
                  
                ),
                
              );
  }
}
