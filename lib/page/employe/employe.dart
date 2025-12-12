import 'package:control_empl/model/employe.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';

import '../../blocs/employe_form_bloc.dart';

class EquipeScreen extends StatefulWidget {
  const EquipeScreen({super.key});

  @override
  State<EquipeScreen> createState() => _EquipeScreenState();
}

class _EquipeScreenState extends State<EquipeScreen> {

  final List<Employe> equipe = [
    Employe(
      nom: 'Maria Garcia',
      email: 'maria@example.com',
      telephone: '52 211 706',
      statut: 'Disponible',
    ),
    Employe(
      nom: 'John Smith',
      email: 'john@example.com',
      telephone: '52 211 706',
      statut: 'Occupé',
    ),
    Employe(
      nom: 'Alice Dupont',
      email: 'alice@example.com',
      telephone: '52 211 706',
      statut: 'En pause',
    ),
    Employe(
      nom: 'Alice Dupont',
      email: 'alice@example.com',
      telephone: '52 211 706',
      statut: 'En pause',
    ),
    Employe(
      nom: 'Alice Dupont',
      email: 'alice@example.com',
      telephone: '52 211 706',
      statut: 'En pause',
    ),
    Employe(
      nom: 'Alice Dupont',
      email: 'alice@example.com',
      telephone: '52 211 706',
      statut: 'En pause',
    ),

    Employe(
      nom: 'Alice Dupont',
      email: 'alice@example.com',
      telephone: '52 211 706',
      statut: 'En pause',
    ),
  ];

  List<Employe> _filteredEquipe = [];

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _filteredEquipe = equipe;
    _searchController.addListener(_filterEquipe);
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterEquipe);
    _searchController.dispose();
    super.dispose();
  }

  void _filterEquipe() {
    final query = _searchController.text.toLowerCase();

    setState(() {
      if (query.isEmpty) {
        _filteredEquipe = equipe;
      } else {
        _filteredEquipe = equipe.where((membre) {
          final nomComplet = membre.nom.toLowerCase();
          final email = membre.email.toLowerCase();

          return nomComplet.contains(query) || email.contains(query);
        }).toList();
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Les employés',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
                color: Colors.black,
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(8),
              ),
              child: IconButton(
                icon: const Icon(Icons.add, color: Colors.white),
                onPressed: () {
                  showEmployeDialog(context);
                },
              ),
            ),
          ),
        ],
        centerTitle: false,
        backgroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 80,
      ),

      body: SizedBox(
        height: MediaQuery.of(context).size.height,

        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 3.0),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Rechercher par nom ou email...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                      },
                    )
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(vertical: 10.0),
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height *0.6,
                child: _filteredEquipe.isEmpty ? Center(child: Text("Liste vide")) : ListView.builder(
                  padding: const EdgeInsets.all(10.0),
                  itemCount: _filteredEquipe.length,
                  itemBuilder: (context, index) {
                    final membre = _filteredEquipe[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 20.0),
                      child: MembreCard(membre: membre),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showEmployeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return BlocProvider(
          create: (context) => EmployeFormBloc(),
          child: const EmployeDialog(),
        );
      },
    );
  }
}

class MembreCard extends StatelessWidget {
  final Employe membre;

  const MembreCard({super.key, required this.membre});

  Map<String, dynamic> _getStatusStyle(String statut) {
    switch (statut) {
      case 'Disponible':
        return {'couleurTexte': Colors.white, 'couleurFond': Colors.black};
      case 'Occupé':
        return {
          'couleurTexte': Colors.black,
          'couleurFond': Colors.grey.shade200,
        };
      case 'En pause':
        return {
          'couleurTexte': Colors.white,
          'couleurFond': Colors.orange.shade700,
        };
      default:
        return {
          'couleurTexte': Colors.black,
          'couleurFond': Colors.grey.shade200,
        };
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusStyle = _getStatusStyle(membre.statut);

    return GestureDetector(
      onTap: (){
        showModifierEmployeDialog(context ,membre);
      },
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildAvatar(membre.initiales),
                  const SizedBox(width: 12),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        membre.nom,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: statusStyle['couleurFond'],
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          membre.statut,
                          style: TextStyle(
                            color: statusStyle['couleurTexte'],
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 15),

              _buildContactRow(Icons.mail_outline, membre.email),
              const SizedBox(height: 5),
              _buildContactRow(Icons.phone_outlined, membre.telephone),
            ],
          ),
        ),
      ),
    );
  }
  void showModifierEmployeDialog(
      BuildContext context,
      Employe employeAModifier,
      ) {
    showDialog(
      context: context,
      builder: (context) {
        return BlocProvider(
          create: (context) => ModifierEmployeFormBloc(employeAModifier),
          child: const ModifierEmployeDialog(),
        );
      },
    );
  }
  Widget _buildAvatar(String initials) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: Colors.blue.shade100,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          initials,
          style: TextStyle(
            color: Colors.blue.shade700,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildContactRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: Colors.grey.shade600, size: 20),
        const SizedBox(width: 8),
        Text(text, style: TextStyle(color: Colors.grey.shade800, fontSize: 14)),
      ],
    );
  }
}

class EmployeDialog extends StatelessWidget {
  const EmployeDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final employeFormBloc = context.read<EmployeFormBloc>();

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(
        horizontal: 20.0,
        vertical: 24.0,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.83,
          child: Container(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Ajouter un employé',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                FormBlocListener<EmployeFormBloc, String, String>(
                  onSubmitting: (context, state) {
                    ScaffoldMessenger.of(context)
                      ..hideCurrentSnackBar()
                      ..showSnackBar(
                        const SnackBar(content: Text('Ajout en cours...')),
                      );
                  },
                  onSuccess: (context, state) {
                    ScaffoldMessenger.of(context)
                      ..hideCurrentSnackBar()
                      ..showSnackBar(
                        SnackBar(content: Text(state.successResponse!)),
                      );
                    Navigator.of(context).pop();
                  },
                  onFailure: (context, state) {
                    ScaffoldMessenger.of(context)
                      ..hideCurrentSnackBar()
                      ..showSnackBar(
                        SnackBar(content: Text(state.failureResponse!)),
                      );
                  },
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabel('Nom complet'),
                        TextFieldBlocBuilder(
                          textFieldBloc: employeFormBloc.nomComplet,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 10),

                        _buildLabel('Email'),
                        TextFieldBlocBuilder(
                          textFieldBloc: employeFormBloc.email,
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 10),

                        _buildLabel('Téléphone'),
                        TextFieldBlocBuilder(
                          textFieldBloc: employeFormBloc.telephone,
                          keyboardType: TextInputType.phone,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 10),

                        _buildLabel('Mot de passe'),
                        TextFieldBlocBuilder(
                          textFieldBloc: employeFormBloc.motDePasse,
                          obscureText: true, // Masquer le texte
                          decoration: const InputDecoration(
                            hintText: '******',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 50),

                SizedBox(
                  width: double.infinity,
                  height: 40,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: employeFormBloc.submit,
                    child: const Text(
                      'Ajouter',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
      ),
    );
  }


}

class ModifierEmployeDialog extends StatelessWidget {
  const ModifierEmployeDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final employeFormBloc = context.read<ModifierEmployeFormBloc>();

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(
        horizontal: 20.0,
        vertical: 24.0,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: SizedBox(
        child: Container(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Modifier un employé', // TITRE MIS À JOUR
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 20),
        
              FormBlocListener<ModifierEmployeFormBloc, String, String>(
                onSubmitting: (context, state) {
                  ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(
                      const SnackBar(content: Text('Sauvegarde en cours...')),
                    );
                },
                onSuccess: (context, state) {
                  ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(
                      SnackBar(content: Text(state.successResponse!)),
                    );
                  Navigator.of(context).pop();
                },
                onFailure: (context, state) {
                  ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(
                      SnackBar(content: Text(state.failureResponse!)),
                    );
                },
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLabel('Nom complet'),
                      TextFieldBlocBuilder(
                        textFieldBloc: employeFormBloc.nomComplet,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 15),
        
                      _buildLabel('Email'),
                      TextFieldBlocBuilder(
                        textFieldBloc: employeFormBloc.email,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 15),
        
                      _buildLabel('Téléphone'),
                      TextFieldBlocBuilder(
                        textFieldBloc: employeFormBloc.telephone,
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 15),
        
                      _buildLabel('Mot de passe (Laisser vide si inchangé)'),
                      TextFieldBlocBuilder(
                        textFieldBloc: employeFormBloc.motDePasse,
                        obscureText: true,
                        decoration: const InputDecoration(
                          hintText: 'Nouveau mot de passe',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: employeFormBloc.submit,
                  child: const Text(
                    'Enregistrer',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),
    );
  }
}
