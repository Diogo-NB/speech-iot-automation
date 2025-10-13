import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:speech_iot_app/src/core/app_config/app_config_cubit.dart';
import 'package:speech_iot_app/src/features/speech_recognition/data/speech_recognition_repository.dart';

class CoreScopeProvider extends StatelessWidget {
  final Widget child;

  const CoreScopeProvider({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        BlocProvider(
          create: (_) => AppConfig(
            initialBaseHttpUrl: 'http://localhost:3000',
            initialBaseSocketUrl: 'ws://localhost:3000',
          ),
        ),
      ],
      child: child,
    );
  }
}

class DataScopeProvider extends StatelessWidget {
  final Widget child;

  const DataScopeProvider({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<SpeechRecognitionRepository>(
          create: (context) =>
              SpeechRecognitionRepository(context.read<AppConfig>()),
        ),
      ],
      child: child,
    );
  }
}
