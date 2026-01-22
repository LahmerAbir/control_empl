




import 'package:control_empl/model/ImageNotes.dart';
import 'package:control_empl/model/appartement.dart';
import 'package:control_empl/model/tache.dart';
import 'package:flutter/cupertino.dart';

import '../data/building_api.dart';
import '../model/building.dart';
import '../model/planning_cleaner.dart';

class BuildingRepository {
  final buildingApi = BuildingApi();
  String? token;
  String? role;

  Future<List<Building>?> getBuilding() async {
    print("cc");
    final response = await buildingApi.getBuilding();
    try {
      if (response != null) {
        final List<dynamic> data = response.data;
        final List<Building> list = data.map((e) => Building.fromJson(e)).toList();


        return list;
      }
      return null;
    }catch (e)
    {
      print("e $e");
      return null;
    }
  }

  Future<List<Appartement>?> getRommByBuilding(String idBuilding ) async {
    print("cc");
    final response = await buildingApi.getRommbyBuilding(idBuilding);
    try {
      if (response != null) {
        final List<dynamic> data = response.data;
        final List<Appartement> list = data.map((e) => Appartement.fromJson(e)).toList();


        return list;
      }
      return null;
    }catch (e)
    {
      print("e $e");
      return null;
    }
  }
  Future<List<TachePlanning>?> getTachesByBuilding(String idBuilding ) async {
    final response = await buildingApi.getTachebyBuilding(idBuilding);
    try {
      if (response != null) {
        final List<dynamic> data = response.data;
        final List<TachePlanning> list = data.map((e) => TachePlanning.fromJson(e)).toList();


        return list;
      }
      return null;
    }catch (e)
    {
      print("e $e");
      return null;
    }
  }

  Future<List<PlanningCleaner>?> getTachesByCleaner(String idUser ) async {
    final response = await buildingApi.getTachebyCleaner(idUser);
    try {
      if (response != null) {
        final List<dynamic> data = response.data;
        final List<PlanningCleaner> list = data.map((e) => PlanningCleaner.fromJson(e)).toList();
        return list;
      }
      return null;
    }catch (e)
    {
      print("e $e");
      return null;
    }
  }
  Future<String?> getStatusRoom(String idRoom ) async {
    final response = await buildingApi.getRoomStatus(idRoom);
    try {
      if (response != null) {

        return response.data["status"];
      }
      return null;
    }catch (e)
    {
      print("e $e");
      return null;
    }
  }

  Future<ImageNote?> getImageNoteRomm(String idRoom ) async {
    final response = await buildingApi.getImageNotesRoom(idRoom);
    try {
      if (response != null) {

        final List<dynamic> data = response.data;
        final List<ImageNote> list = data.map((e) => ImageNote.fromJson(e)).toList();


        return list.first;      }
      return null;
    }catch (e)
    {
      print("e $e");
      return null;
    }
  }
  Future<bool?> addRommbyBuilding(String idBuilding ,{String? name , String? description} ) async {
    final response = await buildingApi.addAppartement(idBuilding , name : name , description:   description);
    try {
      if (response != null) {
          return true;
      }
      return null;
    }catch (e)
    {
      print("e $e");
      return null;
    }
  }
  Future<String?> addnoteRoom(String roomid ,  String? description ) async {
    final response = await buildingApi.addNoteRoom(roomid ,  description);
    try {
      if (response != null) {
        return response.data["id"];
      }
      return null;
    }catch (e)
    {
      print("e $e");
      return null;
    }
  }
  Future<bool?> addImagesRoom(String noteId ,  String baseImaage , String fileName ) async {
    final response = await buildingApi.addImageRoom(noteId ,  baseImaage , fileName);
    try {
      if (response != null) {
        return true;
      }
      return null;
    }catch (e)
    {
      print("e $e");
      return null;
    }
  }
  Future<bool?> addTache({String? cleaner_id , String? building_id , String? room_id , String? start_date , String? end_date } ) async {
    final response = await buildingApi.addTache(cleaner_id: cleaner_id , building_id: building_id , room_id: room_id , start_date: start_date , end_date: end_date);
    try {
      if (response != null) {
        return true;
      }
      return null;
    }catch (e)
    {
      print("exx $e");
      return null;
    }
  }
}