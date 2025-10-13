import 'package:equatable/equatable.dart';

enum ConnectionStatus { initial, testing, success, failure }

final class SettingsState extends Equatable {
  final String host;
  final String port;
  final ConnectionStatus status;

  const SettingsState({
    this.host = '',
    this.port = '',
    this.status = ConnectionStatus.initial,
  });

  SettingsState copyWith({
    String? host,
    String? port,
    ConnectionStatus? status,
  }) {
    return SettingsState(
      host: host ?? this.host,
      port: port ?? this.port,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [host, port, status];
}
