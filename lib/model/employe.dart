class Employe {
  final String nom;
  final String email;
  final String telephone;
  final String statut;

  Employe({
    required this.nom,
    required this.email,
    required this.telephone,
    required this.statut,
  });

  String get initiales {
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