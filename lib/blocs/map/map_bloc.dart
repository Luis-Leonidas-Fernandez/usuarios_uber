import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:flutter_map/flutter_map.dart';

import 'package:usuario_inri/blocs/blocs.dart';

//import 'package:mapbox_gl/mapbox_gl.dart';


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
    on<OnIsAcceptedTravel>((event, emit) => emit(state.copyWith(isAccepted: true)));
    on<OnIsDeclinedTravel>((event, emit) => emit(state.copyWith(isAccepted: false)));
  
      
  
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

@override
  Future<void> close() {
    locationStateSubscription?.cancel();
    addressStateSubscription?.cancel();    
    return super.close();
  }  

}
