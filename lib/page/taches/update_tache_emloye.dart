// Placeholder pour simuler une photo
import 'dart:io';

import 'package:control_empl/resources/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../model/tache.dart';
import 'package:auto_route/auto_route.dart';

const String _photoPlaceholder = 'https://placehold.co/100x100.png?text=NEW%20PHOTO';
@RoutePage()
class ModifierTachePage extends StatefulWidget {
  final TachePlanning tache;

  const ModifierTachePage({super.key, required this.tache});

  @override
  State<ModifierTachePage> createState() => _ModifierTacheScreenState();
}

class _ModifierTacheScreenState extends State<ModifierTachePage> {
  late TachePlanning _currentTache;
  final ImagePicker _picker = ImagePicker();
  @override
  void initState() {
    super.initState();
    _currentTache = widget.tache;
  }

 /* void _marquerTermine() {
    setState(() {
    //  _currentTache = _currentTache.copyWith(statut: 'Terminée');
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Statut changé à "Terminée" et sauvegardé.')),
    );
  }

  void _showImageSourceDialog(bool isAvant) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Prendre une photo (Caméra)'),
                onTap: () {
                  Navigator.pop(context); // Ferme le dialogue
                  _pickImage(ImageSource.camera, isAvant);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Sélectionner depuis la Galerie'),
                onTap: () {
                  Navigator.pop(context); // Ferme le dialogue
                  _pickImage(ImageSource.gallery, isAvant);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickImage(ImageSource source, bool isAvant) async {
    final bool granted = await _requestPermission(source);

    if (!granted) {
      return;
    }
    final XFile? pickedFile = await _picker.pickImage(
      source: source,
      imageQuality: 70,
    );

    if (pickedFile != null) {

      final String imagePath = pickedFile.path;

      setState(() {
        if (isAvant) {
          _currentTache = _currentTache.copyWith(
            photosAvant: [..._currentTache.photosAvant, imagePath],
          );
        } else {
          _currentTache = _currentTache.copyWith(
            photosApres: [..._currentTache.photosApres, imagePath],
          );
        }
      });
    }
  }

  void _addPhoto(bool isAvant) {
    _showImageSourceDialog(isAvant);
  }
  Future<bool> _requestPermission(ImageSource source) async {
    PermissionStatus status;

    if (source == ImageSource.camera) {
      status = await Permission.camera.request();
    } else {
      status = await Permission.photos.request();

      if (!status.isGranted && (Theme.of(context).platform == TargetPlatform.android)) {
        status = await Permission.storage.request();
      }
    }

    if (status.isGranted) {
      return true;
    } else if (status.isPermanentlyDenied) {
      openAppSettings();
      return false;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Permission ${source == ImageSource.camera ? 'Caméra' : 'Galerie'} refusée.')),
      );
      return false;
    }
  }

  Widget _buildPhotoSection(String title, List<String> photoUrls, bool isAvant) {
    return SizedBox(
      height: 140,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 120,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                GestureDetector(
                  onTap: () => _addPhoto(isAvant),
                  child: Container(
                    width: 100,
                    height: 100,
                    margin: const EdgeInsets.only(right: 10),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50, // Fond bleu clair
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.blue.shade200, width: 2),
                    ),
                    child: Column( // Contenu : Icône et Texte
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add_a_photo_outlined, color: Colors.blue.shade700, size: 30),
                        const Text('Ajouter', style: TextStyle(color: Colors.blue, fontSize: 12)),
                      ],
                    ),
                  ),
                ),
                ...photoUrls.map((url) => SizedBox(
                  width: 100,
                  height: 100,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: SizedBox(
                      width: 100,
                      height: 100,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: url.startsWith('http')
                            ? Image.network(
                          url,
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        )
                            : Image.file(
                          File(url),
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Container(
                            width: 100, height: 100, color: Colors.grey.shade300,
                            child: const Icon(Icons.broken_image, color: Colors.red),
                          ),
                        ),
                      ),
                    ),
                  ),
                )),
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildTaskDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDetailRow('Appartement N°', _currentTache.numeroAppartement, Icons.apartment),
        _buildDetailRow('Date', _currentTache.date, Icons.calendar_today_outlined),
        _buildDetailRow('Heure', _currentTache.heure, Icons.access_time),
        _buildDetailRow('Statut Actuel', _currentTache.statut, Icons.info_outline),
        const SizedBox(height: 10),
        const Text('Description:', style: TextStyle(fontWeight: FontWeight.bold)),
        Text(_currentTache.description),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey.shade600),
          const SizedBox(width: 8),
          Text('$label : ', style: const TextStyle(fontWeight: FontWeight.w600)),
          Text(value),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isTermine = _currentTache.statut == 'Terminée';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Text(
            'Tâche d\' ${_currentTache.numeroAppartement}',
            style: const TextStyle(fontWeight: FontWeight.bold , fontSize: 16),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTaskDetails(),
            const Divider(height: 30),

            _buildPhotoSection(
              'Photos Avant',
              _currentTache.photosAvant,
              true,
            ),

            _buildPhotoSection(
              'Photos Après',
              _currentTache.photosApres,
              false,
            ),
            const SizedBox(height: 40),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: isTermine ? null : _marquerTermine,
                style: ElevatedButton.styleFrom(
                  backgroundColor: isTermine ? Colors.grey : DeliveryColors.blue,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  elevation: 0,
                ),
                child: Text(
                  isTermine ? 'Tâche Terminée' : 'Marquer comme Terminé',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }*/
  @override
  Widget build(BuildContext context)
  {
    return Container();
  }
}