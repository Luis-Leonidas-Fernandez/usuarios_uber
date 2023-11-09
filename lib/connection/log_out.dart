import 'package:usuario_inri/service/addresses_service.dart';

import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:usuario_inri/Generators/isolate_parse_json.dart';
import 'package:usuario_inri/service/storage_service.dart';

class LogOutApp {


   LogOutApp._internal();


   static final LogOutApp _instance = LogOutApp._internal();
   static LogOutApp get instance => _instance;
   late AddressService addressService = AddressService(); 
      

   void finishApp() async {

    

    //Eliminar ID ORDER
    StorageService.instance.deleteIdOrder();

    StorageService.instance.deleteIdDriver();  
    
    // Eliminar token
    StorageService.instance.deleteToken();

    //finalizar Isolate get Orders

    ParseData.instance.stopIsolate();

    // Finalizar BackgroundService
    final service = FlutterBackgroundService();
    service.invoke('stopService');

    


   }
}