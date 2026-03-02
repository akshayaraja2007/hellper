import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'state.dart';
import 'dashboard.dart';
import 'tasks.dart';
import 'progress.dart';
import 'charts.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => AppState(),
      child: const Hellper(),
    ),
  );
}

class Hellper extends StatelessWidget {
  const Hellper({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: state.themeMode,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.deepPurple,
      ),
      darkTheme: ThemeData.dark(useMaterial3: true),
      home: const Root(),
    );
  }
}

class Root extends StatefulWidget {
  const Root({super.key});

  @override
  State<Root> createState() => _RootState();
}

class _RootState extends State<Root> {
  int index = 0;

  final pages = const [
    DashboardPage(),
    TasksPage(),
    ProgressPage(),
    ChartsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[index],
      bottomNavigationBar: NavigationBar(
        selectedIndex: index,
        onDestinationSelected: (i) => setState(() => index = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: "Home"),
          NavigationDestination(icon: Icon(Icons.check), label: "Tasks"),
          NavigationDestination(icon: Icon(Icons.trending_up), label: "Progress"),
          NavigationDestination(icon: Icon(Icons.bar_chart), label: "Charts"),
        ],
      ),
    );
  }
}