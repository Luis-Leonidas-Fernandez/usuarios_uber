import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:usuario_inri/blocs/blocs.dart';
import 'package:usuario_inri/models/address.dart';
import 'package:usuario_inri/service/addresses_service.dart';

part 'address_event.dart';
part 'address_state.dart';

class AddressBloc extends HydratedBloc<AddressEvent, AddressState> {
  AddressService addressService;
  final AuthBloc authBloc;

  final StreamController<OrderUser> _addressController = StreamController();
  Stream<OrderUser> get addressOrder => _addressController.stream;

  AddressBloc({required this.addressService, required this.authBloc}) : super(const AddressState()) {
    on<OnStartLoadingOrderUser>(
        (event, emit) => emit(state.copyWith(loading: true)));
    on<OnStopLoadingOrderUser>(
        (event, emit) => emit(state.copyWith(loading: false)));
    on<ExistOrderUserEvent>(
        (event, emit) => emit(state.copyWith(existOrder: false)));
    on<OnIsDeclinedTravel>(
        (event, emit) => emit(state.copyWith(isAccepted: false)));
    on<OnIsAcceptedTravel>(
        (event, emit) => emit(state.copyWith(isAccepted: true)));
    on<OnClearStateEvent>((event, emit) => emit(const UserInitialState()));

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

  Stream<OrderUser> getOrderUser() async* {

    final String? token = authBloc.state.usuario?.token; 
    final String? idUser = authBloc.state.usuario?.uid;

    final closeController = _addressController.isClosed;
  
    try {
      if (closeController) return;     

      final resp = await addressService.getAddress(token!, idUser!);      
      
      final id = resp.idDriver;
     

      if (id == '0') {

        add(ExistOrderUserEvent());
        return;
      } else {
        Future.delayed(const Duration(seconds: 2));

        add(AddOrderUserEvent(resp));

        _addressController.add(resp);

        yield resp;
      }
    } catch (e) {
      print('Error: $e');
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
