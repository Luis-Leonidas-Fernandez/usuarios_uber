
import 'dart:convert';

class Location {
    
    String? id;
    String? miId;
    bool? estado;
    Mensaje? ubicacion;
    Mensaje? mensaje;    
    DateTime? createdAt;
    DateTime? updatedAt;

    Location({
        this.id,
        this.miId,
        this.estado,
        this.ubicacion,
        required this.mensaje,       
        this.createdAt,
        this.updatedAt,
    });

   

    String toJson() => json.encode(toMap());

    factory Location.fromMap(Map<String, dynamic> json) => Location(
        id: json["_id"]?? '',
        miId: json["miId"]?? '',
        estado: json["estado"]?? false,
        ubicacion:  Mensaje.fromMap(json["ubicacion"]),
        mensaje: Mensaje.fromMap(json["mensaje"]),        
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
    );

    Map<String, dynamic> toMap() => {
        "id": id,
        "miId": miId,
        "estado": estado,
        "ubicacion": ubicacion!.toMap(),
        "mensaje": mensaje!.toMap(),       
        "createdAt": createdAt!.toIso8601String(),
        "updatedAt": updatedAt!.toIso8601String(),
    };
}

class Mensaje {
    List<double> coordinates;
    String type;

    Mensaje({
        required this.coordinates,
        required this.type,
    });

    factory Mensaje.fromJson(String str) => Mensaje.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Mensaje.fromMap(Map<String, dynamic> json) => Mensaje(
        coordinates: List<double>.from(json["coordinates"].map((x) => x.toDouble())),
        type: json["type"],
    );

    Map<String, dynamic> toMap() => {
        "coordinates": List<dynamic>.from(coordinates.map((x) => x)),
        "type": type,
    };
}


