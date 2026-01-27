import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../repository/auth_repository.dart';
import '../utils/utils.dart';
import 'dart:convert';

enum LoginFormStatus { initial, loading, success, failure }

class LoginFormState {
  final String username;
  final String password;
  final bool stayConnect;
  final LoginFormStatus status;
  final String? errorMessage;

  LoginFormState({
    this.username = '',
    this.password = '',
    this.stayConnect = true,
    this.status = LoginFormStatus.initial,
    this.errorMessage,
  });

  LoginFormState copyWith({
    String? username,
    String? password,
    bool? stayConnect,
    LoginFormStatus? status,
    String? errorMessage,
  }) {
    return LoginFormState(
      username: username ?? this.username,
      password: password ?? this.password,
      stayConnect: stayConnect ?? this.stayConnect,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class LoginFormBloc extends Cubit<LoginFormState> {
  final AuthRepository authRepository;

  LoginFormBloc({required this.authRepository}) : super(LoginFormState());

  void onUsernameChanged(String value) {
    emit(state.copyWith(username: value, status: LoginFormStatus.initial));
  }

  void onPasswordChanged(String value) {
    emit(state.copyWith(password: value, status: LoginFormStatus.initial));
  }

  void onStayConnectChanged(bool value) {
    emit(state.copyWith(stayConnect: value, status: LoginFormStatus.initial));
  }

  void initialize(String username, String password) {
    emit(state.copyWith(username: username, password: password));
  }

  Future<void> submit() async {
    if (state.username.isEmpty || state.password.isEmpty) {
      emit(state.copyWith(
        status: LoginFormStatus.failure,
        errorMessage: 'Veuillez remplir tous les champs',
      ));
      return;
    }

    emit(state.copyWith(status: LoginFormStatus.loading));
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setBool('stay_connect', state.stayConnect);

    try {
      var response = await authRepository.login(state.username, state.password);
      if (response != null) {
        Utils.isFirstAccess = null;

        if (state.stayConnect) {
          await authRepository.stayConnect(response);
          await Utils.setMailUser(state.username);
          await Utils.setPasswordUser(state.password);
        } else {
          await Utils.setMailUser(null);
          await Utils.setPasswordUser(null);
        }

        var me = await Utils.getMeFromShared();
        if (me != null) {
          await Utils.isFirstCnx(true);
          Utils.setMe(me);
          Utils.setIdUser(me.id);
          pref.setString("me", jsonEncode(me.toJson()));
        }
        emit(state.copyWith(status: LoginFormStatus.success));
      } else {
        emit(state.copyWith(
          status: LoginFormStatus.failure,
          errorMessage: 'Identifiants incorrects',
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        status: LoginFormStatus.failure,
        errorMessage: 'Une erreur est survenue: $e',
      ));
    }
  }
}
