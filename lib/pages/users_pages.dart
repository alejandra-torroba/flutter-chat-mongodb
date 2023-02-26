import 'package:chat_mongodb/services/auth_services.dart';
import 'package:chat_mongodb/services/chat_service.dart';
import 'package:chat_mongodb/services/socket_service.dart';
import 'package:chat_mongodb/services/users_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'package:chat_mongodb/models/user.dart';


class UsersPages extends StatefulWidget{
  @override
  State<UsersPages> createState() => _UsersPagesState();
}

class _UsersPagesState extends State<UsersPages> {
  final usersService = UsersService();
  RefreshController _refreshController = RefreshController(initialRefresh: false);
  List<User> users = [];

  @override
  void initState() {
    _loadUsers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    final authService = Provider.of<AuthServices>(context);
    final socketService = Provider.of<SocketService>(context);
    final user = authService.user;

    return Scaffold(
      appBar: AppBar(
        title: Text('${user.nombre}', style: TextStyle(color: Colors.black54),),
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.exit_to_app, color: Colors.black54,),
          onPressed: (){
            // Desconectar del socket server
            socketService.disconnect();

            //Navega a la pantalla principal
            Navigator.pushReplacementNamed(context, 'login');

            //Elimina el token
            AuthServices.deleteToken();
          },
        ),
        actions: [
          Container(
            margin: EdgeInsets.only(right: 10),
            child: socketService.serverStatus == ServerStatus.Online ?
                      Icon(Icons.check_circle, color: Colors.green):
                      Icon(Icons.offline_bolt, color: Colors.red),
          )
        ],
      ),
      body:SmartRefresher(
        controller: _refreshController,
        enablePullDown: true,
        onRefresh: _loadUsers,
        header: WaterDropHeader(    //Apariencia del Refresh
          complete: Icon(Icons.check, color: Colors.blue[300],),  //Icono que sale cuando completa el refresh
          waterDropColor: Colors.blue,
        ),
        child: ListView.separated(
            physics: const BouncingScrollPhysics(),
            itemBuilder: ( _ , i) => _userTitle(users[i]),
            separatorBuilder: ( _ , i) => Divider(),
            itemCount: users.length
        ),
      )
    );
  }

  ListTile _userTitle(User user){
    return ListTile(
      title: Text(user.nombre),
      subtitle: Text(user.email),
      leading: CircleAvatar(
        child: Text(user.nombre.toString().substring(0,2)),
        backgroundColor: Colors.blue[200],
      ),
      trailing: Container(
        width: 10,
        height: 10,
        decoration: BoxDecoration(
            color: user.online? Colors.green[300] : Colors.red,
            borderRadius: BorderRadius.circular(100)
        ),
      ),
      onTap: (){
        final chatService = Provider.of<ChatService>(context, listen: false);
        chatService.userTo = user;
        Navigator.pushNamed(context, 'chat');
      },
    );
  }

  void  _loadUsers() async {

    users = await usersService.getUsers();

    setState(() {});

    _refreshController.refreshCompleted();
  }
}
