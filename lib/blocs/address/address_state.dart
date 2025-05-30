part of 'address_bloc.dart';


class AddressState extends Equatable {  

final bool loading;
final bool? existOrder; 
final OrderUser? orderUser;
final List<OrderUser> orderHistory;
final bool? isAccepted;
final String? message;
final LatLng? destinoSeleccionado;

// 🆕 Nuevos flags para controlar UI
  final bool isWaitingDriver;
  final bool isTripActive;
  final bool isTripFinished;


const AddressState({

  this.loading = false,
  this.existOrder= false,
  this.isAccepted = false,
  this.isWaitingDriver = false,
  this.isTripActive = false,
  this.isTripFinished = false, // corregido aqui
  this.message = '',    
  this.orderUser,
  this.destinoSeleccionado,
  orderHistory   

}): orderHistory = orderHistory ?? const[];

AddressState copyWith({
  bool? loading,
  bool? existOrder,
  bool? isAccepted,  
  OrderUser? orderUser,
  List<OrderUser>? orderhistory,
  String? message,
  LatLng? destinoSeleccionado,
  bool? isWaitingDriver,
  bool? isTripActive,
  bool? isTripFinished,
})
=> AddressState(
  loading: loading?? this.loading, 
  existOrder: existOrder?? this.existOrder,
  isAccepted: isAccepted?? this.isAccepted,   
  orderUser: orderUser?? this.orderUser,
  orderHistory: orderhistory?? orderHistory,
  message: message?? this.message,
  isWaitingDriver: isWaitingDriver ?? this.isWaitingDriver,
  isTripActive: isTripActive ?? this.isTripActive,
  isTripFinished: isTripFinished ?? this.isTripFinished,
  destinoSeleccionado: destinoSeleccionado ?? this.destinoSeleccionado,

);


  
  @override
  List<Object?> get props => [
    loading,
    existOrder,
    isAccepted,
    orderUser,
    orderHistory,
    message,
    destinoSeleccionado,
    isWaitingDriver,
    isTripActive,
    isTripFinished,];
  
}


class UserInitialState extends AddressState {
  const UserInitialState(): super( 
    existOrder: false,
    orderUser: null,
    isTripActive: false,
    isWaitingDriver: false,
    isTripFinished: false,);
}

