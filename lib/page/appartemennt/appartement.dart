import 'package:control_empl/blocs/appartement_form_bloc.dart';
import 'package:control_empl/model/appartement.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';

import '../../repository/building_repository.dart';
import '../../ui/common/text_control.dart';

class LogementsScreen extends StatefulWidget {
  const LogementsScreen({super.key , required this.selectedBuildingId});
  final String selectedBuildingId ;

  @override
  State<LogementsScreen> createState() => _LogementsScreenState();
}

class _LogementsScreenState extends State<LogementsScreen> {

  final List<Appartement> logements = [
    Appartement(
      name: 'Appartement 101',
      buildingId: '123 Rue Principale, App. 101',
      roomType: "2",
    ),
    Appartement(
      name: 'Appartement 101',
      buildingId: '123 Rue Principale, App. 101',
      roomType: "2",
    ),
    Appartement(
      name: 'Appartement 101',
      buildingId: '123 Rue Principale, App. 101',
      roomType: "2",
    ),
  ];
  final List<String> _statusFilters = ['Tous', 'Propre', 'En cours', 'À nettoyer'];
  String _selectedFilter = 'Tous';
  List<Appartement> get _filteredLogements {
 //   if (_selectedFilter == 'Tous') {
      return logements;
   // } else {
    //  return logements
     //     .where((logement) => logement.statut == _selectedFilter)
     //     .toList();
   // }
  }

  void _onFilterSelected(String filter) {
    setState(() {
      _selectedFilter = filter;
    });
  }
  List<Appartement> appartemnts = [];
  bool isLoading = true ;

  @override
  initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      appartemnts =  await BuildingRepository().getRommByBuilding(widget.selectedBuildingId) ?? [];
      setState(() {
        isLoading = false ;
      });
    }
    );

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
              'Appartement',
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
                  showLogementDialog(context);
                },
              ),
            ),
          ),
        ],
        // Le titre doit être à gauche, pas centré
        centerTitle: false,
        backgroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 80, // Augmenter la hauteur pour accommoder le sous-titre
      ),

      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _statusFilters.map((filter) {
                  final isSelected = _selectedFilter == filter;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: ChoiceChip(
                      label: Text(filter),
                      selected: isSelected,
                      onSelected: (selected) {
                        if (selected) {
                          _onFilterSelected(filter);
                        }
                      },
                      // Styles pour les filtres sélectionnés et non sélectionnés
                      selectedColor: Colors.blue.shade100,
                      backgroundColor: Colors.grey.shade100,
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.blue.shade800 : Colors.grey.shade700,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(
                          color: isSelected ? Colors.blue.shade800 : Colors.transparent,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height *0.58,

            child: _filteredLogements.isEmpty ? Center(child: Text("Liste vide")) :
            ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: _filteredLogements.length,
              itemBuilder: (context, index) {

                final logement = _filteredLogements[index];
                // Utilisation du widget de carte pour chaque logement
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  // Espacement entre les cartes
                  child: LogementCard(logement: logement),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void showLogementDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return BlocProvider(
          create: (context) => AppartementFormBloc(),
          child: LogementDialog(context),
        );
      },
    );
  }

  Widget LogementDialog(BuildContext context) {
    final logementFormBloc = context.read<AppartementFormBloc>();

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(
        horizontal: 20.0,
        vertical: 24.0,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: SingleChildScrollView(
        child: SizedBox(height: MediaQuery.of(context).size.height *0.65,
          child :  Container(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Ajouter un Appartement',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 15),
        
              FormBlocListener<AppartementFormBloc, String, String>(
                onSubmitting: (context, state) {
                  ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(
                      const SnackBar(content: Text('Soumission en cours...')),
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
                      _buildLabel('Nom du Appartement'),
                      TextFormControl(
                        textFieldBloc: logementFormBloc.nomLogement,
                      ),
                      const SizedBox(height: 10),
                      _buildLabel('Adresse'),
                      TextFormControl(textFieldBloc: logementFormBloc.adresse),
                      const SizedBox(height: 10),
        
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildLabel("Chambres"),
                                TextFormControl(
                                  textFieldBloc: logementFormBloc.chambres,
                                ),
                              ],
                            ),
                          ),
        
                          const SizedBox(width: 15),
                          // Salles de bain
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildLabel("Salle de bain"),
                                TextFormControl(
                                  textFieldBloc: logementFormBloc.sallesDeBain,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),
        
              SizedBox(
                width: double.infinity,
                height: 40,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    // Couleur noire comme dans l'image
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: logementFormBloc.submit,
                  // Déclenche la soumission du FormBloc
                  child: const Text(
                    'Ajouter',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      ));
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

class LogementCard extends StatelessWidget {
  final Appartement logement;

  const LogementCard({super.key, required this.logement});

  // Détermine le style (couleur et fond) du badge de statut
  Map<String, dynamic> _getStatusStyle(String statut) {
    switch (statut) {
      case 'Propre':
        return {'couleurTexte': Colors.white, 'couleurFond': Colors.black};
      case 'En cours':
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
   // final statusStyle = _getStatusStyle(logement.statut);

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Ligne du titre et du statut
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  logement.name ?? "",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                // Badge de statut
             /*   Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                   // color: statusStyle['couleurFond'],
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    logement.statut,
                    style: TextStyle(
                      color: statusStyle['couleurTexte'],
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),*/
              ],
            ),

            const SizedBox(height: 12),

          /*  _buildIconText(
              Icons.location_on_outlined,
              logement.batiment,
              Colors.grey.shade600,
            ),*/

            const SizedBox(height: 8),

            Row(
              children: [
                _buildIconText(
                  Icons.king_bed_outlined,
                  '${logement.roomType} ch.',
                  Colors.grey.shade600,
                ),
              ],
            ),
            const Divider(height: 24, thickness: 0.5),
          ],
        ),
      ),
    );
  }

  Widget _buildIconText(IconData icon, String text, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 4),
        Text(text, style: TextStyle(color: color, fontSize: 14)),
      ],
    );
  }
}
