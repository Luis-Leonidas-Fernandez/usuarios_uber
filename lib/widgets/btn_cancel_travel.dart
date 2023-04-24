import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:usuario_inri/blocs/address/address_bloc.dart';
import 'package:usuario_inri/blocs/map/map_bloc.dart';
//import 'package:usuario_inri/service/addresses_service.dart';
//import 'package:usuario_inri/service/auth_service.dart';
import 'package:usuario_inri/widgets/button_options.dart';



class BtnCancelTravel extends StatelessWidget {

  const BtnCancelTravel({Key? key}) : super(key: key);
  
  bool get mounted => true;

  @override
  Widget build(BuildContext context) {

    //late AddressService addressService = AddressService();
    final mapBloc =  BlocProvider.of<MapBloc>(context);
    final addressBloc =  BlocProvider.of<AddressBloc>(context);

    return  mapBloc.state.isAccepted == true?

    Positioned(
                top: 620,
                left: 220,
                right: 20,
                child: BlocBuilder<MapBloc, MapState>(
                  builder: (context, state) {
                    return ButtonOptions(iconData: Icons.free_cancellation_outlined,
                           buttonText: 'Cancelar Viaje',
                           onTap: () async {

                            // Eliminando viaje de base de datos
                            //await  addressService.finishTravel(); 

                            //await AuthService.deleteIdDriver();
                            //await AuthService.deleteIdOrder();
                            
                                                                              
                           

                            // ocultando boton finalizar
                            mapBloc.add(OnIsDeclinedTravel());
                            
                            // intentando emitir un evento 
                            addressBloc.add(const DeleteOrderUserEvent());

                            if (!mounted) return;

                            Navigator.pushReplacementNamed(context, 'loading' );
                                                    

                           },
                             
                     );
                  }, 
                  
                ),
                
              )
              : const SizedBox();
  }
}
