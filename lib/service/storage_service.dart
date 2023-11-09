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
  Future saveToken( String? token ) async {   
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
    
    final storage = FlutterSecureStorage();
    final id = await storage.read(key: 'idDriver', aOptions: _getAndroidOptions());       
    return id; 
  }

  
  // Eliminando ID del Driver
  Future<void> deleteIdDriver() async {
    final storage = FlutterSecureStorage();
    await storage.delete(key: 'idDriver', aOptions: _getAndroidOptions());
  }  
  

}