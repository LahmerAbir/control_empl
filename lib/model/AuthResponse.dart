import 'package:control_empl/model/user_response.dart';

class AuthResp {
  UserRes? user;
  Session? session;

  AuthResp({this.user, this.session});

  AuthResp.fromJson(Map<String, dynamic> json) {
    user = json['user'] != null ? new UserRes.fromJson(json['user']) : null;
    session =
    json['session'] != null ? new Session.fromJson(json['session']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    if (this.session != null) {
      data['session'] = this.session!.toJson();
    }
    return data;
  }
}


class AppMetadata {
  String? provider;
  List<String>? providers;

  AppMetadata({this.provider, this.providers});

  AppMetadata.fromJson(Map<String, dynamic> json) {
    provider = json['provider'];
    providers = json['providers'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['provider'] = this.provider;
    data['providers'] = this.providers;
    return data;
  }
}

class UserMetadata {
  String? email;
  bool? emailVerified;
  String? firstName;
  String? lastName;
  bool? phoneVerified;
  String? role;
  String? sub;

  UserMetadata(
      {this.email,
        this.emailVerified,
        this.firstName,
        this.lastName,
        this.phoneVerified,
        this.role,
        this.sub});

  UserMetadata.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    emailVerified = json['email_verified'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    phoneVerified = json['phone_verified'];
    role = json['role'];
    sub = json['sub'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['email'] = this.email;
    data['email_verified'] = this.emailVerified;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['phone_verified'] = this.phoneVerified;
    data['role'] = this.role;
    data['sub'] = this.sub;
    return data;
  }
}

class Identities {
  String? identityId;
  String? id;
  String? userId;
  UserMetadata? identityData;
  String? provider;
  String? lastSignInAt;
  String? createdAt;
  String? updatedAt;
  String? email;

  Identities(
      {this.identityId,
        this.id,
        this.userId,
        this.identityData,
        this.provider,
        this.lastSignInAt,
        this.createdAt,
        this.updatedAt,
        this.email});

  Identities.fromJson(Map<String, dynamic> json) {
    identityId = json['identity_id'];
    id = json['id'];
    userId = json['user_id'];
    identityData = json['identity_data'] != null
        ? new UserMetadata.fromJson(json['identity_data'])
        : null;
    provider = json['provider'];
    lastSignInAt = json['last_sign_in_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['identity_id'] = this.identityId;
    data['id'] = this.id;
    data['user_id'] = this.userId;
    if (this.identityData != null) {
      data['identity_data'] = this.identityData!.toJson();
    }
    data['provider'] = this.provider;
    data['last_sign_in_at'] = this.lastSignInAt;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['email'] = this.email;
    return data;
  }
}

class Session {
  String? accessToken;
  String? tokenType;
  int? expiresIn;
  int? expiresAt;
  String? refreshToken;
  UserRes? user;
  Null? weakPassword;

  Session(
      {this.accessToken,
        this.tokenType,
        this.expiresIn,
        this.expiresAt,
        this.refreshToken,
        this.user,
        this.weakPassword});

  Session.fromJson(Map<String, dynamic> json) {
    accessToken = json['access_token'];
    tokenType = json['token_type'];
    expiresIn = json['expires_in'];
    expiresAt = json['expires_at'];
    refreshToken = json['refresh_token'];
    user = json['user'] != null ? new UserRes.fromJson(json['user']) : null;
    weakPassword = json['weak_password'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['access_token'] = this.accessToken;
    data['token_type'] = this.tokenType;
    data['expires_in'] = this.expiresIn;
    data['expires_at'] = this.expiresAt;
    data['refresh_token'] = this.refreshToken;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    data['weak_password'] = this.weakPassword;
    return data;
  }
}