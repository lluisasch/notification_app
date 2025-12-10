import 'package:flutter/foundation.dart';

import '../models/alert_event.dart';
import '../services/history_service.dart';

class HistoryProvider extends ChangeNotifier {
  final HistoryService _service;

  List<AlertEvent> _events = [];
  List<AlertEvent> get events => _events;

  HistoryProvider(this._service) {
    load();
  }

  Future<void> load() async {
    _events = await _service.getAllEvents();
    notifyListeners();
  }
}