import 'package:flutter_form_bloc/flutter_form_bloc.dart';

import '../utils/utils.dart';

class AppartementFormBloc extends FormBloc<String, String> {
  final nomLogement = TextFieldBloc(
    validators: [
      Utils.required,
    ],
  );

  final adresse = TextFieldBloc(
    validators: [
      Utils.required,
    ],
  );


  final chambres = TextFieldBloc(
    initialValue: "1", // Valeur par défaut
    validators: [
      FieldBlocValidators.required,
    ],
  );
  final sallesDeBain = TextFieldBloc(
    initialValue: "1", // Valeur par défaut
    validators: [
      FieldBlocValidators.required,
    ],
  );


  AppartementFormBloc() {
    addFieldBlocs(
      fieldBlocs: [
        nomLogement,
        adresse,
        chambres,
        sallesDeBain,
      ],
    );
  }

  @override
  void onSubmitting() async {

    emitSuccess(
      canSubmitAgain: true,
      successResponse: 'Appartement ajouté avec succès !',
    );


  }
}