import 'package:equatable/equatable.dart';
import 'package:speech_to_text/speech_recognition_result.dart';

sealed class SpeechRecognitionEvent extends Equatable {
  const SpeechRecognitionEvent();

  @override
  List<Object?> get props => [];
}

class InitializeEvent extends SpeechRecognitionEvent {
  const InitializeEvent();
}

class StartListeningEvent extends SpeechRecognitionEvent {
  const StartListeningEvent();
}

class StopListeningEvent extends SpeechRecognitionEvent {
  const StopListeningEvent();
}

class SpeechResultEvent extends SpeechRecognitionEvent {
  final SpeechRecognitionResult result;

  const SpeechResultEvent(this.result);
}

class SpeechStatusEvent extends SpeechRecognitionEvent {
  final String status;

  const SpeechStatusEvent(this.status);

  @override
  List<Object?> get props => [status];
}

class SpeechErrorEvent extends SpeechRecognitionEvent {
  final String error;
  final bool isPermanent;

  const SpeechErrorEvent({required this.error, required this.isPermanent});

  @override
  List<Object?> get props => [error, isPermanent];
}
