class AppConfigState {
  final Uri baseSocketUrl;
  final Uri baseHttpUrl;

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
