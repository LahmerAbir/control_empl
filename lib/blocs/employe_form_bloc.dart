
import 'package:control_empl/model/employe.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';

class EmployeFormBloc extends FormBloc<String, String> {
  final nomComplet = TextFieldBloc(
    validators: [
      FieldBlocValidators.required,
    ],
  );

  final email = TextFieldBloc(
    validators: [
      FieldBlocValidators.required,
      FieldBlocValidators.email,
    ],
  );

  final telephone = TextFieldBloc(
    validators: [
      FieldBlocValidators.required,
    ],
  );

  final motDePasse = TextFieldBloc(
    validators: [
      FieldBlocValidators.required,
    ],
  );

  EmployeFormBloc() {
    addFieldBlocs(
      fieldBlocs: [
        nomComplet,
        email,
        telephone,
        motDePasse,
      ],
    );
  }

  // Logique de soumission
  @override
  void onSubmitting() async {
    print('Soumission des données de l\'employé :');
    print('Nom: ${nomComplet.value}');
    print('Email: ${email.value}');
    print('Téléphone: ${telephone.value}');
    print('Mot de passe: ${motDePasse.value}');

    // Simuler un appel API
    await Future.delayed(const Duration(seconds: 1));

    emitSuccess(
      canSubmitAgain: true,
      successResponse: 'Employé ajouté avec succès !',
    );
  }
}


class ModifierEmployeFormBloc extends FormBloc<String, String> {
  final nomComplet = TextFieldBloc(validators: [FieldBlocValidators.required]);
  final email = TextFieldBloc(validators: [FieldBlocValidators.required, FieldBlocValidators.email]);
  final telephone = TextFieldBloc(validators: [FieldBlocValidators.required]);
  final motDePasse = TextFieldBloc();

  ModifierEmployeFormBloc(Employe employe) {
    nomComplet.updateInitialValue(employe.nom);
    email.updateInitialValue(employe.email);
    telephone.updateInitialValue(employe.telephone);
    motDePasse.updateInitialValue('');

    addFieldBlocs(
      fieldBlocs: [
        nomComplet,
        email,
        telephone,
        motDePasse,
      ],
    );
  }

  @override
  void onSubmitting() async {
    print('Mise à jour de l\'employé:');
    print('Nom (nouveau): ${nomComplet.value}');

    await Future.delayed(const Duration(seconds: 1));

    emitSuccess(
      canSubmitAgain: true,
      successResponse: 'Employé modifié avec succès !',
    );
  }
}