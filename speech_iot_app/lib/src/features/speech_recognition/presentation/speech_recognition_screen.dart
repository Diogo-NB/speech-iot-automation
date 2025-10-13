import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:speech_iot_app/src/app/app_router.dart';
import 'package:speech_iot_app/src/features/speech_recognition/application/bloc/speech_recognition_bloc.dart';
import 'package:speech_iot_app/src/features/speech_recognition/application/bloc/speech_recognition_event.dart';
import 'package:speech_iot_app/src/features/speech_recognition/application/bloc/speech_recognition_state.dart';
import 'package:speech_iot_app/src/features/speech_recognition/data/speech_recognition_repository.dart';
import 'package:speech_iot_app/src/features/speech_recognition/presentation/components/loading_text_indicator.dart';

@RoutePage()
class SpeechRecognitionScreen extends StatefulWidget
    implements AutoRouteWrapper {
  const SpeechRecognitionScreen({super.key});

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider<SpeechRecognitionBloc>(
      create: (context) => SpeechRecognitionBloc(
        repository: context.read<SpeechRecognitionRepository>(),
      ),
      child: this,
    );
  }

  @override
  State<SpeechRecognitionScreen> createState() => _SpeechRecognitionState();
}

class _SpeechRecognitionState extends State<SpeechRecognitionScreen> {
  @override
  void initState() {
    super.initState();
    context.read<SpeechRecognitionBloc>().add(const InitializeEvent());
  }

  @override
  void dispose() {
    context.read<SpeechRecognitionBloc>().add(const StopListeningEvent());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Speech Recognition'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: 'Settings',
            onPressed: () => context.pushRoute(const SettingsRoute()),
          ),
        ],
      ),
      backgroundColor: Colors.grey[50],
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFF9F9F9), Color(0xFFEFEFEF)],
          ),
        ),
        child: BlocBuilder<SpeechRecognitionBloc, SpeechRecognitionState>(
          builder: (context, state) {
            String displayText;

            switch (state.status) {
              case SpeechRecognitionStatus.error:
                displayText = 'Ocorreu um erro, tente novamente';
                break;
              case SpeechRecognitionStatus.done:
                displayText = state.result.map((res) => res.words).join('\n');
                break;
              case SpeechRecognitionStatus.listening:
                displayText = 'Ouvindo...';
                break;
              default:
                displayText = 'Toque no microfone para começar';
            }

            return Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Diga um comando de voz:',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                    const SizedBox(height: 32),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 400),
                      transitionBuilder: (child, animation) {
                        final offsetAnim = Tween<Offset>(
                          begin: const Offset(0, 0.2),
                          end: Offset.zero,
                        ).animate(animation);
                        return FadeTransition(
                          opacity: animation,
                          child: SlideTransition(
                            position: offsetAnim,
                            child: child,
                          ),
                        );
                      },
                      child: state.status == SpeechRecognitionStatus.listening
                          ? const LoadingTextIndicator(
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w500,
                                color: Colors.black87,
                              ),
                            )
                          : Text(
                              displayText,
                              key: ValueKey(displayText),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w500,
                                color:
                                    state.status ==
                                        SpeechRecognitionStatus.error
                                    ? Colors.red
                                    : Colors.black87,
                              ),
                            ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton:
          BlocBuilder<SpeechRecognitionBloc, SpeechRecognitionState>(
            builder: (context, state) {
              final isListening = state.isListening;
              final isEnabled = state.isSpeechEnabled;

              final double size = isListening ? 78 : 64;

              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: size,
                height: size,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    if (isListening)
                      BoxShadow(
                        color: Colors.redAccent.withValues(alpha: 0.5),
                        blurRadius: 20,
                        spreadRadius: 6,
                      ),
                  ],
                ),
                child: FloatingActionButton(
                  onPressed: isEnabled
                      ? () {
                          if (isListening) {
                            context.read<SpeechRecognitionBloc>().add(
                              const StopListeningEvent(),
                            );
                          } else {
                            context.read<SpeechRecognitionBloc>().add(
                              const StartListeningEvent(),
                            );
                          }
                        }
                      : null,
                  backgroundColor: isListening
                      ? Colors.redAccent
                      : Colors.blueAccent,
                  tooltip: isListening ? 'Parar de ouvir' : 'Começar a ouvir',
                  child: Icon(
                    isListening ? Icons.mic : Icons.mic_none,
                    size: 34,
                    color: Colors.white,
                  ),
                ),
              );
            },
          ),
    );
  }
}
