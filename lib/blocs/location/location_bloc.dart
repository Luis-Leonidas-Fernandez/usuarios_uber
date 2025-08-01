
import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart' show LatLng;


part 'location_event.dart';
part 'location_state.dart';

class LocationBloc extends Bloc<LocationEvent, LocationState> {

  StreamSubscription<Position>? positionStream;
 
  
  

  LocationBloc() : super(const LocationState()) {

    on<OnStartFollowingUser>((event, emit) => emit(state.copyWith(followingUser: true)));
    on<OnStopFollowingUser>((event, emit) => emit(state.copyWith(followingUser: false)));
    
    on<OnNewUserLocationEvent>((event, emit) {

      emit(state.copyWith(
        lastKnownLocation: event.newLocation,
        myLocationHistory: [...state.myLocationHistory, event.newLocation]
      ));
    });

  }

  Future getCurrentPosition()async {

  final LocationSettings locationSettings = LocationSettings(
  accuracy: LocationAccuracy.high,
  
);

    final position = await Geolocator.getCurrentPosition(
    locationSettings: locationSettings);
    
    add(OnNewUserLocationEvent(LatLng(position.latitude, position.longitude)));
    
  }


  void startFollowingUser(){

    const locationSettings = LocationSettings(
    accuracy: LocationAccuracy.best,
    distanceFilter: 5,        // Emitir solo si se movió al menos 5 metros
    
     );
    
    // FollowingUser = true;
    add(OnStartFollowingUser());
    
     positionStream = Geolocator.getPositionStream(locationSettings: locationSettings).listen((event) {
      
     final position = event;
        
    //Agrega la ubicacion del usuario a un evento
    add(OnNewUserLocationEvent(LatLng(position.latitude, position.longitude)));
    
   

    });

  }

  void stopFollowingUser(){
    
    positionStream?.cancel();
    add(OnStopFollowingUser());
   
  }


  @override
  Future<void> close() {    
    stopFollowingUser();
    return super.close();
  }
}