import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'state.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();

    final completedProgress =
        state.progress.where((e) => e['done'] == true).length;

    final totalProgress = state.progress.length;

    final double health = totalProgress == 0
        ? 0.0
        : completedProgress / totalProgress;

    final personalDone = state.tasks
        .where((e) => e['category'] == 'personal' && e['done'] == true)
        .length;

    final collegeDone = state.tasks
        .where((e) => e['category'] == 'college' && e['done'] == true)
        .length;

    final totalTasks = state.tasks.length;

    final double workPercent = totalTasks == 0
        ? 0.0
        : (personalDone + collegeDone) / totalTasks;

    final double waterPercent =
        state.dailyTarget == 0 ? 0.0 : state.water / state.dailyTarget;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _header(context),
              const SizedBox(height: 20),
              _healthCard(health),
              const SizedBox(height: 20),
              _workCard(workPercent),
              const SizedBox(height: 20),
              _waterCard(context, waterPercent),
            ],
          ),
        ),
      ),
    );
  }

  Widget _header(BuildContext context) {
    final state = context.read<AppState>();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF4338CA), Color(0xFF7C3AED)],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "HELLPER",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (_) => Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListTile(
                      title: const Text("Light"),
                      onTap: () => state.changeTheme(ThemeMode.light),
                    ),
                    ListTile(
                      title: const Text("Dark"),
                      onTap: () => state.changeTheme(ThemeMode.dark),
                    ),
                    ListTile(
                      title: const Text("System"),
                      onTap: () => state.changeTheme(ThemeMode.system),
                    ),
                  ],
                ),
              );
            },
          )
        ],
      ),
    );
  }

  Widget _healthCard(double health) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text(
              "Health",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 120,
              width: 120,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0, end: health),
                    duration: const Duration(milliseconds: 300),
                    builder: (context, value, _) {
                      return CircularProgressIndicator(
                        value: value,
                        strokeWidth: 12,
                      );
                    },
                  ),
                  Text(
                    "${(health * 100).toInt()}%",
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _workCard(double percent) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text(
              "Work",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: percent),
              duration: const Duration(milliseconds: 300),
              builder: (context, value, _) {
                return LinearProgressIndicator(
                  value: value,
                  minHeight: 12,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _waterCard(BuildContext context, double percent) {
    final state = context.read<AppState>();

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text(
              "Water Intake",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Container(
              height: 120,
              width: 200,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  height: 120 * percent,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF22D3EE), Color(0xFF3B82F6)],
                    ),
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(20),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text("${state.water}/${state.dailyTarget} ml"),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _selectTarget(context),
                    child: Text("${state.dailyTarget} ml"),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      state.addWater();
                    },
                    child: Text("+${state.addStep} ml"),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: state.resetWater,
              child: const Text("Reset"),
            )
          ],
        ),
      ),
    );
  }

  void _selectTarget(BuildContext context) {
    final state = context.read<AppState>();

    showModalBottomSheet(
      context: context,
      builder: (_) {
        int temp = state.dailyTarget;

        return StatefulBuilder(
          builder: (context, setStateSheet) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Target: $temp ml"),
                  Slider(
                    min: 1000,
                    max: 5000,
                    divisions: 8,
                    value: temp.toDouble(),
                    onChanged: (value) {
                      setStateSheet(() {
                        temp = value.toInt();
                      });
                    },
                  ),
                  ElevatedButton(
                    onPressed: () {
                      state.changeTarget(temp);
                      Navigator.pop(context);
                    },
                    child: const Text("Save"),
                  )
                ],
              ),
            );
          },
        );
      },
    );
  }
}