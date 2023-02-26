
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:chat_mongodb/routes/routes.dart';
import 'package:chat_mongodb/services/auth_services.dart';
import 'package:chat_mongodb/services/socket_service.dart';
import 'package:chat_mongodb/services/chat_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider( create: ( _ ) => AuthServices() ),
        ChangeNotifierProvider(create: ( _ ) => SocketService() ),
        ChangeNotifierProvider(create: ( _ ) => ChatService() ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Chat MongoDB',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: 'loading',
        routes: appRoutes,
      ),
    );
  }
}
