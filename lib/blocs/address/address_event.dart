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

class OnStartLoadingOrderUser extends AddressEvent{}
class OnStopLoadingOrderUser extends AddressEvent{}
class ExistOrderUserEvent extends AddressEvent{}
class OnIsAcceptedTravel extends AddressEvent{}
class OnIsDeclinedTravel extends AddressEvent{}


