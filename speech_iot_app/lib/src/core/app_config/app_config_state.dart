import 'package:flutter/foundation.dart';

@immutable
class AppConfigState {
  final Uri baseSocketUrl;
  final Uri baseHttpUrl;

  String get baseUrlAuthority => baseHttpUrl.authority;

  const AppConfigState({
    required this.baseSocketUrl,
    required this.baseHttpUrl,
  });

  AppConfigState copyWith({Uri? baseSocketUrl, Uri? baseHttpUrl}) {
    return AppConfigState(
      baseSocketUrl: baseSocketUrl ?? this.baseSocketUrl,
      baseHttpUrl: baseHttpUrl ?? this.baseHttpUrl,
    );
  }
}
