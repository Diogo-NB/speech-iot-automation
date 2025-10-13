import 'package:auto_route/auto_route.dart';

import 'app_router.gr.dart';
export 'app_router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Screen|Page,Route')
class AppRouter extends RootStackRouter {
  @override
  RouteType get defaultRouteType => RouteType.adaptive();

  @override
  List<AutoRoute> get routes => [
    AutoRoute(path: '/settings', page: SettingsRoute.page),
    AutoRoute(initial: true, path: '/', page: SpeechRecognitionRoute.page),
  ];
}
