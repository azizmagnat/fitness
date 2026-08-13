import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// App-wide profile store (display name + local photo path) backed by
/// SharedPreferences, so editing it in Profile has a real, persisted effect
/// everywhere the name/avatar is shown.
class UserProfile {
  UserProfile._();

  static final ValueNotifier<String> name = ValueNotifier("aziz.magnat");
  static final ValueNotifier<String?> photoPath = ValueNotifier(null);
  static final ValueNotifier<String> bio = ValueNotifier("");

  static bool _loaded = false;

  static Future<void> load() async {
    if (_loaded) return;
    _loaded = true;
    final prefs = await SharedPreferences.getInstance();
    name.value = prefs.getString("profile_name") ?? "aziz.magnat";
    photoPath.value = prefs.getString("profile_photo_path");
    bio.value = prefs.getString("profile_bio") ?? "";
  }

  static Future<void> setName(String value) async {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return;
    name.value = trimmed;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("profile_name", trimmed);
  }

  static Future<void> setBio(String value) async {
    final trimmed = value.trim();
    bio.value = trimmed;
    final prefs = await SharedPreferences.getInstance();
    if (trimmed.isEmpty) {
      await prefs.remove("profile_bio");
    } else {
      await prefs.setString("profile_bio", trimmed);
    }
  }

  static Future<void> setPhotoPath(String? path) async {
    photoPath.value = path;
    final prefs = await SharedPreferences.getInstance();
    if (path == null) {
      await prefs.remove("profile_photo_path");
    } else {
      await prefs.setString("profile_photo_path", path);
    }
  }

  static Future<void> resetToDefault() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("profile_name");
    await prefs.remove("profile_photo_path");
    await prefs.remove("profile_bio");
    name.value = "aziz.magnat";
    photoPath.value = null;
    bio.value = "";
  }

  static String get initial => name.value.isNotEmpty ? name.value[0].toUpperCase() : "?";

  static String get firstName {
    final n = name.value;
    final cut = n.indexOf(RegExp(r'[.\s_]'));
    return cut > 0 ? n.substring(0, cut) : n;
  }
}
