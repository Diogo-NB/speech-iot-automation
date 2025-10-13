import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:speech_iot_app/src/features/speech_recognition/domain/recognized_words_model.dart';

enum SpeechRecognitionStatus {
  unknown('unknown'),
  initialized('initialized'),
  speechNotEnabled('speech_not_enabled'),
  listening('listening'),
  stopped('stopped'),
  done('done'),
  error('error');

  const SpeechRecognitionStatus(this.value);

  final String value;

  static SpeechRecognitionStatus fromValue(String statusValue) {
    return SpeechRecognitionStatus.values.firstWhere(
      (e) => e.value == statusValue,
      orElse: () => SpeechRecognitionStatus.unknown,
    );
  }
}

@immutable
class SpeechRecognitionState extends Equatable {
  final bool isSpeechEnabled;
  final bool isListening;
  final List<RecognizedWordsModel> result;
  final SpeechRecognitionStatus status;
  final String? error;

  const SpeechRecognitionState({
    this.isSpeechEnabled = false,
    this.isListening = false,
    this.result = const [],
    this.status = SpeechRecognitionStatus.unknown,
    this.error,
  });

  SpeechRecognitionState copyWith({
    bool? isSpeechEnabled,
    bool? isListening,
    List<RecognizedWordsModel>? result,
    SpeechRecognitionStatus? status,
    String? error,
  }) {
    return SpeechRecognitionState(
      isSpeechEnabled: isSpeechEnabled ?? this.isSpeechEnabled,
      isListening: isListening ?? this.isListening,
      result: result ?? this.result,
      status: status ?? this.status,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [
    isSpeechEnabled,
    isListening,
    result,
    status,
    error,
  ];
}
