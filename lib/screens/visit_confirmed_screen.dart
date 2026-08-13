import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/models.dart';
import '../state/user_profile.dart';
import '../state/visits_store.dart';
import '../widgets/feedback.dart';
import '../widgets/scanner_overlay.dart';
import '../widgets/sound.dart';

// Colors sampled frame-by-frame from the original app's recording.
const _kHeaderGreen = Color(0xFF16BA33);
const _kCardWhite = Color(0xFFF7FBFF);
const _kButtonBlue = Color(0xFF3546F8);
const _kDateBlue = Color(0xFF3F51F5);

// Confetti palette, picked off the celebration frames.
const _kConfettiColors = [
  Color(0xFFE91E8C), // magenta
  ScannerColors.accent, // blue
  Color(0xFF22C55E), // green
  Color(0xFF9333EA), // purple
  Color(0xFF60A5FA), // light blue
];

/// Every size and gap below is a fraction of screen WIDTH only, never height.
/// The layout flows top-to-bottom naturally (Column) instead of pinning
/// elements to absolute Y-fractions of screen height — mixing width- and
/// height-relative numbers only lines up on the exact aspect ratio they were
/// measured from, and drifts out of place on any other device. Width-only
/// scaling plus natural flow keeps every gap correct regardless of aspect
/// ratio, matching how the original's layout actually behaves.
class _M {
  _M._();
  static const hPadding = 0.0433;
  static const avatarSize = 0.2416;
  static const cardRadius = 0.038;

  static const topGap = 0.16; // safe-area top -> avatar
  static const avatarNameGap = 0.035;
  static const nameCardGap = 0.10;
  static const cardBubbleGap = 0.045;
  static const buttonBottomGap = 0.045;

  // Inner padding of the cards.
  static const cardPadH = 0.039;
  static const headerPadV = 0.028;
  static const bodyPadTop = 0.034;
  static const bodyPadBottom = 0.040;
  static const bubblePadV = 0.040;
  static const gapDateTitle = 0.052;
  static const gapTitleGym = 0.028;
  static const buttonHeight = 0.098;

  // Font sizes, as a fraction of screen width.
  static const fName = 0.0477;
  static const fHeader = 0.0390;
  static const fDate = 0.0433;
  static const fDuration = 0.0347;
  static const fTitle = 0.0455;
  static const fGym = 0.0325;
  static const fBubble = 0.0390;
  static const fButton = 0.0433;
}

class VisitConfirmedScreen extends StatefulWidget {
  final ScheduleItem item;
  const VisitConfirmedScreen({super.key, required this.item});

  @override
  State<VisitConfirmedScreen> createState() => _VisitConfirmedScreenState();
}

class _VisitConfirmedScreenState extends State<VisitConfirmedScreen> with TickerProviderStateMixin {
  late final AnimationController _entrance;
  late final AnimationController _chevronAnim;
  late final AnimationController _confetti;
  late final List<_Burst> _bursts;

  @override
  void initState() {
    super.initState();
    AppSound.success();
    _entrance = AnimationController(vsync: this, duration: const Duration(milliseconds: 500))..forward();
    _chevronAnim = AnimationController(vsync: this, duration: const Duration(milliseconds: 1300))..repeat();
    _confetti = AnimationController(vsync: this, duration: const Duration(milliseconds: 2600))..forward();

    final rand = Random(11);
    _bursts = List.generate(6, (i) {
      return _Burst(
        center: Offset(0.12 + rand.nextDouble() * 0.76, 0.12 + rand.nextDouble() * 0.55),
        delay: i * 0.09,
        seed: rand.nextInt(9999),
        ringColor: _kConfettiColors[i % _kConfettiColors.length],
      );
    });

    // The original screen carries no limit panel, so a rolled-over allowance
    // is reported as a floating notice instead of changing the layout.
    final rolled = VisitsStore.takeRollover();
    if (rolled != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        showConfirmed(context, "Limit tugadi va yangilandi — yana ${VisitsStore.maxFor(rolled)} tashrif");
      });
    }
  }

  @override
  void dispose() {
    _entrance.dispose();
    _chevronAnim.dispose();
    _confetti.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final fade = CurvedAnimation(parent: _entrance, curve: Curves.easeOut);

    // "24-iyul, 20:00, 120 min" -> blue date/time + grey duration, which the
    // original renders as two styled runs on one line.
    final timeText = widget.item.time;
    final durIndex = timeText.lastIndexOf(", ");
    final hasDuration = durIndex > 0 && timeText.endsWith("min");
    final whenText = hasDuration
        ? "${widget.item.date}, ${timeText.substring(0, durIndex)}"
        : "${widget.item.date}, $timeText";
    final durationText = hasDuration ? timeText.substring(durIndex + 2) : null;

    return Scaffold(
      backgroundColor: AppColors.confirmBackground,
      body: Stack(
        fit: StackFit.expand,
        children: [
          AnimatedBuilder(
            animation: _chevronAnim,
            builder: (context, _) => CustomPaint(
                painter: _ChevronPainter(_ChevronPainter.fastPauseCurve.transform(_chevronAnim.value))),
          ),
          SafeArea(
            child: FadeTransition(
              opacity: fade,
              child: LayoutBuilder(builder: (context, constraints) {
                final w = constraints.maxWidth;
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: w * _M.hPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(height: w * _M.topGap),
                      // Avatar
                      Center(
                        child: ValueListenableBuilder<String?>(
                          valueListenable: UserProfile.photoPath,
                          builder: (context, photoPath, _) {
                            final avatar = w * _M.avatarSize;
                            return Container(
                              width: avatar,
                              height: avatar,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white, width: avatar * 0.037),
                                color: AppColors.primary,
                                image: photoPath != null
                                    ? DecorationImage(image: FileImage(File(photoPath)), fit: BoxFit.cover)
                                    : null,
                              ),
                              alignment: Alignment.center,
                              child: photoPath == null
                                  ? Text(UserProfile.initial,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: avatar * 0.38,
                                          fontWeight: FontWeight.w900))
                                  : null,
                            );
                          },
                        ),
                      ),
                      SizedBox(height: w * _M.avatarNameGap),
                      // Username
                      ValueListenableBuilder<String>(
                        valueListenable: UserProfile.name,
                        builder: (context, name, _) => Text(name,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white, fontSize: w * _M.fName, fontWeight: FontWeight.w900)),
                      ),
                      SizedBox(height: w * _M.nameCardGap),
                      // Booking card: green header + white body
                      ClipRRect(
                        borderRadius: BorderRadius.circular(w * _M.cardRadius),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Container(
                              color: _kHeaderGreen,
                              padding:
                                  EdgeInsets.symmetric(horizontal: w * _M.cardPadH, vertical: w * _M.headerPadV),
                              child: Text("Tashrif tasdiqlandi",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w900,
                                      fontSize: w * _M.fHeader)),
                            ),
                            Container(
                              color: _kCardWhite,
                              padding: EdgeInsets.fromLTRB(
                                  w * _M.cardPadH, w * _M.bodyPadTop, w * _M.cardPadH, w * _M.bodyPadBottom),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.baseline,
                                    textBaseline: TextBaseline.alphabetic,
                                    children: [
                                      Text(whenText,
                                          style: TextStyle(
                                              color: _kDateBlue,
                                              fontWeight: FontWeight.w900,
                                              fontSize: w * _M.fDate)),
                                      SizedBox(width: w * 0.023),
                                      if (durationText != null)
                                        Text(durationText,
                                            style: TextStyle(
                                                color: const Color(0xFF9AA0A6),
                                                fontWeight: FontWeight.w600,
                                                fontSize: w * _M.fDuration)),
                                    ],
                                  ),
                                  SizedBox(height: w * _M.gapDateTitle),
                                  Text(widget.item.title,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w900,
                                          fontSize: w * _M.fTitle)),
                                  SizedBox(height: w * _M.gapTitleGym),
                                  Text(widget.item.gymName,
                                      style: TextStyle(
                                          color: const Color(0xFF3C4043),
                                          fontWeight: FontWeight.w600,
                                          fontSize: w * _M.fGym)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: w * _M.cardBubbleGap),
                      // Motivational speech bubble
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(horizontal: w * _M.cardPadH, vertical: w * _M.bubblePadV),
                            decoration: BoxDecoration(
                              color: _kCardWhite,
                              borderRadius: BorderRadius.circular(w * _M.cardRadius),
                            ),
                            child: Text(
                              "Bryus Li faqat muntazam ravishda shug'illanadiganlardan qo'rqardi. Siz to'g'ri yoldasiz 💪",
                              style: TextStyle(
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w600,
                                  fontSize: w * _M.fBubble,
                                  height: 1.42),
                            ),
                          ),
                          Positioned(
                            left: -w * 0.012,
                            bottom: -w * 0.011,
                            child: CustomPaint(size: Size(w * 0.036, w * 0.03), painter: _BubbleTailPainter()),
                          ),
                        ],
                      ),
                      // Spacer absorbs whatever room is left, so the button
                      // always sits near the bottom regardless of device
                      // height — matching the original's large empty gap
                      // here without needing to guess it as a fixed fraction.
                      const Spacer(),
                      SizedBox(height: w * 0.03),
                      // "Super" button
                      SizedBox(
                        height: w * _M.buttonHeight,
                        child: ElevatedButton(
                          onPressed: () {
                            AppSound.tap();
                            Navigator.of(context).popUntil((r) => r.isFirst);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _kButtonBlue,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(w * _M.buttonHeight / 2)),
                            elevation: 0,
                            padding: EdgeInsets.zero,
                          ),
                          child: Text("Super",
                              style: TextStyle(fontSize: w * _M.fButton, fontWeight: FontWeight.w800)),
                        ),
                      ),
                      SizedBox(height: w * _M.buttonBottomGap),
                    ],
                  ),
                );
              }),
            ),
          ),
          // Confetti sits above the content, as in the original recording.
          IgnorePointer(
            child: AnimatedBuilder(
              animation: _confetti,
              builder: (context, _) => CustomPaint(painter: _ConfettiPainter(_bursts, _confetti.value)),
            ),
          ),
        ],
      ),
    );
  }
}

class _BubbleTailPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = _kCardWhite;
    final path = Path()
      ..moveTo(size.width, 0)
      ..lineTo(0, size.height)
      ..lineTo(size.width, size.height * 0.55)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ---------------------------------------------------------------------------
// Confetti
// ---------------------------------------------------------------------------

class _Burst {
  final Offset center;
  final double delay;
  final int seed;
  final Color ringColor;
  const _Burst({required this.center, required this.delay, required this.seed, required this.ringColor});
}

/// Confetti made of short rotating sticks plus an expanding dashed ring per
/// burst — the two shapes visible in the original celebration frames.
class _ConfettiPainter extends CustomPainter {
  final List<_Burst> bursts;
  final double progress;
  _ConfettiPainter(this.bursts, this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    for (final b in bursts) {
      final local = ((progress - b.delay) / (1 - b.delay)).clamp(0.0, 1.0);
      if (local <= 0) continue;
      final origin = Offset(b.center.dx * size.width, b.center.dy * size.height);
      final rand = Random(b.seed);

      // Expanding dashed ring, only in the first third of the burst.
      if (local < 0.35) {
        final t = local / 0.35;
        final r = 16 + 44 * Curves.easeOut.transform(t);
        final ringPaint = Paint()
          ..color = b.ringColor.withValues(alpha: (1 - t).clamp(0.0, 1.0))
          ..strokeWidth = 4
          ..strokeCap = StrokeCap.round;
        for (var i = 0; i < 16; i++) {
          final a = (2 * pi * i / 16);
          final inner = origin + Offset(cos(a), sin(a)) * (r - 7);
          final outer = origin + Offset(cos(a), sin(a)) * r;
          canvas.drawLine(inner, outer, ringPaint);
        }
      }

      // Radiating sticks with gravity and fade.
      const count = 15;
      final expand = Curves.easeOutCubic.transform(min(local * 1.5, 1.0));
      final fade = local < 0.7 ? 1.0 : ((1 - local) / 0.3).clamp(0.0, 1.0);
      for (var i = 0; i < count; i++) {
        final angle = (2 * pi * i / count) + rand.nextDouble() * 0.5;
        final dist = 70 + rand.nextDouble() * 110;
        final spin = rand.nextDouble() * pi;
        final color = _kConfettiColors[rand.nextInt(_kConfettiColors.length)];
        final len = 11 + rand.nextDouble() * 7;

        final dx = cos(angle) * dist * expand;
        final dy = sin(angle) * dist * expand + (240 * local * local);
        final p = origin + Offset(dx, dy);
        if (p.dy > size.height + 30) continue;

        final rot = spin + local * 7;
        final half = Offset(cos(rot), sin(rot)) * (len / 2);
        final paint = Paint()
          ..color = color.withValues(alpha: fade)
          ..strokeWidth = 4.5
          ..strokeCap = StrokeCap.round;
        canvas.drawLine(p - half, p + half, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _ConfettiPainter oldDelegate) => oldDelegate.progress != progress;
}

// ---------------------------------------------------------------------------
// Chevron background
// ---------------------------------------------------------------------------

// The chevrons travel upward quickly through the first part of each cycle,
// hold still for the rest, then the cycle wraps invisibly (scroll offset is
// periodic with the chevron spacing) and the next fast push begins.
class _FastPauseCurve extends Curve {
  const _FastPauseCurve();
  @override
  double transform(double t) {
    const riseEnd = 0.35;
    if (t >= riseEnd) return 1.0;
    return Curves.easeOutQuart.transform(t / riseEnd);
  }
}

class _ChevronPainter extends CustomPainter {
  final double t;
  _ChevronPainter(this.t);

  static const fastPauseCurve = _FastPauseCurve();
  static const _spacing = 60.0;

  @override
  void paint(Canvas canvas, Size size) {
    final centerX = size.width / 2;
    final scroll = t * _spacing;
    for (double y = -100 - _spacing; y < size.height + _spacing * 2; y += _spacing) {
      final yy = y - scroll;
      // Strokes taper from thin at the top of the screen to a little thicker
      // at the bottom. Drawn as translucent white over the navy background —
      // a flat opaque colour (even one sampled from a compressed reference
      // frame) reads far bolder than the original's faint texture once the
      // strokes are this wide; alpha blending reproduces the subtle look
      // regardless of exact stroke width.
      final normY = (yy / size.height).clamp(0.0, 1.0);
      final paint = Paint()
        ..color = Colors.white.withValues(alpha: 0.05 + normY * 0.04)
        ..strokeWidth = 12 + normY * 34
        ..style = PaintingStyle.stroke;
      final path = Path()
        ..moveTo(centerX - 240, yy + 95)
        ..lineTo(centerX, yy)
        ..lineTo(centerX + 240, yy + 95);
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _ChevronPainter oldDelegate) => oldDelegate.t != t;
}
