import 'dart:convert';
import 'package:speech_iot_app/src/features/speech_recognition/data/recognized_speech_result_dto.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;

class SpeechRecognitionWebSocketService {
  WebSocketChannel? _channel;

  final Uri url;

  SpeechRecognitionWebSocketService(Uri baseUrl)
    : url = Uri(
        scheme: 'ws',
        host: baseUrl.host,
        port: baseUrl.port,
        path: 'speech-recognition',
      );

  Stream get stream => _channel!.stream;

  bool get isConnected => _channel != null;

  void connect() {
    if (_channel != null) return;

    _channel = WebSocketChannel.connect(url);

    _channel!.stream.listen(
      (event) {},
      onError: (error) {
        disconnect();
      },
      onDone: () {
        disconnect();
      },
    );
  }

  void send(RecognizedSpeechResultDto dto) {
    if (_channel == null) {
      throw Exception('WebSocket not connected.');
    }

    final message = jsonEncode({'data': dto.toJson()});

    _channel!.sink.add(message);
  }

  void disconnect() {
    _channel?.sink.close(status.normalClosure);
    _channel = null;
  }
}
