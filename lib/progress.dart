import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'state.dart';

class ProgressPage extends StatelessWidget {
  const ProgressPage({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();

    final physical = state.progress
        .where((e) => e['type'] == 'physical')
        .toList();

    final mental = state.progress
        .where((e) => e['type'] == 'mental')
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Self Progress"),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _progressDialog(context),
        child: const Icon(Icons.add),
      ),
      body: state.progress.isEmpty
          ? const Center(child: Text("No progress added"))
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _sectionTitle("PHYSICAL"),
                const SizedBox(height: 10),
                ...physical.map((item) =>
                    _progressCard(context, item)),
                const SizedBox(height: 20),
                _sectionTitle("MENTAL"),
                const SizedBox(height: 10),
                ...mental.map((item) =>
                    _progressCard(context, item)),
              ],
            ),
    );
  }

  Widget _sectionTitle(String title) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1E3A8A), Color(0xFF9333EA)],
        ),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _progressCard(
      BuildContext context, Map<String, dynamic> item) {
    final state = context.read<AppState>();

    return Dismissible(
      key: Key(item['id']),
      direction: DismissDirection.horizontal,
      onDismissed: (_) =>
          state.deleteProgress(item['id']),
      background: _deleteBackground(true),
      secondaryBackground: _deleteBackground(false),
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF4338CA), Color(0xFF7C3AED)],
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: ListTile(
          leading: Checkbox(
            value: item['done'],
            onChanged: (_) =>
                state.toggleProgress(item['id']),
            activeColor: Colors.white,
            checkColor: Colors.deepPurple,
          ),
          title: Text(
            item['title'],
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              decoration: item['done']
                  ? TextDecoration.lineThrough
                  : null,
            ),
          ),
          trailing: IconButton(
            icon:
                const Icon(Icons.edit, color: Colors.white),
            onPressed: () =>
                _progressDialog(context, item),
          ),
        ),
      ),
    );
  }

  Widget _deleteBackground(bool left) {
    return Container(
      alignment:
          left ? Alignment.centerLeft : Alignment.centerRight,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Icon(
        Icons.delete,
        color: Colors.white,
      ),
    );
  }

  void _progressDialog(BuildContext context,
      [Map<String, dynamic>? item]) {
    final state = context.read<AppState>();
    final controller =
        TextEditingController(text: item?['title'] ?? "");
    String type = item?['type'] ?? "physical";

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Text(
            item == null ? "Add Progress" : "Edit Progress"),
        content: StatefulBuilder(
          builder: (context, setStateDialog) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: controller,
                  decoration: const InputDecoration(
                    labelText: "Progress Title",
                  ),
                ),
                const SizedBox(height: 12),
                DropdownButton<String>(
                  value: type,
                  isExpanded: true,
                  items: const [
                    DropdownMenuItem(
                        value: "physical",
                        child: Text("Physical")),
                    DropdownMenuItem(
                        value: "mental",
                        child: Text("Mental")),
                  ],
                  onChanged: (val) {
                    setStateDialog(() {
                      type = val ?? "physical";
                    });
                  },
                ),
              ],
            );
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.text.trim().isEmpty) return;

              if (item == null) {
                state.addProgress(
                    controller.text.trim(), type);
              } else {
                item['title'] =
                    controller.text.trim();
                item['type'] = type;
                state.save();
                state.notifyListeners();
              }

              Navigator.pop(context);
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }
}