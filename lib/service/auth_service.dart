import 'dart:convert';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:usuario_inri/global/environment.dart';
import 'package:usuario_inri/models/login.dart';
import 'package:usuario_inri/models/usuario.dart';
import 'package:usuario_inri/service/storage_service.dart';


class AuthService with ChangeNotifier {

bool _autenticando = false;
//crear storage
final storage = StorageService.instance;


//determina la autenticacion

bool get autenticando => _autenticando;
set autenticando( bool valor ) {
  _autenticando = valor;

  notifyListeners();    

}   
          

//Registro de Usuario
Future<Usuario> register(String nombre, String email, String password ) async {
   

    final data = {'nombre': nombre,'email': email,'password': password};    
    final body = jsonEncode(data);
    final headers = {'Content-Type': 'application/json'};

    final resp = await http.post(Uri.parse('${Environment.apiUrl }/login/new'), body: body, headers: headers);     
    
   
    if ( resp.statusCode == 200 ) {
    
    final loginResponse = loginResponseFromJson( resp.body ); 
    final usuario = loginResponse.usuario;  
    
    final user = Usuario(online: usuario.online, nombre: usuario.nombre, email: usuario.email, uid: usuario.email,
    urlMapbox: usuario.urlMapbox, tokenMapBox: usuario.tokenMapBox, idMapBox: usuario.idMapBox, mapToken: usuario.mapToken,
    token: usuario.token, cupon: usuario.cupon
    );
    
    await storage.saveToken(loginResponse.token);
    await storage.saveId(usuario.uid);

    return user;
    
    } else {
      //final respBody = jsonDecode(resp.body);
      return Usuario(
        online: false,
        nombre: "",
        email: "",
        uid: "",
        urlMapbox: "",
        tokenMapBox: "",
        idMapBox: "",
        mapToken: ""
        );
    }

  }

  Future<bool> isLoggedIn(String token) async {
    
    final token  = await StorageService.instance.getToken();
    
    final Map<String, String> headers = {'Content-Type': 'application/json', 'x-token': token.toString()};
  
    
    final resp = await http.get( Uri.parse('${Environment.apiUrl }/login/renew'),   headers: headers);

    if ( resp.statusCode == 200 ) {

      final loginResponse = loginResponseFromJson( resp.body );        
      await storage.saveToken(loginResponse.token);
      

      return true;

    } else {

     storage.deleteToken();
      return false;

    }

  }
  
  
  Future<Usuario> loginUser( String email, String password ) async {    
    

    final data = {'email': email, 'password': password};
    final headers = {'Content-Type': 'application/json'};    
    final body = jsonEncode(data);
    

    final resp = await http.post(Uri.parse('${ Environment.apiUrl }/login'), body: body, headers: headers  );
      
    
    if ( resp.statusCode == 200 ) {
      final loginResponse = loginResponseFromJson( resp.body );

      final usuario = loginResponse.usuario;

      final user = Usuario(online: usuario.online, nombre: usuario.nombre, email: usuario.email, uid: usuario.uid,
      urlMapbox: usuario.urlMapbox, tokenMapBox: usuario.tokenMapBox, idMapBox: usuario.idMapBox, mapToken: usuario.mapToken,
      token:  loginResponse.token, cupon: usuario.cupon);    

      await storage.saveToken(loginResponse.token);
      await storage.saveId(usuario.uid);
      
      return user;
    } else {
     
      return Usuario(
        online: false,
        nombre: "",
        email: "",
        uid: "",
        urlMapbox: "",
        tokenMapBox: "",
        idMapBox: "",
        mapToken: ""
        );
    }
  }  
}
