import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:latlong2/latlong.dart';
import 'package:usuario_inri/blocs/blocs.dart';
import 'package:usuario_inri/models/address.dart';
import 'package:usuario_inri/service/addresses_service.dart';
import 'package:usuario_inri/service/message_service.dart';
import 'package:usuario_inri/service/storage_service.dart';

part 'address_event.dart';
part 'address_state.dart';

class AddressBloc extends HydratedBloc<AddressEvent, AddressState> {
  AddressService addressService;
  final MessageService messageService = MessageService();
  final AuthBloc authBloc;
  Timer? _pollingTimer;

  final CronometroBloc cronometroBloc;
  final PrecioDistanciaBloc precioDistanciaBloc;
  final storage = StorageService.instance;

  final StreamController<OrderUser> _addressController = StreamController();
  Stream<OrderUser> get addressOrder => _addressController.stream;

  AddressBloc(
      {required this.addressService,
      required this.authBloc,
      required this.cronometroBloc,
      required this.precioDistanciaBloc})
      : super(const AddressState()) {
    on<OnUpdateVisualStateEvent>((event, emit) {
      emit(state.copyWith(
        isWaitingDriver: event.isWaitingDriver,
        isTripActive: event.isTripActive,
        isTripFinished: event.isTripFinished,
        orderUser: event.orderUser,
      ));
    });

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

    // limpieza de la UI
    on<OnClearStateEvent>((event, emit) async {
      final resumenPrevio = state.orderUser;
      final tieneResumen =
          resumenPrevio?.precio != null && resumenPrevio?.distanciaKm != null;

      // 🔒 Solo borra el ID si no hay resumen
      if (!tieneResumen) {
        await HydratedBloc.storage.write('AddressBloc', null);
        _addressController.add(OrderUser.empty());
        await storage.deleteIdOrder();
        await storage.deleteIdDriver();
        cronometroBloc.add(const ResetCronometroEvent());
        emit(const UserInitialState());
        return;
      }


      emit(state.copyWith(
        isWaitingDriver: false,
        isTripActive: false,
        isTripFinished: true,
        orderUser: resumenPrevio?.copyWith(id: 'resumen'),
      ));
    });

    on<CreateOrderUserEvent>(_onCreateOrderUserEvent);
    on<FinishOrderEvent>(_onFinishOrderEvent);

    on<ClearMessageEvent>((event, emit) {
      emit(state.copyWith(message: ''));
    });

    on<AddOrderUserEvent>((event, emit) {
      emit(state.copyWith(
          orderUser: event.orderUser,
          existOrder: event.orderUser.id?.isNotEmpty == true,
          isAccepted: event.orderUser.idDriver?.isNotEmpty == true,
          orderhistory: [...state.orderHistory, event.orderUser]));
    });

    on<OnGuardarResumenViajeEvent>((event, emit) {
      final currentOrder = state.orderUser ?? OrderUser.empty();

      final nuevoOrder = currentOrder.copyWith(
        distanciaKm: event.distanciaKm,
        precio: event.precio,
      );

      emit(state.copyWith(orderUser: nuevoOrder));
    });

    on<OnGuardarPrecioTotalEvent>((event, emit) {
      final currentOrder = state.orderUser ?? OrderUser.empty();
      final newOrder = currentOrder.copyWith(precioTotal: event.precioTotal);

      emit(state.copyWith(orderUser: newOrder));
    });

    on<OnGuardarDestinoEvent>((event, emit) {
      emit(state.copyWith(destinoSeleccionado: event.destino));
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
    final distanciaKm = state.orderUser?.distanciaKm;
    final precio = state.orderUser?.precio;
    final destino = state.destinoSeleccionado;

    if (token == null ||
        idUser == null ||
        distanciaKm == null ||
        precio == null ||
        destino == null) {
     
      return;
    }

    // limpia las ordenes viejas
    emit(state.copyWith(orderUser: OrderUser.empty()));

    // 🔁 Paso 1: Crear la orden en el backend
    final idOrder = await addressService.postAddresses(
      ubicacion,
      destino,
      token,
      idUser,
      distanciaKm,
      precio,
    );

    if (idOrder != null) {
      // 🔁 Paso 2: Consultar el estado completo de la orden
      final fullOrder = await addressService.getAddress(token, idUser);

      // 🔁 Paso 3: Emitir los flags visuales correctos
      final hasOrder = fullOrder.id != null && fullOrder.id!.isNotEmpty;
      final hasDriver =
          fullOrder.idDriver != null && fullOrder.idDriver!.isNotEmpty;
      final isValid = fullOrder.ok ?? false;

      if (hasOrder && !hasDriver && !isValid) {
        add(OnUpdateVisualStateEvent(
          isWaitingDriver: true,
          isTripActive: false,
          isTripFinished: false,
          orderUser: fullOrder,
        ));
      } else if (hasOrder && hasDriver && isValid) {
        add(OnUpdateVisualStateEvent(
          isWaitingDriver: false,
          isTripActive: true,
          isTripFinished: false,
          orderUser: fullOrder,
        ));
      } else {
        add(OnUpdateVisualStateEvent(
          isWaitingDriver: false,
          isTripActive: false,
          isTripFinished: true,
          orderUser: OrderUser.empty(),
        ));
      }

      emit(state.copyWith(message: 'orden_creada'));
    } else {
      emit(state.copyWith(message: 'fuera_covertura'));
    }
  }

  Future<void> getOrderUser() async {
    final token = authBloc.state.usuario?.token;
    final idUser = authBloc.state.usuario?.uid;

    if (token == null || idUser == null) return;

    try {
      final newOrder = await addressService.getAddress(token, idUser);
 

      // Esta es tu orden falsa (resumen local)
      final isFakeOrder = newOrder.id == 'resumen';

      // Si Todabia no hay una order registrada emitimos una order fake
      if (isFakeOrder) {
        // Si ya estamos mostrando el resumen, no lo pisamos
        if (state.isTripFinished &&
            state.orderUser?.id == 'resumen' &&
            state.orderUser?.precio != null &&
            state.orderUser?.distanciaKm != null) {
         
          return;
        }

        final resumen = OrderUser.empty().copyWith(id: 'resumen');

        add(OnUpdateVisualStateEvent(
          isWaitingDriver: false,
          isTripActive: false,
          isTripFinished: true,
          orderUser: resumen,
        ));

        messageService.cancelPeriodicMessage();
        precioDistanciaBloc.add(ResetearPrecioDistanciaEvent());
        cronometroBloc.add(const ResetCronometroEvent());
        return;
      }

      final isEmptyOrder = newOrder.id == null || newOrder.id!.isEmpty;
      final isFinalizado = newOrder.finalizado == true;

      // 🟩 Caso: backend borró la orden
      if (isEmptyOrder) {
       

        // 🧠 Si ya estábamos mostrando el resumen, no limpiamos
        if (state.isTripFinished &&
            state.orderUser?.precio != null &&
            state.orderUser?.distanciaKm != null) {
        
          return;
        }

        // 🧹 Si no hay resumen previo, limpiamos todo
        add(OnClearStateEvent());
        return;
      }

      // ❌ Caso: el conductor finalizó el viaje (antes de borrarse del backend)
      if (isFinalizado) {
      
        final resumenFinal = newOrder.copyWith(
          id: 'resumen', // evitar que sea null
        );

        // 🧠 Emitimos el resumen para conservarlo antes del próximo polling
        add(OnUpdateVisualStateEvent(
          isWaitingDriver: false,
          isTripActive: false,
          isTripFinished: true,
          orderUser: resumenFinal,
        ));

        messageService.cancelPeriodicMessage();
        return;
      }

      // 🔄 Si hay cambios en la orden activa
      final oldOrder = state.orderUser;

      final hasChanged = oldOrder?.id != newOrder.id ||
          oldOrder?.idDriver != newOrder.idDriver ||
          oldOrder?.order != newOrder.order ||
          oldOrder?.horaEsperaInicio != newOrder.horaEsperaInicio ||
          oldOrder?.horaEsperaFin != newOrder.horaEsperaFin ||
          oldOrder?.mensaje?.coordinates.join(',') !=
              newOrder.mensaje?.coordinates.join(',');

      if (hasChanged) {
     
        add(OnUpdateVisualStateEvent(
          isWaitingDriver: newOrder.id != null &&
              (newOrder.idDriver == null || newOrder.idDriver!.isEmpty),
          isTripActive: newOrder.order == 'libre' ||
              newOrder.order == 'en-camino' ||
              newOrder.order == 'llego-conductor',
          isTripFinished: false,
          orderUser: newOrder,
        ));
      }
    } catch (_) {
      return;
    }
  }

  Future<void> _onFinishOrderEvent(
    FinishOrderEvent event,
    Emitter<AddressState> emit,
  ) async {
    final token = authBloc.state.usuario?.token;
    final idUser = authBloc.state.usuario?.uid;

    final precioPorEspera = cronometroBloc.state.price;

    final precioPorDistancia = state.orderUser?.precio ?? 0.0;
    final precioTotal = precioPorDistancia + precioPorEspera;

    // Si necesitás guardarlo en el bloc:
    emit(state.copyWith(
        orderUser: state.orderUser?.copyWith(precio: precioTotal)));

    if (token == null || idUser == null) return;

    try {
      await addressService.finishTravel(token, idUser, precioTotal);

      await StorageService.instance.deleteIdDriver();
      await StorageService.instance.deleteIdOrder();

      add(const OnClearStateEvent());

      emit(state.copyWith(message: 'viaje_finalizado'));
    } catch (e) {
      emit(state.copyWith(message: 'error_finalizar'));
    }
  }

  void startPollingOrderUser() {
    _pollingTimer?.cancel();
    _pollingTimer = Timer.periodic(const Duration(seconds: 5), (_) async {
      await getOrderUser();
    });
  }

  void stopPollingOrderUser() {
    _pollingTimer?.cancel();
    _pollingTimer = null;
  }

  void startLoadingAddress() {
    add(OnStartLoadingOrderUser());
  }

  void stopLoadingAddress() {
    add(OnStopLoadingOrderUser());
  }

  @override
  Future<void> close() {
    stopPollingOrderUser();
    return super.close();
  }
}
