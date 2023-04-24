part of 'address_bloc.dart';

abstract class AddressEvent extends Equatable {
  const AddressEvent();

  @override
  List<Object?> get props => [];
}

class LoadOrderUserEvent extends AddressEvent{

  final OrderUser orderUser;
  const LoadOrderUserEvent(this.orderUser);

}
class DeleteOrderUserEvent extends AddressEvent{
  
  const DeleteOrderUserEvent();

}
class OnStartLoadingOrderUser extends AddressEvent{}
class OnStopLoadingOrderUser extends AddressEvent{}

