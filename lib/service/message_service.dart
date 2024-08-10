import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:usuario_inri/service/manager.dart';


class MessageService {

  static const int helloAlarmID = 0;
  
  Future initPeriodicMessage() async {    

    return await AndroidAlarmManager.periodic(const Duration(minutes: 2),
    helloAlarmID,
    getStatusAddress
    ); 

  }

  Future<void> cancelPeriodicMessage() async {

    await AndroidAlarmManager.cancel(helloAlarmID);
  }

     
     
}