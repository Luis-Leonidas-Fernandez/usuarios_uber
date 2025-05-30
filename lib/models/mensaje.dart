
import 'dart:convert';

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
        coordinates: List<double>.from(json["coordinates"].map((x) => x?.toDouble())),
        type: json["type"],
    );

    Map<String, dynamic> toMap() => {
        "coordinates": List<dynamic>.from(coordinates.map((x) => x)),
        "type": type,
    };
}