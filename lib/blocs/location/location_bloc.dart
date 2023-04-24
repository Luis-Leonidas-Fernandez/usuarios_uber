
import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
//import 'package:usuario_inri/service/socket_service.dart';
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

    final position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
     
    
    add(OnNewUserLocationEvent(LatLng(position.latitude, position.longitude)));
    
  }


  void startFollowingUser(){
    
    // FollowingUser = true;
    add(OnStartFollowingUser());

     positionStream = Geolocator.getPositionStream().listen((event) {
      
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
    //SocketService.instance.finishSocket();
    stopFollowingUser();
    return super.close();
  }
}