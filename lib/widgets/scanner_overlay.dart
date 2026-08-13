import 'dart:math' as math;
import 'dart:ui';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

/// Colors shared across the QR-then-face scan flow and the visit-confirmed
/// celebration that immediately follows it, sampled from the original app's
/// recording. Centralized here (rather than duplicated per-screen) since
/// qr_scan_screen.dart, face_scan_screen.dart, and visit_confirmed_screen.dart
/// all already import this file.
class ScannerColors {
  ScannerColors._();
  static const accent = Color(0xFF2F62E8); // face-scan ring / confetti "blue"
  static const flipIcon = Color(0xFF4A4A55); // camera-flip button icon
  static const manualConfirm = Color(0xFF726EF0); // "Qo'lda tasdiqlash" fallback link
}

/// Blurs+dims the full screen except a centered circular or rounded-rect
/// cutout, matching the original 1Fit app's "frosted glass" scanner look:
/// sharp/clear inside the frame, softly blurred camera feed outside it.
class ScannerBlurMask extends StatelessWidget {
  final double frameSize;
  final bool circle;
  final double borderRadius;
  final double sigma;

  /// Vertical center of the cutout as a fraction of screen height. The
  /// original places both the QR frame and the face ring slightly above the
  /// middle of the screen, not dead center.
  final double centerYFraction;
  const ScannerBlurMask({
    super.key,
    required this.frameSize,
    this.circle = false,
    this.borderRadius = 20,
    this.sigma = 18,
    this.centerYFraction = 0.5,
  });

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: ClipPath(
        clipper: _OutsideCutoutClipper(
          frameSize: frameSize,
          circle: circle,
          borderRadius: borderRadius,
          centerYFraction: centerYFraction,
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: sigma, sigmaY: sigma),
          child: Container(color: Colors.black.withValues(alpha: 0.35)),
        ),
      ),
    );
  }
}

class _OutsideCutoutClipper extends CustomClipper<Path> {
  final double frameSize;
  final bool circle;
  final double borderRadius;
  final double centerYFraction;
  _OutsideCutoutClipper({
    required this.frameSize,
    required this.circle,
    required this.borderRadius,
    required this.centerYFraction,
  });

  @override
  Path getClip(Size size) {
    final center = Offset(size.width / 2, size.height * centerYFraction);
    final rect = Rect.fromCenter(center: center, width: frameSize, height: frameSize);
    final outer = Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height));
    final inner = Path();
    if (circle) {
      inner.addOval(rect);
    } else {
      inner.addRRect(RRect.fromRectAndRadius(rect, Radius.circular(borderRadius)));
    }
    return Path.combine(PathOperation.difference, outer, inner);
  }

  @override
  bool shouldReclip(covariant _OutsideCutoutClipper oldClipper) =>
      oldClipper.frameSize != frameSize ||
      oldClipper.circle != circle ||
      oldClipper.borderRadius != borderRadius ||
      oldClipper.centerYFraction != centerYFraction;
}

/// A ring of thick radial dashes, matching the original app's face-scan
/// frame: all dashes vivid blue with a pale highlight arc that sweeps
/// around while scanning ([highlightAngle], radians). When [allLit] the
/// whole ring renders solid blue (the confirmed state).
class DashedProgressRing extends StatelessWidget {
  final double size;
  final Color color;
  final int dashCount;
  final double dashLength;
  final double strokeWidth;
  final double? highlightAngle;
  final bool allLit;
  const DashedProgressRing({
    super.key,
    required this.size,
    required this.color,
    this.dashCount = 56,
    this.dashLength = 20,
    this.strokeWidth = 5.5,
    this.highlightAngle,
    this.allLit = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _DashedRingPainter(
          color: color,
          dashCount: dashCount,
          dashLength: dashLength,
          strokeWidth: strokeWidth,
          highlightAngle: highlightAngle,
          allLit: allLit,
        ),
      ),
    );
  }
}

class _DashedRingPainter extends CustomPainter {
  final Color color;
  final int dashCount;
  final double dashLength;
  final double strokeWidth;
  final double? highlightAngle;
  final bool allLit;
  _DashedRingPainter({
    required this.color,
    required this.dashCount,
    required this.dashLength,
    required this.strokeWidth,
    required this.highlightAngle,
    required this.allLit,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    for (var i = 0; i < dashCount; i++) {
      final angle = (i / dashCount) * 2 * math.pi - math.pi / 2;
      var dashColor = color;
      if (!allLit && highlightAngle != null) {
        // Pale sweeping arc ~1/7 of the ring wide, wrapping smoothly.
        var d = (angle - highlightAngle!) % (2 * math.pi);
        if (d < 0) d += 2 * math.pi;
        if (d < math.pi / 3.5) {
          dashColor = Color.lerp(const Color(0xFFD7E2FF), color, d / (math.pi / 3.5))!;
        }
      }
      final paint = Paint()
        ..color = dashColor
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round;
      final dx = math.cos(angle);
      final dy = math.sin(angle);
      final start = Offset(center.dx + dx * (radius - dashLength), center.dy + dy * (radius - dashLength));
      final end = Offset(center.dx + dx * radius, center.dy + dy * radius);
      canvas.drawLine(start, end, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _DashedRingPainter oldDelegate) =>
      oldDelegate.highlightAngle != highlightAngle || oldDelegate.allLit != allLit || oldDelegate.color != color;
}

/// Fills its box with a `camera` package preview, cropping the overflow
/// (BoxFit.cover) instead of the letterboxed AspectRatio box CameraPreview
/// uses by default.
///
/// Sizing the preview by its own reported resolution and letting FittedBox do
/// the scaling is far more reliable than computing a scale factor from the
/// screen aspect ratio: a null/odd previewSize used to collapse the preview
/// into a small strip instead of covering the screen.
class CoverCameraPreview extends StatelessWidget {
  final CameraController controller;
  final bool mirror;
  const CoverCameraPreview({super.key, required this.controller, this.mirror = false});

  @override
  Widget build(BuildContext context) {
    // previewSize is reported in sensor (landscape) orientation, so swap the
    // axes to get the portrait size the preview actually paints at.
    final preview = controller.value.previewSize;
    final width = preview?.height ?? 9;
    final height = preview?.width ?? 16;
    Widget child = CameraPreview(controller);
    if (mirror) child = Transform.scale(scaleX: -1, child: child);
    return ClipRect(
      child: FittedBox(
        fit: BoxFit.cover,
        clipBehavior: Clip.hardEdge,
        child: SizedBox(width: width, height: height, child: child),
      ),
    );
  }
}
