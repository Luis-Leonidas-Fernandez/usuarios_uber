part of 'map_bloc.dart';

abstract class MapEvent extends Equatable {
  const MapEvent();

  @override
  List<Object> get props => [];
}

class OnMapInitializeEvent extends MapEvent{
  
  final MapController mapController;
  const OnMapInitializeEvent(this.mapController);
    
}
class OnStopFollowingUserEvent extends MapEvent {}
class OnStartFollowingUserEvent extends MapEvent {}

// se creo el evento que guarda las address
class OnAddAddressEvent extends MapEvent {}

class OnIsAcceptedTravel extends MapEvent{}
class OnIsDeclinedTravel extends MapEvent{}


