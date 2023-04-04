import 'package:chat_mongodb/helpers/mostrar_alerta.dart';
import 'package:chat_mongodb/services/socket_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:chat_mongodb/services/auth_services.dart';
import 'package:chat_mongodb/widgets/button.dart';
import 'package:chat_mongodb/widgets/custom_input.dart';
import 'package:chat_mongodb/widgets/label.dart';
import 'package:chat_mongodb/widgets/logo.dart';


class SignupPages extends StatelessWidget{
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
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Logo(messeger: 'Regristro',),    //LOGO DE LA APLICACIÓN
                          _Form(),    //EL EMIAL Y LA CONTRASEÑA
                          const Labels(titulo: '¿Ya tienes cuenta?', msgbutton: 'Entrar', route: 'login',),  //OPCIÓN PARA QUE EL USUARIO SE REGISTRE
                          const Text('Terminos y condiciones', style: TextStyle(fontWeight: FontWeight.w200),),
                        ],
                      )
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
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthServices>(context);
    final socketService = Provider.of<SocketService>(context);

    return Container(
        margin: EdgeInsets.only(top: 40),
        padding: EdgeInsets.symmetric(horizontal: 50),
        child: Column(
          children: [

            CustomInput(
              icon: Icons.perm_identity,
              placeholder: 'Nombre',
              keyboardType: TextInputType.text,
              textController: nameController,
              isPassword: false,),

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
                text: 'Registrate',
                onPressed: authService.authenticando ? null : () async {
                  final registroOk = await authService.signup(nameController.text.trim(), emailController.text.trim(), passwordController.text.trim());
                  if( registroOk == true ){
                    //Conectar al socket server
                    socketService.connect();

                    //Leva a otra pantalla
                    Navigator.pushReplacementNamed(context, 'users');
                  }else{
                    showAlert(context, 'Error al registrarse', registroOk);
                  }
                }
            ),

          ],
        )
    );
  }

}