import 'package:equatable/equatable.dart';

sealed class SettingsEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

final class HostChanged extends SettingsEvent {
  final String host;
  HostChanged(this.host);

  @override
  List<Object?> get props => [host];
}

final class PortChanged extends SettingsEvent {
  final String port;
  PortChanged(this.port);

  @override
  List<Object?> get props => [port];
}

final class TestConnectionRequested extends SettingsEvent {}

final class SaveSettingsRequested extends SettingsEvent {}
