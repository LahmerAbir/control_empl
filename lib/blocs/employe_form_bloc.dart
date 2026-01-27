import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:control_empl/model/employe.dart';
import 'package:control_empl/repository/employe_repository.dart';

enum EmployeFormStatus { initial, loading, success, failure }

class EmployeFormState {
  final String firstName;
  final String lastName;
  final String email;
  final String telephone;
  final String motDePasse;
  final String? employeId;
  final EmployeFormStatus status;
  final String? responseMessage;

  EmployeFormState({
    this.firstName = '',
    this.lastName = '',
    this.email = '',
    this.telephone = '',
    this.motDePasse = '',
    this.employeId,
    this.status = EmployeFormStatus.initial,
    this.responseMessage,
  });

  EmployeFormState copyWith({
    String? firstName,
    String? lastName,
    String? email,
    String? telephone,
    String? motDePasse,
    String? employeId,
    EmployeFormStatus? status,
    String? responseMessage,
  }) {
    return EmployeFormState(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      telephone: telephone ?? this.telephone,
      motDePasse: motDePasse ?? this.motDePasse,
      employeId: employeId ?? this.employeId,
      status: status ?? this.status,
      responseMessage: responseMessage ?? this.responseMessage,
    );
  }
}

class EmployeFormBloc extends Cubit<EmployeFormState> {
  EmployeFormBloc() : super(EmployeFormState());

  void onFirstNameChanged(String value) => emit(state.copyWith(firstName: value, status: EmployeFormStatus.initial));
  void onLastNameChanged(String value) => emit(state.copyWith(lastName: value, status: EmployeFormStatus.initial));
  void onEmailChanged(String value) => emit(state.copyWith(email: value, status: EmployeFormStatus.initial));
  void onTelephoneChanged(String value) => emit(state.copyWith(telephone: value, status: EmployeFormStatus.initial));
  void onMotDePasseChanged(String value) => emit(state.copyWith(motDePasse: value, status: EmployeFormStatus.initial));

  Future<void> submit() async {
    if (state.firstName.isEmpty || state.lastName.isEmpty || state.email.isEmpty || state.telephone.isEmpty || state.motDePasse.isEmpty) {
      emit(state.copyWith(status: EmployeFormStatus.failure, responseMessage: 'Tous les champs sont requis'));
      return;
    }

    emit(state.copyWith(status: EmployeFormStatus.loading));
    try {
      final res = await EmployeRepository().addUsers(
        email: state.email,
        password: state.motDePasse,
        phone: state.telephone,
        firstName: state.firstName,
        lastName: state.lastName,
        role: "admin",
      );
      if (res == true) {
        emit(state.copyWith(status: EmployeFormStatus.success, responseMessage: 'Employé ajouté avec succès !'));
      } else {
        emit(state.copyWith(status: EmployeFormStatus.failure, responseMessage: 'Erreur lors de l\'ajout de l\'employé'));
      }
    } catch (e) {
      emit(state.copyWith(status: EmployeFormStatus.failure, responseMessage: e.toString()));
    }
  }
}

class ModifierEmployeFormBloc extends Cubit<EmployeFormState> {
  final Employe employe;

  ModifierEmployeFormBloc(this.employe)
      : super(EmployeFormState(
          firstName: employe.firstname ?? '',
          lastName: employe.lastname ?? '',
          email: employe.email ?? '',
          telephone: employe.telephone ?? '',
          employeId: employe.id?.toString(),
        ));

  void onFirstNameChanged(String value) => emit(state.copyWith(firstName: value, status: EmployeFormStatus.initial));
  void onLastNameChanged(String value) => emit(state.copyWith(lastName: value, status: EmployeFormStatus.initial));
  void onEmailChanged(String value) => emit(state.copyWith(email: value, status: EmployeFormStatus.initial));
  void onTelephoneChanged(String value) => emit(state.copyWith(telephone: value, status: EmployeFormStatus.initial));
  void onMotDePasseChanged(String value) => emit(state.copyWith(motDePasse: value, status: EmployeFormStatus.initial));

  Future<void> submit() async {
    if (state.firstName.isEmpty || state.lastName.isEmpty || state.email.isEmpty || state.telephone.isEmpty) {
      emit(state.copyWith(status: EmployeFormStatus.failure, responseMessage: 'Veuillez remplir les champs obligatoires'));
      return;
    }

    emit(state.copyWith(status: EmployeFormStatus.loading));
    try {
      final res = await EmployeRepository().editUsers(
        state.employeId ?? '',
        email: state.email,
        password: state.motDePasse.isNotEmpty ? state.motDePasse : null,
        phone: state.telephone,
        firstName: state.firstName,
        lastName: state.lastName,
        role: "admin",
      );
      if (res == true) {
        emit(state.copyWith(status: EmployeFormStatus.success, responseMessage: 'Employé modifié avec succès !'));
      } else {
        emit(state.copyWith(status: EmployeFormStatus.failure, responseMessage: 'Erreur lors de la modification de l\'employé'));
      }
    } catch (e) {
      emit(state.copyWith(status: EmployeFormStatus.failure, responseMessage: e.toString()));
    }
  }
}
