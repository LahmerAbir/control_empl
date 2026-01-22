import 'dart:convert';
import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../model/planning_cleaner.dart';
import '../../repository/building_repository.dart';
import '../../ui/common/loading.dart';

@RoutePage()
class ModifierTachePage extends StatefulWidget {
  final PlanningCleaner tache;

  const ModifierTachePage({
    super.key,
    required this.tache,
  });

  @override
  State<ModifierTachePage> createState() => _ModifierTachePageState();
}

class _ModifierTachePageState extends State<ModifierTachePage> {
  late PlanningCleaner _currentTache;

  final ImagePicker _picker = ImagePicker();

  /// 📸 Photos locales (NON envoyées dans update tâche)
  final List<File> _photosAvant = [];
  final List<File> _photosApres = [];
  final TextEditingController _noteController = TextEditingController();
  bool _noteError = false;
  bool isLoading = true;
  String status = "Encours";
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        var statusRes =
            await BuildingRepository().getStatusRoom(
              _currentTache.roomId ?? "") ?? "" ;
        setState(() {
          isLoading = false;
         status = mapStatusToLabel(statusRes);
        });
      } catch (e) {
        print("exception $e");
        setState(() {
          isLoading = false;
        });
      }
    });
    _currentTache = widget.tache;
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
  Future<void> _marquerTermine() async {
    if (_noteController.text.trim().isEmpty) {
      setState(() {
        _noteError = true;
      });
      return;
    }

    setState(() {
      _noteError = false;
    });
    final noteId = await BuildingRepository().addnoteRoom(_currentTache.roomId ?? "", _noteController.text.trim());

    if (noteId == null) return;
    final bytes = await _photosAvant.first.readAsBytes();
    final String base64Image = base64Encode(bytes);
    final String fileName = _photosAvant.first.path.split('/').last;
      await BuildingRepository().addImagesRoom(noteId , base64Image ,fileName);
    final bytes2 = await _photosApres.first.readAsBytes();
    final String base64Image2 = base64Encode(bytes2);
    final String fileName2 = _photosApres.first.path.split('/').last;
    await BuildingRepository().addImagesRoom(noteId , base64Image2 ,fileName2);
    final updated = _currentTache.copyWith(status: 'Terminée');
    setState(() => _currentTache = updated);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Tâche terminée avec note et photos')),
    );
  }

  void _showImageSourceDialog(bool isAvant) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Prendre une photo'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera, isAvant);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Depuis la galerie'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery, isAvant);
                },
              ),
            ],
          ),
        );
      },
    );
  }
  Widget _buildNoteField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Note *',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _noteController,
          maxLines: 4,
          decoration: InputDecoration(
            hintText: 'Écrire une note ...',
            errorText: _noteError ? 'La note est obligatoire' : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ],
    );
  }
  Future<void> _pickImage(ImageSource source, bool isAvant) async {
    final granted = await _requestPermission(source);
    if (!granted) return;

    final XFile? pickedFile = await _picker.pickImage(
      source: source,
      imageQuality: 70,
    );

    if (pickedFile == null) return;

    setState(() {
      if (isAvant) {
        _photosAvant.add(File(pickedFile.path));
      } else {
        _photosApres.add(File(pickedFile.path));
      }
    });
  }

  Future<bool> _requestPermission(ImageSource source) async {
    PermissionStatus status;

    if (source == ImageSource.camera) {
      status = await Permission.camera.request();
    } else {
      status = await Permission.photos.request();
      if (!status.isGranted && Platform.isAndroid) {
        status = await Permission.storage.request();
      }
    }

    if (status.isGranted) return true;

    if (status.isPermanentlyDenied) {
      openAppSettings();
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Permission ${source == ImageSource.camera ? 'caméra' : 'galerie'} refusée',
        ),
      ),
    );
    return false;
  }


  Widget _buildPhotoSection(
      String title,
      List<File> photos,
      bool isAvant,
      ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        SizedBox(
          height: 110,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              GestureDetector(
                onTap: () => _showImageSourceDialog(isAvant),
                child: Container(
                  width: 100,
                  margin: const EdgeInsets.only(right: 10),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.blue.shade200),
                  ),
                  child: const Icon(Icons.add_a_photo_outlined, size: 30),
                ),
              ),
              ...photos.map(
                    (file) => Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.file(
                      file,
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }


  Widget _buildTaskDetails() {
    final dtStart = DateTime.parse(_currentTache.startDate  ??"");
    final dtEnd = DateTime.parse(_currentTache.endDate ?? "");

    final dateStart =
        "${dtStart.year}-${dtStart.month.toString().padLeft(2, '0')}-${dtStart.day.toString().padLeft(2, '0')}";
    final dateEnd =
        "${dtEnd.year}-${dtEnd.month.toString().padLeft(2, '0')}-${dtEnd.day.toString().padLeft(2, '0')}";
    final timeStart =
        "${dtStart.hour.toString().padLeft(2, '0')}:${dtStart.minute.toString().padLeft(2, '0')}";
    final timeEnd =
        "${dtEnd.hour.toString().padLeft(2, '0')}:${dtEnd.minute.toString().padLeft(2, '0')}";

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDetailRow(
          "",
          _currentTache.building?.name ?? "",
          Icons.apartment,
        ),
        _buildDetailRow(
          'Date Début',
          "$dateStart - $timeStart",
          Icons.calendar_today,
        ),
        _buildDetailRow(
          'Date Fin',
          "$dateEnd - $timeEnd",
          Icons.calendar_today,
        ),
        _buildDetailRow(
          'Statut',
          status,
          Icons.info_outline,
        ),
        const SizedBox(height: 10),
      //  Text(_currentTache.description),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.grey),
          const SizedBox(width: 8),
          Text('$label ', style: const TextStyle(fontWeight: FontWeight.w600)),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    final isTermine = _currentTache.status == 'Terminée';

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Tâche - ${_currentTache.room?.name ?? ""}',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: isLoading ?   Loader() :  SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTaskDetails(),
            const Divider(height: 30),
            _buildNoteField(),
            const SizedBox(height: 20),
            _buildPhotoSection('Photos Avant', _photosAvant, true),
            const SizedBox(height: 20),
            _buildPhotoSection('Photos Après', _photosApres, false),

            const SizedBox(height: 40),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: isTermine ? null : _marquerTermine,
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                  isTermine ? Colors.grey : Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  isTermine ? 'Tâche Terminée' : 'Marquer comme Terminée',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
