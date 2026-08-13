import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/mock_data.dart';

/// Which gyms the user has bookmarked. Persisted locally so the Saqlangan tab
/// and the bookmark button on a gym page always agree with each other.
class SavedStore {
  SavedStore._();

  static final ValueNotifier<Set<String>> saved = ValueNotifier<Set<String>>({});

  static const _key = "saved_gyms";
  static bool _loaded = false;

  static Future<void> load() async {
    if (_loaded) return;
    _loaded = true;
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getStringList(_key);
    // First run: everything in the catalogue starts bookmarked, matching the
    // seeded "Saqlangan" list the app ships with.
    saved.value = stored?.toSet() ?? MockData.allGyms.map((g) => g.name).toSet();
  }

  static bool isSaved(String gymName) => saved.value.contains(gymName);

  static Future<bool> toggle(String gymName) async {
    final next = Set<String>.from(saved.value);
    final nowSaved = !next.contains(gymName);
    if (nowSaved) {
      next.add(gymName);
    } else {
      next.remove(gymName);
    }
    saved.value = next;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_key, next.toList());
    return nowSaved;
  }
}
