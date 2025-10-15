import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:speech_iot_app/src/core/app_config/app_config.dart';
import 'package:speech_iot_app/src/features/settings/application/bloc/settings_bloc.dart';
import 'package:speech_iot_app/src/features/settings/application/bloc/settings_event.dart';
import 'package:speech_iot_app/src/features/settings/application/bloc/settings_state.dart';

@RoutePage()
class SettingsScreen extends StatefulWidget implements AutoRouteWrapper {
  const SettingsScreen({super.key});

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider(
      create: (_) => SettingsBloc(appConfig: context.read<AppConfig>()),
      child: this,
    );
  }

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _formKey = GlobalKey<FormState>();

  final _hostController = TextEditingController();
  final _portController = TextEditingController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final bloc = context.read<SettingsBloc>();
      final initialAuthoritySplit = bloc.state.baseUrlAuthority.split(':');

      _hostController.text = initialAuthoritySplit.first;

      if (initialAuthoritySplit.length > 1) {
        _portController.text = initialAuthoritySplit[1];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Configurações')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: BlocConsumer<SettingsBloc, SettingsState>(
          listener: (context, state) {
            if (state.connectivityTestStatus ==
                    ConnectivityTestStatus.success ||
                state.connectivityTestStatus ==
                    ConnectivityTestStatus.failure) {
              final success =
                  state.connectivityTestStatus ==
                  ConnectivityTestStatus.success;

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  duration: const Duration(seconds: 2),
                  content: Text(
                    success ? 'Conexão bem-sucedida!' : 'Falha na conexão',
                  ),
                  backgroundColor: success ? Colors.green : Colors.red,
                ),
              );
            }
          },
          builder: (context, state) {
            final bloc = context.read<SettingsBloc>();

            return Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _hostController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Host'),
                    validator: (value) {
                      value = value?.trim();

                      if (value == null || value.isEmpty) {
                        return 'Campo obrigatório';
                      }

                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _portController,
                    decoration: const InputDecoration(labelText: 'Porta'),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      value = value?.trim();

                      if (value == null || value.isEmpty) {
                        return null;
                      }

                      final port = int.tryParse(value);

                      if (port == null || port < 1 || port > 65535) {
                        return 'Porta inválida';
                      }

                      return null;
                    },
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      icon:
                          state.connectivityTestStatus ==
                              ConnectivityTestStatus.inProgress
                          ? const SizedBox(
                              height: 18,
                              width: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.wifi_tethering),
                      label: Text(
                        state.connectivityTestStatus ==
                                ConnectivityTestStatus.inProgress
                            ? 'Testando...'
                            : 'Testar Conexão',
                      ),
                      onPressed:
                          state.connectivityTestStatus ==
                              ConnectivityTestStatus.inProgress
                          ? null
                          : () {
                              if (_formKey.currentState!.validate() == true) {
                                _formKey.currentState!.save();

                                bloc.add(
                                  TestConnectivitySettings(
                                    host: _hostController.text.trim(),
                                    port: _portController.text.trim(),
                                  ),
                                );
                              }
                            },
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.save),
                      label: const Text('Salvar Configurações'),
                      onPressed: () {
                        if (_formKey.currentState!.validate() == true) {
                          _formKey.currentState!.save();

                          bloc.add(
                            SaveSettings(
                              host: _hostController.text.trim(),
                              port: _portController.text.trim(),
                            ),
                          );

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              duration: const Duration(seconds: 5),
                              content: Text('Configurações salvas'),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
