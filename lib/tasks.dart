import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'state.dart';

class TasksPage extends StatelessWidget {
  const TasksPage({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Today Tasks"),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _taskDialog(context),
        child: const Icon(Icons.add),
      ),
      body: state.tasks.isEmpty
          ? const Center(child: Text("No tasks added"))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.tasks.length,
              itemBuilder: (context, index) {
                final task = state.tasks[index];

                return Dismissible(
                  key: Key(task['id']),
                  onDismissed: (_) =>
                      state.deleteTask(task['id']),
                  background: _deleteBackground(),
                  child: _taskCard(context, task),
                );
              },
            ),
    );
  }

  Widget _taskCard(
      BuildContext context, Map<String, dynamic> task) {
    final state = context.read<AppState>();

    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        leading: Checkbox(
          value: task['done'],
          onChanged: (_) =>
              state.toggleTask(task['id']),
        ),
        title: Text(
          task['title'],
          style: TextStyle(
            decoration: task['done']
                ? TextDecoration.lineThrough
                : null,
          ),
        ),
        subtitle: Text(task['category']),
        trailing: IconButton(
          icon: const Icon(Icons.edit),
          onPressed: () =>
              _taskDialog(context, task),
        ),
      ),
    );
  }

  Widget _deleteBackground() {
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      color: Colors.red,
      child:
          const Icon(Icons.delete, color: Colors.white),
    );
  }

  void _taskDialog(BuildContext context,
      [Map<String, dynamic>? task]) {
    final state = context.read<AppState>();
    final controller =
        TextEditingController(text: task?['title'] ?? "");
    String category = task?['category'] ?? "personal";

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(
            task == null ? "Add Task" : "Edit Task"),
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
              value: category,
              isExpanded: true,
              items: const [
                DropdownMenuItem(
                    value: "personal",
                    child: Text("Personal")),
                DropdownMenuItem(
                    value: "college",
                    child: Text("College")),
              ],
              onChanged: (val) {
                category = val ?? "personal";
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

              if (task == null) {
                state.addTask(
                    controller.text.trim(), category);
              } else {
                task['title'] =
                    controller.text.trim();
                task['category'] = category;
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