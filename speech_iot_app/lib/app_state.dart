import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'app_status.dart';

@immutable
class RecognizedWords extends Equatable {
  final String words;
  final double confidence;

  const RecognizedWords({required this.words, required this.confidence});

  @override
  List<Object?> get props => [words, confidence];
}

@immutable
class AppState extends Equatable {
  final bool isSpeechEnabled;
  final bool isListening;
  final List<RecognizedWords> result;
  final AppStatus status;
  final String? error;

  const AppState({
    this.isSpeechEnabled = false,
    this.isListening = false,
    this.result = const [],
    this.status = AppStatus.unknown,
    this.error,
  });

  AppState copyWith({
    bool? isSpeechEnabled,
    bool? isListening,
    List<RecognizedWords>? result,
    AppStatus? status,
    String? error,
  }) {
    return AppState(
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
