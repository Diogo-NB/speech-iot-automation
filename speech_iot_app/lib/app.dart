import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:speech_iot_app/app_status.dart';
import 'package:speech_iot_app/components/loading_text_indicator.dart';
import 'app_bloc.dart';
import 'app_event.dart';
import 'app_state.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  void initState() {
    super.initState();
    context.read<AppBloc>().add(const InitializeSpeechEvent());
  }

  @override
  void dispose() {
    context.read<AppBloc>().add(const StopListeningEvent());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFF9F9F9), Color(0xFFEFEFEF)],
          ),
        ),
        child: BlocBuilder<AppBloc, AppState>(
          builder: (context, state) {
            String displayText;

            switch (state.status) {
              case AppStatus.error:
                displayText = 'Ocorreu um erro, tente novamente';
                break;
              case AppStatus.done:
                displayText = state.result.map((res) => res.words).join('\n');
                break;
              case AppStatus.listening:
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
                      child: state.status == AppStatus.listening
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
                                color: state.status == AppStatus.error
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
      floatingActionButton: BlocBuilder<AppBloc, AppState>(
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
                        context.read<AppBloc>().add(const StopListeningEvent());
                      } else {
                        context.read<AppBloc>().add(
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
