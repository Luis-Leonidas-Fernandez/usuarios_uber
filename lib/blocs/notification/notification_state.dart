part of 'notification_bloc.dart';

class NotificationState extends Equatable {
  
  final bool isNotificationPermissionGranted;

  bool get isAllNotificationGranted => isNotificationPermissionGranted;

  const NotificationState({
    
    required this.isNotificationPermissionGranted
  });

  NotificationState copyWith({
    
    bool? isGpsPermissionGranted, required bool isNotificationPermissionGranted,
  }) => NotificationState(
    
    isNotificationPermissionGranted: isNotificationPermissionGranted
  );

  @override
  List<Object> get props => [ isNotificationPermissionGranted ];
}


/* part of 'notification_bloc.dart';

class NotificationState extends Equatable {
  
  final bool isNotificationPermissionGranted;

  bool get isAllNotificationGranted => isNotificationPermissionGranted;

  const NotificationState({
    
    required this.isNotificationPermissionGranted
  });

  NotificationState copyWith({
    
    bool? isGpsPermissionGranted, required bool isNotificationPermissionGranted,
  }) => NotificationState(
    
    isNotificationPermissionGranted: isNotificationPermissionGranted
  );

  @override
  List<Object> get props => [ isNotificationPermissionGranted ];
}
 */

