import 'package:flutter/material.dart';

class Labels extends StatelessWidget{
  final String titulo;
  final String msgbutton;
  final String route;

  const Labels({super.key, required this.titulo, required this.msgbutton, required this.route});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(titulo, style: TextStyle(color: Colors.black54, fontSize: 15, fontWeight: FontWeight.w300),),
        const SizedBox(height: 10,),
        GestureDetector(        //Reconoce cualquier gesto
          child: Text(msgbutton, style: TextStyle(color: Colors.blue[600], fontWeight: FontWeight.bold, fontSize: 18),),
          onTap: () => Navigator.pushReplacementNamed(context, route),
        )
      ],
    );
  }

}