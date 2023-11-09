
import 'dart:convert';

class Location {
    
    String? id;
    String? miId;
    bool? estado;
    List<double>? ubicacion;    
    DateTime? createdAt;
    DateTime? updatedAt;

    Location({
        this.id,
        this.miId,
        this.estado,
        this.ubicacion,       
        this.createdAt,
        this.updatedAt,
    });

   

    String toJson() => json.encode(toMap());

    factory Location.fromJson(Map<String, dynamic> json) => Location(
        id: json["_id"]?? '',
        miId: json["miId"]?? '',
        estado: json["estado"]?? false,
        ubicacion:  json["ubicacion"] == null ? null : List<double>.from(json["ubicacion"].map((x) => x?.toDouble())),        
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
    );

    Map<String, dynamic> toMap() => {
        "id": id,
        "miId": miId,
        "estado": estado,
        "ubicacion": List<dynamic>.from(ubicacion!.map((x) => x)),       
        "createdAt": createdAt!.toIso8601String(),
        "updatedAt": updatedAt!.toIso8601String(),
    };
}


