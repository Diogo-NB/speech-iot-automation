import 'package:equatable/equatable.dart';
import 'package:speech_to_text/speech_recognition_result.dart';

sealed class AppEvent extends Equatable {
  const AppEvent();

  @override
  List<Object?> get props => [];
}

class InitializeSpeechEvent extends AppEvent {
  const InitializeSpeechEvent();
}

class StartListeningEvent extends AppEvent {
  const StartListeningEvent();
}

class StopListeningEvent extends AppEvent {
  const StopListeningEvent();
}

class SpeechResultEvent extends AppEvent {
  final SpeechRecognitionResult result;

  const SpeechResultEvent(this.result);
}

class SpeechStatusEvent extends AppEvent {
  final String status;

  const SpeechStatusEvent(this.status);

  @override
  List<Object?> get props => [status];
}

class SpeechErrorEvent extends AppEvent {
  final String error;
  final bool isPermanent;

  const SpeechErrorEvent({required this.error, required this.isPermanent});

  @override
  List<Object?> get props => [error, isPermanent];
}
