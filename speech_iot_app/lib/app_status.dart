enum AppStatus {
  unknown('unknown'),
  initialized('initialized'),
  speechNotEnabled('speech_not_enabled'),
  listening('listening'),
  stopped('stopped'),
  done('done'),
  error('error');

  const AppStatus(this.value);

  final String value;

  static AppStatus fromValue(String statusValue) {
    return AppStatus.values.firstWhere(
      (e) => e.value == statusValue,
      orElse: () => AppStatus.unknown,
    );
  }
}
