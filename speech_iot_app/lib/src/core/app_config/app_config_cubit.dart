import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:speech_iot_app/src/core/app_config/app_config_model.dart';

class AppConfig extends Cubit<AppConfigState> {
  AppConfig({
    required String initialBaseSocketUrl,
    required String initialBaseHttpUrl,
  }) : super(
         AppConfigState(
           baseSocketUrl: Uri.parse(initialBaseSocketUrl),
           baseHttpUrl: Uri.parse(initialBaseHttpUrl),
         ),
       );

  void updateUrls(String socketUrl, String httpUrl) {
    emit(
      state.copyWith(
        baseSocketUrl: Uri.parse(socketUrl),
        baseHttpUrl: Uri.parse(httpUrl),
      ),
    );
  }
}
