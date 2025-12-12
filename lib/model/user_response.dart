
import 'AuthResponse.dart';

class UserRes {
  String? id;
  String? aud;
  String? role;
  String? email;
  String? emailConfirmedAt;
  String? phone;
  String? confirmationSentAt;
  String? confirmedAt;
  String? lastSignInAt;
  AppMetadata? appMetadata;
  UserMetadata? userMetadata;
  List<Identities>? identities;
  String? createdAt;
  String? updatedAt;
  bool? isAnonymous;

  UserRes(
      {this.id,
        this.aud,
        this.role,
        this.email,
        this.emailConfirmedAt,
        this.phone,
        this.confirmationSentAt,
        this.confirmedAt,
        this.lastSignInAt,
        this.appMetadata,
        this.userMetadata,
        this.identities,
        this.createdAt,
        this.updatedAt,
        this.isAnonymous});

  UserRes.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    aud = json['aud'];
    role = json['role'];
    email = json['email'];
    emailConfirmedAt = json['email_confirmed_at'];
    phone = json['phone'];
    confirmationSentAt = json['confirmation_sent_at'];
    confirmedAt = json['confirmed_at'];
    lastSignInAt = json['last_sign_in_at'];
    appMetadata = json['app_metadata'] != null
        ? new AppMetadata.fromJson(json['app_metadata'])
        : null;
    userMetadata = json['user_metadata'] != null
        ? new UserMetadata.fromJson(json['user_metadata'])
        : null;
    if (json['identities'] != null) {
      identities = <Identities>[];
      json['identities'].forEach((v) {
        identities!.add(new Identities.fromJson(v));
      });
    }
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    isAnonymous = json['is_anonymous'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['aud'] = this.aud;
    data['role'] = this.role;
    data['email'] = this.email;
    data['email_confirmed_at'] = this.emailConfirmedAt;
    data['phone'] = this.phone;
    data['confirmation_sent_at'] = this.confirmationSentAt;
    data['confirmed_at'] = this.confirmedAt;
    data['last_sign_in_at'] = this.lastSignInAt;
    if (this.appMetadata != null) {
      data['app_metadata'] = this.appMetadata!.toJson();
    }
    if (this.userMetadata != null) {
      data['user_metadata'] = this.userMetadata!.toJson();
    }
    if (this.identities != null) {
      data['identities'] = this.identities!.map((v) => v.toJson()).toList();
    }
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['is_anonymous'] = this.isAnonymous;
    return data;
  }
}