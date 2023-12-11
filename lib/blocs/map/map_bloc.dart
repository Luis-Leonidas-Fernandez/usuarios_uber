// ignore_for_file: avoid_print

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:usuario_inri/blocs/blocs.dart';

import 'dart:math' as math;

part 'map_event.dart';
part 'map_state.dart';

class MapBloc extends Bloc<MapEvent, MapState> {

  final LocationBloc locationBloc;
  final AddressBloc addressBloc;
  
  
  
  //late MapboxMapController mapBoxController;  
  late MapController mapController; 

  StreamSubscription<LocationState>? locationStateSubscription;
  StreamSubscription<AddressState>? addressStateSubscription;

  MapBloc({
  required this.locationBloc, 
  required this.addressBloc,
  }) : super(const MapState()) {

    on<OnMapInitializeEvent>(_onInitMap  );
    on<OnStartFollowingUserEvent>(_onStartFollowingUser);    
    on<OnStopFollowingUserEvent>((event, emit) => emit( state.copyWith( isfollowingUser: false) ));
    on<OnAddAddressEvent>(_onAddAdress );
    //on<OnIsAcceptedTravel>((event, emit) => emit(state.copyWith(isAccepted: true)));
    //on<OnIsDeclinedTravel>((event, emit) => emit(state.copyWith(isAccepted: false)));
  
      
  
  locationStateSubscription = locationBloc.stream.listen((locationState){

    if(!state.isfollowingUser) return;
    if(locationState.lastKnownLocation ==null ) return;    
    //moveCamera(locationState.lastKnownLocation!);
    
  });

  addressStateSubscription = addressBloc.stream.listen((addressState) {

      if(addressState.orderUser == null) return;
      addAddress(addressState.orderUser!);
   }); 


  }

  void _onInitMap(OnMapInitializeEvent event, Emitter<MapState> emit){

    mapController = event.mapController;        
    emit(state.copyWith(isMapInitialized: true));
    
    
    
  }

  void _onStartFollowingUser(OnStartFollowingUserEvent event, Emitter<MapState> emit) {    
    emit( state.copyWith( isfollowingUser: true ) );    
      
  }
 

  // se creo un evento el cual maneja las address
  void _onAddAdress(OnAddAddressEvent event, Emitter<MapState> emit) {    

    if( addressBloc.state.orderUser == null ) return;
    addAddress(addressBloc.state.orderUser!);
    
  }  
  
//se agrega la address a una funcion para dibujar la ui
  void addAddress( address){
    
  }

   LatLng bounds(List<double> location) {
    

    final driver = List.from(location);
    final LatLng myPosition = locationBloc.state.lastKnownLocation!;
    final driverPosition = LatLng(driver[1], driver[0]);   
  

    final double left   = math.min(myPosition.latitude, driverPosition.latitude);
    final double right  = math.max(myPosition.latitude, driverPosition.latitude);
    final double top    = math.min(myPosition.longitude, driverPosition.longitude);
    final double bottom = math.max(myPosition.longitude, driverPosition.longitude);

    final LatLng southwest = LatLng(left,bottom);
    final LatLng northeast = LatLng(right, top);
    
    
     final LatLng  center = LatLng(
      (southwest.latitude + northeast.latitude) /2,
      (southwest.longitude + northeast.longitude) /2, 
      );    
   
  
   
   return center;
  }

  dynamic getZoom(List<dynamic> location){
    
    if(addressBloc.state.orderUser == null) return 6.0;

    

    final driver = List.from(location);
    final LatLng userPosition = locationBloc.state.lastKnownLocation!;
    final driverPosition = LatLng(driver[1], driver[0]);       

    

    
    final distance = getDistanceInKM(userPosition, driverPosition);


    double radius = distance / 2;
    double scale  = radius / 0.3;
    final zoom    = (16 - math.log(scale) / math.log(2));
   
    
    
    if(distance == 0.0){
      return 6.0;
    }else{
     
     return zoom;
    }

    




  }

  /// parse degrees to radians
  static double deg2rad(deg) {
    return deg * (math.pi / 180);
  }


   /// calculates the distance between two coords in km
  static double getDistanceInKM(LatLng userPosition, LatLng driverPosition) {
    final lat1 = userPosition.latitude;
    final lon1 = userPosition.longitude;
    final lat2 = driverPosition.latitude;
    final lon2 = driverPosition.longitude;

    const R = 6371; // Radius of the earth in km

    final dLat = deg2rad(lat2 - lat1); // deg2rad below
    final dLon = deg2rad(lon2 - lon1);
    final a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(deg2rad(lat1)) *
            math.cos(deg2rad(lat2)) *
            math.sin(dLon / 2) *
            math.sin(dLon / 2);
    final c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    final d = R * c; // Distance in km

    return d;
  }






@override
  Future<void> close() {
    locationStateSubscription?.cancel();
    addressStateSubscription?.cancel();    
    return super.close();
  }  

}
