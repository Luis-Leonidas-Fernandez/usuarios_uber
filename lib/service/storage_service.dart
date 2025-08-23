import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StorageService {

 //Instanciando class Storage Service
 StorageService._internal();
 static final StorageService _instance = StorageService._internal();
 static StorageService get instance => _instance;


  //Config Storage Service para android
  static AndroidOptions _getAndroidOptions() => const AndroidOptions(
     encryptedSharedPreferences: true,
   );
  
  // Config Storage para ios
  // ignore: unused_element
   IOSOptions _getIOSOptions() => const IOSOptions(
    accountName: AppleOptions.defaultAccountName,
   );

  final storage = const FlutterSecureStorage( );
  
  //Guardar token en storage 
  Future<void> saveToken( String? token ) async {   
  return await storage.write(key: 'token', value: token, aOptions: _getAndroidOptions() );
  } 

  // Obteniendo el token 
  Future<String?> getToken() async {        
  final token = await storage.read(key: 'token', aOptions: _getAndroidOptions());    
   return token.toString(); 
  }  

  //Eliminar token y cerrar sesion
  Future deleteToken() async {    
  return await storage.delete(key: 'token', aOptions: _getAndroidOptions());
  }  

  // Guardando ID del Usuario  
  Future saveId( String? id ) async {
    return await storage.write(key: 'id', value: id, aOptions: _getAndroidOptions() );
  }

  // Obteniendo ID del Usuario

  Future<String?> getId() async {      
    final id = await storage.read(key: 'id', aOptions: _getAndroidOptions());       
    return id; 
  }

  // Eliminando ID del Usuario
  Future<void> deleteId() async {      
     await storage.delete(key: 'id', aOptions: _getAndroidOptions());       
      
  }    

  // Guardando NOMBRE del Usuario
  Future saveNameUser(String? name) async {      
     await storage.write(key: 'name', value: name, aOptions: _getAndroidOptions());       
      
  }

  // Obteniendo Nombre del Usuario
  Future<String?> getNameUser() async {      
    final name = await storage.read(key: 'name', aOptions: _getAndroidOptions());       
    return name; 
  }


  // Guardando ID de la Order
  Future saveIdOrder( String? idOrder ) async {
    return await storage.write(key: 'idOrder', value: idOrder, aOptions: _getAndroidOptions() );
  }

  // Obteniendo ID de la Order
  Future<String?> getIdOrder() async {      
  final idOrder = await storage.read(key: 'idOrder', aOptions: _getAndroidOptions());       
  return idOrder; 
  }

  // Eliminando ID de la Orden    
  Future<void> deleteIdOrder() async {   
   await storage.delete(key: 'idOrder', aOptions: _getAndroidOptions());   
  }  

  // Guardando ID del Driver
  Future guardarIdDriver( String? id ) async {
  return await storage.write(key: 'idDriver', value: id, aOptions: _getAndroidOptions() );
  }
  
  // Obteniendo ID DRIVER
  Future<dynamic> getIdDriver() async {    
    
    final id = await storage.read(key: 'idDriver', aOptions: _getAndroidOptions());       
    return id; 
  }

  
  // Eliminando ID del Driver
  Future<void> deleteIdDriver() async {
    
    await storage.delete(key: 'idDriver', aOptions: _getAndroidOptions());
  }  


  // Guardar el último ID notificado globalmente
Future<void> saveLastNotifiedOrderId(String orderId) async {
  await storage.write(
    key: 'last_notified_order_id',
    value: orderId,
    aOptions: _getAndroidOptions(),
  );
}

// Obtener el último ID notificado
Future<String?> getLastNotifiedOrderId() async {
  return await storage.read(
    key: 'last_notified_order_id',
    aOptions: _getAndroidOptions(),
  );
}

// Guardar que se notificó un estado de una orden específica
Future<void> saveNotifiedStatus(String orderId, String status) async {
  final key = 'notified_${orderId}_$status';
  await storage.write(key: key, value: 'true', aOptions: _getAndroidOptions());
}

// Verificar si ya se notificó un estado específico de una orden
Future<bool> isStatusAlreadyNotified(String orderId, String status) async {
  final key = 'notified_${orderId}_$status';
  final value = await storage.read(key: key, aOptions: _getAndroidOptions());
  return value == 'true';
}

// Eliminar todo el contenido del storage seguro
Future<void> clearAll() async {
  await storage.deleteAll(aOptions: _getAndroidOptions());
}

  

}