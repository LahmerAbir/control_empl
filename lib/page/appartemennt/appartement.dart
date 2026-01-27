import 'package:control_empl/blocs/appartement_form_bloc.dart';
import 'package:control_empl/model/appartement.dart';
import 'package:control_empl/ui/common/loading.dart';
import 'package:control_empl/ui/common/loading_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../repository/building_repository.dart';

class LogementsScreen extends StatefulWidget {
  const LogementsScreen({super.key, required this.selectedBuildingId});

  final String selectedBuildingId;

  @override
  State<LogementsScreen> createState() => _LogementsScreenState();
}

class _LogementsScreenState extends State<LogementsScreen> {
  final List<String> _statusFilters = [
    'Tous',
    'Propre',
    'En cours',
    'À nettoyer',
  ];
  String _selectedFilter = 'Tous';

  List<Appartement> logements = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchLogements();
  }

  Future<void> _fetchLogements() async {
    setState(() {
      isLoading = true;
    });
    logements =
        await BuildingRepository().getRommByBuilding(
          widget.selectedBuildingId,
        ) ??
        [];
    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Appartement',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: Colors.black,
          ),
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
                  showLogementDialog(context);
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
      body: isLoading
          ? const Loader()
          : logements.isNotEmpty
          ? Column(
              children: [
                // Filters...
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: logements
                          .map((e) => LogementCard(logement: e))
                          .toList(),
                    ),
                  ),
                ),
              ],
            )
          : const Center(child: Text("Liste est vide ")),
    );
  }

  void showLogementDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return BlocProvider(
          create: (context) => AppartementFormBloc(idBuilding: widget.selectedBuildingId),
          child: const LogementDialog(),
        );
      },
    ).then((_) => _fetchLogements());
  }
}

class LogementDialog extends StatelessWidget {
  const LogementDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AppartementFormBloc, AppartementFormState>(
      listener: (context, state) {
        if (state.status == AppartementFormStatus.loading) {
          LoadingDialog.show(context);
        } else if (state.status == AppartementFormStatus.success) {
          LoadingDialog.hide(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Appartement ajouté avec succès !')),
          );
          Navigator.of(context).pop(true);
        } else if (state.status == AppartementFormStatus.failure) {
          LoadingDialog.hide(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errorMessage ?? 'Erreur')),
          );
        }
      },
      child: Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Ajouter un Appartement',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              TextField(
                decoration: const InputDecoration(labelText: 'Nom du Appartement'),
                onChanged: (value) => context.read<AppartementFormBloc>().onNomLogementChanged(value),
              ),
              const SizedBox(height: 12),
              TextField(
                decoration: const InputDecoration(labelText: 'Description'),
                onChanged: (value) => context.read<AppartementFormBloc>().onDescriptionChanged(value),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
                  onPressed: () => context.read<AppartementFormBloc>().submit(),
                  child: const Text('Ajouter', style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LogementCard extends StatelessWidget {
  final Appartement logement;
  const LogementCard({super.key, required this.logement});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(logement.name ?? ""),
        subtitle: Text(logement.roomType ?? ""),
      ),
    );
  }
}
