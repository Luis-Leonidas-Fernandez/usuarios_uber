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
        this.cupon,
        required this.urlMapbox,
        required this.tokenMapBox,
        required this.idMapBox,
        required this.mapToken,
        this.token
    });

    String? token;
    bool   online;
    String nombre;
    String email;
    String uid;
    List<dynamic>? cupon;
    String urlMapbox;
    String tokenMapBox;
    String idMapBox;
    String mapToken;


    factory Usuario.fromJson(Map<String, dynamic> json) => Usuario(
        online: json["online"],
        nombre: json["nombre"],
        email: json["email"],
        uid: json["uid"],
        cupon: json["cupon"] == null ? null : List<dynamic>.from(json["cupon"].map((x) => x)),
        urlMapbox: json["urlMapbox"],
        tokenMapBox: json["tokenMapBox"],
        idMapBox: json["idMapBox"],
        mapToken: json["mapToken"],
        token: json["token"] ?? "",

    );

    Map<String, dynamic> toJson() => {
        "online": online,
        "nombre": nombre,
        "email": email,
        "uid": uid,
        "cupon": cupon == null? null : List<dynamic>.from(cupon!.map((x) => x)),
        "urlMapbox": urlMapbox,
        "tokenMapBox": tokenMapBox,
        "idMapBox": idMapBox,
        "mapToken": mapToken,
        "token": token,
    };
}
