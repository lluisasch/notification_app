import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/history_provider.dart';
import '../models/alert_event.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  String _formatType(AlertEventType type) {
    switch (type) {
      case AlertEventType.panic:
        return 'Pânico';
      case AlertEventType.scheduled:
        return 'Agendado';
      case AlertEventType.system:
        return 'Sistema';
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<HistoryProvider>();
    final events = provider.events;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Histórico de eventos'),
      ),
      body: RefreshIndicator(
        onRefresh: () => provider.load(),
        child: ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: events.length,
          separatorBuilder: (_, __) => const SizedBox(height: 8),
          itemBuilder: (context, index) {
            final e = events[index];
            return Card(
              child: ListTile(
                title: Text(_formatType(e.type)),
                subtitle: Text(
                  'Início: ${e.createdAt}\n'
                  'Conclusão: ${e.processedAt ?? '-'}',
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}