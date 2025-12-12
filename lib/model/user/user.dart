import 'package:flutter_data/flutter_data.dart';
import 'package:json_annotation/json_annotation.dart';

import '../adapters.dart';
part 'user.g.dart';

@JsonSerializable()
@DataRepository([ApplicationAdapter ])
class User extends DataModel<User> {
  @override
  final String? id; // ID can be of any type
  final String? firstname;
  final String? lastname;
  final String? email;
  final String? password;
  final String? phone;
  final String? role;
  final String? street;
  final String? city;
  final String? zipcode;

  User({this.id, this.firstname, this.lastname, this.email, this.password, this.phone, this.role, this.street, this.city, this.zipcode});

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
}