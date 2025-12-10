import 'package:flutter/foundation.dart';

import '../services/notification_service.dart';
import '../services/history_service.dart';
import '../models/alert_event.dart';
import '../models/preferences.dart';

class MonitoringProvider extends ChangeNotifier {
  final NotificationService _notificationService;
  final HistoryService _historyService;

  bool _enabled = false;
  bool get enabled => _enabled;

  bool _alertActive = false;
  bool get alertActive => _alertActive;

  MonitoringProvider(
    this._notificationService,
    this._historyService,
  );

  void toggleEnabled() {
    _enabled = !_enabled;
    notifyListeners();
  }

  Future<void> triggerAlert(Preferences preferences) async {
    if (!_enabled) return;

    _alertActive = true;
    notifyListeners();

    final event = AlertEvent(
      type: AlertEventType.panic,
      createdAt: DateTime.now(),
    );
    await _historyService.insertEvent(event);

    if (preferences.criticalMode || preferences.sound || preferences.banner) {
      await _notificationService.showCriticalAlert(
        'Alerta disparado',
        'Um evento de pânico foi registrado.',
      );
    }

    // Simula conclusão do processamento do alerta
    await Future.delayed(const Duration(seconds: 2));
    _alertActive = false;
    notifyListeners();
  }
}