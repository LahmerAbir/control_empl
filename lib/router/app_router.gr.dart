// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'app_router.dart';

abstract class _$AppRouter extends RootStackRouter {
  // ignore: unused_element
  _$AppRouter({super.navigatorKey});

  @override
  final Map<String, PageFactory> pagesMap = {
    HomeEmployeRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const HomeEmployePage(),
      );
    },
    HomeRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child:  HomePage(),
      );
    },
    LoginRoute.name: (routeData) {
      final args = routeData.argsAs<LoginRouteArgs>(
          orElse: () => const LoginRouteArgs());
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: LoginPage(
          key: args.key,
        ),
      );
    },
    ModifierTacheRoute.name: (routeData) {
      final args = routeData.argsAs<ModifierTacheRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: ModifierTachePage(
          key: args.key,
          tache: args.tache,
        ),
      );
    },
    SplashScreenRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const SplashScreenPage(),
      );
    },
  };
}

/// generated route for
/// [HomeEmployePage]
class HomeEmployeRoute extends PageRouteInfo<void> {
  const HomeEmployeRoute({List<PageRouteInfo>? children})
      : super(
          HomeEmployeRoute.name,
          initialChildren: children,
        );

  static const String name = 'HomeEmployeRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [HomePage]
class HomeRoute extends PageRouteInfo<void> {
  const HomeRoute({List<PageRouteInfo>? children})
      : super(
          HomeRoute.name,
          initialChildren: children,
        );

  static const String name = 'HomeRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [LoginPage]
class LoginRoute extends PageRouteInfo<LoginRouteArgs> {
  LoginRoute({
    Key? key,
    Function? onSuccess,
    bool? padding = true,
    List<PageRouteInfo>? children,
  }) : super(
          LoginRoute.name,
          args: LoginRouteArgs(
            key: key,
            onSuccess: onSuccess,
            padding: padding,
          ),
          initialChildren: children,
        );

  static const String name = 'LoginRoute';

  static const PageInfo<LoginRouteArgs> page = PageInfo<LoginRouteArgs>(name);
}

class LoginRouteArgs {
  const LoginRouteArgs({
    this.key,
    this.onSuccess,
    this.padding = true,
  });

  final Key? key;

  final Function? onSuccess;

  final bool? padding;

  @override
  String toString() {
    return 'LoginRouteArgs{key: $key, onSuccess: $onSuccess, padding: $padding}';
  }
}

/// generated route for
/// [ModifierTachePage]
class ModifierTacheRoute extends PageRouteInfo<ModifierTacheRouteArgs> {
  ModifierTacheRoute({
    Key? key,
    required PlanningCleaner tache,
    List<PageRouteInfo>? children,
  }) : super(
          ModifierTacheRoute.name,
          args: ModifierTacheRouteArgs(
            key: key,
            tache: tache,
          ),
          initialChildren: children,
        );

  static const String name = 'ModifierTacheRoute';

  static const PageInfo<ModifierTacheRouteArgs> page =
      PageInfo<ModifierTacheRouteArgs>(name);
}

class ModifierTacheRouteArgs {
  const ModifierTacheRouteArgs({
    this.key,
    required this.tache,
  });

  final Key? key;

  final PlanningCleaner tache;

  @override
  String toString() {
    return 'ModifierTacheRouteArgs{key: $key, tache: $tache}';
  }
}

/// generated route for
/// [SplashScreenPage]
class SplashScreenRoute extends PageRouteInfo<void> {
  const SplashScreenRoute({List<PageRouteInfo>? children})
      : super(
          SplashScreenRoute.name,
          initialChildren: children,
        );

  static const String name = 'SplashScreenRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}
