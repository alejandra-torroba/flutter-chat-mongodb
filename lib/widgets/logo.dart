import 'package:flutter/material.dart';

class Logo extends StatelessWidget{
  final String messeger;

  const Logo({super.key, required this.messeger});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 175,
        margin: const EdgeInsets.only(top: 50),
        child: Column(
          children: [
            Expanded(
              child: Image(image: AssetImage('assets/chat.png')),
            ),

            const SizedBox(height: 20,),
            Text(messeger, style: TextStyle(fontSize: 30),)
          ],
        ),
      ),
    );
  }
}