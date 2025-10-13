import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:speech_iot_app/src/features/speech_recognition/application/bloc/speech_recognition_event.dart';
import 'package:speech_iot_app/src/features/speech_recognition/application/bloc/speech_recognition_state.dart';
import 'package:speech_iot_app/src/features/speech_recognition/data/speech_recognition_repository.dart';
import 'package:speech_iot_app/src/features/speech_recognition/domain/recognized_words_model.dart';
import 'package:speech_to_text/speech_to_text.dart';

class SpeechRecognitionBloc
    extends Bloc<SpeechRecognitionEvent, SpeechRecognitionState> {
  final SpeechToText _speechToText = SpeechToText();
  final SpeechRecognitionRepository _repository;

  SpeechRecognitionBloc({required SpeechRecognitionRepository repository})
    : _repository = repository,
      super(const SpeechRecognitionState()) {
    on<InitializeEvent>(_onInitialize);
    on<StartListeningEvent>(_onStartListening);
    on<StopListeningEvent>(_onStopListening);
    on<SpeechResultEvent>(_onSpeechResult);
    on<SpeechStatusEvent>(_onSpeechStatus);
    on<SpeechErrorEvent>(_onSpeechError);
  }

  Future<void> _onInitialize(
    InitializeEvent event,
    Emitter<SpeechRecognitionState> emit,
  ) async {
    try {
      final isEnabled = await _speechToText.initialize(
        finalTimeout: Duration(seconds: 7),
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
          status: SpeechRecognitionStatus.initialized,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isSpeechEnabled: false,
          status: SpeechRecognitionStatus.error,
          error: e.toString(),
        ),
      );
    }
  }

  Future<void> _onStartListening(
    StartListeningEvent event,
    Emitter<SpeechRecognitionState> emit,
  ) async {
    if (!state.isSpeechEnabled) {
      emit(
        state.copyWith(
          status: SpeechRecognitionStatus.speechNotEnabled,
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
          status: SpeechRecognitionStatus.listening,
          error: '',
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isListening: false,
          status: SpeechRecognitionStatus.error,
          error: 'Failed to start listening: $e',
        ),
      );
    }
  }

  Future<void> _onStopListening(
    StopListeningEvent event,
    Emitter<SpeechRecognitionState> emit,
  ) async {
    try {
      await _speechToText.stop();
      emit(
        state.copyWith(
          isListening: false,
          status: SpeechRecognitionStatus.stopped,
          error: '',
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isListening: false,
          status: SpeechRecognitionStatus.error,
          error: 'Failed to stop listening: $e',
        ),
      );
    }
  }

  void _onSpeechResult(
    SpeechResultEvent event,
    Emitter<SpeechRecognitionState> emit,
  ) {
    final result =
        event.result.alternates
            .where((res) => res.isConfident())
            .map(
              (res) => RecognizedWordsModel(
                words: res.recognizedWords,
                confidence: res.confidence,
              ),
            )
            .toList()
          ..sort((a, b) => b.confidence.compareTo(a.confidence));

    try {
      _repository.sendRecognizedWords(result);
    } catch (e) {
      emit(
        state.copyWith(
          isListening: false,
          status: SpeechRecognitionStatus.error,
          error: 'Failed to save recognized words: $e',
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        result: result,
        isListening: false,
        status: SpeechRecognitionStatus.done,
      ),
    );
  }

  void _onSpeechStatus(
    SpeechStatusEvent event,
    Emitter<SpeechRecognitionState> emit,
  ) {
    final status = SpeechRecognitionStatus.fromValue(event.status);
    emit(state.copyWith(status: status));
  }

  void _onSpeechError(
    SpeechErrorEvent event,
    Emitter<SpeechRecognitionState> emit,
  ) {
    emit(
      state.copyWith(
        isListening: false,
        status: SpeechRecognitionStatus.error,
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
