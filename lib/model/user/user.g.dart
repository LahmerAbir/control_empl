// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// RepositoryGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, duplicate_ignore

mixin $UserLocalAdapter on LocalAdapter<User> {
  static final Map<String, RelationshipMeta> _kUserRelationshipMetas = {};

  @override
  Map<String, RelationshipMeta> get relationshipMetas =>
      _kUserRelationshipMetas;

  @override
  User deserialize(map) {
    map = transformDeserialize(map);
    return User.fromJson(map);
  }

  @override
  Map<String, dynamic> serialize(model, {bool withRelationships = true}) {
    final map = model.toJson();
    return transformSerialize(map, withRelationships: withRelationships);
  }
}

final _usersFinders = <String, dynamic>{};

// ignore: must_be_immutable
class $UserHiveLocalAdapter = HiveLocalAdapter<User> with $UserLocalAdapter;

class $UserRemoteAdapter = RemoteAdapter<User> with ApplicationAdapter<User>;

final internalUsersRemoteAdapterProvider = Provider<RemoteAdapter<User>>(
    (ref) => $UserRemoteAdapter(
        $UserHiveLocalAdapter(ref), InternalHolder(_usersFinders)));

final usersRepositoryProvider =
    Provider<Repository<User>>((ref) => Repository<User>(ref));

extension UserDataRepositoryX on Repository<User> {
  ApplicationAdapter<User> get applicationAdapter =>
      remoteAdapter as ApplicationAdapter<User>;
}

extension UserRelationshipGraphNodeX on RelationshipGraphNode<User> {}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      id: json['id'] as String?,
      firstname: json['firstname'] as String?,
      lastname: json['lastname'] as String?,
      email: json['email'] as String?,
      password: json['password'] as String?,
      phone: json['phone'] as String?,
      role: json['role'] as String?,
      street: json['street'] as String?,
      city: json['city'] as String?,
      zipcode: json['zipcode'] as String?,
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'firstname': instance.firstname,
      'lastname': instance.lastname,
      'email': instance.email,
      'password': instance.password,
      'phone': instance.phone,
      'role': instance.role,
      'street': instance.street,
      'city': instance.city,
      'zipcode': instance.zipcode,
    };
