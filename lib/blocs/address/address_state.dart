part of 'address_bloc.dart';


class AddressState extends Equatable {  

final bool loading;
final bool? existOrder; 
final OrderUser? orderUser;
final List<OrderUser> orderHistory;
final bool? isAccepted;
final String? message;

const AddressState({
  this.loading = false,
  this.existOrder= false,
  this.isAccepted = false,
  this.message = '',    
  this.orderUser,
  orderHistory   

}): orderHistory = orderHistory ?? const[];

AddressState copyWith({
  bool? loading,
  bool? existOrder,
  bool? isAccepted,  
  OrderUser? orderUser,
  List<OrderUser>? orderhistory,
  String? message
})
=> AddressState(
  loading: loading?? this.loading, 
  existOrder: existOrder?? this.existOrder,
  isAccepted: isAccepted?? this.isAccepted,   
  orderUser: orderUser?? this.orderUser,
  orderHistory: orderhistory?? orderHistory,
  message: message?? this.message
);


  
  @override
  List<Object?> get props => [loading,existOrder,  isAccepted, orderUser, orderHistory,message];
  
}


class UserInitialState extends AddressState {
  const UserInitialState(): super( existOrder: false, orderUser: null );
}

