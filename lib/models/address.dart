

// To parse this JSON data, do
//
//     final address = addressFromMap(jsonString);


import 'dart:convert';

class AddressUser {
    AddressUser({
        required this.orderUser,
    });

    List<OrderUser> orderUser;

    factory AddressUser.fromJson(String str) => AddressUser.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory AddressUser.fromMap(Map<String, dynamic> json) => AddressUser(
        orderUser: List<OrderUser>.from(json["orderUser"].map((x) => OrderUser.fromMap(x))),
    );

    Map<String, dynamic> toMap() => {
        "orderUser": List<dynamic>.from(orderUser.map((x) => x.toMap())),
    };
}

class OrderUser {
    OrderUser({
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
        this.mensaje,
        this.idDriver,
        this.createdAt,
        this.updatedAt,
    });

    String? id;
    String? email;
    String? nombre;
    String? apellido;
    String? vehiculo;
    String? modelo;
    String? patente;
    bool? online;
    String? order;
    bool? estado;
    List<List<dynamic>>? mensaje;
    String? idDriver;
    DateTime? createdAt;
    DateTime? updatedAt;

    factory OrderUser.fromJson(String str) => OrderUser.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory OrderUser.fromMap(Map<String, dynamic> json) => OrderUser(
        id: json["_id"] ?? '',
        email: json["email"] ?? '',
        nombre: json["nombre"] ?? '',
        apellido: json["apellido"] ?? '',
        vehiculo: json["vehiculo"] ?? '',
        modelo: json["modelo"] ?? '',
        patente: json["patente"] ?? '',
        online: json["online"] ?? '',
        order: json["order"] ?? '',
        estado: json["estado"] ?? '',
        idDriver: json["idDriver"]?? '',
        mensaje: json["mensaje"] == null ? null : List<List<dynamic>>.from(json["mensaje"].map((x) => x)),
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
    );

    Map<String, dynamic> toMap() => {
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
        "mensaje": List<dynamic>.from(mensaje!.map((x) => x)),
        "idDriver": idDriver,
        "createdAt": createdAt!.toIso8601String(),
        "updatedAt": updatedAt!.toIso8601String(),
    };
}
