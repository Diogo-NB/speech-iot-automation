import 'package:flutter/material.dart';
import 'package:speech_iot_app/src/app/di.dart';
import 'package:speech_iot_app/src/features/speech_recognition/presentation/speech_recognition_screen.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return CoreProvider(
      child: DataProvider(
        child: ApplicationProvider(
          child: MaterialApp(home: SpeechRecognitionScreen()),
        ),
      ),
    );
  }
}
