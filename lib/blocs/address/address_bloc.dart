import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:latlong2/latlong.dart';
import 'package:usuario_inri/blocs/blocs.dart';
import 'package:usuario_inri/models/address.dart';
import 'package:usuario_inri/service/addresses_service.dart';
import 'package:usuario_inri/service/storage_service.dart';

part 'address_event.dart';
part 'address_state.dart';

class AddressBloc extends HydratedBloc<AddressEvent, AddressState> {
  AddressService addressService;
  final AuthBloc authBloc;
  final storage = StorageService.instance;

  final StreamController<OrderUser> _addressController = StreamController();
  Stream<OrderUser> get addressOrder => _addressController.stream;

  AddressBloc({required this.addressService, required this.authBloc}) : super(const AddressState()) {
    on<OnStartLoadingOrderUser>(
        (event, emit) => emit(state.copyWith(loading: true)));
    on<OnStopLoadingOrderUser>(
        (event, emit) => emit(state.copyWith(loading: false)));
    on<OnNotExistOrderUserEvent>(
        (event, emit) => emit(state.copyWith(existOrder: false)));
    on<OnExistOrderUserEvent>(
        (event, emit) => emit(state.copyWith(existOrder: true)));    
    on<OnIsDeclinedTravel>(
        (event, emit) => emit(state.copyWith(isAccepted: false)));
    on<OnIsAcceptedTravel>(
        (event, emit) => emit(state.copyWith(isAccepted: true)));
    on<OnClearStateEvent>((event, emit) => emit(const UserInitialState()));

    on<CreateOrderUserEvent>(_onCreateOrderUserEvent);
    on<FinishOrderEvent>(_onFinishOrderEvent);

    on<ClearMessageEvent>((event, emit) {emit(state.copyWith(message: ''));
});



    on<AddOrderUserEvent>((event, emit) {
      emit(state.copyWith(
          orderUser: event.orderUser,
          existOrder: true,
          isAccepted: false,
          orderhistory: [...state.orderHistory, event.orderUser]));
    });
  }

  @override
  Map<String, dynamic>? toJson(AddressState state) {
    if (state.orderUser != null) {
      final data = state.orderUser?.toJson();

      return data;
    }
    return null;
  }

  @override
  AddressState? fromJson(Map<String, dynamic> json) {
    try {
      final order = OrderUser.fromJson(json);      

      final obj = AddressState(
          orderUser: order,
          existOrder: order.id != null ? true : false,
          orderHistory: [...state.orderHistory, order]);

      return obj;
    } catch (e) {
      return null;
    }
  }

  Future<void> _onCreateOrderUserEvent(
  CreateOrderUserEvent event,
  Emitter<AddressState> emit,
) async {
  final ubicacion = event.ubicacion;
  final token = authBloc.state.usuario?.token;
  final idUser = authBloc.state.usuario?.uid;

  if (token == null || idUser == null) {
    print('⚠️ Token o ID de usuario nulo');
    return;
  }

  final idOrder = await addressService.postAddresses(ubicacion, token, idUser);

  if (idOrder != null) {
  

    final order = await addressService.getAddress(token, idUser);
    add(AddOrderUserEvent(order));
    emit(state.copyWith(message: 'orden_creada'));
  } else {
  
    emit(state.copyWith(message: 'fuera_covertura'));
  }
}
 
  

  Stream<OrderUser> getOrderUser() async* {

    final String? token = authBloc.state.usuario?.token; 
    final String? idUser = authBloc.state.usuario?.uid;

    final closeController = _addressController.isClosed;
  
    try {

      if (closeController) return;     

      final resp = await addressService.getAddress(token!, idUser!);      
      
      final idOrder = resp.id ?? '';      
      final idDriver = resp.idDriver ?? '';
      

      if (idOrder.isEmpty || idDriver.isEmpty  ) {

        add(OnNotExistOrderUserEvent());
        return;
      } else {
        Future.delayed(const Duration(seconds: 2));       

        add(AddOrderUserEvent(resp));

        _addressController.add(resp);

        yield resp;
      }
    } catch (e) {
      // ignore: avoid_print
      print('Error: $e');
    }
  }

  Future<void> _onFinishOrderEvent(
  FinishOrderEvent event,
  Emitter<AddressState> emit,
) async {
  final token = authBloc.state.usuario?.token;
  final idUser = authBloc.state.usuario?.uid;

  if (token == null || idUser == null) return;

  try {

    await addressService.finishTravel(token, idUser);
    await StorageService.instance.deleteIdDriver();
    await StorageService.instance.deleteIdOrder();
   

    add(const OnClearStateEvent());

    emit(state.copyWith(message: 'viaje_finalizado'));
  } catch (e) {
    emit(state.copyWith(message: 'error_finalizar'));
  }
}

 


  void startLoadingAddress() {
    add(OnStartLoadingOrderUser());
    getOrderUser();
  }

  void stopLoadingAddress() {
    add(OnStopLoadingOrderUser());
    _addressController.close();
  }

  @override
  Future<void> close() {
    stopLoadingAddress();
    return super.close();
  }
}
