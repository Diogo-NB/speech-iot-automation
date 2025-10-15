import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:speech_iot_app/src/core/app_config/app_config_state.dart';

enum ConfigKeys { baseSocketUrl, baseHttpUrl }

class AppConfig extends Cubit<AppConfigState> {
  final SharedPreferencesWithCache _prefs;

  AppConfig({required SharedPreferencesWithCache prefs})
    : _prefs = prefs,
      super(
        AppConfigState(
          baseSocketUrl: Uri.parse(
            prefs.getString(ConfigKeys.baseSocketUrl.name) ??
                'ws://localhost:8080',
          ),
          baseHttpUrl: Uri.parse(
            prefs.getString(ConfigKeys.baseHttpUrl.name) ??
                'ws://localhost:8080',
          ),
        ),
      );

  String getString(ConfigKeys key) {
    return _prefs.getString(key.name) ?? '';
  }

  Future<void> saveString(ConfigKeys key, String value) {
    return _prefs.setString(key.name, value);
  }

  Future<void> updateConfig({
    required String socketUrl,
    required String httpUrl,
  }) async {
    await saveString(ConfigKeys.baseSocketUrl, socketUrl);
    await saveString(ConfigKeys.baseHttpUrl, httpUrl);

    emit(
      state.copyWith(
        baseSocketUrl: Uri.parse(socketUrl),
        baseHttpUrl: Uri.parse(httpUrl),
      ),
    );
  }
}
