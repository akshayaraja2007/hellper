import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'state.dart';

class ChartsPage extends StatelessWidget {
  const ChartsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();

    final personalDone = state.tasks
        .where((e) => e['category'] == 'personal' && e['done'] == true)
        .length;

    final collegeDone = state.tasks
        .where((e) => e['category'] == 'college' && e['done'] == true)
        .length;

    final physicalDone = state.progress
        .where((e) => e['type'] == 'physical' && e['done'] == true)
        .length;

    final mentalDone = state.progress
        .where((e) => e['type'] == 'mental' && e['done'] == true)
        .length;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Analytics"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _chartCard(
              title: "Task Distribution",
              sections: _buildSections(
                personalDone,
                collegeDone,
                Colors.deepPurple,
                Colors.blue,
              ),
              labels: [
                "Personal: $personalDone",
                "College: $collegeDone"
              ],
            ),
            const SizedBox(height: 20),
            _chartCard(
              title: "Progress Distribution",
              sections: _buildSections(
                physicalDone,
                mentalDone,
                Colors.green,
                Colors.orange,
              ),
              labels: [
                "Physical: $physicalDone",
                "Mental: $mentalDone"
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _chartCard({
    required String title,
    required List<PieChartSectionData> sections,
    required List<String> labels,
  }) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              title,
              style: const TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 200,
              child: PieChart(
                PieChartData(
                  sections: sections,
                  sectionsSpace: 3,
                  centerSpaceRadius: 40,
                ),
                swapAnimationDuration:
                    const Duration(milliseconds: 300),
              ),
            ),
            const SizedBox(height: 20),
            Column(
              children: labels
                  .map((e) => Padding(
                        padding:
                            const EdgeInsets.symmetric(vertical: 4),
                        child: Text(
                          e,
                          style: const TextStyle(
                              fontWeight: FontWeight.w500),
                        ),
                      ))
                  .toList(),
            )
          ],
        ),
      ),
    );
  }

  List<PieChartSectionData> _buildSections(
      int value1,
      int value2,
      Color color1,
      Color color2) {
    final total = value1 + value2;

    if (total == 0) {
      return [
        PieChartSectionData(
          value: 1,
          color: Colors.grey.shade300,
          showTitle: false,
        )
      ];
    }

    return [
      PieChartSectionData(
        value: value1.toDouble(),
        color: color1,
        radius: 60,
        title: "",
      ),
      PieChartSectionData(
        value: value2.toDouble(),
        color: color2,
        radius: 60,
        title: "",
      ),
    ];
  }
}