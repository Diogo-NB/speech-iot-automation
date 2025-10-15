import 'dart:async';
import 'package:bloc_concurrency/bloc_concurrency.dart';
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
    on<InitializeEvent>(_onInitialize, transformer: droppable());
    on<StartListeningEvent>(_onStartListening);
    on<StopListeningEvent>(_onStopListening);
    on<SpeechResultEvent>(_onSpeechResult);
    on<SpeechStatusEvent>(_onSpeechStatus);
    on<SpeechErrorEvent>(_onSpeechError, transformer: restartable());
  }

  Future<void> _onInitialize(
    InitializeEvent event,
    Emitter<SpeechRecognitionState> emit,
  ) async {
    final isEnabled = await _speechToText.initialize(
      finalTimeout: Duration(seconds: 7),
      onError: (error) {
        add(SpeechErrorEvent(error.errorMsg));
      },
      onStatus: (status) {
        add(SpeechStatusEvent(status));
      },
    );

    emit(
      SpeechRecognitionState(
        status: SpeechRecognitionStatus.initialized,
        isSpeechEnabled: isEnabled,
      ),
    );
  }

  Future<void> _onStartListening(
    StartListeningEvent event,
    Emitter<SpeechRecognitionState> emit,
  ) async {
    if (!state.isSpeechEnabled) {
      add(SpeechErrorEvent('Speech recognition is not available'));
      return;
    }

    await _speechToText.listen(
      localeId: 'pt_BR',
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
        result: [],
        error: '',
      ),
    );
  }

  Future<void> _onStopListening(
    StopListeningEvent event,
    Emitter<SpeechRecognitionState> emit,
  ) async {
    await _speechToText.stop();

    emit(
      state.copyWith(
        isListening: false,
        status: SpeechRecognitionStatus.stopped,
        error: '',
      ),
    );
  }

  void _onSpeechResult(
    SpeechResultEvent event,
    Emitter<SpeechRecognitionState> emit,
  ) {
    final List<RecognizedWordsModel> result =
        event.result.alternates
            .where((res) => res.isConfident(threshold: 0.7))
            .map(
              (res) => RecognizedWordsModel(
                words: res.recognizedWords.toLowerCase(),
                confidence: res.confidence,
              ),
            )
            .toList()
          ..sort((a, b) => b.confidence.compareTo(a.confidence));

    try {
      _repository.sendResult(result);
    } catch (e) {
      add(SpeechErrorEvent('Failed to save recognized words: $e'));
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
    print('Error occurred: ${event.error}');
    emit(
      state.copyWith(
        isListening: false,
        result: [],
        status: SpeechRecognitionStatus.error,
        error: event.error,
      ),
    );
  }

  @override
  Future<void> close() async {
    await _speechToText.stop();
    return super.close();
  }
}
