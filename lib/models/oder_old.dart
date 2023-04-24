// To parse this JSON data, do
//
//     final addressResponse = addressResponseFromMap(jsonString);


import 'dart:convert';

class AddressResponse {
    AddressResponse({
        required this.data,
    });

    Data data;

    factory AddressResponse.fromJson(String str) => AddressResponse.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory AddressResponse.fromMap(Map<String, dynamic> json) => AddressResponse(
        data: Data.fromMap(json["data"]),
    );

    Map<String, dynamic> toMap() => {
        "data": data.toMap(),
    };
}

class Data {
    Data({
        required this.userAddress,
    });

    UserAddress userAddress;

    factory Data.fromJson(String str) => Data.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Data.fromMap(Map<String, dynamic> json) => Data(
        userAddress: UserAddress.fromMap(json["UserAddress"]),
    );

    Map<String, dynamic> toMap() => {
        "UserAddress": userAddress.toMap(),
    };
}

class UserAddress {
    UserAddress({
        this.miId,
        this.estado,
        this.ubicacion,
        this.mensaje,
        this.createdAt,
        this.updatedAt,
        this.idDriver,
    });

    String? miId;
    bool? estado;
    List<double>? ubicacion;
    List<dynamic>? mensaje;
    DateTime? createdAt;
    DateTime? updatedAt;
    String? idDriver;

    factory UserAddress.fromJson(String str) => UserAddress.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory UserAddress.fromMap(Map<String, dynamic> json) => UserAddress(
        miId: json["miId"] ?? '',
        estado: json["estado"] ?? '',
        ubicacion: json["ubicacion"] == null ? null : List<double>.from(json["ubicacion"].map((x) => x?.toDouble())),
        mensaje: json["mensaje"]     == null ? null : List<dynamic>.from(json["mensaje"].map((x) => x)),
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
        idDriver: json["idDriver"] ?? '',
    );

    Map<String, dynamic> toMap() => {
        "miId": miId,
        "estado": estado,
        "ubicacion": List<dynamic>.from(ubicacion!.map((x) => x)),
        //"mensaje": List<dynamic>.from(mensaje!.map((x) => x)),
        "createdAt": createdAt!.toIso8601String(),
        "updatedAt": updatedAt!.toIso8601String(),
        "idDriver": idDriver,
    };
}
