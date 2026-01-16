




import 'package:control_empl/model/appartement.dart';
import 'package:control_empl/model/tache.dart';
import 'package:flutter/cupertino.dart';

import '../data/building_api.dart';
import '../model/building.dart';

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

  Future<bool?> addTache({String? cleaner_id , String? building_id , String? room_id , String? start_date , String? end_date } ) async {
    final response = await buildingApi.addTache(cleaner_id: cleaner_id , building_id: building_id , room_id: room_id , start_date: start_date , end_date: end_date);
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
}