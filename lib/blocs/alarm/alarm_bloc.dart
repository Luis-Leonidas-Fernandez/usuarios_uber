import 'dart:async';

import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:usuario_inri/models/alarm.dart';
import 'package:equatable/equatable.dart';


part 'alarm_event.dart';
part 'alarm_state.dart';

class AlarmBloc extends HydratedBloc<AlarmEvent, AlarmState> {

  late StreamSubscription alarmServiceSubscription;

  AlarmBloc() : super(const AlarmState(alarmModel: null)) {
    
    on<AlarmAndPermissionEvent>((event, emit) => emit(state.copyWith(
     alarmModel: event.alarmModel,
     
    ))
    
    );
    initAlarmBloc();
  }

  
  
  @override
  AlarmState? fromJson(Map<String, dynamic> json) {
     
      try {

      final alarmModel  = AlarmModel.fromJson(json);
            
      final alarmStatus = AlarmState(
      alarmModel: alarmModel      
       );          
           
      return alarmStatus;  

      
    } catch (e) {
      return null;
    }
  }
  
  @override
  Map<String, dynamic>? toJson(AlarmState state) {
       
       if(state.alarmModel != null){
      final data = state.alarmModel!.toJson();      
     
      return data;
     }else{
      return null;
     }     
  } 

  Future <void> initAlarmBloc() async {

    await _isAlarmPermissionGranted();
   
    
    final alarmInitStatus = await Future.wait([   
    _isAlarmPermissionGranted(),
    ]);

    final alarmStatus = AlarmModel(
      isAlarmPermissionGranted: alarmInitStatus[0]);
    
    
    add(AlarmAndPermissionEvent(      
      alarmModel: alarmStatus
      ));
  }


  Future<bool> _isAlarmPermissionGranted() async {
    final isGranted = await Permission.scheduleExactAlarm.isGranted;
    return isGranted;

  }

  //pregunta y muestra los permisos que necesita como la Alarma
  Future<void> askAlarmAccess() async {
  final status = await Permission.scheduleExactAlarm.request();

  switch(status){

    //case PermissionStatus
    case PermissionStatus.provisional:
    case PermissionStatus.granted:

      //habilita los permisos de la alarma
      add(AlarmAndPermissionEvent(

        alarmModel: AlarmModel(
          isAlarmPermissionGranted: true)
      ));

      break;

    case PermissionStatus.denied:     
    case PermissionStatus.restricted:
    case PermissionStatus.limited:
    case PermissionStatus.permanentlyDenied:

    add(AlarmAndPermissionEvent(

    alarmModel: AlarmModel(
          isAlarmPermissionGranted: false)

   )); 
    openAppSettings();    
    
      
   }

  }
  
   @override 
  Future<void> close(){
    alarmServiceSubscription.cancel();
    return super.close();
  }

 
  
}
