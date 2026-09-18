import 'package:flutter/material.dart';
import 'core/theme.dart';
import 'features/dashboard/dashboard_screen.dart';
import 'features/services/service_management_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const IncidentPulseApp());
}

class IncidentPulseApp extends StatelessWidget {
  const IncidentPulseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'IncidentPulse - Serverpod Incident Commander',
      debugShowCheckedModeBanner: false,
      theme: IncidentTheme.darkTheme,
      home: const MainNavigationShell(),
    );
  }
}

class MainNavigationShell extends StatefulWidget {
  const MainNavigationShell({super.key});

  @override
  State<MainNavigationShell> createState() => _MainNavigationShellState();
}

class _MainNavigationShellState extends State<MainNavigationShell> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    DashboardScreen(),
    ServiceManagementScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        backgroundColor: IncidentTheme.surface,
        selectedItemColor: IncidentTheme.aiAccent,
        unselectedItemColor: Colors.white38,
        onTap: (idx) => setState(() => _currentIndex = idx),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_rounded),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_input_component_rounded),
            label: 'Services & Webhooks',
          ),
        ],
      ),
    );
  }
}
