import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

enum ConnectivityTestStatus { initial, inProgress, success, failure }

@immutable
final class SettingsState extends Equatable {
  final String baseUrlAuthority;
  final ConnectivityTestStatus connectivityTestStatus;

  const SettingsState({
    this.baseUrlAuthority = '',
    this.connectivityTestStatus = ConnectivityTestStatus.initial,
  });

  SettingsState copyWith({
    String? baseUrlAuthority,
    ConnectivityTestStatus? connectivityTestStatus,
  }) {
    return SettingsState(
      baseUrlAuthority: baseUrlAuthority ?? this.baseUrlAuthority,
      connectivityTestStatus:
          connectivityTestStatus ?? this.connectivityTestStatus,
    );
  }

  @override
  List<Object?> get props => [baseUrlAuthority, connectivityTestStatus];
}
