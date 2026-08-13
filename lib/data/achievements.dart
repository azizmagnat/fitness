import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../state/bookings_store.dart';
import '../state/visits_store.dart';

/// What a badge is measured against, so its locked state can be derived from
/// real activity instead of being hard-coded.
enum AchievementMetric { visits, distinctGyms, bookings }

class Achievement {
  final IconData icon;
  final Color color;
  final String title;
  final String description;
  final AchievementMetric metric;
  final int target;
  const Achievement({
    required this.icon,
    required this.color,
    required this.title,
    required this.description,
    required this.metric,
    required this.target,
  });

  int get progress {
    switch (metric) {
      case AchievementMetric.visits:
        return VisitsStore.totalVisits.value;
      case AchievementMetric.distinctGyms:
        return VisitsStore.visitedGyms.value.length;
      case AchievementMetric.bookings:
        return BookingsStore.items.value.length;
    }
  }

  bool get locked => progress < target;
}

const achievements = [
  Achievement(
    icon: Icons.military_tech_rounded,
    color: AppColors.accentAmber,
    title: "Birinchi qadam",
    description: "Birinchi mashg'ulotingizni yakunlang",
    metric: AchievementMetric.visits,
    target: 1,
  ),
  Achievement(
    icon: Icons.handshake_rounded,
    color: AppColors.accentPink,
    title: "Do'stona ruh",
    description: "Birinchi mashg'ulotga yoziling",
    metric: AchievementMetric.bookings,
    target: 1,
  ),
  Achievement(
    icon: Icons.place_rounded,
    color: AppColors.accentGreen,
    title: "Sayohatchi",
    description: "3 xil zalga tashrif buyuring",
    metric: AchievementMetric.distinctGyms,
    target: 3,
  ),
  Achievement(
    icon: Icons.shield_rounded,
    color: AppColors.primary,
    title: "Temir intizom",
    description: "7 ta mashg'ulotni yakunlang",
    metric: AchievementMetric.visits,
    target: 7,
  ),
  Achievement(
    icon: Icons.local_fire_department_rounded,
    color: Color(0xFFEF4444),
    title: "Olov",
    description: "15 ta mashg'ulotni yakunlang",
    metric: AchievementMetric.visits,
    target: 15,
  ),
];
