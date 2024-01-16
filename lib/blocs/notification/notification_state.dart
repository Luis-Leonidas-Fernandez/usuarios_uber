part of 'notification_bloc.dart';

class NotificationState extends Equatable {  
  
  
  final NotificationModel? notificationModel;

  const NotificationState({
    this.notificationModel,
    
  });

  NotificationState copyWith({    
   
    NotificationModel? notificationModel,

  }) => NotificationState(
    notificationModel: notificationModel?? this.notificationModel,
   
  );

  @override
  List<Object?> get props => [ notificationModel ];
}



