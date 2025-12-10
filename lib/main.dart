import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/app_routes.dart';
import 'services/notification_service.dart';
import 'services/preferences_service.dart';
import 'services/history_service.dart';
import 'providers/monitoring_provider.dart';
import 'providers/preferences_provider.dart';
import 'providers/history_provider.dart';
import 'screens/dashboard_screen.dart';
import 'screens/preferences_screen.dart';
import 'screens/history_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService().init();

  runApp(const MonitoringApp());
}

class MonitoringApp extends StatelessWidget {
  const MonitoringApp({super.key});

  @override
  Widget build(BuildContext context) {
    final notificationService = NotificationService();
    final preferencesService = PreferencesService();
    final historyService = HistoryService();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => PreferencesProvider(preferencesService),
        ),
        ChangeNotifierProvider(
          create: (_) => MonitoringProvider(notificationService, historyService),
        ),
        ChangeNotifierProvider(
          create: (_) => HistoryProvider(historyService),
        ),
      ],
      child: MaterialApp(
        title: 'Monitoramento & Alertas',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
          useMaterial3: true,
        ),
        initialRoute: AppRoutes.dashboard,
        routes: {
          AppRoutes.dashboard: (_) => const DashboardScreen(),
          AppRoutes.preferences: (_) => const PreferencesScreen(),
          AppRoutes.history: (_) => const HistoryScreen(),
        },
      ),
    );
  }
}

