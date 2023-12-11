import 'dart:async';
import 'package:bloc/bloc.dart';

import 'package:equatable/equatable.dart';
import 'package:usuario_inri/models/address.dart';

import 'package:usuario_inri/service/addresses_service.dart';
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
  on<ExistOrderUserEvent> ((event, emit)  => emit(state.copyWith(existOrder: false)));
  on<OnIsAcceptedTravel>((event, emit) => emit(state.copyWith(isAccepted: true)));
  on<OnIsDeclinedTravel>((event, emit) => emit(state.copyWith(isAccepted: false)));
  on<OnClearStateEvent> ((event, emit)  => emit(const UserInitialState()));  

  
  on<AddOrderUserEvent>((event, emit) {

      emit(state.copyWith(
        orderUser: event.orderUser,
        existOrder: true,
        orderhistory: [...state.orderHistory, event.orderUser]
      
      ));
      
    });

    
    
  }
  
  Stream<OrderUser> get getOrder async* {    

    final  respOrder = await addressService.getAddress();   
   
    final id = respOrder.idDriver;

    if(id == '0'){   
    
        
      return;       
     
    }else{
     
     add(AddOrderUserEvent(respOrder));

    _addressController.add(respOrder);
    

     yield respOrder;
    }    

    }
  
  
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