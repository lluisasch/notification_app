import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/monitoring_provider.dart';
import '../providers/preferences_provider.dart';
import '../services/api_service.dart';
import '../core/app_routes.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final _apiService = ApiService();
  String? _apiStatus;
  bool _loadingStatus = false;

  Future<void> _loadApiStatus() async {
    setState(() => _loadingStatus = true);
    try {
      final data = await _apiService.fetchStatus();
      setState(() => _apiStatus = data.toString());
    } catch (e) {
      setState(() => _apiStatus = 'Erro ao carregar status: $e');
    } finally {
      setState(() => _loadingStatus = false);
    }
  }

  @override
  void initState() {
    super.initState();
    _loadApiStatus(); // demonstra integração com API
  }

  @override
  Widget build(BuildContext context) {
    final monitoring = context.watch<MonitoringProvider>();
    final preferencesProvider = context.watch<PreferencesProvider>();

    final enabled = monitoring.enabled;
    final alertActive = monitoring.alertActive;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Monitoramento'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () => Navigator.pushNamed(context, AppRoutes.history),
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => Navigator.pushNamed(context, AppRoutes.preferences),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              child: ListTile(
                title: const Text('Estado do sistema'),
                subtitle: Text(enabled ? 'Ativado' : 'Desativado'),
                trailing: Switch(
                  value: enabled,
                  onChanged: (_) => monitoring.toggleEnabled(),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: ListTile(
                title: const Text('Status da API'),
                subtitle: _loadingStatus
                    ? const Text('Carregando...')
                    : Text(_apiStatus ?? 'Nenhum dado'),
                trailing: IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: _loadApiStatus,
                ),
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(56),
                backgroundColor: alertActive ? Colors.red : Colors.orange,
              ),
              icon: const Icon(Icons.warning_amber_rounded),
              label: Text(alertActive ? 'Alerta em processamento...' : 'Simular Alerta / Botão de Pânico'),
              onPressed: alertActive || !enabled
                  ? null
                  : () async {
                      final prefs = preferencesProvider.preferences;
                      await monitoring.triggerAlert(prefs);
                      if (!mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Alerta disparado!')),
                      );
                    },
            ),
            const SizedBox(height: 16),
            if (!enabled)
              const Text(
                'Ative o sistema para permitir o disparo de alertas.',
                style: TextStyle(color: Colors.grey),
              ),
          ],
        ),
      ),
    );
  }
}