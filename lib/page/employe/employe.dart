import 'package:control_empl/model/employe.dart';
import 'package:control_empl/repository/employe_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/employe_form_bloc.dart';
import '../../ui/common/loading.dart';
import '../../ui/common/loading_dialog.dart';

class EquipeScreen extends StatefulWidget {
  const EquipeScreen({super.key});

  @override
  State<EquipeScreen> createState() => _EquipeScreenState();
}

class _EquipeScreenState extends State<EquipeScreen> {
  List<Employe> equipe = [];
  List<Employe> _filteredEquipe = [];
  bool isLoading = true;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    equipe = await EmployeRepository().getUsers() ?? [];
    if (mounted) {
      setState(() {
        isLoading = false;
        _filteredEquipe = equipe;
        _searchController.addListener(_filterEquipe);
      });
    }
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
          final nomComplet = membre.firstname?.toLowerCase() ?? "";
          final email = membre.email?.toLowerCase() ?? "";
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
        title: const Text(
          'Les employés',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24, color: Colors.black),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(8)),
              child: IconButton(
                icon: const Icon(Icons.add, color: Colors.white),
                onPressed: () => showEmployeDialog(context),
              ),
            ),
          ),
        ],
        centerTitle: false,
        backgroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 80,
      ),
      body: isLoading
          ? const Loader()
          : equipe.isNotEmpty
              ? Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: 'Rechercher...',
                          prefixIcon: const Icon(Icons.search),
                          filled: true,
                          fillColor: Colors.grey.shade100,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                        ),
                      ),
                    ),
                    Expanded(
                      child: _filteredEquipe.isEmpty
                          ? const Center(child: Text("Liste vide"))
                          : ListView.builder(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              itemCount: _filteredEquipe.length,
                              itemBuilder: (context, index) => MembreCard(membre: _filteredEquipe[index]),
                            ),
                    ),
                  ],
                )
              : const Center(child: Text("Liste est vide")),
    );
  }

  void showEmployeDialog(BuildContext context) async {
    final result = await showDialog(
      context: context,
      builder: (context) => BlocProvider(
        create: (context) => EmployeFormBloc(),
        child: const EmployeDialog(),
      ),
    );
    if (result == true) _loadData();
  }

  void showModifierEmployeDialog(BuildContext context, Employe employe) async {
    final result = await showDialog(
      context: context,
      builder: (context) => BlocProvider(
        create: (context) => ModifierEmployeFormBloc(employe),
        child: ModifierEmployeDialog(employe: employe),
      ),
    );
    if (result == true) _loadData();
  }


  Widget MembreCard({required Employe membre}) {

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        onTap: () => showModifierEmployeDialog(context, membre),
        leading: CircleAvatar(child: Text(membre.initiales ?? "")),
        title: Text("${membre.lastname ?? ""} ${membre.firstname ?? ""}"),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(membre.email ?? ""),
            Text(membre.telephone ?? ""),
          ],
        ),
        trailing: const Icon(Icons.edit, size: 20),
      ),
    );
  }
}

class EmployeDialog extends StatelessWidget {
  const EmployeDialog({super.key});

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<EmployeFormBloc, EmployeFormState>(
      listener: (context, state) {
        if (state.status == EmployeFormStatus.loading) {
          LoadingDialog.show(context);
        } else if (state.status == EmployeFormStatus.success) {
          LoadingDialog.hide(context);
          Navigator.pop(context, true);
        } else if (state.status == EmployeFormStatus.failure) {
          LoadingDialog.hide(context);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.responseMessage ?? 'Erreur')));
        }
      },
      child: Builder(builder: (context) {
        final bloc = context.read<EmployeFormBloc>();
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Ajouter un employé', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  TextField(decoration: _inputDecoration('Nom'), onChanged: bloc.onFirstNameChanged),
                  const SizedBox(height: 12),
                  TextField(decoration: _inputDecoration('Prénom'), onChanged: bloc.onLastNameChanged),
                  const SizedBox(height: 12),
                  TextField(decoration: _inputDecoration('Email'), onChanged: bloc.onEmailChanged),
                  const SizedBox(height: 12),
                  TextField(decoration: _inputDecoration('Téléphone'), onChanged: bloc.onTelephoneChanged),
                  const SizedBox(height: 12),
                  TextField(decoration: _inputDecoration('Mot de passe'), obscureText: true, onChanged: bloc.onMotDePasseChanged),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 45,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      onPressed: bloc.submit,
                      child: const Text('Ajouter'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}

class ModifierEmployeDialog extends StatelessWidget {
  final Employe employe;
  const ModifierEmployeDialog({super.key, required this.employe});

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ModifierEmployeFormBloc, EmployeFormState>(
      listener: (context, state) {
        if (state.status == EmployeFormStatus.loading) {
          LoadingDialog.show(context);
        } else if (state.status == EmployeFormStatus.success) {
          LoadingDialog.hide(context);
          Navigator.pop(context, true);
        } else if (state.status == EmployeFormStatus.failure) {
          LoadingDialog.hide(context);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.responseMessage ?? 'Erreur')));
        }
      },
      child: Builder(builder: (context) {
        final bloc = context.read<ModifierEmployeFormBloc>();
        final state = context.watch<ModifierEmployeFormBloc>().state;
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Modifier un employé', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  TextField(
                    decoration: _inputDecoration('Nom'),
                    onChanged: bloc.onFirstNameChanged,
                    controller: TextEditingController(text: state.firstName)..selection = TextSelection.collapsed(offset: state.firstName.length),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    decoration: _inputDecoration('Prénom'),
                    onChanged: bloc.onLastNameChanged,
                    controller: TextEditingController(text: state.lastName)..selection = TextSelection.collapsed(offset: state.lastName.length),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    decoration: _inputDecoration('Email'),
                    onChanged: bloc.onEmailChanged,
                    controller: TextEditingController(text: state.email)..selection = TextSelection.collapsed(offset: state.email.length),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    decoration: _inputDecoration('Téléphone'),
                    onChanged: bloc.onTelephoneChanged,
                    controller: TextEditingController(text: state.telephone)..selection = TextSelection.collapsed(offset: state.telephone.length),
                  ),
                  const SizedBox(height: 12),
                  TextField(decoration: _inputDecoration('Nouveau mot de passe'), obscureText: true, onChanged: bloc.onMotDePasseChanged),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 45,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      onPressed: bloc.submit,
                      child: const Text('Enregistrer'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
