import 'package:flutter/services.dart';

/// Lightweight feedback using only built-in system sounds/haptics —
/// no bundled audio assets, so nothing to license.
class AppSound {
  static void tap() {
    HapticFeedback.selectionClick();
    SystemSound.play(SystemSoundType.click);
  }

  static void success() {
    HapticFeedback.mediumImpact();
    SystemSound.play(SystemSoundType.click);
  }

  static void error() {
    HapticFeedback.heavyImpact();
  }
}
