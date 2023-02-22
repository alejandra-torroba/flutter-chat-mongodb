import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:chat_mongodb/globals/environment.dart';
import 'package:chat_mongodb/models/login_response.dart';
import 'package:chat_mongodb/models/user.dart';


class AuthServices with ChangeNotifier{
  late User user;
  bool _authenticando = false;
  final _storage = new FlutterSecureStorage(); //Crear la instacia de storage

  bool get authenticando => _authenticando;
  set authenticando( bool valor ){
    _authenticando = valor;
    notifyListeners();    //NOTIFICA A TODOS LOS QUE ESTAN ESCUCHANDO PARA QUE SE REDIBUJEN
  }

  //GETTERS DEL TOKEN DE FORMA ESTETICA
  static Future<String> getToken() async {
    final _storage = new FlutterSecureStorage();
    final token = await _storage.read(key: 'token');
    return token!;
  }

  static Future<void> deleteToken() async {
    final _storage = new FlutterSecureStorage();
    await _storage.delete(key: 'token');
  }


  Future<bool> login ( String email, String password ) async{
    authenticando = true;

     final data = {
       'email': email,
       'password': password
     };

     final resp = await http.post(
       Uri.parse('${Enviroment.apiUrl}/login'),
       body: jsonEncode(data),
       headers: {
         'Content-Type':'application/json'
       }
     );

     authenticando = false;

     if( resp.statusCode == 200 ){
       final loginResponse = loginResponseFromJson( resp.body );
       user = loginResponse.user;

       //Guardar token en un lugar seguro
       await _saveToken(loginResponse.token);

       return true;
     }else{
       return false;
     }
  }     //LOGIN DE LA APP


  Future signup ( String nombre, String email, String password ) async{
    authenticando = true;

    final data = {
      'nombre':nombre,
      'email': email,
      'password': password
    };

    final resp = await http.post(
        Uri.parse('${Enviroment.apiUrl}/login/new'),
        body: jsonEncode(data),
        headers: {
          'Content-Type':'application/json'
        }
    );

    authenticando = false;

    if( resp.statusCode == 200 ){
      final loginResponse = loginResponseFromJson( resp.body );
      user = loginResponse.user;

      //Guardar token en un lugar seguro
      await _saveToken(loginResponse.token);

      return true;
    }else{
      final respBody = jsonDecode(resp.body);
      return respBody['msg'];
    }
  }   // REGISTRO DE LA APP

  Future<bool> isLoggedIn() async {
    final token = await _storage.read(key: 'token');
    if(token != null){
      final resp = await http.get(
          Uri.parse('${Enviroment.apiUrl}/login/renew'),
          headers: {
            'Content-Type':'application/json',
            'Authorization': token ?? '',
          }
      );
      print('Comprobar si funciona el token: ${resp.statusCode}');
      if( resp.statusCode == 200 ){
        final loginResponse = loginResponseFromJson( resp.body );
        user = loginResponse.user;

        //Guardar token en un lugar seguro
        await _saveToken(loginResponse.token);
        return true;
      }else{
        logout();
        return false;
      }
    } else{
      return false;
    }


  }

  Future _saveToken( String token ) async {   //GUARDAR TOKEN
    return await _storage.write(key: 'token', value: token);
  }

  Future logout() async {   //ELIMINAR TOKEN
    await _storage.delete(key: 'token');
  }

}