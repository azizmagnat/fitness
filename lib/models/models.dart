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
  final int durationMin;
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
    this.durationMin = 0,
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
      durationMin: durationMin,
    );
  }

  static const _months = [
    "yanvar", "fevral", "mart", "aprel", "may", "iyun",
    "iyul", "avgust", "sentabr", "oktabr", "noyabr", "dekabr",
  ];

  /// The session's real start moment, parsed from the "D-oy" date label and
  /// the leading "HH:MM" of [time] (which may be "HH:MM" or "HH:MM, N min").
  /// Assumes the current year, rolling forward a year if that reads as more
  /// than a few days in the past (handles bookings made right at year-end).
  DateTime? get startDateTime {
    final dateParts = date.split('-');
    if (dateParts.length != 2) return null;
    final day = int.tryParse(dateParts[0]);
    final monthIndex = _months.indexOf(dateParts[1]);
    if (day == null || monthIndex == -1) return null;
    final hhmm = time.split(',').first.trim().split(':');
    if (hhmm.length != 2) return null;
    final hour = int.tryParse(hhmm[0]);
    final minute = int.tryParse(hhmm[1]);
    if (hour == null || minute == null) return null;
    final now = DateTime.now();
    var start = DateTime(now.year, monthIndex + 1, day, hour, minute);
    if (start.isBefore(now.subtract(const Duration(days: 3)))) {
      start = DateTime(now.year + 1, monthIndex + 1, day, hour, minute);
    }
    return start;
  }

  DateTime? get endDateTime =>
      durationMin > 0 ? startDateTime?.add(Duration(minutes: durationMin)) : null;

  /// True once this session's scheduled window has fully elapsed.
  bool get isPastSession {
    final end = endDateTime;
    return end != null && DateTime.now().isAfter(end);
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
