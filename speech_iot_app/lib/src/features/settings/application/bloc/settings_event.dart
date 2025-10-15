import 'package:equatable/equatable.dart';

sealed class SettingsEvent extends Equatable {
  const SettingsEvent();

  @override
  List<Object?> get props => [];
}

final class InitializeEvent extends SettingsEvent {}

final class TestConnectivitySettings extends SettingsEvent {
  final String host;
  final String? port;

  const TestConnectivitySettings({required this.host, this.port});

  @override
  List<Object?> get props => [host, port];
}

final class SaveSettings extends SettingsEvent {
  final String host;
  final String? port;

  const SaveSettings({required this.host, this.port});

  @override
  List<Object?> get props => [host, port];
}
