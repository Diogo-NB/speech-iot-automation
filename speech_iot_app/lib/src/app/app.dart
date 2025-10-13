import 'package:flutter/material.dart';
import 'package:speech_iot_app/src/app/app_router.dart';
import 'package:speech_iot_app/src/app/app_theme.dart';
import 'package:speech_iot_app/src/app/di.dart';

class App extends StatelessWidget {
  App({super.key});

  final AppRouter _appRouter = AppRouter();
  final ThemeData _appTheme = AppTheme.light();

  @override
  Widget build(BuildContext context) {
    return CoreScopeProvider(
      child: DataScopeProvider(
        child: MaterialApp.router(
          routerConfig: _appRouter.config(),
          theme: _appTheme,
        ),
      ),
    );
  }
}
