import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:intl/intl.dart';

import '../utils/utils.dart';

class TacheFormBloc extends FormBloc<String, String> {
  final employe = SelectFieldBloc<String, dynamic>(
    validators: [Utils.required],
    items: ['Ameli', 'John', 'Maria'],
  );

  final appartement = SelectFieldBloc<String, dynamic>(
    validators: [Utils.required],
    items: ['109', '100', '50'],
  );

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
  }

  @override
  void onSubmitting() async {
    final dateFormat = DateFormat('yyyy-MM-dd');
    final timeFormat = DateFormat('hh:mm a'); // Format AM/PM

    print('Soumission du planning :');
    print('Employé: ${employe.value}');
    print('Appartement: ${appartement.value}');
    print('Date: ${date.value != null ? dateFormat.format(date.value!) : 'N/A'}');
    print('Note: ${note.value}');

    // Simuler un appel API
    await Future.delayed(const Duration(seconds: 1));

    emitSuccess(
      canSubmitAgain: true,
      successResponse: 'Planning assigné avec succès !',
    );
  }
}