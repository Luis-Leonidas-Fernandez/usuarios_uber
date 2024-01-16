import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:usuario_inri/blocs/blocs.dart';
import 'package:usuario_inri/models/usuario.dart';
import 'package:usuario_inri/service/auth_service.dart';


class MapView extends StatefulWidget {

final LatLng initialLocation;


const MapView({
super.key,
required this.initialLocation
});   

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {

  late LocationBloc locationBloc;
  late final MapController _mapController;
  late Usuario usuario;
  AuthService? authService;

  @override
  void initState() {    
    super.initState();

    BlocProvider.of<AuthBloc>(context);
    BlocProvider.of<AddressBloc>(context);
    _mapController = MapController();
    
  }
@override
  void dispose() {
   
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {  

    final usuario      = BlocProvider.of<AuthBloc>(context).state.usuario!; 
    final locationBloc = BlocProvider.of<LocationBloc>(context);
    final myLocation   = locationBloc.state.lastKnownLocation!;
   

    final size = MediaQuery.of(context).size; 

       return SizedBox(
        width: size.width,
        height: size.height,
        child: FlutterMap(          
          mapController: _mapController,          
          options: MapOptions(             
            zoom: 15.0,
            minZoom: 1.0,
            maxZoom: 20.0,            
            center:  LatLng(myLocation.latitude, myLocation.longitude),
          ),
          nonRotatedChildren: [
            TileLayer(
              urlTemplate: usuario.urlMapbox,
              additionalOptions: {               
                'accessToken': usuario.tokenMapBox,
                'id': usuario.idMapBox,
              },
              
            ),
            
              MarkerLayer(
              markers: [
                Marker(                  
                  point: LatLng(myLocation.latitude, myLocation.longitude),
                  width: 95,
                  height: 95,
                  builder: (context) => 
                 Container(                                                   
                  color: Colors.transparent,
                  child: Image.asset('assets/icon.png'),                  
                 ) 
                ),
                  
              ],            
            ), 
          ],          
        ),
       );
     
  }
}
