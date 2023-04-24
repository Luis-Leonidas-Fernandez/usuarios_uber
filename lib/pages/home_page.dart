import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:latlong2/latlong.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:usuario_inri/blocs/blocs.dart';
import 'package:usuario_inri/models/address.dart';
import 'package:usuario_inri/service/auth_service.dart';
import 'package:usuario_inri/views/card_view.dart';
import 'package:usuario_inri/views/map_view.dart';
import 'package:usuario_inri/views/map_view_order.dart';
import 'package:usuario_inri/widgets/btn_cancel_travel.dart';
import 'package:usuario_inri/widgets/btn_finish_travel.dart';
import 'package:usuario_inri/widgets/btn_reservar.dart';

import 'package:usuario_inri/widgets/button_my_tracking.dart';

class HomePage extends StatefulWidget {

  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  AddressBloc? addressBloc;
  LocationBloc? locationBloc;
  
  @override
  void initState() {
    super.initState();
    
    final locationBloc = BlocProvider.of<LocationBloc>(context);
    locationBloc.startFollowingUser();
    final addressBloc =  BlocProvider.of<AddressBloc>(context);
    addressBloc.state.loading;    
    addressBloc.startLoadingAddress();
    
    
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
    addressBloc.state.loading; 
    
    return Scaffold(
      extendBodyBehindAppBar: true, 
      appBar: AppBar(
        backgroundColor: Colors.transparent,
                     
        title: const Center(child: Text('BIENVENIDO A INRI', style: TextStyle(color: Colors.black87),)),
        leading: Builder(
          builder: (BuildContext context){
            return IconButton(
              icon: const Icon(Icons.exit_to_app_rounded, color: Colors.black87,),
              onPressed: () async { 
              
              await AuthService.deleteIdDriver();
              await AuthService.deleteIdOrder();

              if (!mounted) return;
              Navigator.pushReplacementNamed(context, 'login');
              setState(() {});
              
        },
              );
          } 
          ),
        
        
        ),
         
      
    
      body: BlocBuilder<LocationBloc, LocationState>(
        builder: (context, state) {

          
          if(state.lastKnownLocation == null) return Center(child: CircularPercentIndicator(animation: true,animationDuration: 1000, radius: 200, lineWidth: 40, percent: 1, progressColor: Colors.deepPurple,backgroundColor: Colors.deepPurple.shade100, circularStrokeCap: CircularStrokeCap.round, center: const Text('100%', style: TextStyle(fontSize: 50) ),));
                    
          final long = (state.lastKnownLocation!.longitude);
          final lat  = state.lastKnownLocation!.latitude;           
          final doc     = addressBloc.getOrder;       
           final map     = BlocProvider.of<MapBloc>(context);     
              
              return StreamBuilder(
              stream: doc,
              builder: (context, AsyncSnapshot<OrderUser> snapshot) {
              final orderUser = snapshot.data;
             
               

                return SingleChildScrollView(
                 
                  child: Stack(              
                    
                    children: [
              
                      orderUser?.id == null ?
                      MapView(initialLocation: LatLng( lat, long))
                      : MapViewOrder(initialLocation: LatLng( lat, long) ),
                      
                      
              
                      orderUser?.id != null?
                      CardView(orderUser: orderUser!)
                      : Container(),
              
                      map.state.isAccepted == true?
                         
                      BtnFinishTravel()
                      : Container(),
                      

                      map.state.isAccepted == true? 
                      BtnCancelTravel()
                      : Container(),

                      orderUser?.id == null && map.state.isAccepted == false?
                      
                       ReservarButton()
                      : Container(), 
                    
              
                 ],
                ), 
             );
           }
          );
         }
        ),
         
        
        
      
      floatingActionButton: const BtnMyTracking(),
     
      );
     }
    }
   
   
    
   
  
