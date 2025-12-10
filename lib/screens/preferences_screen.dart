import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/preferences_provider.dart';

class PreferencesScreen extends StatelessWidget {
  const PreferencesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PreferencesProvider>();

    if (provider.loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final prefs = provider.preferences;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Preferências'),
      ),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text('Vibração'),
            value: prefs.vibration,
            onChanged: (_) => provider.toggleVibration(),
          ),
          SwitchListTile(
            title: const Text('Som'),
            value: prefs.sound,
            onChanged: (_) => provider.toggleSound(),
          ),
          SwitchListTile(
            title: const Text('Banner / Notificação visual'),
            value: prefs.banner,
            onChanged: (_) => provider.toggleBanner(),
          ),
          const Divider(),
          SwitchListTile(
            title: const Text('Modo Crítico'),
            subtitle: const Text(
                'Tentar reproduzir som mesmo em volume baixo ou Não Perturbe, usando canais de alta prioridade.'),
            value: prefs.criticalMode,
            onChanged: (_) => provider.toggleCriticalMode(),
          ),
        ],
      ),
    );
  }
}