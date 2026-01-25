import 'dart:async';
import 'package:dio/dio.dart';

import '../resources/config.dart';
import '../utils/utils.dart';

class EmployeApi {
  var dio = Dio();


  Future<Response?> getUsers( ) async {
    var token = await Utils.getToken();
    print("token $token");
    dio.options.headers['Content-Type'] = "Application/json";
    dio.options.headers['accept'] = "Application/json";
    dio.options.headers['authorization'] = "Bearer ${token}";
    try {
      return await dio.get('${Config.baseUrl}/users' ,
       ).catchError((onError) {
         print("exception $onError");
        return null;
      });
    } catch (error) {
      print("exception $error");

      return null;
    }
  }




  Future<Response?> addUsers({String? email , String? password , String? phone , String? firstName , String? lastName , String? role } ) async {
    var token = await Utils.getToken();
    print("token $token");
    dio.options.headers['Content-Type'] = "Application/json";
    dio.options.headers['accept'] = "Application/json";
    dio.options.headers['authorization'] = "Bearer ${token}";
    try {
      return await dio.post('${Config.baseUrl}/users' , data: {
          "email": email,
          "password": password,
          "first_name": firstName,
          "phone": phone,
          "last_name": lastName,
          "role": "cleaner"

      }
      ).catchError((onError) {
        print("exception $onError");
        return null;
      });
    } catch (error) {
      print("exception $error");

      return null;
    }
  }


  Future<Response?> editUsers(String id , {String? email , String? password ,String? phone , String? firstName , String? lastName , String? role } ) async {
    var token = await Utils.getToken();
    print("token $token");
    dio.options.headers['Content-Type'] = "Application/json";
    dio.options.headers['accept'] = "Application/json";
    dio.options.headers['authorization'] = "Bearer ${token}";

    try {
      return await dio.put('${Config.baseUrl}/users/$id' , data: {
      if(email != null)  if(email != '') "email": email,
       if(password != null) if(password != '')  "password": password,
      if(firstName != null) if(firstName != '')  "first_name": firstName,
       if(lastName != null) if(lastName != '') "last_name": lastName,
       if(phone != null) if(phone != '') "phone": phone,
        "role": "admin"

      }
      ).catchError((onError) {
        print("exception $onError");
        return null;
      });
    } catch (error) {
      print("exception $error");

      return null;
    }
  }

}


