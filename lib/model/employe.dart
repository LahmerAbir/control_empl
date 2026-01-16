class Employe {
  final String? id;
  final String? email;
  final String? telephone;
  final String? statut;
  final String? firstname;
  final String? lastname;
  final String? role;

  Employe({
    required this.id,
    required this.email,
    required this.telephone,
    required this.statut,
    this.firstname,
    this.lastname,
    this.role,
  });

  /// FROM JSON
  factory Employe.fromJson(Map<String, dynamic> json) {
    return Employe(
      id: json['id'] as String?,
      email: json['email'] as String?,
      telephone: json['phone'] as String?,
      statut: json['statut'] as String?,
      firstname: json['first_name'] as String?,
      lastname: json['last_name'] as String?,
      role: json['role'] as String?,
    );

  }

  /// TO JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'telephone': telephone,
      'statut': statut,
      'firstname': firstname,
      'lastname': lastname,
      'role': role,
    };
  }

  String get initiales {
    String nom = lastname ?? " $firstname" ?? "";
    List<String> parts = nom.split(' ');
    String initiales = '';
    if (parts.isNotEmpty && parts[0].isNotEmpty) {
      initiales += parts[0][0];
    }
    if (parts.length > 1 && parts[1].isNotEmpty) {
      initiales += parts[1][0];
    }
    return initiales.toUpperCase();
  }
}
