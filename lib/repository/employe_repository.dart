import 'package:control_empl/data/employe_api.dart';
import 'package:control_empl/model/appartement.dart';
import 'package:control_empl/model/employe.dart';
import 'package:control_empl/model/tache.dart';

import '../data/building_api.dart';
import '../model/building.dart';

class EmployeRepository {
  final employeApi = EmployeApi();
  String? token;
  String? role;

  Future<List<Employe>?> getUsers() async {
    final response = await employeApi.getUsers();
    try {
      if (response != null) {
        final List<dynamic> data = response.data;
        final List<Employe> list = data
            .map((e) => Employe.fromJson(e))
            .toList();

        return list;
      }
      return null;
    } catch (e) {
      print("e $e");
      return null;
    }
  }

  Future<bool?> addUsers({
    String? email,
    String? password,
    String? firstName,
    String? lastName,
    String? phone,
    String? role,
  }) async {
    final response = await employeApi.addUsers(
      email: email,
      password: password,
      firstName: firstName,
      lastName: lastName,
      phone: phone,
      role: role,
    );
    try {
      if (response != null) {
        return true;
      }
      return null;
    } catch (e) {
      print("e $e");
      return null;
    }
  }

  Future<bool?> editUsers(String id, {
    String? email,
    String? password,
    String? firstName,
    String? lastName,
    String? phone,
    String? role,
  }) async {
    final response = await employeApi.editUsers(id ,   email: email,
      password: password,
      firstName: firstName,
      phone: phone,
      lastName: lastName,
      role: role,
    );
    try {
      if (response != null) {
        return true;
      }
      return null;
    } catch (e) {
      print("e $e");
      return null;
    }
  }
}
