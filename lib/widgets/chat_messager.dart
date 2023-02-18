import 'package:flutter/material.dart';

class ChatMessager extends StatelessWidget{
  final String text;
  final String uid;
  final AnimationController animationController;

  const ChatMessager({super.key, required this.text, required this.uid, required this.animationController});

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: animationController,
      child: SizeTransition(    //Ayuda a que se vea más natural la animación
        sizeFactor: CurvedAnimation(
          parent: animationController,
          curve: Curves.easeInOut,      //Animación al mostrar por pantalla un nuevo mensaje
        ),
        child: Container(
          child: uid == '123'?
          _myMessage():
          _message(),
        ),
      )
    );
  }

  Widget _myMessage(){
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        padding: const EdgeInsets.all(8),
        margin: EdgeInsets.only(bottom: 5, left: 50, right: 5),   //Left = 50 porque si el texto es muy grande no tocara la otra parte de la pantalla
        decoration: const BoxDecoration(
          color: Color(0xFF4D9EF6),
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(20),
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(0)
          ),
        ),
        child: Text(text, style: TextStyle(color: Colors.white),),
      ),
    );
  }

  Widget _message(){
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.all(8),
        margin: EdgeInsets.only(bottom: 5, right: 50, left: 5),   //Left = 50 porque si el texto es muy grande no tocara la otra parte de la pantalla
        decoration: const BoxDecoration(
          color: Color(0xFFE4E5E8),
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(10),
              topLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
              bottomLeft: Radius.circular(0)
          ),
        ),
        child: Text(text, style: TextStyle(color: Colors.black87),),
      ),
    );;
  }

}