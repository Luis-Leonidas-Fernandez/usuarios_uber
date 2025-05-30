
import 'package:usuario_inri/models/mensaje.dart';

class OrderUser {
  bool? ok;
  String? id;
  String? email;
  String? nombre;
  String? apellido;
  String? vehiculo;
  String? modelo;
  String? patente;
  bool? online;
  String? order;
  dynamic estado;
  DateTime? createdAt;
  DateTime? updatedAt;
  Mensaje? mensaje;
  Mensaje? destino;
  String? idDriver;
  final double? distanciaKm;
  final double? precio;
  DateTime? horaEsperaInicio;
  DateTime? horaEsperaFin;
  final double? precioTotal;
  bool? finalizado;



  OrderUser({
    this.ok,
    this.id,
    this.email,
    this.nombre,
    this.apellido,
    this.vehiculo,
    this.modelo,
    this.patente,
    this.online,
    this.order,
    this.estado,
    this.createdAt,
    this.updatedAt,
    this.mensaje,
    this.destino,
    this.idDriver,
    this.distanciaKm,
    this.precio,
    this.horaEsperaInicio,
    this.horaEsperaFin,
    this.precioTotal,
    this.finalizado
  });

  factory OrderUser.empty() => OrderUser(
        ok: false,
        id: '',
        idDriver: '',
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
        mensaje: Mensaje(coordinates: [0.0, 0.0], type: 'Point'),
        destino: Mensaje(coordinates: [0.0, 0.0], type: 'Point'),
        distanciaKm: null,
        precio: null,
        horaEsperaInicio: null,
        horaEsperaFin: null,
        precioTotal: null,
        finalizado: null
      );

  factory OrderUser.fromJson(Map<String, dynamic> json) => OrderUser(
        ok: json["ok"] ?? false,
        id: json["_id"] ?? '',
        email: json["email"] ?? '',
        nombre: json["nombre"] ?? '',
        apellido: json["apellido"] ?? '',
        vehiculo: json["vehiculo"] ?? '',
        modelo: json["modelo"] ?? '',
        patente: json["patente"] ?? '',
        online: json["online"] ?? false,
        order: json["order"] ?? '',
        estado: json["estado"] ?? '',
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
        mensaje: json["mensaje"] == null ? null : Mensaje.fromMap(json["mensaje"]),
        destino: json["destino"] == null ? null : Mensaje.fromMap(json["destino"]),
        idDriver: json["idDriver"] ?? '',
        distanciaKm: (json["distanciaKm"] as num?)?.toDouble(),
        precio: (json["precio"] as num?)?.toDouble(),
        horaEsperaInicio: json["horaEsperaInicio"] == null ? null : DateTime.parse(json["horaEsperaInicio"]),
        horaEsperaFin: json["horaEsperaFin"] == null ? null : DateTime.parse(json["horaEsperaFin"]),
        precioTotal: (json["precioTotal"] as num?)?.toDouble(),
        finalizado: json["finalizado"] ?? false,


      );

  Map<String, dynamic> toMap() => {
        "ok": ok,
        "_id": id,
        "email": email,
        "nombre": nombre,
        "apellido": apellido,
        "vehiculo": vehiculo,
        "modelo": modelo,
        "patente": patente,
        "online": online,
        "order": order,
        "estado": estado,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "mensaje": mensaje?.toMap(),
        "destino": destino?.toMap(),
        "idDriver": idDriver,
        "distanciaKm": distanciaKm,
        "precio": precio,
        "horaEsperaInicio": horaEsperaInicio?.toIso8601String(),
        "horaEsperaFin": horaEsperaFin?.toIso8601String(),
        "precioTotal": precioTotal,
        "finalizado": finalizado,

 
      };

  Map<String, dynamic> toJson() => toMap();

  OrderUser copyWith({
    bool? ok,
    String? id,
    String? email,
    String? nombre,
    String? apellido,
    String? vehiculo,
    String? modelo,
    String? patente,
    bool? online,
    String? order,
    dynamic estado,
    DateTime? createdAt,
    DateTime? updatedAt,
    Mensaje? mensaje,
    Mensaje? destino,
    String? idDriver,
    double? distanciaKm,
    double? precio,
    DateTime? horaEsperaInicio,
    DateTime? horaEsperaFin,
    double? precioTotal,
    bool? finalizado
 
  }) {
    return OrderUser(
      ok: ok ?? this.ok,
      id: id ?? this.id,
      email: email ?? this.email,
      nombre: nombre ?? this.nombre,
      apellido: apellido ?? this.apellido,
      vehiculo: vehiculo ?? this.vehiculo,
      modelo: modelo ?? this.modelo,
      patente: patente ?? this.patente,
      online: online ?? this.online,
      order: order ?? this.order,
      estado: estado ?? this.estado,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      mensaje: mensaje ?? this.mensaje,
      destino: destino ?? this.destino,
      idDriver: idDriver ?? this.idDriver,
      distanciaKm: distanciaKm ?? this.distanciaKm,
      precio: precio ?? this.precio,
      horaEsperaInicio: horaEsperaInicio ?? this.horaEsperaInicio,
      horaEsperaFin: horaEsperaFin ?? this.horaEsperaFin,
      precioTotal: precioTotal ?? this.precioTotal,
      finalizado: finalizado ?? this.finalizado,
    );
  }
}
