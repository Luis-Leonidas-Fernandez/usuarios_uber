import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:usuario_inri/models/notification.dart';

part 'notification_event.dart';
part 'notification_state.dart';

class NotificationBloc extends HydratedBloc<NotificationEvent, NotificationState> {

  late StreamSubscription notificationServiceSubscription;

  NotificationBloc() : super(const NotificationState(notificationModel: null)) {
    
    on<NotificationAndPermissionEvent>((event, emit) => emit(state.copyWith(
     notificationModel: event.notificationModel,
     
    ))
    
    );
    initBloc();
  }

  
  
  @override
  NotificationState? fromJson(Map<String, dynamic> json) {
     
      try {

      final noticationModel  = NotificationModel.fromJson(json);
            
      final notificationStatus = NotificationState(
      notificationModel: noticationModel      
       );          
           
      return notificationStatus;  

      
    } catch (e) {
      return null;
    }
  }
  
  @override
  Map<String, dynamic>? toJson(NotificationState state) {
       
       if(state.notificationModel != null){
      final data = state.notificationModel!.toJson();      
     
      return data;
     }else{
      return null;
     }     
  } 

  Future <void> initBloc() async {

    await _isNotificationPermissionGranted();
   
    
    final notificationInitStatus = await Future.wait([   
    _isNotificationPermissionGranted(),
    ]);

    final notificationStatus = NotificationModel(
      isNotificationPermissionGranted: notificationInitStatus[0]);
    
    
    add(NotificationAndPermissionEvent(      
      notificationModel: notificationStatus
      ));
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

        notificationModel: NotificationModel(
          isNotificationPermissionGranted: true)
      ));

      break;

    case PermissionStatus.denied:     
    case PermissionStatus.restricted:
    case PermissionStatus.limited:
    case PermissionStatus.permanentlyDenied:

    add(NotificationAndPermissionEvent(

    notificationModel: NotificationModel(
          isNotificationPermissionGranted: false)

   )); 
    openAppSettings();    
    
      
   }

  }
  
   @override 
  Future<void> close(){
    notificationServiceSubscription.cancel();
    return super.close();
  }

 
  
}
