part of 'address_bloc.dart';


class AddressState extends Equatable {  

final bool loading;
final bool existOrder; 
final OrderUser? orderUser;
final List<OrderUser> orderHistory;
final bool isAccepted;


const AddressState({
  this.loading = false,
  this.existOrder= false,
  this.isAccepted = false,    
  this.orderUser,
  orderHistory   

}): orderHistory = orderHistory ?? const[];

AddressState copyWith({
  bool? loading,
  bool? existOrder,
  bool? isAccepted,  
  OrderUser? orderUser,
  List<OrderUser>? orderhistory
})
=> AddressState(
  loading: loading?? this.loading, 
  existOrder: existOrder?? this.existOrder,
  isAccepted: isAccepted?? this.isAccepted,   
  orderUser: orderUser?? this.orderUser,
  orderHistory: orderhistory?? orderHistory
);

  
  @override
  List<Object?> get props => [loading,existOrder,  isAccepted, orderUser, orderHistory,];
}

class UserInitialState extends AddressState {
  const UserInitialState(): super( existOrder: false, orderUser: null , isAccepted: false);
}
