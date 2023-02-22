import 'package:chat_mongodb/globals/environment.dart';
import 'package:chat_mongodb/services/auth_services.dart';
import 'package:flutter/material.dart';

import 'package:socket_io_client/socket_io_client.dart';

enum ServerStatus {
  Online,
  Offline,
  Connecting
}


class SocketService with ChangeNotifier {

  late ServerStatus _serverStatus = ServerStatus.Connecting;
  late Socket _socket;

  ServerStatus get serverStatus  => this._serverStatus;
  Socket get socket => this._socket;

  //CONECTARNOS AL SERVIDOR
  void connect() async {

    final token = await AuthServices.getToken();

    // Dart client
    _socket = io(
        Enviroment.socketUrl,
        OptionBuilder()
            .setTransports(['websocket'])
            .enableForceNew()   //Va a consumir más recursos porque cada vez que un cliente se conecte se crea una nueva instancia
            .enableAutoConnect().setExtraHeaders({'Authorization':token})
            .build()
    );

    _socket.on('connect', (_) {
      _serverStatus = ServerStatus.Online;
      notifyListeners();
    });

    _socket.on('disconnect', (_) {
      _serverStatus = ServerStatus.Offline;
      notifyListeners();
    });

  }


  //DESCONECTARNOS DEL SERVIDOR
  void disconnect(){
    _socket.disconnect();
  }

}