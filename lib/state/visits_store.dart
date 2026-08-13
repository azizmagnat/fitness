import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/mock_data.dart';

/// Tracks how many visits the subscription still allows, per gym and in total
/// for the current cycle. Persisted locally — this prototype has no backend,
/// so the whole limit system lives on the device.
///
/// When a gym's allowance is fully spent the cycle rolls over immediately:
/// the counter refills to the gym's maximum and [lastRollover] is set so the
/// UI can tell the user their limit renewed. That mirrors the "limit tugagach
/// qayta to'ladi" behaviour requested for this build.
class VisitsStore {
  VisitsStore._();

  /// gymName -> visits still available in the current cycle.
  static final ValueNotifier<Map<String, int>> remaining = ValueNotifier<Map<String, int>>({});

  /// Total visits used across all gyms since install (never resets — feeds
  /// the profile's "Barcha mashg'ulotlar soni" stat).
  static final ValueNotifier<int> totalVisits = ValueNotifier(0);

  /// Distinct gyms the user has actually checked in at.
  static final ValueNotifier<Set<String>> visitedGyms = ValueNotifier<Set<String>>({});

  /// Set to the gym name whenever its allowance just rolled over, so the
  /// confirmation screen can show "limit yangilandi". Cleared after reading.
  static final ValueNotifier<String?> lastRollover = ValueNotifier(null);

  static const _kRemaining = "visits_remaining";
  static const _kTotal = "visits_total_count";
  static const _kVisited = "visits_gyms";

  static bool _loaded = false;

  /// Full allowance for a gym, taken from its subscription plan in mock data.
  static int maxFor(String gymName) {
    final gym = MockData.allGyms.where((g) => g.name == gymName).firstOrNull;
    final planned = gym?.visitsUsed ?? 0; // visitsUsed holds the plan size
    return planned > 0 ? planned : 12;
  }

  static Future<void> load() async {
    if (_loaded) return;
    _loaded = true;
    final prefs = await SharedPreferences.getInstance();

    final raw = prefs.getString(_kRemaining);
    final map = <String, int>{};
    if (raw != null) {
      final decoded = jsonDecode(raw) as Map<String, dynamic>;
      decoded.forEach((k, v) => map[k] = (v as num).toInt());
    }
    // Seed any gym we don't have a counter for yet with its full allowance.
    for (final gym in MockData.allGyms) {
      map.putIfAbsent(gym.name, () => maxFor(gym.name));
    }
    remaining.value = map;

    totalVisits.value = prefs.getInt(_kTotal) ?? 0;
    visitedGyms.value = (prefs.getStringList(_kVisited) ?? []).toSet();
  }

  static int remainingFor(String gymName) => remaining.value[gymName] ?? maxFor(gymName);

  /// True while the gym still has visits left this cycle.
  static bool canVisit(String gymName) => remainingFor(gymName) > 0;

  /// Spends one visit at [gymName]. Refills the allowance when it runs out so
  /// the user is never permanently locked out, and records the visit in the
  /// lifetime stats.
  static Future<void> consume(String gymName) async {
    await load();
    final map = Map<String, int>.from(remaining.value);
    final left = (map[gymName] ?? maxFor(gymName)) - 1;

    if (left <= 0) {
      map[gymName] = maxFor(gymName);
      lastRollover.value = gymName;
    } else {
      map[gymName] = left;
    }
    remaining.value = map;

    totalVisits.value = totalVisits.value + 1;
    visitedGyms.value = {...visitedGyms.value, gymName};

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kRemaining, jsonEncode(map));
    await prefs.setInt(_kTotal, totalVisits.value);
    await prefs.setStringList(_kVisited, visitedGyms.value.toList());
  }

  /// Manually refills every gym's allowance (used by "Abonementni yangilash").
  static Future<void> resetAll() async {
    final map = <String, int>{};
    for (final gym in MockData.allGyms) {
      map[gym.name] = maxFor(gym.name);
    }
    remaining.value = map;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kRemaining, jsonEncode(map));
  }

  static String? takeRollover() {
    final value = lastRollover.value;
    lastRollover.value = null;
    return value;
  }
}
