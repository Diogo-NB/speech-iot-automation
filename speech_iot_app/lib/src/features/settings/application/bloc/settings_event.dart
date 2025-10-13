import 'package:equatable/equatable.dart';

sealed class SettingsEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

final class InitializeEvent extends SettingsEvent {}

final class HostChangedEvent extends SettingsEvent {
  final String host;
  HostChangedEvent(this.host);

  @override
  List<Object?> get props => [host];
}

final class PortChangedEvent extends SettingsEvent {
  final String port;
  PortChangedEvent(this.port);

  @override
  List<Object?> get props => [port];
}

final class TestConnectionRequestedEvent extends SettingsEvent {}

final class SaveSettingsRequestedEvent extends SettingsEvent {}
