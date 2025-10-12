import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'app_event.dart';
import 'app_state.dart';
import 'app_status.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  final SpeechToText _speechToText = SpeechToText();

  AppBloc() : super(const AppState()) {
    on<InitializeSpeechEvent>(_onInitializeSpeech);
    on<StartListeningEvent>(_onStartListening);
    on<StopListeningEvent>(_onStopListening);
    on<SpeechResultEvent>(_onSpeechResult);
    on<SpeechStatusEvent>(_onSpeechStatus);
    on<SpeechErrorEvent>(_onSpeechError);
  }

  Future<void> _onInitializeSpeech(
    InitializeSpeechEvent event,
    Emitter<AppState> emit,
  ) async {
    try {
      final isEnabled = await _speechToText.initialize(
        finalTimeout: Duration(seconds: 7),
        debugLogging: true,
        onError: (errorNotification) {
          add(
            SpeechErrorEvent(
              error: errorNotification.errorMsg,
              isPermanent: errorNotification.permanent,
            ),
          );
        },
        onStatus: (status) {
          add(SpeechStatusEvent(status));
        },
      );

      emit(
        state.copyWith(
          isSpeechEnabled: isEnabled,
          isListening: false,
          status: AppStatus.initialized,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isSpeechEnabled: false,
          status: AppStatus.error,
          error: e.toString(),
        ),
      );
    }
  }

  Future<void> _onStartListening(
    StartListeningEvent event,
    Emitter<AppState> emit,
  ) async {
    if (!state.isSpeechEnabled) {
      emit(
        state.copyWith(
          status: AppStatus.speechNotEnabled,
          error: 'Speech recognition is not available',
        ),
      );
      return;
    }

    try {
      await _speechToText.listen(
        listenOptions: SpeechListenOptions(
          cancelOnError: true,
          partialResults: false,
        ),
        onResult: (result) => add(SpeechResultEvent(result)),
      );

      emit(
        state.copyWith(
          isListening: true,
          status: AppStatus.listening,
          error: '',
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isListening: false,
          status: AppStatus.error,
          error: 'Failed to start listening: $e',
        ),
      );
    }
  }

  Future<void> _onStopListening(
    StopListeningEvent event,
    Emitter<AppState> emit,
  ) async {
    try {
      await _speechToText.stop();
      emit(
        state.copyWith(
          isListening: false,
          status: AppStatus.stopped,
          error: '',
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isListening: false,
          status: AppStatus.error,
          error: 'Failed to stop listening: $e',
        ),
      );
    }
  }

  void _onSpeechResult(SpeechResultEvent event, Emitter<AppState> emit) {
    final result =
        event.result.alternates
            .where((res) => res.isConfident())
            .map(
              (res) => RecognizedWords(
                words: res.recognizedWords,
                confidence: res.confidence,
              ),
            )
            .toList()
          ..sort((a, b) => b.confidence.compareTo(a.confidence));

    emit(
      state.copyWith(
        result: result,
        isListening: false,
        status: AppStatus.done,
      ),
    );
  }

  void _onSpeechStatus(SpeechStatusEvent event, Emitter<AppState> emit) {
    final status = AppStatus.fromValue(event.status);
    emit(state.copyWith(status: status));
  }

  void _onSpeechError(SpeechErrorEvent event, Emitter<AppState> emit) {
    emit(
      state.copyWith(
        isListening: false,
        status: AppStatus.error,
        error: event.error,
      ),
    );
  }

  @override
  Future<void> close() {
    _speechToText.stop();
    return super.close();
  }
}
