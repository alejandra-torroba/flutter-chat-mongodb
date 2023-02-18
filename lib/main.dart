
import 'package:flutter/material.dart';

import 'package:chat_mongodb/routes/routes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Chat MongoDB',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: 'chat',
      routes: appRoutes,
    );
  }
}
