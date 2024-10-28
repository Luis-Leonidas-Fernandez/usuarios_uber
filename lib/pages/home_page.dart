import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:latlong2/latlong.dart';
import 'package:usuario_inri/blocs/blocs.dart';
import 'package:usuario_inri/constants/app_bar.dart';


import 'package:usuario_inri/models/address.dart';
import 'package:usuario_inri/models/usuario.dart';
//import 'package:usuario_inri/service/message_service.dart';


import 'package:usuario_inri/views/circular_progress_view.dart';
import 'package:usuario_inri/views/map_view_order.dart';
import 'package:usuario_inri/widgets/booking_card.dart';
import 'package:usuario_inri/widgets/car.dart';
import 'package:usuario_inri/widgets/small_booking_card.dart';


class HomePage extends StatefulWidget {

  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  
  AddressBloc? addressBloc;
  LocationBloc? locationBloc;
  AuthBloc? usuarioBloc;
  Usuario? usuario;
  //final MessageService messageService = MessageService();
  
  @override
  void initState() {
    super.initState();
    
    final locationBloc = BlocProvider.of<LocationBloc>(context);
    locationBloc.startFollowingUser();
    final addressBloc =  BlocProvider.of<AddressBloc>(context);
    addressBloc.state.loading;    
    addressBloc.startLoadingAddress();
    BlocProvider.of<AuthBloc>(context);
          
    
  }

  @override
  void dispose() {   
    locationBloc?.stopFollowingUser();
    addressBloc?.stopLoadingAddress();
    usuarioBloc?.deleteUser();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    
    final addressBloc =  BlocProvider.of<AddressBloc>(context);
    final usuarioBloc = BlocProvider.of<AuthBloc>(context);

  
    final usuario = usuarioBloc.state.usuario;
    addressBloc.state.loading;
    final height = MediaQuery.of(context).size.height;

 
    
    return Scaffold(
      extendBodyBehindAppBar: true, 

      appBar: AppBarConstants.customAppBar(context),
    
      body: BlocBuilder<LocationBloc, LocationState>(
        builder: (context, state) {

          
          if(state.lastKnownLocation == null || usuario == null)  return CircularProgress();
                    
          final long = (state.lastKnownLocation!.longitude);
          final lat  = state.lastKnownLocation!.latitude;          
         
                              
              return StreamBuilder(
              stream: addressBloc.getOrderUser(),
              builder: (context, AsyncSnapshot<OrderUser> snapshot) {

              //final order = snapshot.data; 

              //final existOrder = addressBloc.state.existOrder!;
              //final isAccepted = addressBloc.state.isAccepted!;

                       

                return SingleChildScrollView(
                 
                  child: Stack(              
                    
                    children: [
              
                      usuarioBloc.state.usuario != null ?
                      MapViewOrder(initialLocation: LatLng( lat, long) )// IS ACCEPTED = TRUE
                      : Container(),     
                                            
                       height < 778 ?
                      const SmallBookingCard()
                      : BookingCard() ,


                      const CarImage()
                      //existOrder == false && order?.id == null?
                      //Container() //IS ACCEPTED= FALSE
                      //: CardView(orderUser: order!, usuario: usuario), //IS ACCEPTED = TRUE
                       
                      //BUTTONS

                      //existOrder == true && isAccepted ==  false ?                       
                      //BtnFinishTravel(messageService: messageService) //IS ACCEPTED = TRUE
                      //: Container(), // IS ACCEPTED = FALSE
                      

                      //existOrder == true && isAccepted  ==  false ?                       
                      //BtnCancelTravel(messageService: messageService) //IS ACCEPTED = TRUE
                      //: Container(), // IS ACCEPTED = FALSE                      
                      

                      //existOrder == false && isAccepted == false?
                       //ReservarButton(messageService: messageService) // IS ACCEPTED = FALSE
                      //: Container(), // IS ACCEPTED = TRUE 


                      //existOrder == false && isAccepted == true?                      
                      //TimeLineAddress(messageService: messageService) // IS ACCEPTED = FALSE
                      //: Container(),

                     //const BtnMyTracking(), 
                    
              
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
   
   
    
   
  
