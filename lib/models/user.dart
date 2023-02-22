import 'dart:convert';

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User {
  User({
    required this.nombre,
    required this.email,
    required this.online,
    required this.uid,
  });

  String nombre;
  String email;
  bool online;
  String uid;

  factory User.fromJson(Map<String, dynamic> json) => User(
    nombre: json["nombre"],
    email: json["email"],
    online: json["online"],
    uid: json["uid"],
  );

  Map<String, dynamic> toJson() => {
    "nombre": nombre,
    "email": email,
    "online": online,
    "uid": uid,
  };
}
