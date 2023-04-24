import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'package:usuario_inri/global/environment.dart';
import 'package:usuario_inri/models/address.dart';

import 'package:usuario_inri/models/post_address.dart';
import 'package:usuario_inri/models/usuario.dart';
import 'package:usuario_inri/service/auth_service.dart';


class AddressService {   
  
  late AuthService authService;
  //Address? address;
  Usuario? usuario;
   
  Future postAddresses( LatLng ubicacion) async {  
      
   
  final token = await AuthService.getToken();
  final id    =  await AuthService.getId();
  final lat   = ubicacion.latitude;
  final long  = ubicacion.longitude;
  final  position = [lat, long];
  
  final data = {'miId': id, 'estado': true, 'ubicacion': position};  
  final Map<String, String> headers = {'Content-Type': 'application/json', 'Charset': 'utf-8','x-token': token.toString()};
  final body = jsonEncode(data); 
    

  final resp = await http.post(Uri.parse('${Environment.apiUrl }/ubicaciones/lugar'), body: body, headers: headers);
  if ( resp.statusCode == 200) {

  List<int> bytes      = resp.body.toString().codeUnits;
  final responseString = utf8.decode(bytes);  

  final response           = Address.fromJson(responseString);
  final order          = response.data.idOrder;


  AuthService().guardarIdOder(order);
  final result = response.toMap();
  
  
  // ignore: avoid_print
  print('******$result*******');

   // ignore: avoid_print
   print('*********$data*********'); 
   
   return response;
  
  
} else {
  return [];
}       
}


Future<List<OrderUser>> getAddress( ) async {  
      
   
  final token = await AuthService.getToken();
  final id    =  await AuthService.getId();
 
  final Map<String, String> headers = {'Content-Type': 'application/json', 'Charset': 'utf-8','x-token': token.toString()};
  
  final resp = await http.get(Uri.parse('${Environment.apiUrl }/viajes/$id'), headers: headers);
  if ( resp.statusCode == 200) {

  List<int> bytes      = resp.body.toString().codeUnits;
  final responseString = utf8.decode(bytes);  

  final data           = AddressUser.fromJson(responseString);
  
  
  
  
  final result = data.toMap();
  
  
  // ignore: avoid_print
  print('******$result*******');

   
   
   return data.orderUser;
  
  
} else {
  return [];
}       
}


 Future<dynamic> finishTravel() async {  
  
  final token = await AuthService.getToken();
  final id    = await AuthService.getId();

  final Map<String, String> headers = {'Content-Type': 'application/json', 'Charset': 'utf-8','x-token': token.toString()};
  final Map<String, String> data   = {'miId': id!, 'order': 'libre'};

  
  final resp = await http.put(Uri.parse('${Environment.apiUrl }/ubicaciones/remove/address'), headers: headers, body: json.encode(data));
  if ( resp.statusCode == 200 ) {

  final Map<String, dynamic> address = jsonDecode(resp.body);
  

  return address;    
} else {
  return '';
}
}
 
}
