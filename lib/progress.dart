import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'state.dart';

class ProgressPage extends StatelessWidget {
  const ProgressPage({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();

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
          ? const Center(
              child: Text("No progress added"))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.progress.length,
              itemBuilder: (context, index) {
                final item = state.progress[index];

                return Dismissible(
                  key: Key(item['id']),
                  onDismissed: (_) =>
                      state.deleteProgress(item['id']),
                  background: Container(
                    color: Colors.red,
                    alignment:
                        Alignment.centerLeft,
                    padding:
                        const EdgeInsets.all(16),
                    child: const Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                  ),
                  child: Card(
                    margin: const EdgeInsets.only(
                        bottom: 14),
                    child: ListTile(
                      leading: Checkbox(
                        value: item['done'],
                        onChanged: (_) =>
                            state.toggleProgress(
                                item['id']),
                      ),
                      title: Text(
                        item['title'],
                        style: TextStyle(
                          decoration: item['done']
                              ? TextDecoration
                                  .lineThrough
                              : null,
                        ),
                      ),
                      subtitle:
                          Text(item['type']),
                      trailing: IconButton(
                        icon:
                            const Icon(Icons.edit),
                        onPressed: () =>
                            _progressDialog(
                                context, item),
                      ),
                    ),
                  ),
                );
              },
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
        title: Text(item == null
            ? "Add Progress"
            : "Edit Progress"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: controller,
              decoration:
                  const InputDecoration(labelText: "Title"),
            ),
            const SizedBox(height: 10),
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
                type = val ?? "physical";
              },
            )
          ],
        ),
        actions: [
          TextButton(
              onPressed: () =>
                  Navigator.pop(context),
              child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () {
              if (controller.text.trim().isEmpty)
                return;

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
          )
        ],
      ),
    );
  }
}