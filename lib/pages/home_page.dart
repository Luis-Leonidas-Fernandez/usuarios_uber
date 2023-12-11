// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:usuario_inri/blocs/blocs.dart';
import 'package:usuario_inri/connection/log_out.dart';
import 'package:usuario_inri/models/address.dart';
import 'package:usuario_inri/models/usuario.dart';
import 'package:usuario_inri/service/auth_service.dart';
import 'package:usuario_inri/views/card_view.dart';
import 'package:usuario_inri/views/map_view.dart';
import 'package:usuario_inri/views/map_view_order.dart';
import 'package:usuario_inri/widgets/btn_cancel_travel.dart';
import 'package:usuario_inri/widgets/btn_finish_travel.dart';
import 'package:usuario_inri/widgets/btn_reservar.dart';

import 'package:usuario_inri/widgets/button_my_tracking.dart';
import 'package:usuario_inri/widgets/time_line.dart';

class HomePage extends StatefulWidget {

  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  AddressBloc? addressBloc;
  LocationBloc? locationBloc;
  Usuario? perfilUsuario;
  
  @override
  void initState() {
    super.initState();
    
    final locationBloc = BlocProvider.of<LocationBloc>(context);
    locationBloc.startFollowingUser();
    final addressBloc =  BlocProvider.of<AddressBloc>(context);
    addressBloc.state.loading;    
    addressBloc.startLoadingAddress();
    Provider.of<AuthService>(context, listen:false);
    
    
    
  }

  @override
  void dispose() {
    
    locationBloc?.stopFollowingUser();
    addressBloc?.stopLoadingAddress();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    
    final addressBloc =  BlocProvider.of<AddressBloc>(context);
    final usuario = Provider.of<AuthService>(context).perfilUsuario;
    addressBloc.state.loading; 
    
    return Scaffold(
      extendBodyBehindAppBar: true, 

      appBar: AppBar(

        backgroundColor: Colors.indigo,
        elevation: 0,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(25),
          bottomRight: Radius.circular(25),
        )
        ), 

        title:  Center(child:
         Text('Bienvenido a Inri ${usuario.nombre}',
         style: GoogleFonts.satisfy(color: Colors.white, fontSize: 25)
         )
         ),
        leading: Builder(
          builder: (BuildContext context){
            return IconButton(
              icon: const Icon(Icons.exit_to_app_rounded,
               color: Colors.white
               ),
              onPressed: () async { 
              
              LogOutApp.instance.finishApp();             
              
              if (!mounted) return;   
              setState(() {});          
              Navigator.pushReplacementNamed(context, 'login');
             
              
        },
              );
          } 
          ),
        
        
        ),
         
      
    
      body: BlocBuilder<LocationBloc, LocationState>(
        builder: (context, state) {

          
          if(state.lastKnownLocation == null)  return const Center(child: Text('Espere por favor...'));
                    
          final long = (state.lastKnownLocation!.longitude);
          final lat  = state.lastKnownLocation!.latitude; 
          
                    
          
              return StreamBuilder(
              stream: addressBloc.getOrder,
              builder: (context, AsyncSnapshot<OrderUser> snapshot) {
              final order = snapshot.data;
              
              

                return SingleChildScrollView(
                 
                  child: Stack(              
                    
                    children: [
              
                      addressBloc.state.existOrder == true ?
                      MapViewOrder(initialLocation: LatLng( lat, long) )// IS ACCEPTED = TRUE
                      : MapView(initialLocation: LatLng( lat, long)),  //IS ACCEPTED = FALSE                   
                                            
              
                      addressBloc.state.existOrder == false?
                      Container() //IS ACCEPTED= FALSE
                      : CardView(orderUser: order!, usuario: usuario), //IS ACCEPTED = TRUE
                       
                      //BUTTONS

                      addressBloc.state.existOrder == true &&
                      addressBloc.state.isAccepted ==  true ?   
                      BtnFinishTravel() //IS ACCEPTED = TRUE
                      : Container(), // IS ACCEPTED = FALSE
                      

                      addressBloc.state.existOrder == true &&
                      addressBloc.state.isAccepted ==  true ? 
                      BtnCancelTravel() //IS ACCEPTED = TRUE
                      : Container(), // IS ACCEPTED = FALSE

                      addressBloc.state.existOrder == false &&
                      addressBloc.state.isAccepted == false?                      
                       ReservarButton() // IS ACCEPTED = FALSE
                      : Container(), // IS ACCEPTED = TRUE

                      addressBloc.state.existOrder == false &&
                      addressBloc.state.isAccepted == true?
                      const HomeStepper() // IS ACCEPTED = FALSE
                      : Container(),

                      const BtnMyTracking(), 
                    
              
                 ],
                ), 
             );
           }
          );
         }
        ),      
        
     
      );
     }
    }
   
   
    
   
  
