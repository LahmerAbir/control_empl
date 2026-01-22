import 'package:control_empl/blocs/tache_form_bloc.dart';
import 'package:control_empl/model/ImageNotes.dart';
import 'package:control_empl/model/tache.dart';
import 'package:control_empl/ui/common/loading.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
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

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        _allTaches =
            await BuildingRepository().getTachesByBuilding(
              widget.selectedBuildingId ?? "",
            ) ??
            [];
        setState(() {
          isLoading = false;
          _filteredTaches = _allTaches;
          _searchController.addListener(_applyFilters);
        });
      } catch (e) {
        print("exception $e");
        setState(() {
          isLoading = false;
        });
      }
    });
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
    final String? dateQuery = _selectedDate != null
        ? _dateFormat.format(_selectedDate!)
        : null;
    print("_selectedDate $_selectedDate");

    setState(() {
      _filteredTaches = _allTaches.where((tache) {
        final matchesSearch =
            query.isEmpty ||
            tache.room!.name!.toLowerCase().contains(query) ||
            tache.cleanerId!.toLowerCase().contains(query);

        final matchesDate =
            dateQuery == null ||
            isSameDate(
              tache.startDate ?? DateTime.now(),
              _selectedDate ?? DateTime.now(),
            );

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
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.blue.shade700,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
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
    final dateDisplay = _selectedDate != null
        ? _dateFormat.format(_selectedDate!)
        : 'Sélectionner une date';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Liste des taches',
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
                  showAjoutPlanningDialog(context);
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
          ? Loader()
          : _allTaches.isNotEmpty
          ? SizedBox(
              height: MediaQuery.of(context).size.height,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: 'Rechercher (Appartement, Employé)...',
                          prefixIcon: const Icon(
                            Icons.search,
                            color: Colors.grey,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.grey.shade200,
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 10.0,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6.0),
                      child: InkWell(
                        onTap: () => _selectDate(context),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12.0,
                            vertical: 15.0,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const Icon(
                                    Icons.calendar_month,
                                    color: Colors.blue,
                                    size: 24,
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    dateDisplay,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                              if (_selectedDate != null)
                                IconButton(
                                  icon: const Icon(
                                    Icons.close,
                                    color: Colors.grey,
                                  ),
                                  onPressed: _clearDateFilter,
                                )
                              else
                                const Icon(
                                  Icons.keyboard_arrow_down,
                                  color: Colors.black,
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.45,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            ..._filteredTaches.map((tache) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6.0,
                                  vertical: 6.0,
                                ),
                                child: PlanningCard(tache: tache),
                              );
                            }).toList(),
                            if (_filteredTaches.isEmpty)
                              const Padding(
                                padding: EdgeInsets.all(6.0),
                                child: Center(
                                  child: Text(
                                    "Liste vide",
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          : Text("Liste est vide"),
    );
  }
  void showAjoutPlanningDialog(BuildContext context) async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(builder: (context) =>  AjoutPlanningDialog()),
    );

    if (result == true) {
      setState(() {
        isLoading = true;
      });
       _allTaches=
          await BuildingRepository().getTachesByBuilding(
            widget.selectedBuildingId,
          ) ??
              [];
      setState(() {
        isLoading = false;
        _filteredTaches = _allTaches;

      });
    }
  }

}

class PlanningCard extends StatelessWidget {
  final TachePlanning tache;

  const PlanningCard({super.key, required this.tache});



  void showTacheDetailDialog(BuildContext context, TachePlanning tache) {
    showDialog(
      context: context,
      builder: (context) {
        return TacheDetailDialog(tache: tache);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    //final statusColor = _getStatusColor(tache.statut);
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
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Appartement : ${tache.room!.name}',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),

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
                  const SizedBox(height: 4),

                  Text(
                    'Effectué à : ${tache.cleaner?.lastName} ${tache.cleaner?.firstName}',
                    style: const TextStyle(fontSize: 14, color: Colors.black87),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(2.0),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.remove_red_eye_outlined,
                      color: Colors.blue.shade600,
                      size: 25,
                    ),
                    onPressed: () => showTacheDetailDialog(context, tache),
                  ),

                  const SizedBox(width: 8),
                  // Bouton Modifier (Crayon)
                  IconButton(
                    icon: const Icon(
                      Icons.edit_outlined,
                      color: Colors.black,
                      size: 20,
                    ),
                    onPressed: () =>
                        print('Modifier tâche ${tache.room!.name}'),
                  ),
                ],
              ),
            ),
          ],
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
      child: isLoading ? Loader() : Container(
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
  AjoutPlanningDialog({super.key});

  @override
  State<AjoutPlanningDialog> createState() => AjoutPlanningDialogState();
}

class AjoutPlanningDialogState extends State<AjoutPlanningDialog> {
  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, top: 4.0),
      child: Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),
    );
  }

  InputDecoration _inputDecoration({
    required String hintText,
    Widget? suffixIcon,
    EdgeInsetsGeometry? contentPadding,
  }) {
    return InputDecoration(
      hintText: hintText,
      suffixIcon: suffixIcon,
      contentPadding:
          contentPadding ??
          const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.blue.shade700, width: 1.5),
      ),
      filled: true,
      fillColor: Colors.grey.shade200,
    );
  }

  List<Appartement> logements = [];
  bool isLoading = true;
  List<Employe> equipe = [];

  @override
  initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      logements =
          await BuildingRepository().getRommByBuilding(
            Utils.idBuilding ?? "",
          ) ??
          [];

      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final planningFormBloc = context.read<TacheFormBloc>();

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(
        horizontal: 16.0,
        vertical: 24.0,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),

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
                  'Ajouter une Tache',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const SizedBox(height: 10),

            Flexible(
              child: FormBlocListener<TacheFormBloc, String, String>(
                onSubmitting: (context, state) {
                  ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(
                      const SnackBar(content: Text('Assignation en cours...')),);
                },
                onLoading: (context, state) {
                  LoadingDialog.show(context);
                },
                onSuccess: (context, state) {
                  LoadingDialog.hide(context);

                  ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(
                      SnackBar(content: Text(state.successResponse!)),
                    );
                  Navigator.of(context).pop(true);
                },
                onFailure: (context, state) {
                  LoadingDialog.hide(context);

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
                      _buildLabel('Employé'),

                      BlocProvider(
                        create: (_) => TacheFormBloc(),
                        child: BlocBuilder<TacheFormBloc, FormBlocState>(
                          builder: (context, state) {

                            if (state is FormBlocLoading) {
                              return const CircularProgressIndicator();
                            } else {
                              return DropdownFieldBlocBuilder<Employe>(
                                selectFieldBloc: planningFormBloc.employe,
                                decoration: _inputDecoration(
                                  hintText: 'Sélectionner un employé',
                                  suffixIcon: const Icon(
                                    Icons.menu_outlined,
                                    color: Colors.blue,
                                  ),
                                ),
                                itemBuilder: (context, emp) {
                                  return FieldItem(
                                    child: Text(
                                      emp.lastname ?? "${emp.firstname}",
                                    ),
                                  );
                                },
                                onChanged: (value) {
                                  print("Selected building id: ${value?.id}");
                                },
                              );
                            }
                          },
                        ),
                      ),
                      const SizedBox(height: 15),

                      _buildLabel('Appartement :'),

                      BlocProvider(
                        create: (_) => TacheFormBloc(),
                        child: BlocBuilder<TacheFormBloc, FormBlocState>(
                          builder: (context, state) {

                            if (state is FormBlocLoading) {
                              return const CircularProgressIndicator();
                            } else {
                              return DropdownFieldBlocBuilder<Appartement>(
                                selectFieldBloc: planningFormBloc.appartement,
                                decoration: _inputDecoration(
                                  hintText: 'Sélectionner un appartement',
                                  suffixIcon: const Icon(
                                    Icons.menu_outlined,
                                    color: Colors.blue,
                                  ),
                                ),
                                itemBuilder: (context, emp) {
                                  return FieldItem(child: Text(emp.name ?? ""));
                                },
                                onChanged: (value) {
                                  print("Selected building id: ${value?.id}");
                                },
                              );
                            }
                          },
                        ),
                      ),

                      const SizedBox(height: 15),

                      _buildLabel('Date'),
                      DateTimeFieldBlocBuilder(
                        dateTimeFieldBloc: planningFormBloc.date,
                        format: DateFormat('MMM dd, yyyy'),
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2023),
                        lastDate: DateTime(2030),
                        decoration: _inputDecoration(
                          hintText: 'Sélectionner une date',
                          suffixIcon: const Icon(
                            Icons.calendar_month,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),

                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildLabel('De'),
                                TimeFieldBlocBuilder(
                                  timeFieldBloc: planningFormBloc.heureDebut,
                                  format: DateFormat('hh:mm a'),
                                  decoration: _inputDecoration(
                                    hintText: '09:30 AM',
                                    suffixIcon: const Icon(
                                      Icons.access_time,
                                      color: Colors.grey,
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 15,
                                    ),
                                  ),
                                  initialTime: TimeOfDay(hour: 12, minute: 30),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 15),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildLabel('à'),
                                TimeFieldBlocBuilder(
                                  timeFieldBloc: planningFormBloc.heureFin,
                                  format: DateFormat('hh:mm a'),
                                  decoration: _inputDecoration(
                                    hintText: '12:30 PM',
                                    suffixIcon: const Icon(
                                      Icons.access_time,
                                      color: Colors.grey,
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 15,
                                    ),
                                  ),
                                  initialTime: TimeOfDay(hour: 12, minute: 30),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),


                      _buildLabel('Note'),
                      TextFieldBlocBuilder(
                        textFieldBloc: planningFormBloc.note,
                        maxLines: 5,

                        decoration: _inputDecoration(
                          hintText: 'Ajouter description.',
                          contentPadding: const EdgeInsets.all(12),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),

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
                onPressed: planningFormBloc.submit,
                child: const Text(
                  'Enregistrer',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
