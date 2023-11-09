
// To parse this JSON data, do
//
//     final address = addressFromMap(jsonString);


import 'dart:convert';

class Address {
    Address({
        required this.data,
    });

    Data data;

    factory Address.fromJson(String str) => Address.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Address.fromMap(Map<String, dynamic> json) => Address(
        data: Data.fromMap(json["data"]),
    );

    Map<String, dynamic> toMap() => {
        "data": data.toMap(),
    };
}

class Data {
    Data({
        
       
        this.miId,
        this.estado,
        this.ubicacion,
        this.idOrder
    });
    
    
    String? miId;
    bool? estado;
    List<double>? ubicacion;
    String? idOrder;

    factory Data.fromJson(String str) => Data.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Data.fromMap(Map<String, dynamic> json) => Data(
        idOrder: json["id"]?? '',
        miId: json["miId"] ?? '',
        estado: json["estado"] ?? '',
        ubicacion:  json["ubicacion"] == null ? null : List<double>.from(json["ubicacion"].map((x) => x?.toDouble())),
        
    );

    Map<String, dynamic> toMap() => {
       
        "miId": miId,
        "estado": estado,
        "ubicacion": List<dynamic>.from(ubicacion!.map((x) => x)),
        "idOrder": idOrder,
    };
}
