import 'package:chat_mongodb/pages/login_page.dart';
import 'package:chat_mongodb/pages/users_pages.dart';
import 'package:chat_mongodb/services/auth_services.dart';
import 'package:chat_mongodb/services/socket_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoadingPages extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: checkLoginState(context),
        builder: (context, snapshot){
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
  
  Future checkLoginState( BuildContext context ) async {

    final authService = Provider.of<AuthServices>(context, listen: false);
    final socketService = Provider.of<SocketService>(context);
    final autenticado = await authService.isLoggedIn();
    //final socketService = Provider.of<SocketService>(context);

    if(autenticado){
      //Conectar al shocket server
      socketService.connect();
      //Navegar a la pantalla deseada
      Navigator.pushReplacement(
          context,
          PageRouteBuilder(
              pageBuilder: ( _, __, ___) => UsersPages(),
            transitionDuration: Duration(milliseconds: 0)     //Quita la animación que hay al mostrar la nueva pantalla
          )
      );

      //Navigator.pushReplacementNamed(context, 'users');
    }else{

      Navigator.pushReplacement(
          context,
          PageRouteBuilder(
              pageBuilder: ( _, __, ___) => LoginPages(),
              transitionDuration: Duration(milliseconds: 0)     //Quita la animación que hay al mostrar la nueva pantalla
          )
      );

      //Navigator.pushReplacementNamed(context, 'login');
    }
    
  }
}