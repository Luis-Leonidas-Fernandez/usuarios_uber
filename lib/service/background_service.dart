// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:io';


import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';


import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:usuario_inri/service/addresses_service.dart';
import 'package:usuario_inri/service/location_service.dart';



class BackgroundService {

  BackgroundService._internal();

  static final BackgroundService _instance = BackgroundService._internal();
  static BackgroundService get instance => _instance;
  

  Future<void> initializeService() async {


    final service = FlutterBackgroundService(); 

    const AndroidNotificationChannel channel = AndroidNotificationChannel(
     'my_foreground',// id
      'MY FOREGROUND SERVICE', // title
      description:
          'This channel is used for important notifications.', // description
      importance: Importance.low, // importance must be at low or higher level
    );

    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    if (Platform.isIOS || Platform.isAndroid) {

    await flutterLocalNotificationsPlugin.initialize(
      const InitializationSettings(
        iOS: DarwinInitializationSettings(),
        android: AndroidInitializationSettings('ic_bg_service_small'),
      ),
    );
  }  

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    await service.configure(
    androidConfiguration: AndroidConfiguration(
      // this will be executed when app is in foreground or background in separated isolate
      onStart: onStart,

      // auto start service
      autoStart: true,
      isForegroundMode: true,

      notificationChannelId: 'my_foreground',
      initialNotificationTitle: 'UBICACION ACTIVA',
      initialNotificationContent: 'SERVICIO INRI ACTIVO',
      foregroundServiceNotificationId: 888,
    ),

      iosConfiguration: IosConfiguration(
        // auto start service
        autoStart: true,

        // this will executed when app is in foreground in separated isolate
        onForeground: onStart,

        // you have to enable background fetch capability on xcode project
        onBackground: onIosBackground,
      ),
    );
    service.startService();
  }
}

@pragma('vm:entry-point')

Future<bool> onIosBackground(ServiceInstance service) async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();

  return true;
}

@pragma('vm:entry-point')

void onStart(ServiceInstance service) async {
  DartPluginRegistrant.ensureInitialized();

  /// OPTIONAL when use custom notification
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  if (service is AndroidServiceInstance) {
    service.on('setAsForeground').listen((event) {
      service.setAsForegroundService();
    });

    service.on('setAsBackground').listen((event) {
      service.setAsBackgroundService();
    });
  }

  service.on('stopService').listen((event) {
    service.stopSelf();

  });    
 
  

  Timer.periodic(const Duration(minutes: 1), (timer) async {      
  
  
  // verifica si existe una order activa  en Storage Service
  final isActiveOrder = await LocationService.instance.isActiveOrder();
  final existUserIdAndToken = await LocationService.instance.getIdUserAndToken();


    if (isActiveOrder && existUserIdAndToken) {

    if (service is AndroidServiceInstance) {     

      if (await service.isForegroundService()) { 

        await existAddress();   
             
        DateTime now = DateTime.now();
        const color = Colors.indigo;        
        
        final fecha = "${now.day}" '-' "${now.month}" '-' "${now.year}";
        final hora = "${now.hour}:${now.minute}";
        const message = 'Felicitaciones ya tienes tu conductor!';      
                

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
      } else {
        false;
      }
    }
    }
  });


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




  
