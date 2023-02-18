
//Rutas que tiene mi aplicación

import 'package:chat_mongodb/pages/chat_page.dart';
import 'package:chat_mongodb/pages/loading_page.dart';
import 'package:chat_mongodb/pages/login_page.dart';
import 'package:chat_mongodb/pages/signup_page.dart';
import 'package:chat_mongodb/pages/users_pages.dart';
import 'package:flutter/material.dart';

final Map<String,  Widget Function(BuildContext)> appRoutes = {
  'users': ( _ ) => UsersPages(),
  'chat': ( _ ) => ChatPages(),
  'login': ( _ ) => LoginPages(),
  'signup': ( _ ) => SignupPages(),
  'loading': ( _ ) => LoadingPages(),
};