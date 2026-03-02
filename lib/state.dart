import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppState extends ChangeNotifier {
  List<Map<String, dynamic>> tasks = [];
  List<Map<String, dynamic>> progress = [];

  int dailyTarget = 3000;
  int addStep = 250;
  int water = 0;

  ThemeMode themeMode = ThemeMode.light;

  AppState() {
    load();
  }

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    tasks = (jsonDecode(prefs.getString('tasks') ?? '[]') as List)
        .cast<Map<String, dynamic>>();
    progress = (jsonDecode(prefs.getString('progress') ?? '[]') as List)
        .cast<Map<String, dynamic>>();
    dailyTarget = prefs.getInt('dailyTarget') ?? 3000;
    addStep = prefs.getInt('addStep') ?? 250;
    water = prefs.getInt('water') ?? 0;
    themeMode =
        ThemeMode.values[prefs.getInt('themeMode') ?? 0];
    notifyListeners();
  }

  Future<void> save() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('tasks', jsonEncode(tasks));
    prefs.setString('progress', jsonEncode(progress));
    prefs.setInt('dailyTarget', dailyTarget);
    prefs.setInt('addStep', addStep);
    prefs.setInt('water', water);
    prefs.setInt('themeMode', themeMode.index);
  }

  void addTask(String title, String category) {
    tasks.add({
      "id": DateTime.now().toString(),
      "title": title,
      "category": category,
      "done": false
    });
    save();
    notifyListeners();
  }

  void toggleTask(String id) {
    final t = tasks.firstWhere((e) => e['id'] == id);
    t['done'] = !t['done'];
    save();
    notifyListeners();
  }

  void deleteTask(String id) {
    tasks.removeWhere((e) => e['id'] == id);
    save();
    notifyListeners();
  }

  void addProgress(String title, String type) {
    progress.add({
      "id": DateTime.now().toString(),
      "title": title,
      "type": type,
      "done": false
    });
    save();
    notifyListeners();
  }

  void toggleProgress(String id) {
    final p = progress.firstWhere((e) => e['id'] == id);
    p['done'] = !p['done'];
    save();
    notifyListeners();
  }

  void deleteProgress(String id) {
    progress.removeWhere((e) => e['id'] == id);
    save();
    notifyListeners();
  }

  void addWater() {
    water += addStep;
    if (water > dailyTarget) water = dailyTarget;
    save();
    notifyListeners();
  }

  void resetWater() {
    water = 0;
    save();
    notifyListeners();
  }

  void changeTarget(int value) {
    dailyTarget = value;
    save();
    notifyListeners();
  }

  void changeStep(int value) {
    addStep = value;
    save();
    notifyListeners();
  }

  void changeTheme(ThemeMode mode) {
    themeMode = mode;
    save();
    notifyListeners();
  }
}