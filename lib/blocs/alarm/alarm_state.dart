part of 'alarm_bloc.dart';


class AlarmState extends Equatable {  
  
  
  final AlarmModel? alarmModel;

  const AlarmState({
    this.alarmModel,
    
  });

  AlarmState copyWith({    
   
    AlarmModel? alarmModel,

  }) => AlarmState(
    alarmModel: alarmModel?? this.alarmModel,
   
  );

  @override
  List<Object?> get props => [ alarmModel ];
}

