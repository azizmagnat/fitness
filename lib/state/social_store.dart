import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Locally-stored social handles shown on the profile ("Instagram", "TikTok").
/// No real OAuth — this app has no backend to authenticate against, so
/// "connecting" simply records the handle the user typed, same as the rest
/// of this prototype's locally-simulated state.
class SocialStore {
  SocialStore._();

  static final ValueNotifier<String?> instagram = ValueNotifier(null);
  static final ValueNotifier<String?> tiktok = ValueNotifier(null);

  static bool _loaded = false;

  static Future<void> load() async {
    if (_loaded) return;
    _loaded = true;
    final prefs = await SharedPreferences.getInstance();
    instagram.value = prefs.getString("social_instagram");
    tiktok.value = prefs.getString("social_tiktok");
  }

  static Future<void> setInstagram(String? handle) async {
    instagram.value = (handle == null || handle.trim().isEmpty) ? null : handle.trim();
    final prefs = await SharedPreferences.getInstance();
    if (instagram.value == null) {
      await prefs.remove("social_instagram");
    } else {
      await prefs.setString("social_instagram", instagram.value!);
    }
  }

  static Future<void> setTiktok(String? handle) async {
    tiktok.value = (handle == null || handle.trim().isEmpty) ? null : handle.trim();
    final prefs = await SharedPreferences.getInstance();
    if (tiktok.value == null) {
      await prefs.remove("social_tiktok");
    } else {
      await prefs.setString("social_tiktok", tiktok.value!);
    }
  }
}
