import 'package:flutter/material.dart';

/// Purely local subscription state — this prototype has no payment backend,
/// so "purchase" and "freeze" just flip a local flag, mirroring how bookings
/// are simulated elsewhere in the app. No real money ever moves.
class SubscriptionStore {
  SubscriptionStore._();

  static final ValueNotifier<bool> frozen = ValueNotifier(false);
  static final ValueNotifier<String?> lastPurchase = ValueNotifier(null);
  static final ValueNotifier<List<String>> purchaseHistory = ValueNotifier<List<String>>([]);

  static void toggleFrozen() => frozen.value = !frozen.value;

  static void recordPurchase(String label) {
    lastPurchase.value = label;
    purchaseHistory.value = [label, ...purchaseHistory.value];
  }
}
