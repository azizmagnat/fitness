import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart';

/// Feedback via built-in system sounds/haptics, plus a short success chime
/// (assets/sounds/success.m4a — user-provided, AI-generated, not sampled
/// from any third-party app) played once at the visit-confirmation moment.
class AppSound {
  static final AudioPlayer _player = AudioPlayer()..setReleaseMode(ReleaseMode.stop);

  static void tap() {
    HapticFeedback.selectionClick();
    SystemSound.play(SystemSoundType.click);
  }

  static void success() {
    HapticFeedback.mediumImpact();
    _player.play(AssetSource('sounds/success.m4a'));
  }

  static void error() {
    HapticFeedback.heavyImpact();
  }
}
