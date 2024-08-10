part of 'alarm_bloc.dart';


abstract class AlarmEvent extends Equatable{

const AlarmEvent();

@override
List<Object> get props => [];

}

class AlarmAndPermissionEvent extends AlarmEvent{
 
 final AlarmModel? alarmModel;
  
 const AlarmAndPermissionEvent({ required this.alarmModel});

  
}
