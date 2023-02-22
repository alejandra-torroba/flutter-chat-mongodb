
import 'package:http/http.dart' as http;

import 'package:chat_mongodb/globals/environment.dart';
import 'package:chat_mongodb/models/user.dart';
import 'package:chat_mongodb/services/auth_services.dart';
import 'package:chat_mongodb/models/users_response.dart';


class UsersService{

  Future<List<User>> getUsers() async {

    try{
      final response = await http.get(
          Uri.parse('${Enviroment.apiUrl}/users'),
          headers: {
            'Content-Type':'application/json',
            'Authorization': await AuthServices.getToken(),
          }
      );

      final usersResponse = usersFromJson( response.body );
      return usersResponse.users;

    }catch(e){
      return [];
    }

  }

}