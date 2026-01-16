import 'package:control_empl/repository/building_repository.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';

import '../utils/utils.dart';

class AppartementFormBloc extends FormBloc<String, String> {
  final nomLogement = TextFieldBloc(validators: [Utils.required]);

  final description = TextFieldBloc(validators: [Utils.required]);


  final TextFieldBloc<String> buildingIdField =
  TextFieldBloc(name: 'building_id');
  AppartementFormBloc({ String? buildingId,}) {
    buildingIdField.updateValue(buildingId ?? "");
    addFieldBlocs(fieldBlocs: [nomLogement, description , buildingIdField]);
  }

  @override
  void onSubmitting() async {
    emitLoading();

    try {
      var res = await BuildingRepository().addRommbyBuilding(
       Utils.idBuilding ?? "",

        name: nomLogement.value,
        description: description.value,
      );
      if (res == true) {
        emitSuccess(
          canSubmitAgain: true,
          successResponse: 'Appartement ajouté avec succès !',
        );
      } else {
        emitFailure();
      }
    } catch (e) {
      emitFailure();
    }
  }
}
