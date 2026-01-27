import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:control_empl/repository/building_repository.dart';

enum AppartementFormStatus { initial, loading, success, failure }

class AppartementFormState {
  final String nomLogement;
  final String description;
  final String idBuilding;
  final AppartementFormStatus status;
  final String? errorMessage;

  AppartementFormState({
    this.nomLogement = '',
    this.description = '',
    this.idBuilding = '',
    this.status = AppartementFormStatus.initial,
    this.errorMessage,
  });

  AppartementFormState copyWith({
    String? nomLogement,
    String? description,
    String? idBuilding,
    AppartementFormStatus? status,
    String? errorMessage,
  }) {
    return AppartementFormState(
      nomLogement: nomLogement ?? this.nomLogement,
      description: description ?? this.description,
      idBuilding: idBuilding ?? this.idBuilding,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class AppartementFormBloc extends Cubit<AppartementFormState> {
  AppartementFormBloc({String? idBuilding})
      : super(AppartementFormState(idBuilding: idBuilding ?? ''));

  void onNomLogementChanged(String value) {
    emit(state.copyWith(nomLogement: value, status: AppartementFormStatus.initial));
  }

  void onDescriptionChanged(String value) {
    emit(state.copyWith(description: value, status: AppartementFormStatus.initial));
  }

  Future<void> submit() async {
    if (state.nomLogement.isEmpty || state.description.isEmpty) {
      emit(state.copyWith(
        status: AppartementFormStatus.failure,
        errorMessage: 'Tous les champs sont requis',
      ));
      return;
    }

    emit(state.copyWith(status: AppartementFormStatus.loading));

    try {
      final res = await BuildingRepository().addRommbyBuilding(
        state.idBuilding,
        name: state.nomLogement,
        description: state.description,
      );

      if (res == true) {
        emit(state.copyWith(status: AppartementFormStatus.success));
      } else {
        emit(state.copyWith(
          status: AppartementFormStatus.failure,
          errorMessage: 'Erreur lors de l\'ajout de l\'appartement',
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        status: AppartementFormStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }
}
