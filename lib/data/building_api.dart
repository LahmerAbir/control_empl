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

  Future<Response?> getTachebyCleaner(String cleanerId) async {
    var token = await Utils.getToken();
    dio.options.headers['Content-Type'] = "Application/json";
    dio.options.headers['accept'] = "Application/json";
    dio.options.headers['authorization'] = "Bearer ${token}";
    try {
      return await dio.get('${Config.baseUrl}/assignments/by-cleaner/$cleanerId' ,
      ).catchError((onError) {
        return null;
      });
    } catch (error) {
      return null;
    }
  }

  Future<Response?> getRoomStatus(String roomid) async {
    var token = await Utils.getToken();
    dio.options.headers['Content-Type'] = "Application/json";
    dio.options.headers['accept'] = "Application/json";
    dio.options.headers['authorization'] = "Bearer ${token}";
    try {
      return await dio.get('${Config.baseUrl}/room-statuses/$roomid' ,
      ).catchError((onError) {
        return null;
      });
    } catch (error) {
      return null;
    }
  }

  Future<Response?> getImageNotesRoom(String roomid) async {
    var token = await Utils.getToken();
    dio.options.headers['Content-Type'] = "Application/json";
    dio.options.headers['accept'] = "Application/json";
    dio.options.headers['authorization'] = "Bearer ${token}";
    try {
      return await dio.get('${Config.baseUrl}/notes-images/room/$roomid' ,
      ).catchError((onError) {
        return null;
      });
    } catch (error) {
      return null;
    }
  }

  Future<Response?> addAppartement(String idBuilding , {String? name , String? description}) async {
    var token = await Utils.getToken();
    dio.options.headers['Content-Type'] = "Application/json";
    dio.options.headers['accept'] = "Application/json";
    dio.options.headers['authorization'] = "Bearer ${token}";
    try {
      return await dio.post('${Config.baseUrl}/buildings/$idBuilding/rooms' , data: {
          "name": name,
          "description": description

      }
      ).catchError((onError) {
        return null;
      });
    } catch (error) {
      return null;
    }
  }
  Future<Response?> addNoteRoom(String idRoom ,String? description) async {
    var token = await Utils.getToken();
    dio.options.headers['Content-Type'] = "Application/json";
    dio.options.headers['accept'] = "Application/json";
    dio.options.headers['authorization'] = "Bearer ${token}";
    try {
      return await dio.post('${Config.baseUrl}/notes-images/notes' , data:   {
        "room_id": idRoom,
        "text": description
      }
      ).catchError((onError) {
        return null;
      });
    } catch (error) {
      return null;
    }
  }

  Future<Response?> addImageRoom(String noteId ,  String baseImaage , String fileName) async {
    var token = await Utils.getToken();
    dio.options.headers['Content-Type'] = "Application/json";
    dio.options.headers['accept'] = "Application/json";
    dio.options.headers['authorization'] = "Bearer ${token}";
    try {
      return await dio.post('${Config.baseUrl}/notes-images/images/$noteId' , data:    {
        "base64Image": baseImaage,
        "fileName": fileName
      }
      ).catchError((onError) {
        return null;
      });
    } catch (error) {
      return null;
    }
  }
  Future<Response?> addTache( {String? cleaner_id , String? building_id , String? room_id , String? start_date , String? end_date }) async {

    print("api add tache");
    print("api add tache $cleaner_id");
    print("api add tache $building_id");
    print("api add tache $room_id");
    print("api add tache $start_date");
    print("api add tache $end_date");
    var token = await Utils.getToken();
    dio.options.headers['Content-Type'] = "Application/json";
    dio.options.headers['accept'] = "Application/json";
    dio.options.headers['authorization'] = "Bearer ${token}";
    try {
      return await dio.post('${Config.baseUrl}/assignments' , data: {


          "cleaner_id": cleaner_id,
          "building_id": building_id,
          "room_id": room_id,
          "start_date": start_date,
          "end_date": end_date


      }
      ).catchError((onError) {
        print("erreeurr $onError");
        return null;
      });
    } catch (error) {
      print("erreeurr $error");

      return null;
    }
  }
}


