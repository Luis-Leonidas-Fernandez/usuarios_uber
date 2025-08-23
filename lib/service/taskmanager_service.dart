// Be sure to annotate your callback function to avoid issues in release mode on Flutter >= 3.3.0
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:usuario_inri/constants/constants.dart';
import 'package:usuario_inri/models/address.dart';
import 'package:usuario_inri/service/addresses_service.dart';
import 'package:usuario_inri/service/location_service.dart';
//import 'package:usuario_inri/service/message_service.dart';
import 'package:usuario_inri/service/storage_service.dart';
import 'package:usuario_inri/main.dart' show flutterLocalNotificationsPlugin;


@pragma('vm:entry-point')
 void getStatusAddress() async { 
  

  // verifica si existe una order activa  en Storage Service
  final isActiveOrder = await LocationService.instance.isActiveOrder();
  final existUserIdAndToken = await LocationService.instance.getIdUserAndToken();
  final idOrder =  await StorageService.instance.getIdOrder(); 
  final lastNotified = await StorageService.instance.getLastNotifiedOrderId();
  
  
    if (isActiveOrder && existUserIdAndToken && idOrder != null ) {
        
        
        final order = await searchAddress();

        final enCaminoYaNotificado = await StorageService.instance.isStatusAlreadyNotified(idOrder, 'en-camino');
        //Mostrar nontificacion si: existe addres, existe conductor y order marcada como en camino
        if(!enCaminoYaNotificado && order.id != null && order.idDriver != null && 
        order.idDriver != '0' && order.order == 'en-camino'){

        
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

        await StorageService.instance.saveNotifiedStatus(idOrder, 'en-camino');
   
        }                     
        
        final llegoYaNotificado = await StorageService.instance.isStatusAlreadyNotified(idOrder, 'llego-conductor');

        // Mostrar nontificacion si: existe addres, existe conductor y order marcada como llego conductor
        if(!llegoYaNotificado && order.id != null && order.idDriver != null && 
        order.idDriver != '0' && order.order == 'llego-conductor'){
        
        const color   =  Color.fromARGB(255, 63, 81, 184);  
        final fecha   =   AppConstants.getFormattedDate();
        final hora    =   AppConstants.getFormattedTime();
        const message =  'El conductor ha llegado a tu ubicacion!';

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
        await StorageService.instance.saveNotifiedStatus(idOrder, 'llego-conductor');

        }
    
       //await StorageService.instance.saveNotified(idOrder);
       //await MessageService().cancelPeriodicMessage();
  
       } else{
        return;
       }
       


 }


Future<OrderUser> searchAddress() async {

  // leer order de Data Base  
  final response = await AddressService().getAddressesBackground(); 
   
  return response;
}