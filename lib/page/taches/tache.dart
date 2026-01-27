// dart
import 'package:control_empl/blocs/tache_form_bloc.dart';
import 'package:control_empl/model/ImageNotes.dart';
import 'package:control_empl/model/tache.dart';
import 'package:control_empl/ui/common/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../model/appartement.dart';
import '../../model/employe.dart';
import '../../repository/building_repository.dart';
import '../../repository/employe_repository.dart';
import '../../ui/common/loading_dialog.dart';
import '../../utils/utils.dart';

class PlanningScreen extends StatefulWidget {
  const PlanningScreen({super.key, required this.selectedBuildingId});

  final String selectedBuildingId;

  @override
  State<PlanningScreen> createState() => _PlanningScreenState();
}

class _PlanningScreenState extends State<PlanningScreen> {
  List<TachePlanning> _allTaches = [];
  List<TachePlanning> _filteredTaches = [];
  final TextEditingController _searchController = TextEditingController();
  DateTime? _selectedDate;
  final DateFormat _dateFormat = DateFormat('MMM dd, yyyy', 'en');
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTaches();
  }

  Future<void> _loadTaches() async {
    try {
      _allTaches = await BuildingRepository()
          .getTachesByBuilding(widget.selectedBuildingId) ??
          [];
      if (mounted) {
        setState(() {
          isLoading = false;
          _filteredTaches = _allTaches;
          _searchController.addListener(_applyFilters);
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _searchController.removeListener(_applyFilters);
    _searchController.dispose();
    super.dispose();
  }

  bool isSameDate(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  void _applyFilters() {
    final query = _searchController.text.toLowerCase();

    setState(() {
      _filteredTaches = _allTaches.where((tache) {
        final matchesSearch = query.isEmpty ||
            (tache.room?.name?.toLowerCase().contains(query) ?? false) ||
            (tache.cleanerId?.toLowerCase().contains(query) ?? false);

        final matchesDate = _selectedDate == null ||
            isSameDate(tache.startDate ?? DateTime.now(), _selectedDate!);

        return matchesSearch && matchesDate;
      }).toList();
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime(2030),
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
      _applyFilters();
    }
  }

  void _clearDateFilter() {
    setState(() {
      _selectedDate = null;
    });
    _applyFilters();
  }

  @override
  Widget build(BuildContext context) {
    final dateDisplay =
    _selectedDate != null ? _dateFormat.format(_selectedDate!) : 'Sélectionner une date';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Liste des taches',
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
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(8),
              ),
              child: IconButton(
                icon: const Icon(Icons.add, color: Colors.white),
                onPressed: () => showAjoutPlanningDialog(context),
              ),
            ),
          ),
        ],
        centerTitle: false,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: isLoading
          ? const Loader()
          : Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Rechercher...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.grey.shade200,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: InkWell(
              onTap: () => _selectDate(context),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.calendar_month, color: Colors.blue),
                    const SizedBox(width: 10),
                    Text(dateDisplay),
                    const Spacer(),
                    if (_selectedDate != null)
                      IconButton(onPressed: _clearDateFilter, icon: const Icon(Icons.close))
                    else
                      const Icon(Icons.keyboard_arrow_down),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: _filteredTaches.isEmpty
                ? const Center(child: Text("Liste vide"))
                : ListView.builder(
              itemCount: _filteredTaches.length,
              itemBuilder: (context, index) => PlanningCard(tache: _filteredTaches[index]),
            ),
          ),
        ],
      ),
    );
  }

  void showAjoutPlanningDialog(BuildContext context) async {
    final result = await showDialog(
      context: context,
      builder: (context) => const AjoutPlanningDialog(),
    );

    if (result == true) {
      _loadTaches();
    }
  }
}

class PlanningCard extends StatelessWidget {
  final TachePlanning tache;
  const PlanningCard({super.key, required this.tache});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        title: Text('Appartement: ${tache.room?.name ?? "N/A"}'),
        subtitle: Text('Employé: ${tache.cleaner?.lastName ?? ""} ${tache.cleaner?.firstName ?? ""}'),
        trailing: IconButton(
          icon: const Icon(Icons.remove_red_eye_outlined),
          onPressed: () {
            showDialog(context: context, builder: (context) => TacheDetailDialog(tache: tache));
          },
        ),
      ),
    );
  }
}

class TacheDetailDialog extends StatefulWidget {
  TacheDetailDialog({super.key , required this.tache});
  final TachePlanning tache;

  @override
  State<TacheDetailDialog> createState() => TacheDetailDialogState();
}

class TacheDetailDialogState extends State<TacheDetailDialog> {
  late TachePlanning tache;
  ImageNote? description;
  String status = "";
  bool isLoading = true;

  @override
  initState() {
    super.initState();
    tache = widget.tache;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        description =
        await BuildingRepository().getImageNoteRomm(
            tache.roomId ?? "");
        var  statusRes =
            await BuildingRepository().getStatusRoom(
                tache.roomId ?? "") ?? "";

        setState(() {
          status = mapStatusToLabel(statusRes);
          isLoading = false;
        });
      }catch(e)
      {
        setState(() {
          isLoading = false;

        });
      }
    });
  }

  Widget _buildInfoRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.blue.shade700),
          const SizedBox(width: 10),
          Text(
            '$label : ',
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
          ),
          Flexible(child: Text(value, style: const TextStyle(fontSize: 15))),
        ],
      ),
    );
  }
  String mapStatusToLabel(String status) {
    switch (status) {
      case 'clean':
        return 'Terminé';
      case 'dirty':
        return 'Retard';
      case 'in_progress':
        return 'En cours';
      case 'needs_attention':
        return 'Faire attention';
      default:
        throw Exception('Statut inconnu: $status');
    }
  }
  Widget buildNoteSection(ImageNote note) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Note',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),

        // 📝 Texte de la note
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Text(
            note.text ?? "",
            style: const TextStyle(fontSize: 14),
          ),
        ),

        const SizedBox(height: 12),

        // 🖼️ Images
        if(note.images != null ) if (note.images!.isNotEmpty) ...[
          const Text(
            'Images',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 100,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: note.images!.length,
              separatorBuilder: (_, __) => const SizedBox(width: 10),
              itemBuilder: (context, index) {
                final image = note.images![index];
                return ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    image.imageUrl  ?? "",
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, progress) {
                      if (progress == null) return child;
                      return const SizedBox(
                        width: 100,
                        height: 100,
                        child: Center(child: CircularProgressIndicator()),
                      );
                    },
                    errorBuilder: (_, __, ___) => Container(
                      width: 100,
                      height: 100,
                      color: Colors.grey.shade300,
                      child: const Icon(Icons.broken_image),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ],
    );
  }


  @override
  Widget build(BuildContext context) {
    final dtStart = DateTime.parse(tache.startDate != null ? tache.startDate.toString() : DateTime.now().toString());
    final dtEnd = DateTime.parse(tache.endDate != null ? tache.endDate.toString() : DateTime.now().toString());

    final dateStart =
        "${dtStart.year}-${dtStart.month.toString().padLeft(2, '0')}-${dtStart.day.toString().padLeft(2, '0')}";
    final dateEnd =
        "${dtEnd.year}-${dtEnd.month.toString().padLeft(2, '0')}-${dtEnd.day.toString().padLeft(2, '0')}";
    final timeStart =
        "${dtStart.hour.toString().padLeft(2, '0')}:${dtStart.minute.toString().padLeft(2, '0')}";
    final timeEnd =
        "${dtEnd.hour.toString().padLeft(2, '0')}:${dtEnd.minute.toString().padLeft(2, '0')}";
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(
        horizontal: 20.0,
        vertical: 24.0,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: isLoading ? SizedBox(height : 200 , child: Loader()) : Container(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // --- En-tête ---
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Détail Tâche: ${tache.room!.name}',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),

            RichText(
              text: TextSpan(
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black, // important sinon texte invisible
                ),
                children: [
                  const TextSpan(
                    text: "De ",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: "$dateStart - $timeStart "),
                  const TextSpan(
                    text: "à ",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: "$dateEnd - $timeEnd"),
                ],
              ),
            ),
            const Divider(height: 20),
            Flexible(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Infos Tâche
                    _buildInfoRow(
                      'Employé',
                      "${tache.cleaner?.lastName} ${tache.cleaner?.firstName}",
                      Icons.person_outline,
                    ),

                    _buildInfoRow(
                      'Statut',
                      status,
                      Icons.check_circle_outline,
                    ),
                    const SizedBox(height: 15),

                    // Description
                    const Text(
                      'Description du travail',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    if(description != null) buildNoteSection(description!)
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class AjoutPlanningDialog extends StatefulWidget {
  const AjoutPlanningDialog({super.key});

  @override
  State<AjoutPlanningDialog> createState() => _AjoutPlanningDialogState();
}

class _AjoutPlanningDialogState extends State<AjoutPlanningDialog> {
  List<Appartement> logements = [];
  List<Employe> equipe = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    logements = await BuildingRepository().getRommByBuilding(Utils.idBuilding ?? "") ?? [];
    equipe = await EmployeRepository().getUsers() ?? [];
    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  InputDecoration _inputDecoration(String label, {Widget? suffixIcon}) {
    return InputDecoration(
      labelText: label,
      suffixIcon: suffixIcon,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TaskFormBloc(),
      child: BlocListener<TaskFormBloc, TaskFormState>(
        listener: (context, state) {
          if (state.status == TaskFormStatus.loading) {
            LoadingDialog.show(context);
          } else if (state.status == TaskFormStatus.success) {
            LoadingDialog.hide(context);
            Navigator.pop(context, true);
          } else if (state.status == TaskFormStatus.failure) {
            LoadingDialog.hide(context);
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.errorMessage ?? 'Erreur')));
          }
        },
        child: Builder(builder: (context) {
          final bloc = context.read<TaskFormBloc>();
          final state = context.watch<TaskFormBloc>().state;

          return Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: isLoading
                ? const SizedBox(height: 200, child: Center(child: CircularProgressIndicator()))
                : Padding(
              padding: const EdgeInsets.all(20.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Ajouter une Tache', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context)),
                      ],
                    ),
                    const SizedBox(height: 15),
                    DropdownButtonFormField<String>(
                      value: state.employeId,
                      decoration: _inputDecoration('Employé'),
                      items: equipe.map((e) => DropdownMenuItem(value: e.id, child: Text('${e.lastname} ${e.firstname}'))).toList(),
                      onChanged: bloc.updateEmploye,
                    ),
                    const SizedBox(height: 15),
                    DropdownButtonFormField<String>(
                      value: state.appartementId,
                      decoration: _inputDecoration('Appartement'),
                      items: logements.map((a) => DropdownMenuItem(value: a.id, child: Text(a.name ?? ""))).toList(),
                      onChanged: bloc.updateAppartement,
                    ),
                    const SizedBox(height: 15),
                    InkWell(
                      onTap: () async {
                        final d = await showDatePicker(
                          context: context,
                          initialDate: state.date ?? DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2030),
                        );
                        if (d != null) bloc.updateDate(d);
                      },
                      child: InputDecorator(
                        decoration: _inputDecoration('Date', suffixIcon: const Icon(Icons.calendar_today)),
                        child: Text(state.date == null ? 'Sélectionner une date' : DateFormat('yyyy-MM-dd').format(state.date!)),
                      ),
                    ),
                    const SizedBox(height: 15),
                    Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () async {
                              final t = await showTimePicker(context: context, initialTime: state.heureDebut);
                              if (t != null) bloc.updateHeureDebut(t);
                            },
                            child: InputDecorator(
                              decoration: _inputDecoration('De', suffixIcon: const Icon(Icons.access_time)),
                              child: Text(state.heureDebut.format(context)),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: InkWell(
                            onTap: () async {
                              final t = await showTimePicker(context: context, initialTime: state.heureFin);
                              if (t != null) bloc.updateHeureFin(t);
                            },
                            child: InputDecorator(
                              decoration: _inputDecoration('À', suffixIcon: const Icon(Icons.access_time)),
                              child: Text(state.heureFin.format(context)),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    TextField(
                      decoration: _inputDecoration('Note'),
                      maxLines: 4,
                      onChanged: bloc.updateNote,
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: bloc.submit,
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
        }),
      ),
    );
  }
}
