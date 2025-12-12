import 'package:control_empl/blocs/tache_form_bloc.dart';
import 'package:control_empl/model/tache.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:intl/intl.dart';

class PlanningScreen extends StatefulWidget {
  const PlanningScreen({super.key});

  @override
  State<PlanningScreen> createState() => _PlanningScreenState();
}

class _PlanningScreenState extends State<PlanningScreen> {
  final List<TachePlanning> _allTaches = [

  ];

  List<TachePlanning> _filteredTaches = [];
  final TextEditingController _searchController = TextEditingController();

  DateTime? _selectedDate;

  final DateFormat _dateFormat = DateFormat('MMM dd, yyyy', 'en');

  @override
  void initState() {
    super.initState();
    _filteredTaches = _allTaches;
    _searchController.addListener(_applyFilters);
  }

  @override
  void dispose() {
    _searchController.removeListener(_applyFilters);
    _searchController.dispose();
    super.dispose();
  }

  void _applyFilters() {
    final query = _searchController.text.toLowerCase();
    final String? dateQuery = _selectedDate != null
        ? _dateFormat.format(_selectedDate!)
        : null;

    setState(() {
      _filteredTaches = _allTaches.where((tache) {
        final matchesSearch =
            query.isEmpty ||
            tache.room!.name!.toLowerCase().contains(query) ||
            tache.cleanerId!.toLowerCase().contains(query);

        final matchesDate = dateQuery == null || tache.startDate == dateQuery;

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

      body: SizedBox(
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
                    prefixIcon: const Icon(Icons.search, color: Colors.grey),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.grey.shade200,
                    contentPadding: const EdgeInsets.symmetric(vertical: 10.0),
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
                            icon: const Icon(Icons.close, color: Colors.grey),
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
      ),
    );
  }
  void showAjoutPlanningDialog(BuildContext context) {
    showDialog(
      context: context,
      useSafeArea: true,
      builder: (context) {
        return BlocProvider(
          create: (context) => TacheFormBloc(),
          child: const AjoutPlanningDialog(),
        );
      },
    );
  }

}

class PlanningCard extends StatelessWidget {
  final TachePlanning tache;

  const PlanningCard({super.key, required this.tache});

  Color _getStatusColor(String statut) {
    switch (statut) {
      case 'En Attend':
        return Colors.green.shade600;
      case 'Terminé':
        return Colors.black;
      case 'En cours':
        return Colors.blue.shade600;
      case 'Retard':
        return Colors.red.shade600;
      default:
        return Colors.grey.shade600;
    }
  }

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
                  Row(

                    children: [
                      Text(
                        'Appartement N : ${tache.room!.name}',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Badge de Statut
                     /* Text(
                        ' ${tache.statut}',
                        style: TextStyle(
                          color: statusColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),*/
                    ],
                  ),
                  const SizedBox(height: 4),

                  Row(
                    children: [
                      Text(
                        '${tache.startDate}',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(width: 15),
                      Text(
                        '${tache.startDate}',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),

                  Text(
                    'Effectué à : ${tache.cleanerId}',
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

class TacheDetailDialog extends StatelessWidget {
  final TachePlanning tache;

  const TacheDetailDialog({super.key, required this.tache});

  // Widget utilitaire pour afficher une ligne d'information
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

  Widget _buildPhotoGallery(String title, List<String> photoUrls) {
    if (photoUrls.isEmpty) {
      return Container();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: photoUrls.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.network(
                    photoUrls[index], // Utilisation des URLs de photos
                    width: 120,
                    height: 120,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        width: 120,
                        height: 120,
                        color: Colors.blueAccent.shade200,
                        child: const Center(
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: 120,
                      height: 120,
                      color: Colors.red.shade100,
                      child: const Center(
                        child: Icon(Icons.broken_image, color: Colors.red),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(
        horizontal: 20.0,
        vertical: 24.0,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Container(
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
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const Divider(height: 20),

            // --- Corps (Défilement) ---
            Flexible(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Infos Tâche
                    _buildInfoRow(
                      'Employé',
                      tache.cleanerId ?? "",
                      Icons.person_outline,
                    ),
                    _buildInfoRow(
                      'Date',
                      tache.startDate ?? "",
                      Icons.calendar_today_outlined,
                    ),
                    _buildInfoRow('Heure', tache.startDate!, Icons.access_time),
                  /*  _buildInfoRow(
                      'Statut',
                      tache.statut,
                      Icons.check_circle_outline,
                    ),*/
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
                   /* Text(
                      tache.description,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade700,
                      ),
                    ),*/
                    const SizedBox(height: 20),

                    // Photos Avant
                    /*_buildPhotoGallery(
                      'Photos Avant Nettoyage',
                      tache.photosAvant,
                    ),*/

                    // Photos Après
                 /*   _buildPhotoGallery(
                      'Photos Après Nettoyage',
                      tache.photosApres,
                    ),*/
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
class AjoutPlanningDialog extends StatelessWidget {
  const AjoutPlanningDialog({super.key});
  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, top: 4.0),
      child: Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),
    );
  }

  InputDecoration _inputDecoration({required String hintText, Widget? suffixIcon, EdgeInsetsGeometry? contentPadding}) {
    return InputDecoration(
      hintText: hintText,
      suffixIcon: suffixIcon,
      contentPadding: contentPadding ?? const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
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
  @override
  Widget build(BuildContext context) {
    final planningFormBloc = context.read<TacheFormBloc>();

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
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
                  style: TextStyle(
                    fontSize: 20,
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

            Flexible(
              child: FormBlocListener<TacheFormBloc, String, String>(
                onSubmitting: (context, state) {
                  ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(const SnackBar(content: Text('Assignation en cours...')));
                },
                onSuccess: (context, state) {
                  ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(SnackBar(content: Text(state.successResponse!)));
                  Navigator.of(context).pop(); // Fermer le dialogue
                },
                onFailure: (context, state) {
                  ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(SnackBar(content: Text(state.failureResponse!)));
                },
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLabel('Employé'),
                      DropdownFieldBlocBuilder<String>(
                        selectFieldBloc: planningFormBloc.employe,

                        decoration: _inputDecoration(hintText: 'Sélectionner un employé',suffixIcon: const Icon(Icons.menu_outlined, color: Colors.blue),),
                        itemBuilder: (context, value) => FieldItem(child: Text(value)),
                      ),
                      const SizedBox(height: 15),

                      _buildLabel('Appartement N :'),
                      DropdownFieldBlocBuilder<String>(
                        selectFieldBloc: planningFormBloc.appartement,
                        decoration: _inputDecoration(hintText: 'Sélectionner un appartement'),
                        itemBuilder: (context, value) => FieldItem(child: Text(value)),
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
                          suffixIcon: const Icon(Icons.calendar_month, color: Colors.grey),
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
                                  decoration: _inputDecoration(hintText: '09:30 AM',
                                      suffixIcon: const Icon(Icons.access_time, color: Colors.grey)
                                      , contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 15)),
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
                                  decoration:
                                  _inputDecoration(hintText: '12:30 PM', suffixIcon: const Icon(Icons.access_time, color: Colors.grey), contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 15)), initialTime: TimeOfDay(hour: 12, minute: 30),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),

                      // --- Note/Description ---
                      _buildLabel('Note'),
                      TextFieldBlocBuilder(
                        textFieldBloc: planningFormBloc.note,
                        maxLines: 5,
                        decoration: _inputDecoration(hintText: 'Ajouter description.', contentPadding: const EdgeInsets.all(12)),
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
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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