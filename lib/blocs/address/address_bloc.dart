import 'dart:async';
import 'package:bloc/bloc.dart';

import 'package:equatable/equatable.dart';
import 'package:usuario_inri/models/address.dart';

import 'package:usuario_inri/service/addresses_service.dart';
import 'package:usuario_inri/service/auth_service.dart';
part 'address_event.dart';
part 'address_state.dart';

class AddressBloc extends Bloc<AddressEvent, AddressState> {

  AddressService addressService;
  
  final StreamController<OrderUser> _addressController = StreamController();
  Stream get  addressOrder => _addressController.stream;

  AddressBloc({

     required this.addressService
  
  }) : super( const AddressState()) {

  on<OnStartLoadingOrderUser>((event, emit) => emit(state.copyWith(loading: true)));
  on<OnStopLoadingOrderUser> ((event, emit)  => emit(state.copyWith(loading: false)));
  on<DeleteOrderUserEvent> ((event, emit)  => emit(const AddressState()));  
  on<LoadOrderUserEvent>((event, emit) {

      emit(state.copyWith(
        orderUser: event.orderUser,
        orderhistory: [...state.orderHistory, event.orderUser]
      
      ));
      
    });

    
    
  }
  
  Stream<OrderUser> get getOrder async* {

    final List<OrderUser> orderUsers = [];

    final  obj = await addressService.getAddress();

    if(obj.isNotEmpty){

    final orderUser = obj.first; 
    
    add( LoadOrderUserEvent( orderUser ) ); 
    await AuthService().guardarIdDriver(orderUser.idDriver);

    for( OrderUser orderUser in orderUsers){
      
     orderUsers.add(orderUser);
     await Future.delayed(const Duration(seconds: 2));
     
     }

     _addressController.add(orderUser); 
     yield orderUser;

    }else{
      return;
    }   

    }

  get orderUser => null;

  
  
  
  void startLoadingAddress(){ 

    add(OnStartLoadingOrderUser());  
    getOrder;
    
    
   
  } 

  void stopLoadingAddress(){    
    //addressStream?.cancel();
    _addressController.close;
    add(OnStopLoadingOrderUser());
   
  }


  @override
  Future<void> close() {
    stopLoadingAddress();
    return super.close();
  }


}