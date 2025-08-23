import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'package:usuario_inri/Generators/isolate_parse_json.dart';
import 'package:usuario_inri/global/environment.dart';
import 'package:usuario_inri/models/address.dart';
import 'package:usuario_inri/models/location.dart';
import 'package:usuario_inri/models/usuario.dart';
import 'package:usuario_inri/service/auth_service.dart';
import 'package:usuario_inri/service/storage_service.dart';

class AddressService {
  late AuthService authService;
  //Address? address;
  Usuario? usuario;
  final storage = StorageService.instance;

  Future<OrderUser> getAddressesBackground() async {
    final token = await storage.getToken();
    final idUser = await storage.getId();

    final Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Charset': 'utf-8',
      'x-token': token.toString()
    };

    final resp = await http.get(
        Uri.parse('${Environment.apiUrl}/viajes/$idUser'),
        headers: headers);

    if (resp.statusCode == 200) {
      final data = resp.body;

      await storage.deleteIdOrder();

      final respuesta = await ParseData.instance.isolateFunction(data);

      final idOrder = respuesta.id;

      await storage.saveIdOrder(idOrder);

      return respuesta;
    }

    if (resp.statusCode == 201) {
      //convert data a Address Model
      await storage.deleteIdOrder();
      final date = OrderUser(id: null, idDriver: '0' ,order: null);
      final result = date;

      return result;
    }

    if (resp.statusCode == 401) {
      await storage.deleteIdOrder();

      final date = OrderUser(id: null, idDriver: '0',order: null);
      final result = date;
      return result;
    } else {
      return throw Exception('oops!');
    }
  }

  Future<OrderUser> getAddress(String token, String idUser) async {
    final Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Charset': 'utf-8',
      'x-token': token,
    };

    final uri = Uri.parse('${Environment.apiUrl}/viajes/$idUser');

    try {
      final resp = await http.get(uri, headers: headers);

      if (resp.statusCode != 200) {       
        return OrderUser.empty();
      }

      final decoded = jsonDecode(resp.body);

      // 🟨 Caso: el backend respondió con address: null (orden eliminada)
      if (decoded["address"] == null) {
      
        await storage.deleteIdOrder();
        

        return OrderUser(
          id: 'resumen',
          finalizado: true,
          ok: false,
          email: '',
          nombre: '',
          apellido: '',
          vehiculo: '',
          modelo: '',
          patente: '',
          online: false,
          order: '',
          estado: null,
          createdAt: null,
          updatedAt: null,
          mensaje: null,
          destino: null,
          idDriver: '',
          distanciaKm: null,
          precio: null,
          horaEsperaInicio: null,
          horaEsperaFin: null,
          precioTotal: 0.0,
        );
      }

      // ✅ Caso normal: devolvemos la orden activa
      final dataMap = decoded["address"];
      final order = OrderUser.fromJson(dataMap);

      if (order.id != null && order.id!.isNotEmpty) {
        await storage.saveIdOrder(order.id);
      }

      return order;
    } on FormatException catch (_) {
   
      return OrderUser.empty();
    } catch (e) {      
      return OrderUser.empty();
    }
  }

  Future postAddresses(LatLng ubicacion, LatLng destino, String token,
      String idUser, double distanciaKm, double precio) async {
    final lat = ubicacion.latitude;
    final long = ubicacion.longitude;
    final position = [long, lat];

    final latDestino = destino.latitude;
    final longDestino = destino.longitude;
    final userDestino = [longDestino, latDestino];

    final data = {
      'miId': idUser,
      'estado': true,
      'ubicacion': position,
      'destino': userDestino,
      'distanciaKm': distanciaKm,
      'precio': precio
    };
    final Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Charset': 'utf-8',
      'x-token': token.toString()
    };
    final body = jsonEncode(data);

    final resp = await http.post(
        Uri.parse('${Environment.apiUrl}/ubicaciones/lugar'),
        body: body,
        headers: headers);

    await Future.delayed(const Duration(seconds: 2));
    if (resp.statusCode == 200) {
      try {
        //data decoded
        final dataMap = jsonDecode(resp.body)["data"];

        final response = Location.fromMap(dataMap);
        final idOrder = response.id;

        await storage.saveIdOrder(idOrder);

        return idOrder;
      } catch (e) {
        return null;
      }
    }
  }

  Future<dynamic> finishTravel(
      String token, String idUser, double precioTotal) async {
    final Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Charset': 'utf-8',
      'x-token': token.toString()
    };
    final Map<String, dynamic> data = {
      'miId': idUser,
      'order': 'libre',
      'precioTotal': precioTotal
    };

    final resp = await http.put(
        Uri.parse('${Environment.apiUrl}/ubicaciones/remove/address'),
        headers: headers,
        body: json.encode(data));
    if (resp.statusCode == 200) {
      final Map<String, dynamic> address = jsonDecode(resp.body);

      return address;
    } else {
      return '';
    }
  }

  Future<bool> isActiveOrder() async {
    final isActive = await StorageService.instance.getIdOrder();

    if (isActive == null) {
      return false;
    }
    return true;
  }
}
