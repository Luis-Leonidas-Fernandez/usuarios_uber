import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:permission_handler/permission_handler.dart';

part 'notification_event.dart';
part 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {

  late StreamSubscription notificationServiceSubscription;

  NotificationBloc() : super(const NotificationState(isNotificationPermissionGranted:  false)) {
    
    on<NotificationAndPermissionEvent>((event, emit) => emit(state.copyWith(
     
     isNotificationPermissionGranted: event.isNotificationPermissionGranted
    ))
    
    );
    initBloc();
  }

  Future <void> initBloc() async {

    final isEnable = await _isNotificationPermissionGranted();
    // ignore: avoid_print
    print('Habilitado: $isEnable');
    
    final notificationInitStatus = await Future.wait([   
    _isNotificationPermissionGranted(),
    ]);
    
    
    add(NotificationAndPermissionEvent(      
      isNotificationPermissionGranted: notificationInitStatus[0]));
  }


  Future<bool> _isNotificationPermissionGranted() async {
    final isGranted = await Permission.notification.isGranted;
    return isGranted;

  }

  //pregunta y muestra los permisos que necesita como la ubicacion
  Future<void> askNotificationAccess() async {
  final status = await Permission.notification.request();

  switch(status){

    //case PermissionStatus
    case PermissionStatus.provisional:
    case PermissionStatus.granted:

      //habilita los permisos de la ubicacion
      add(NotificationAndPermissionEvent(
      isNotificationPermissionGranted: true));

      break;

    case PermissionStatus.denied:     
    case PermissionStatus.restricted:
    case PermissionStatus.limited:
    case PermissionStatus.permanentlyDenied:

    add(NotificationAndPermissionEvent(
    isNotificationPermissionGranted: false)); 
    openAppSettings();    
    
      
   }

  }


  @override 
  Future<void> close(){
    notificationServiceSubscription.cancel();
    return super.close();
  } 
  
}
