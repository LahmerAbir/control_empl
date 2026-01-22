import 'package:control_empl/model/appartement.dart';
import 'package:control_empl/model/employe.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:intl/intl.dart';

import '../repository/building_repository.dart';
import '../repository/employe_repository.dart';
import '../utils/utils.dart';

class TacheFormBloc extends FormBloc<String, String> {
  final employe = SelectFieldBloc<Employe, dynamic>(  validators: [FieldBlocValidators.required],

  );

  final appartement = SelectFieldBloc<Appartement, dynamic>(
      validators: [FieldBlocValidators.required]  );

  final date = InputFieldBloc<DateTime?, dynamic>(
    validators: [(value) => value == null ? 'Veuillez sélectionner une date.' : null],
    initialValue: null,
  );

  final heureDebut = InputFieldBloc<TimeOfDay?, dynamic>(
    validators: [(value) => value == null ? 'Veuillez sélectionner une heure de début.' : null],
    initialValue: TimeOfDay(hour: 12, minute: 30),
  );

  final heureFin = InputFieldBloc<TimeOfDay?, dynamic>(
    validators: [(value) => value == null ? 'Veuillez sélectionner une heure de fin.' : null],
    initialValue: TimeOfDay(hour: 12, minute: 30),
  );

  final note = TextFieldBloc();

  TacheFormBloc() {
    addFieldBlocs(
      fieldBlocs: [
        employe,
        appartement,
        date,
        heureDebut,
        heureFin,
        note,
      ],
    );
    _loadUsers();
    _loadApp();

  }
  Future<void> _loadUsers() async {
    try {
      emitLoading();
      final list = await  await EmployeRepository().getUsers();

      employe.updateItems(list ?? []);
    } catch (e) {
      emitFailure(failureResponse: "Erreur chargement utilisateur");
    }
  }
  Future<void> _loadApp() async {
    try {
      final list =    await BuildingRepository().getRommByBuilding(
        Utils.idBuilding ?? "",
      ) ??
          [];

      appartement.updateItems(list);
      emitLoaded();
    } catch (e) {
      emitFailure(failureResponse: "Erreur chargement utilisateur");
    }
  }
  @override
  void onSubmitting() async {
    try {
      print("submiiitttiing 1");

      final employeId = employe.value?.id;
      final appartementId = appartement.value?.id;

      final selectedDate = date.value!;

      final startTime = heureDebut.value!;
      final endTime = heureFin.value!;

      final dateDebut = DateTime(
        selectedDate.year,
        selectedDate.month,
        selectedDate.day,
        startTime.hour,
        startTime.minute,
      );

      final dateFin = DateTime(
        selectedDate.year,
        selectedDate.month,
        selectedDate.day,
        endTime.hour,
        endTime.minute,
      );

      print("submiiitttiing 2");
      emitLoading();

     var res =  await BuildingRepository().addTache( cleaner_id : employeId,
         building_id: Utils.idBuilding ?? "",
         room_id: appartementId,
          start_date: dateDebut.toString(),

    end_date: dateFin.toString(),
   );

     if(res != null)
      emitSuccess(
        canSubmitAgain: true,
        successResponse: 'Planning assigné avec succès !',
      );
     else
       emitFailure(failureResponse:  "Erreur lors de la création api");


    } catch (e) {

      print("eexeceptionnn $e");
      emitFailure(failureResponse:  "Erreur lors de la création");
    }


  }
}