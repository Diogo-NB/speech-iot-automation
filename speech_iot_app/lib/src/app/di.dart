import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:speech_iot_app/src/core/app_config/app_config_cubit.dart';
import 'package:speech_iot_app/src/features/speech_recognition/application/bloc/speech_recognition_bloc.dart';
import 'package:speech_iot_app/src/features/speech_recognition/data/speech_recognition_repository.dart';

class CoreProvider extends StatelessWidget {
  final Widget child;

  const CoreProvider({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        BlocProvider(
          create: (_) => AppConfigCubit(
            initialBaseHttpUrl: 'http://localhost:3000',
            initialBaseSocketUrl: 'ws://localhost:3000',
          ),
        ),
      ],
      child: child,
    );
  }
}

class DataProvider extends StatelessWidget {
  final Widget child;

  const DataProvider({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<SpeechRecognitionRepository>(
          create: (context) =>
              SpeechRecognitionRepository(context.read<AppConfigCubit>()),
        ),
      ],
      child: child,
    );
  }
}

class ApplicationProvider extends StatelessWidget {
  final Widget child;

  const ApplicationProvider({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => SpeechRecognitionBloc(
            repository: context.read<SpeechRecognitionRepository>(),
          ),
        ),
      ],
      child: child,
    );
  }
}
