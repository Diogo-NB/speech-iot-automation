// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i3;
import 'package:speech_iot_app/src/features/settings/presentation/settings_screen.dart'
    as _i1;
import 'package:speech_iot_app/src/features/speech_recognition/presentation/speech_recognition_screen.dart'
    as _i2;

/// generated route for
/// [_i1.SettingsScreen]
class SettingsRoute extends _i3.PageRouteInfo<void> {
  const SettingsRoute({List<_i3.PageRouteInfo>? children})
    : super(SettingsRoute.name, initialChildren: children);

  static const String name = 'SettingsRoute';

  static _i3.PageInfo page = _i3.PageInfo(
    name,
    builder: (data) {
      return _i3.WrappedRoute(child: const _i1.SettingsScreen());
    },
  );
}

/// generated route for
/// [_i2.SpeechRecognitionScreen]
class SpeechRecognitionRoute extends _i3.PageRouteInfo<void> {
  const SpeechRecognitionRoute({List<_i3.PageRouteInfo>? children})
    : super(SpeechRecognitionRoute.name, initialChildren: children);

  static const String name = 'SpeechRecognitionRoute';

  static _i3.PageInfo page = _i3.PageInfo(
    name,
    builder: (data) {
      return _i3.WrappedRoute(child: const _i2.SpeechRecognitionScreen());
    },
  );
}
