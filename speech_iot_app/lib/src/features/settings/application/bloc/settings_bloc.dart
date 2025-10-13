import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:speech_iot_app/src/core/app_config/app_config_cubit.dart';
import 'package:speech_iot_app/src/core/utils/bloc_event_transformers.dart';
import 'settings_event.dart';
import 'settings_state.dart';
import 'package:http/http.dart' as http;

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final AppConfig _appConfig;

  SettingsBloc({required AppConfig appConfig})
    : _appConfig = appConfig,
      super(
        SettingsState(
          host: appConfig.state.baseHttpUrl.host,
          port: appConfig.state.baseHttpUrl.port.toString(),
        ),
      ) {
    on<HostChangedEvent>(
      (e, emit) => emit(state.copyWith(host: e.host)),
      transformer: debounce(const Duration(milliseconds: 300)),
    );
    on<PortChangedEvent>(
      (e, emit) => emit(state.copyWith(port: e.port)),
      transformer: debounce(const Duration(milliseconds: 300)),
    );
    on<TestConnectionRequestedEvent>(_onTestConnection);
    on<SaveSettingsRequestedEvent>(_onSaveSettings);
  }

  Future<void> _onTestConnection(
    TestConnectionRequestedEvent event,
    Emitter<SettingsState> emit,
  ) async {
    emit(state.copyWith(status: ConnectionStatus.testing));

    try {
      final host = state.host.trim();
      final port = state.port.trim();
      print('Saving settings with host: $host and port: $port');

      if (host.isEmpty || int.tryParse(port) == null) {
        emit(state.copyWith(status: ConnectionStatus.failure));
        return;
      }

      final uri = Uri.parse('http://$host:$port/health-check/');
      final response = await http.get(uri).timeout(const Duration(seconds: 5));

      final success = response.statusCode == 200;

      emit(
        state.copyWith(
          status: success ? ConnectionStatus.success : ConnectionStatus.failure,
        ),
      );
    } catch (_) {
      emit(state.copyWith(status: ConnectionStatus.failure));
    }
  }

  void _onSaveSettings(
    SaveSettingsRequestedEvent event,
    Emitter<SettingsState> emit,
  ) {
    final host = state.host.trim();
    final port = state.port.trim();
    final authority = '$host:$port';

    _appConfig.updateUrls('ws://$authority', 'http://$authority');
  }
}
