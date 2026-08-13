import 'package:flutter/material.dart';

class StoryItem {
  final String name;
  final String imageUrl;
  final bool isAdd;
  final bool viewed;
  const StoryItem({
    required this.name,
    required this.imageUrl,
    this.isAdd = false,
    this.viewed = false,
  });
}

class QuickAction {
  final String label;
  final bool hasBadge;
  const QuickAction(this.label, {this.hasBadge = false});
}

class GamePrize {
  final String title;
  final String subtitle;
  final String daysLeft;
  final IconData icon;
  const GamePrize({
    required this.title,
    required this.subtitle,
    required this.daysLeft,
    required this.icon,
  });
}

class TimeSlot {
  final String time;
  final int seatsLeft;
  final bool ended;
  const TimeSlot(this.time, this.seatsLeft, {this.ended = false});
}

class WorkoutSession {
  final String title;
  final int durationMin;
  final String restriction;
  final List<TimeSlot> slots;
  const WorkoutSession({
    required this.title,
    required this.durationMin,
    this.restriction = "",
    required this.slots,
  });
}

class Gym {
  final String name;
  final double rating;
  final String address;
  final String category;
  final List<String> tags;
  final String description;
  final int visitsUsed;
  final int visitsTotal;
  final List<(String, double)> ratingBreakdown;
  final List<(String, bool)> amenities;
  final List<WorkoutSession> sessions;
  final List<String> photoAssets;
  final String? phone;
  final String? metro;
  final Color metroColor;
  final String? distance;
  final double? lat;
  final double? lng;
  const Gym({
    required this.name,
    required this.rating,
    required this.address,
    required this.category,
    this.tags = const [],
    this.description = "",
    this.visitsUsed = 0,
    this.visitsTotal = 0,
    this.ratingBreakdown = const [],
    this.amenities = const [],
    this.sessions = const [],
    this.photoAssets = const [],
    this.phone,
    this.metro,
    this.metroColor = const Color(0xFFE11D48),
    this.distance,
    this.lat,
    this.lng,
  });

  bool get hasLocation => lat != null && lng != null;
}

class ScheduleItem {
  final String title;
  final String gymName;
  final String date;
  final String time;
  final String status;
  final bool needsConfirmation;
  final double rating;
  final String address;
  final String distanceKm;
  final String restriction;
  final String alertText;
  const ScheduleItem({
    required this.title,
    required this.gymName,
    required this.date,
    required this.time,
    required this.status,
    this.needsConfirmation = false,
    this.rating = 0,
    this.address = "",
    this.distanceKm = "",
    this.restriction = "",
    this.alertText = "",
  });

  ScheduleItem copyWith({String? status, bool? needsConfirmation}) {
    return ScheduleItem(
      title: title,
      gymName: gymName,
      date: date,
      time: time,
      status: status ?? this.status,
      needsConfirmation: needsConfirmation ?? this.needsConfirmation,
      rating: rating,
      address: address,
      distanceKm: distanceKm,
      restriction: restriction,
      alertText: alertText,
    );
  }
}

class SearchCategory {
  final String label;
  final String count;
  final IconData icon;
  final String? emoji;
  const SearchCategory({required this.label, required this.count, required this.icon, this.emoji});
}

class SubscriptionPlan {
  final String title;
  final String? discountBadge;
  final String price;
  final String? oldPrice;
  final List<Color> gradient;
  const SubscriptionPlan({
    required this.title,
    this.discountBadge,
    required this.price,
    this.oldPrice,
    required this.gradient,
  });
}
