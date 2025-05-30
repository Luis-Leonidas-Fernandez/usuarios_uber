// Be sure to annotate your callback function to avoid issues in release mode on Flutter >= 3.3.0
//import 'package:flutter/material.dart';

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:usuario_inri/constants/constants.dart';
import 'package:usuario_inri/service/addresses_service.dart';
import 'package:usuario_inri/service/location_service.dart';
import 'package:usuario_inri/service/message_service.dart';
import 'package:usuario_inri/service/storage_service.dart';

@pragma('vm:entry-point')
 void getStatusAddress() async { 

 
  /// OPTIONAL when use custom notification
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // verifica si existe una order activa  en Storage Service
  final isActiveOrder = await LocationService.instance.isActiveOrder();
  final existUserIdAndToken = await LocationService.instance.getIdUserAndToken();
  final idOrder =  await StorageService.instance.getIdOrder(); 
  final alreadyNotified = await StorageService.instance.isAlreadyNotified(idOrder);
  
  
    if (isActiveOrder && existUserIdAndToken && !alreadyNotified ) {
        
        
        await existAddress();                      
       
        const color   =  Color.fromARGB(255, 63, 81, 184);  
        final fecha   =   AppConstants.getFormattedDate();
        final hora    =   AppConstants.getFormattedTime();
        const message =  'Felicitaciones ya tienes tu conductor!';

        flutterLocalNotificationsPlugin.show(
         888,
          'NUEVO MENSAJE:  $message',
          'Fecha: $fecha Hora: $hora',
                   
          const NotificationDetails(
              android: AndroidNotificationDetails(
            'my_foreground',
            'MY FOREGROUND SERVICE',
            importance: Importance.max,
            priority: Priority.high,
            icon: '@drawable/car_launcher',
            largeIcon: DrawableResourceAndroidBitmap('@mipmap/ic_launcher'),           
            color: color,
            colorized: true,           
            
          )),
        );   
    
       await StorageService.instance.saveNotified(idOrder);
       await MessageService().cancelPeriodicMessage();
  
       } else{
        return;
       }
       


 }


Future<bool> existAddress() async {

  // leer order de Data Base  
  final address = await AddressService().getAddressesBackground(); 
  final idOrderAct = address.id;   
  
  if(idOrderAct != null){
    return true;
  }else{
    return false;
  }
}