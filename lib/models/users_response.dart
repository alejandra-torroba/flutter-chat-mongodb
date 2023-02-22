import 'dart:convert';

import 'package:chat_mongodb/models/user.dart';

Users usersFromJson(String str) => Users.fromJson(json.decode(str));

String usersToJson(Users data) => json.encode(data.toJson());

class Users {
  Users({
    required this.ok,
    required this.users,
    required this.desde,
  });

  bool ok;
  List<User> users;
  int desde;

  factory Users.fromJson(Map<String, dynamic> json) => Users(
    ok: json["ok"],
    users: List<User>.from(json["users"].map((x) => User.fromJson(x))),
    desde: json["desde"],
  );

  Map<String, dynamic> toJson() => {
    "ok": ok,
    "users": List<dynamic>.from(users.map((x) => x.toJson())),
    "desde": desde,
  };
}