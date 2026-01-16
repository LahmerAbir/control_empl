
import 'package:control_empl/model/employe.dart';
import 'package:control_empl/repository/employe_repository.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';

class EmployeFormBloc extends FormBloc<String, String> {
  final firstName = TextFieldBloc(
    validators: [
      FieldBlocValidators.required,
    ],
  );
  final lastName = TextFieldBloc(
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
        firstName,
        lastName,
        email,
        telephone,
        motDePasse,
      ],
    );
  }

  // Logique de soumission
  @override
  void onSubmitting() async {

    emitLoading();
    var res = await EmployeRepository().addUsers(email: email.value, password: motDePasse.value, phone : telephone.value, firstName: firstName.value, lastName: lastName.value, role: "admin");
    if(res == true)
    emitSuccess(
      canSubmitAgain: true,
      successResponse: 'Employé ajouté avec succès !',
    );
    else
      emitFailure(
        failureResponse: 'Erreur lors de l\'ajout de l\'employé',
      );

  }
}


class ModifierEmployeFormBloc extends FormBloc<String, String> {
  final lastName = TextFieldBloc(validators: [FieldBlocValidators.required]);
  final firstName = TextFieldBloc(validators: [FieldBlocValidators.required]);
  final email = TextFieldBloc(validators: [FieldBlocValidators.required, FieldBlocValidators.email]);
  final telephone = TextFieldBloc(validators: [FieldBlocValidators.required]);
  final motDePasse = TextFieldBloc();

  ModifierEmployeFormBloc(Employe employe) {
    lastName.updateInitialValue(employe.lastname ?? "");
    firstName.updateInitialValue(employe.firstname ?? "");
    email.updateInitialValue(employe.email ?? "");
    telephone.updateInitialValue(employe.telephone ?? "");
    motDePasse.updateInitialValue('');

    addFieldBlocs(
      fieldBlocs: [
        lastName,
        firstName,
        email,
        telephone,
        motDePasse,
      ],
    );
  }

  @override
  void onSubmitting() async {
    emitLoading();
    emitSubmitting();


  }
}