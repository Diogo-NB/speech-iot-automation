import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:speech_iot_app/src/core/app_config/app_config_cubit.dart';
import 'package:speech_iot_app/src/core/utils/bloc_event_transformers.dart';
import 'settings_event.dart';
import 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final AppConfig _appConfig;

  SettingsBloc({required AppConfig appConfig})
    : _appConfig = appConfig,
      super(const SettingsState()) {
    on<HostChanged>(
      (e, emit) => emit(state.copyWith(host: e.host)),
      transformer: debounce(const Duration(milliseconds: 300)),
    );
    on<PortChanged>(
      (e, emit) => emit(state.copyWith(port: e.port)),
      transformer: debounce(const Duration(milliseconds: 300)),
    );
    on<TestConnectionRequested>(_onTestConnection);
    on<SaveSettingsRequested>(_onSaveSettings);
  }

  Future<void> _onTestConnection(
    TestConnectionRequested event,
    Emitter<SettingsState> emit,
  ) async {
    emit(state.copyWith(status: ConnectionStatus.testing));
    await Future.delayed(const Duration(seconds: 1));

    final success = state.host.isNotEmpty && int.tryParse(state.port) != null;
    emit(
      state.copyWith(
        status: success ? ConnectionStatus.success : ConnectionStatus.failure,
      ),
    );
  }

  void _onSaveSettings(
    SaveSettingsRequested event,
    Emitter<SettingsState> emit,
  ) {
    final host = state.host.trim();
    final port = state.port.trim();

    _appConfig.baseHttpUrl = 'http://$host:$port';
    _appConfig.baseSocketUrl = 'ws://$host:$port';
  }
}
