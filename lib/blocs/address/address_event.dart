part of 'address_bloc.dart';

abstract class AddressEvent extends Equatable {
  const AddressEvent();

  @override
  List<Object?> get props => [];
}

class GetOrderUserEvent extends AddressEvent{}


class AddOrderUserEvent extends AddressEvent{

  final OrderUser orderUser;
  const AddOrderUserEvent(this.orderUser);

}
class OnClearStateEvent extends AddressEvent{
  
  const OnClearStateEvent();

}

class CreateOrderUserEvent extends AddressEvent {
  final LatLng ubicacion;
  const CreateOrderUserEvent(this.ubicacion);

  @override
  List<Object?> get props => [ubicacion];
}

class OnGuardarResumenViajeEvent extends AddressEvent {
  final double distanciaKm;
  final double precio;

  const OnGuardarResumenViajeEvent({
    required this.distanciaKm,
    required this.precio,
  });

  @override
  List<Object?> get props => [distanciaKm, precio];
}

class OnGuardarPrecioTotalEvent extends AddressEvent {
  final double precioTotal;

  const OnGuardarPrecioTotalEvent(this.precioTotal);

  @override
  List<Object?> get props => [precioTotal];
}

class OnGuardarDestinoEvent extends AddressEvent {
  final LatLng destino;

  const OnGuardarDestinoEvent(this.destino);

  @override
  List<Object?> get props => [destino];
}



class OnStartLoadingOrderUser extends AddressEvent{}
class OnStopLoadingOrderUser extends AddressEvent{}
class OnNotExistOrderUserEvent extends AddressEvent{}
class OnExistOrderUserEvent extends AddressEvent{}
class OnIsAcceptedTravel extends AddressEvent{}
class OnIsDeclinedTravel extends AddressEvent{}
class ClearMessageEvent extends AddressEvent{}
class FinishOrderEvent extends AddressEvent {}

class OnUpdateVisualStateEvent extends AddressEvent {
  final bool isWaitingDriver;
  final bool isTripActive;
  final bool isTripFinished;
  final OrderUser orderUser;

  const OnUpdateVisualStateEvent({
    required this.isWaitingDriver,
    required this.isTripActive,
    required this.isTripFinished,
    required this.orderUser,
  });
}



