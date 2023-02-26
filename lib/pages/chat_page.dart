import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:chat_mongodb/services/auth_services.dart';
import 'package:chat_mongodb/services/chat_service.dart';
import 'package:chat_mongodb/services/socket_service.dart';
import 'package:chat_mongodb/widgets/chat_messager.dart';


class ChatPages extends StatefulWidget{
  @override
  State<ChatPages> createState() => _ChatPagesState();
}

class _ChatPagesState extends State<ChatPages> with TickerProviderStateMixin{     //TickerProviderStateMixin para trabajar con animaciones
  final _textController = TextEditingController();
  final _focusNode = FocusNode();
  bool _write = false;
  List<ChatMessager> _messages = [];
  late ChatService chatService;
  late SocketService socketService;
  late AuthServices authServices;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    chatService = Provider.of<ChatService>(context, listen: false);
    socketService = Provider.of<SocketService>(context, listen: false); //Para emitir el mensaje
    authServices = Provider.of<AuthServices>(context, listen: false);
    socketService.socket.on('mensaje-personal', (data) => _listenChat(data));

  }

  void _listenChat(dynamic data){
    print('Tengo nuevo mensaje $data');
    //mostrar mensaje
    ChatMessager message = ChatMessager(
        text: data['message'],
        uid: data['to'],
        animationController: AnimationController(vsync: this, duration: Duration(milliseconds: 200))
    );
    setState(() {
      _messages.insert(0, message);
    });
    message.animationController.forward();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Column(
          children: [
            CircleAvatar(
              child: Text(chatService.userTo.nombre.substring(0,2), style: TextStyle(fontSize: 12),),
              backgroundColor: Colors.blue[200],
              maxRadius: 14,
            ),
            const SizedBox(height: 3,),
            Text(chatService.userTo.nombre, style: TextStyle(color: Colors.black54, fontSize: 12),)
          ],
        ),
        centerTitle: true,
        elevation: 1,
      ),
      body: Container(
        child: Column(
          children: [
            Flexible(
              child: ListView.builder(
                itemCount: _messages.length,
                physics: BouncingScrollPhysics(),
                itemBuilder: ( _ , i) => _messages[i],
                reverse: true,
              ),
            ),

            const Divider(
              height: 5,
            ),

            Container(
              color: Colors.white,
              child: _inputChat(),
            ),

          ],
        ),
      ),
    );
  }

  Widget _inputChat(){
    return SafeArea(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          children: [
            Flexible(
              child: TextField(
                controller: _textController,
                onSubmitted: _handleSubmit, //Función al pulsar el enter
                onChanged: ( String texto ){
                  setState(() {
                    if(texto.trim().length > 0){
                      _write = true;
                    }else {
                      _write = false;
                    }
                  });
                },
                decoration: InputDecoration.collapsed(
                  hintText: 'Enviar mensaje',
                ),
                focusNode: _focusNode,
              ),
            ),

            Container(
              margin: EdgeInsets.symmetric(horizontal: 4),
              child: Platform.isIOS?
                CupertinoButton(
                    child: Text('Enviar'),
                    onPressed: _write?
                        () => _handleSubmit(_textController.text):
                        null,
                ):
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 4),
                  child: IconTheme(
                    data: IconThemeData(color: Colors.blue),
                    child: IconButton(
                      highlightColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      icon: Icon(Icons.send),
                      onPressed: _write?
                          () => _handleSubmit(_textController.text):
                          null,
                    ),
                  )
                ),
            )
          ],
        ),
      ),
    );
  }

  _handleSubmit(String text){

    if(text.length == 0) return;

    _textController.clear();      //Limpia la caja del texto
    _focusNode.requestFocus();    //Cuando el usuario pulsa 'enter' no se quita el teclado

    final newMessage = ChatMessager(
      text: text,
      uid: '123',
      animationController: AnimationController(vsync: this, duration: Duration(milliseconds: 400)),
    );
    _messages.insert(0, newMessage);
    newMessage.animationController.forward();   //Comenzar la animación
    setState(() {
      _write = false;
    });

    socketService.socket.emit('mensaje-personal', {
      'from':authServices.user.uid,
      'to': chatService.userTo.uid,
      'message': text
    });
  }

  @override
  void dispose() {
    // TODO: Off del socket

    for( ChatMessager messager in _messages ){    //Para limpiar los Animation Controller
      messager.animationController.dispose();
    }

    socketService.socket.off('mensaje-personal');

    super.dispose();
  }

}