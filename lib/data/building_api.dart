import 'dart:async';
import 'package:dio/dio.dart';

import '../resources/config.dart';
import '../utils/utils.dart';

class BuildingApi {
  var dio = Dio();


  Future<Response?> getBuilding( ) async {
    var token = await Utils.getToken();
    print("token $token");
    dio.options.headers['Content-Type'] = "Application/json";
    dio.options.headers['accept'] = "Application/json";
    dio.options.headers['authorization'] = "Bearer ${token}";
    try {
      return await dio.get('${Config.baseUrl}/buildings' ,
       ).catchError((onError) {
         print("exception $onError");
        return null;
      });
    } catch (error) {
      print("exception $error");

      return null;
    }
  }
  Future<Response?> getFloorbyBuilding(String idBuilding) async {
    var token = await Utils.getToken();
    dio.options.headers['Content-Type'] = "Application/json";
    dio.options.headers['accept'] = "Application/json";
    dio.options.headers['authorization'] = "Bearer ${token}";
    try {
      return await dio.get('${Config.baseUrl}/buildings/$idBuilding/floors' ,
      ).catchError((onError) {
        return null;
      });
    } catch (error) {
      return null;
    }
  }

  Future<Response?> getRommbyBuilding(String idBuilding) async {
    var token = await Utils.getToken();
    dio.options.headers['Content-Type'] = "Application/json";
    dio.options.headers['accept'] = "Application/json";
    dio.options.headers['authorization'] = "Bearer ${token}";
    try {
      return await dio.get('${Config.baseUrl}/buildings/$idBuilding/rooms' ,
      ).catchError((onError) {
        return null;
      });
    } catch (error) {
      return null;
    }
  }

  Future<Response?> getTachebyBuilding(String idBuilding) async {
    var token = await Utils.getToken();
    dio.options.headers['Content-Type'] = "Application/json";
    dio.options.headers['accept'] = "Application/json";
    dio.options.headers['authorization'] = "Bearer ${token}";
    try {
      return await dio.get('${Config.baseUrl}/assignments/by-building/$idBuilding' ,
      ).catchError((onError) {
        return null;
      });
    } catch (error) {
      return null;
    }
  }
}


