import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:speech_iot_app/src/core/app_config/app_config_cubit.dart';
import 'package:speech_iot_app/src/features/settings/application/bloc/settings_bloc.dart';
import 'package:speech_iot_app/src/features/settings/application/bloc/settings_event.dart';
import 'package:speech_iot_app/src/features/settings/application/bloc/settings_state.dart';

@RoutePage()
class SettingsScreen extends StatelessWidget implements AutoRouteWrapper {
  const SettingsScreen({super.key});

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider(
      create: (_) => SettingsBloc(appConfig: context.read<AppConfig>()),
      child: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Configurações')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: BlocConsumer<SettingsBloc, SettingsState>(
          listener: (context, state) {
            if (state.status == ConnectionStatus.success ||
                state.status == ConnectionStatus.failure) {
              final success = state.status == ConnectionStatus.success;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
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
              child: Column(
                children: [
                  TextFormField(
                    initialValue: state.host,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Host'),
                    onChanged: (v) => bloc.add(HostChangedEvent(v)),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    initialValue: state.port,
                    decoration: const InputDecoration(labelText: 'Porta'),
                    keyboardType: TextInputType.number,
                    onChanged: (v) => bloc.add(PortChangedEvent(v)),
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      icon: state.status == ConnectionStatus.testing
                          ? const SizedBox(
                              height: 18,
                              width: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.wifi_tethering),
                      label: Text(
                        state.status == ConnectionStatus.testing
                            ? 'Testando...'
                            : 'Testar Conexão',
                      ),
                      onPressed: state.status == ConnectionStatus.testing
                          ? null
                          : () => bloc.add(TestConnectionRequestedEvent()),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.save),
                      label: const Text('Salvar Configurações'),
                      onPressed: () => bloc.add(SaveSettingsRequestedEvent()),
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
