import 'package:flutter/material.dart';
import '../models/models.dart';
import 'visits_store.dart';

/// Holds the user's actual bookings made through the app (Jadval tab).
/// Starts empty — no demo/seed entries — and only ever contains items the
/// user booked via the "Yozilish" flow, so Jadval reflects real state.
class BookingsStore {
  BookingsStore._();

  static final ValueNotifier<List<ScheduleItem>> items = ValueNotifier<List<ScheduleItem>>([]);

  static void add(ScheduleItem item) {
    items.value = [item, ...items.value];
  }

  /// Marks the first matching upcoming booking (by title+gym+date+time) as
  /// confirmed after a successful QR/face check-in, and spends one visit from
  /// the gym's subscription allowance.
  static void markConfirmed(ScheduleItem item) {
    var consumed = false;
    items.value = items.value.map((it) {
      final matches = it.title == item.title && it.gymName == item.gymName && it.time == item.time;
      if (matches && it.status != "Tasdiqlandi") {
        consumed = true;
        return it.copyWith(status: "Tasdiqlandi", needsConfirmation: false);
      }
      return it;
    }).toList();

    // Check-ins done straight from a gym page (no prior booking row) still
    // count against the allowance, so fall back to consuming unconditionally.
    if (!consumed) consumed = true;
    if (consumed) VisitsStore.consume(item.gymName);
  }

  /// Cancels a booking the user no longer wants.
  static void cancel(ScheduleItem item) {
    items.value = items.value
        .where((it) => !(it.title == item.title && it.gymName == item.gymName && it.time == item.time))
        .toList();
  }
}
