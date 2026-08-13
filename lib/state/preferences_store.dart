import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Local, persisted user preferences (city, address, goal, favorite workout
/// categories, privacy/feed toggles). No backend — this is the same
/// SharedPreferences pattern used by UserProfile/SocialStore.
class PreferencesStore {
  PreferencesStore._();

  static final ValueNotifier<String?> city = ValueNotifier(null);
  static final ValueNotifier<String?> address = ValueNotifier(null);
  static final ValueNotifier<String?> goal = ValueNotifier(null);
  static final ValueNotifier<List<String>> favoriteCategories = ValueNotifier<List<String>>([]);

  static final ValueNotifier<bool> profilePublic = ValueNotifier(true);
  static final ValueNotifier<bool> showActivity = ValueNotifier(true);
  static final ValueNotifier<bool> shareLocation = ValueNotifier(false);

  static final ValueNotifier<bool> feedAutoplay = ValueNotifier(true);
  static final ValueNotifier<bool> storyNotifications = ValueNotifier(true);
  static final ValueNotifier<bool> feedRecommendations = ValueNotifier(true);

  static bool _loaded = false;

  static Future<void> load() async {
    if (_loaded) return;
    _loaded = true;
    final prefs = await SharedPreferences.getInstance();
    city.value = prefs.getString("pref_city");
    address.value = prefs.getString("pref_address");
    goal.value = prefs.getString("pref_goal");
    favoriteCategories.value = prefs.getStringList("pref_favorite_categories") ?? [];
    profilePublic.value = prefs.getBool("pref_profile_public") ?? true;
    showActivity.value = prefs.getBool("pref_show_activity") ?? true;
    shareLocation.value = prefs.getBool("pref_share_location") ?? false;
    feedAutoplay.value = prefs.getBool("pref_feed_autoplay") ?? true;
    storyNotifications.value = prefs.getBool("pref_story_notifications") ?? true;
    feedRecommendations.value = prefs.getBool("pref_feed_recommendations") ?? true;
  }

  static Future<void> setCity(String? value) async {
    city.value = value;
    final prefs = await SharedPreferences.getInstance();
    if (value == null) {
      await prefs.remove("pref_city");
    } else {
      await prefs.setString("pref_city", value);
    }
  }

  static Future<void> setAddress(String? value) async {
    address.value = (value == null || value.trim().isEmpty) ? null : value.trim();
    final prefs = await SharedPreferences.getInstance();
    if (address.value == null) {
      await prefs.remove("pref_address");
    } else {
      await prefs.setString("pref_address", address.value!);
    }
  }

  static Future<void> setGoal(String? value) async {
    goal.value = value;
    final prefs = await SharedPreferences.getInstance();
    if (value == null) {
      await prefs.remove("pref_goal");
    } else {
      await prefs.setString("pref_goal", value);
    }
  }

  static Future<void> toggleFavoriteCategory(String label) async {
    final list = List<String>.of(favoriteCategories.value);
    if (list.contains(label)) {
      list.remove(label);
    } else {
      list.add(label);
    }
    favoriteCategories.value = list;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList("pref_favorite_categories", list);
  }

  static Future<void> _setBool(String key, ValueNotifier<bool> notifier, bool value) async {
    notifier.value = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }

  static Future<void> setProfilePublic(bool v) => _setBool("pref_profile_public", profilePublic, v);
  static Future<void> setShowActivity(bool v) => _setBool("pref_show_activity", showActivity, v);
  static Future<void> setShareLocation(bool v) => _setBool("pref_share_location", shareLocation, v);
  static Future<void> setFeedAutoplay(bool v) => _setBool("pref_feed_autoplay", feedAutoplay, v);
  static Future<void> setStoryNotifications(bool v) => _setBool("pref_story_notifications", storyNotifications, v);
  static Future<void> setFeedRecommendations(bool v) => _setBool("pref_feed_recommendations", feedRecommendations, v);
}
