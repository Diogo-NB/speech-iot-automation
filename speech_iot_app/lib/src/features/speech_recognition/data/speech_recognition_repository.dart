import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:speech_iot_app/src/core/app_config/app_config_cubit.dart';
import 'package:speech_iot_app/src/features/speech_recognition/data/recognized_speech_result_dto.dart';
import 'package:speech_iot_app/src/features/speech_recognition/data/speech_recognition_websocket_service.dart';
import 'package:speech_iot_app/src/features/speech_recognition/domain/recognized_words_model.dart';

class SpeechRecognitionRepository extends Cubit<void> {
  final AppConfigCubit _appConfig;
  SpeechRecognitionWebSocketService? _ws;

  late final StreamSubscription _configSub;

  SpeechRecognitionRepository(this._appConfig) : super(null) {
    _connect(_appConfig.state.baseSocketUrl);

    _configSub = _appConfig.stream.listen(
      (state) => _connect(state.baseSocketUrl),
    );
  }

  void _connect(Uri baseUrl) {
    _ws?.disconnect();
    _ws = SpeechRecognitionWebSocketService(baseUrl)..connect();
  }

  void sendRecognizedWords(List<RecognizedWordsModel> recognizedWordsList) {
    _ws?.send(
      RecognizedSpeechResultDto(
        recognizedWordsList
            .map((words) => (words.words, words.confidence))
            .toList(),
      ),
    );
  }

  @override
  Future<void> close() async {
    await _configSub.cancel();
    _ws?.disconnect();
    await super.close();
  }
}
