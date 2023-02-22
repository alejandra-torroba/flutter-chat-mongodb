
import 'package:chat_mongodb/helpers/mostrar_alerta.dart';
import 'package:chat_mongodb/services/auth_services.dart';
import 'package:chat_mongodb/services/socket_service.dart';
import 'package:flutter/material.dart';

import 'package:chat_mongodb/widgets/button.dart';
import 'package:chat_mongodb/widgets/custom_input.dart';
import 'package:chat_mongodb/widgets/label.dart';
import 'package:chat_mongodb/widgets/logo.dart';
import 'package:provider/provider.dart';

class LoginPages extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF2F2F2),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.9,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Logo(messeger: 'Chat social',),    //LOGO DE LA APLICACIÓN
                  _Form(),    //EL EMIAL Y LA CONTRASEÑA
                  const Labels(titulo: '¿No tienes una cuenta?', msgbutton: 'REGISTRATE', route: 'signup',),  //OPCIÓN PARA QUE EL USUARIO SE REGISTRE
                  const Text('Terminos y condiciones', style: TextStyle(fontWeight: FontWeight.w200),),
                ],
              )
            )
          ),
        ),
      )
    );
  }
}

class _Form extends StatefulWidget{
  @override
  __FormState createState() => __FormState();
}

class __FormState extends State<_Form>{
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthServices>( context, listen: false );
    final socketService = Provider.of<SocketService>(context);

    return Container(
      margin: EdgeInsets.only(top: 40),
      padding: EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        children: [

          CustomInput(
            icon: Icons.mail_outline,
            placeholder: 'Email',
            keyboardType: TextInputType.emailAddress,
            textController: emailController,
            isPassword: false,),

          CustomInput(
            icon: Icons.lock_outline,
            placeholder: 'Contraseña',
            keyboardType: TextInputType.text,
            textController: passwordController,
            isPassword: true,),

          ButtonBlue(
              text: 'Entrar',
              onPressed: authService.authenticando ? null :() async{
                FocusScope.of(context).unfocus();
                final loginOK = await authService.login( emailController.text.trim(), passwordController.text.trim()); //.trim() para asegurar que no se manden espacios en blanco
                if( loginOK ){
                  //Conectar al socket server
                  socketService.connect();
                  //Navegar a otra pantalla
                  Navigator.pushReplacementNamed(context, 'users');
                }else{
                  //Mostrar alerta de que algo salio mal
                  showAlert(context, 'Login incorrecto', 'Revise los credenciales');
                }
              }
          ),
        ],
      )
    );
  }

}
