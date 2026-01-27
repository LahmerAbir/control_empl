import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';import '../../repository/building_repository.dart';
import '../../utils/utils.dart';

enum TaskFormStatus { initial, loading, success, failure }

class TaskFormState {
  final String? employeId;
  final String? appartementId;
  final DateTime? date;
  final TimeOfDay heureDebut;
  final TimeOfDay heureFin;
  final String note;
  final TaskFormStatus status;
  final String? errorMessage;

  TaskFormState({
    this.employeId,
    this.appartementId,
    this.date,
    this.heureDebut = const TimeOfDay(hour: 12, minute: 30),
    this.heureFin = const TimeOfDay(hour: 12, minute: 30),
    this.note = '',
    this.status = TaskFormStatus.initial,
    this.errorMessage,
  });

  TaskFormState copyWith({
    String? employeId,
    String? appartementId,
    DateTime? date,
    TimeOfDay? heureDebut,
    TimeOfDay? heureFin,
    String? note,
    TaskFormStatus? status,
    String? errorMessage,
  }) {
    return TaskFormState(
      employeId: employeId ?? this.employeId,
      appartementId: appartementId ?? this.appartementId,
      date: date ?? this.date,
      heureDebut: heureDebut ?? this.heureDebut,
      heureFin: heureFin ?? this.heureFin,
      note: note ?? this.note,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class TaskFormBloc extends Cubit<TaskFormState> {
  TaskFormBloc() : super(TaskFormState());

  void updateEmploye(String? value) => emit(state.copyWith(employeId: value, status: TaskFormStatus.initial));
  void updateAppartement(String? value) => emit(state.copyWith(appartementId: value, status: TaskFormStatus.initial));
  void updateDate(DateTime? value) => emit(state.copyWith(date: value, status: TaskFormStatus.initial));
  void updateHeureDebut(TimeOfDay value) => emit(state.copyWith(heureDebut: value, status: TaskFormStatus.initial));
  void updateHeureFin(TimeOfDay value) => emit(state.copyWith(heureFin: value, status: TaskFormStatus.initial));
  void updateNote(String value) => emit(state.copyWith(note: value, status: TaskFormStatus.initial));

  Future<void> submit() async {
    if (state.employeId == null || state.appartementId == null || state.date == null) {
      emit(state.copyWith(status: TaskFormStatus.failure, errorMessage: 'Veuillez remplir tous les champs obligatoires'));
      return;
    }

    emit(state.copyWith(status: TaskFormStatus.loading));

    try {
      final selectedDate = state.date!;

      final dateDebut = DateTime(
        selectedDate.year, selectedDate.month, selectedDate.day,
        state.heureDebut.hour, state.heureDebut.minute,
      );

      final dateFin = DateTime(
        selectedDate.year, selectedDate.month, selectedDate.day,
        state.heureFin.hour, state.heureFin.minute,
      );

      var res = await BuildingRepository().addTache(
        cleaner_id: state.employeId,
        building_id: Utils.idBuilding ?? "",
        room_id: state.appartementId,
        start_date: dateDebut.toIso8601String(),
        end_date: dateFin.toIso8601String(),
      );

      if (res != null) {
        emit(state.copyWith(status: TaskFormStatus.success));
      } else {
        emit(state.copyWith(status: TaskFormStatus.failure, errorMessage: "Erreur API lors de la création"));
      }
    } catch (e) {
      emit(state.copyWith(status: TaskFormStatus.failure, errorMessage: "Erreur: $e"));
    }
  }
}