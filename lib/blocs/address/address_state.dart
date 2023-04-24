part of 'address_bloc.dart';


class AddressState extends Equatable {  

final bool loading; 
final OrderUser? orderUser;
final List<OrderUser> orderHistory;


const AddressState({
  this.loading = false,  
  this.orderUser,
  orderHistory   

}): orderHistory = orderHistory ?? const[];

AddressState copyWith({
  bool? loading,  
  OrderUser? orderUser,
  List<OrderUser>? orderhistory
})
=> AddressState(
  loading: loading?? this.loading,  
  orderUser: orderUser?? this.orderUser,
  orderHistory: orderhistory?? orderHistory
);

  
  @override
  List<Object?> get props => [loading, orderUser, orderHistory,];
}


