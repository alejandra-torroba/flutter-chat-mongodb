import 'package:flutter/material.dart';

import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'package:chat_mongodb/models/user.dart';


class UsersPages extends StatefulWidget{
  @override
  State<UsersPages> createState() => _UsersPagesState();
}

class _UsersPagesState extends State<UsersPages> {
  RefreshController _refreshController = RefreshController(initialRefresh: false);
  final users = [
    User(online: true, email: 'user1@example.com', nombre: 'User1', uid: '1'),
    User(online: true, email: 'user2@example.com', nombre: 'User2', uid: '2'),
    User(online: false, email: 'user3@example.com', nombre: 'User3', uid: '3'),
    User(online: true, email: 'user4@example.com', nombre: 'User4', uid: '4'),
    User(online: false, email: 'user5@example.com', nombre: 'User5', uid: '5'),
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nombre user', style: TextStyle(color: Colors.black54),),
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.exit_to_app, color: Colors.black54,),
          onPressed: (){},
        ),
        actions: [
          Container(
            margin: EdgeInsets.only(right: 10),
            child: Icon(Icons.check_circle, color: Colors.green),
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
    );
  }

  void  _loadUsers() async {
    await Future.delayed(Duration(milliseconds: 1000));
    _refreshController.refreshCompleted();
  }
}
