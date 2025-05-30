import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:usuario_inri/blocs/blocs.dart';
import 'package:usuario_inri/service/storage_service.dart';


class ViajeUtils {
  

  /// Función maestra para limpiar todo al finalizar un viaje
  static Future<void> finalizarViajeYLimpiarTodo(BuildContext context) async {
  
    // 1. Cancelar streams, timers y ubicaciones
    context.read<LocationBloc>().stopFollowingUser();
    //context.read<LocationBloc>().stopPeriodicTask();

    // 2. Reiniciar lógica de precio y cronómetro
    context.read<PrecioDistanciaBloc>().add(const ResetearPrecioDistanciaEvent());
    context.read<CronometroBloc>().add(const ResetCronometroEvent());

    // 3. Reiniciar estado de AddressBloc
    context.read<AddressBloc>().add(OnClearStateEvent());

    //.4 Eliminar Usuario del Estado
    context.read<AuthBloc>().add(OnClearUserSessionEvent());

    // 4. Limpiar storage persistente
    await HydratedBloc.storage.clear();    

    //5. Limpiar Notification saved
    final orderId = await StorageService.instance.getIdOrder();
    if (orderId != null) {
    await StorageService.instance.clearNotified(orderId);
    }
   
    

  }
}
