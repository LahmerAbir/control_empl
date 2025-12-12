import 'package:auto_route/auto_route.dart';

import 'package:flutter/material.dart';

import '../model/tache.dart';
import '../page/home/home.dart';
import '../page/home/home_employe.dart';
import '../page/login.dart';
import '../page/splash_screen_view.dart';
import '../page/taches/update_tache_emloye.dart';



part 'app_router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Page,Route')
class AppRouter extends _$AppRouter {
  factory AppRouter() => AppRouter.instance;

  @override
  List<AutoRoute> get routes => [
    AutoRoute(page: SplashScreenRoute.page, initial: true),
    AutoRoute(page: LoginRoute.page, path: '/login'),
    AutoRoute(page: HomeRoute.page),
    AutoRoute(page: HomeEmployeRoute.page),
    AutoRoute(page: ModifierTacheRoute.page),

  ];

  AppRouter._()
    : super(
        navigatorKey: GlobalKey<NavigatorState>(),
        // anonymousGuard: AnonymousGuard(),
      ) {}

  static final instance = AppRouter._();

  final Map<String, String> deepPaths = {};
}
