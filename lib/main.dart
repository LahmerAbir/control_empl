import 'dart:async';

import 'package:control_empl/blocs/appartement_form_bloc.dart';
import 'package:control_empl/blocs/employe_form_bloc.dart';
import 'package:control_empl/blocs/login_form_bloc.dart';
import 'package:control_empl/blocs/tache_form_bloc.dart';
import 'package:control_empl/repository/auth_repository.dart';
import 'package:control_empl/router/app_router.dart';
import 'package:control_empl/router/app_router_observer.dart';
import 'package:control_empl/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'main.data.dart';

final router = AppRouter().delegate(
  navigatorObservers: () => [AppRouterObserver()],
);
Future<void> main() async {
  tz.initializeTimeZones();

  WidgetsFlutterBinding.ensureInitialized();
  await runZonedGuarded(() async {

    WidgetsFlutterBinding.ensureInitialized();
    Bloc.observer = AppBlocObserver();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    final authRepository = AuthRepository();
    await Utils.getToken();
    await initializeDateFormatting('fr', null);

    runApp(ProviderScope(
      overrides: [
        configureRepositoryLocalStorage(),
      ],
      child:
      CleanApp(
          authRepository: authRepository
      ),

    ));
  }, (error, st) => print(error));
}

class CleanApp extends ConsumerWidget {
  CleanApp(
      {super.key , required this.authRepository,});

  AuthRepository authRepository = AuthRepository();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MultiRepositoryProvider(
        providers: [
          RepositoryProvider.value(value: authRepository),
        ],
        child: MultiBlocProvider(
            providers: [
              BlocProvider<LoginFormBloc>(
                create: (BuildContext context) =>
                    LoginFormBloc(authRepository: authRepository)),
              BlocProvider<AppartementFormBloc>(
                  create: (BuildContext context) =>
                      AppartementFormBloc()),

            ],
            child: ref.watch(repositoryInitializerProvider).when(
                error: (error, _) => Container(),
                loading: () => Container(),
                data: (_) {
                  return MaterialApp.router(
                    routeInformationParser: AppRouter().defaultRouteParser(),
                    routerDelegate: router,
                    debugShowCheckedModeBanner: false,
                    theme: ThemeData(
                      brightness: Brightness.light,
                      dividerColor: Colors.white,
                      /* textTheme: GoogleFonts.montserratTextTheme(
                       Theme.of(context).textTheme,
                             ),*/
                      // add tabBarTheme
                    ),
                    builder: (context, child) {
                      return Scaffold(
                        backgroundColor: Colors.white,
                        body: SafeArea(
                          child: child!,
                        ),
                      );
                    },
                  );
                })));
  }
}

/// Custom [BlocObserver] that observes all bloc and cubit state changes.
class AppBlocObserver extends BlocObserver {
  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    if (bloc is Cubit) print(change);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    print(transition);
  }
}
