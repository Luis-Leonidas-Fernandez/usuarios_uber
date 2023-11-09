// To parse this JSON data, do
//
//     final usuario = usuarioFromJson(jsonString);

import 'dart:convert';

Usuario usuarioFromJson(String str) => Usuario.fromJson(json.decode(str));

String usuarioToJson(Usuario data) => json.encode(data.toJson());

class Usuario {
    Usuario({
        required this.online,
        required this.nombre,
        required this.email,
        required this.uid,
        this.cupon
    });

    bool online;
    String nombre;
    String email;
    String uid;
    List<dynamic>? cupon;

    factory Usuario.fromJson(Map<String, dynamic> json) => Usuario(
        online: json["online"],
        nombre: json["nombre"],
        email: json["email"],
        uid: json["uid"],
        cupon: json["cupon"] == null ? null : List<dynamic>.from(json["cupon"].map((x) => x)),

    );

    Map<String, dynamic> toJson() => {
        "online": online,
        "nombre": nombre,
        "email": email,
        "uid": uid,
         "cupon": List<dynamic>.from(cupon!.map((x) => x)),
    };
}
