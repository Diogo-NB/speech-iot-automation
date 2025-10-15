import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:speech_iot_app/src/core/app_config/app_config.dart';
import 'package:speech_iot_app/src/core/utils/bloc_event_transformers.dart';
import 'settings_event.dart';
import 'settings_state.dart';
import 'package:http/http.dart' as http;

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final AppConfig _appConfig;

  SettingsBloc({required AppConfig appConfig})
    : _appConfig = appConfig,
      super(SettingsState(baseUrlAuthority: appConfig.state.baseUrlAuthority)) {
    on<TestConnectivitySettings>(
      _onTestConnection,
      transformer: debounce(const Duration(milliseconds: 300)),
    );

    on<SaveSettings>(
      _onSaveSettings,
      transformer: debounce(const Duration(milliseconds: 300)),
    );
  }

  String _buildAuthority(String host, [String? port]) {
    final hasPort = port?.isNotEmpty ?? false;
    final authority = '$host${hasPort ? ':$port' : ''}';
    return authority;
  }

  Future<void> _onTestConnection(
    TestConnectivitySettings event,
    Emitter<SettingsState> emit,
  ) async {
    emit(
      state.copyWith(connectivityTestStatus: ConnectivityTestStatus.inProgress),
    );

    final authority = _buildAuthority(event.host, event.port);

    try {
      final healthCheckUrl = Uri.parse('http://$authority/health-check/');
      final response = await http
          .get(healthCheckUrl)
          .timeout(const Duration(seconds: 5));

      final success = response.statusCode == 200;

      emit(
        state.copyWith(
          connectivityTestStatus: success
              ? ConnectivityTestStatus.success
              : ConnectivityTestStatus.failure,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(connectivityTestStatus: ConnectivityTestStatus.failure),
      );
    }
  }

  void _onSaveSettings(SaveSettings event, Emitter<SettingsState> emit) {
    final authority = _buildAuthority(event.host, event.port);
    _appConfig.updateConfig(
      socketUrl: 'ws://$authority',
      httpUrl: 'http://$authority',
    );
  }
}
