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


class OnStartLoadingOrderUser extends AddressEvent{}
class OnStopLoadingOrderUser extends AddressEvent{}
class OnNotExistOrderUserEvent extends AddressEvent{}
class OnExistOrderUserEvent extends AddressEvent{}
class OnIsAcceptedTravel extends AddressEvent{}
class OnIsDeclinedTravel extends AddressEvent{}
class ClearMessageEvent extends AddressEvent{}
class FinishOrderEvent extends AddressEvent {}


