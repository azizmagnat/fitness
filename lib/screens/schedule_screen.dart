import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/models.dart';
import '../state/bookings_store.dart';
import '../widgets/app_actions.dart';
import '../widgets/common.dart';
import '../widgets/feedback.dart';
import '../widgets/page_transitions.dart';
import 'booking_detail_screen.dart';
import 'main_nav_screen.dart';
import 'map_view_screen.dart';
import 'notifications_screen.dart';
import 'qr_scan_screen.dart';
import 'subscription_screen.dart';
import 'visit_history_screen.dart';

class ScheduleScreen extends StatelessWidget {
  const ScheduleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ValueListenableBuilder<List<ScheduleItem>>(
          valueListenable: BookingsStore.items,
          builder: (context, bookings, _) {
            final header = [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 8, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.access_time_rounded, size: 26),
                      onPressed: () => Navigator.of(context).push(slideRightRoute(const VisitHistoryScreen())),
                    ),
                    IconButton(
                      icon: const Icon(Icons.notifications_none_rounded, size: 26),
                      onPressed: () => Navigator.of(context).push(slideRightRoute(const NotificationsScreen())),
                    ),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.fromLTRB(20, 8, 20, 18),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Jadval", style: TextStyle(fontSize: 34, fontWeight: FontWeight.bold)),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: _ProBanner(),
              ),
            ];
            if (bookings.isEmpty) {
              return Column(
                children: [
                  ...header,
                  const Expanded(child: _EmptyBookings()),
                ],
              );
            }
            return ListView.separated(
              padding: const EdgeInsets.only(bottom: 16),
              itemCount: bookings.length + 1,
              separatorBuilder: (_, __) => const SizedBox(height: 16),
              itemBuilder: (context, i) {
                if (i == 0) return Column(children: header);
                final item = bookings[i - 1];
                final card = item.needsConfirmation
                    ? _ConfirmCard(item: item)
                    : item.status == "Tasdiqlandi"
                        ? _ConfirmedCard(item: item)
                        : _SimpleCard(item: item);
                return Padding(padding: const EdgeInsets.symmetric(horizontal: 16), child: card);
              },
            );
          },
        ),
      ),
    );
  }
}

class _EmptyBookings extends StatelessWidget {
  const _EmptyBookings();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CustomPaint(size: Size(240, 200), painter: _EmptyCalendarPainter()),
            const SizedBox(height: 26),
            const Text("Rejalashtirilgan mashg'ulotlar yo'q",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            const Text("Siz yozilgan mashg'ulotlar\nshu yerda paydo bo'ladi",
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.textSecondary, fontSize: 15.5, height: 1.35)),
            const SizedBox(height: 26),
            SizedBox(
              height: 54,
              child: ElevatedButton(
                onPressed: () => MainNavScreen.tabRequest.value = 1,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 44),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                  elevation: 0,
                ),
                child: const Text("Mashg'ulotni topish",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

/// Line-art empty-state illustration matching the original: an outlined
/// calendar with binder pins, an X across it, a "0" badge on its top-right
/// corner and soft cloud shapes floating beside it.
class _EmptyCalendarPainter extends CustomPainter {
  const _EmptyCalendarPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final stroke = Paint()
      ..color = const Color(0xFF3F4045)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 7
      ..strokeCap = StrokeCap.round;
    final cloudFill = Paint()..color = const Color(0xFF26272B);

    final cx = size.width / 2;
    final cy = size.height / 2 + 8;
    final body = RRect.fromRectAndRadius(
      Rect.fromCenter(center: Offset(cx, cy), width: 128, height: 118),
      const Radius.circular(18),
    );

    // Clouds behind the calendar.
    void cloud(Offset c, double s) {
      final p = Path()
        ..addOval(Rect.fromCircle(center: c.translate(-s * 0.5, 0), radius: s * 0.42))
        ..addOval(Rect.fromCircle(center: c, radius: s * 0.55))
        ..addOval(Rect.fromCircle(center: c.translate(s * 0.55, 0.1 * s), radius: s * 0.38))
        ..addRect(Rect.fromCenter(center: c.translate(0, s * 0.25), width: s * 1.5, height: s * 0.5));
      canvas.drawPath(p, cloudFill);
    }

    cloud(Offset(cx - 105, cy + 6), 32);
    cloud(Offset(cx + 108, cy - 24), 26);
    cloud(Offset(cx + 96, cy + 44), 20);

    canvas.drawRRect(body, stroke);

    // Binder pins on top.
    canvas.drawLine(Offset(cx - 34, cy - 78), Offset(cx - 34, cy - 46), stroke);
    canvas.drawLine(Offset(cx + 34, cy - 78), Offset(cx + 34, cy - 46), stroke);

    // X across the middle.
    canvas.drawLine(Offset(cx - 24, cy - 14), Offset(cx + 24, cy + 34), stroke);
    canvas.drawLine(Offset(cx + 24, cy - 14), Offset(cx - 24, cy + 34), stroke);

    // "0" badge overlapping the top-right corner.
    final badgeCenter = Offset(cx + 64, cy - 59);
    canvas.drawCircle(badgeCenter, 24, Paint()..color = Colors.black);
    canvas.drawCircle(badgeCenter, 24, stroke);
    final tp = TextPainter(
      text: const TextSpan(
        text: "0",
        style: TextStyle(color: Color(0xFF3F4045), fontSize: 26, fontWeight: FontWeight.w800),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, badgeCenter - Offset(tp.width / 2, tp.height / 2));
  }

  @override
  bool shouldRepaint(covariant _EmptyCalendarPainter oldDelegate) => false;
}

class _ProBanner extends StatelessWidget {
  const _ProBanner();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(22),
      onTap: () => Navigator.of(context).push(slideRightRoute(const SubscriptionScreen())),
      child: Container(
        height: 148,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          gradient: const LinearGradient(
            colors: [Color(0xFF060B1E), Color(0xFF12245F), Color(0xFF1E3A9E)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
        child: Stack(
          children: [
            // 3D-illustration cluster on the right, approximated with emoji.
            const Positioned(right: 64, top: 16, child: Text("✦", style: TextStyle(color: Color(0xFF6FA7FF), fontSize: 18))),
            const Positioned(right: 10, top: 40, child: Text("✦", style: TextStyle(color: Color(0xFF6FA7FF), fontSize: 12))),
            Positioned(
              right: 12,
              bottom: 10,
              child: Row(
                children: [
                  Transform.rotate(
                    angle: -0.15,
                    child: const Text("📋", style: TextStyle(fontSize: 44)),
                  ),
                  const SizedBox(width: 2),
                  Transform.rotate(
                    angle: 0.2,
                    child: const Text("🏋️", style: TextStyle(fontSize: 40)),
                  ),
                  const SizedBox(width: 2),
                  const Text("🍗", style: TextStyle(fontSize: 36)),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    width: 210,
                    child: Text("Mashg'ulotlar va ovqatlanish rejangiz",
                        style: TextStyle(color: Colors.white, fontSize: 17.5, fontWeight: FontWeight.w700, height: 1.25)),
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFF2F6BFF),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text("1FIT",
                            style: TextStyle(
                                color: Colors.white, fontWeight: FontWeight.w900, fontSize: 15, fontStyle: FontStyle.italic)),
                      ),
                      const SizedBox(width: 8),
                      const Text("PRO",
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 21, letterSpacing: 1)),
                      const Text("✦", style: TextStyle(color: Colors.white, fontSize: 12)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ConfirmCard extends StatelessWidget {
  final ScheduleItem item;
  const _ConfirmCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(18)),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () => Navigator.of(context).push(slideRightRoute(const MapViewScreen())),
            child: Container(
              height: 110,
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF2A3350), Color(0xFF3A4166)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: CustomPaint(painter: _MapDotsPainter()),
                  ),
                  Positioned(
                    bottom: 10,
                    left: 10,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.black45,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.open_in_full_rounded, size: 14, color: Colors.white70),
                    ),
                  ),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Container(
                      width: 28,
                      height: 28,
                      decoration: const BoxDecoration(color: Colors.black45, shape: BoxShape.circle),
                      child: const Icon(Icons.more_horiz_rounded, size: 16, color: Colors.white70),
                    ),
                  ),
                  const Center(
                    child: Icon(Icons.location_on, color: AppColors.accentPink, size: 30),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.title, style: const TextStyle(fontSize: 19, fontWeight: FontWeight.bold)),
                if (item.restriction.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Builder(builder: (context) {
                    final (icon, color) = restrictionVisual(item.restriction);
                    return Row(
                      children: [
                        Icon(icon, size: 16, color: color),
                        const SizedBox(width: 4),
                        Text(item.restriction, style: TextStyle(color: color, fontSize: 13)),
                      ],
                    );
                  }),
                ],
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.calendar_today_outlined, size: 14, color: AppColors.textSecondary),
                    const SizedBox(width: 4),
                    Text(item.date, style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600, fontSize: 13)),
                    const SizedBox(width: 12),
                    const Icon(Icons.access_time_rounded, size: 14, color: AppColors.textSecondary),
                    const SizedBox(width: 4),
                    Text(item.time, style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                  ],
                ),
                if (item.alertText.isNotEmpty) ...[
                  const SizedBox(height: 14),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.accentPurple.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(item.alertText,
                        style: const TextStyle(color: Color(0xFFC9B6FF), fontSize: 12.5, height: 1.4)),
                  ),
                ],
                const SizedBox(height: 14),
                Row(
                  children: [
                    Text(item.rating.toStringAsFixed(1),
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    const SizedBox(width: 3),
                    const Icon(Icons.star, color: AppColors.accentGreen, size: 16),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(item.gymName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.place_outlined, size: 14, color: AppColors.textSecondary),
                    Expanded(
                      child: Text(" ${item.address}",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(color: AppColors.textSecondary, fontSize: 12.5)),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    const Icon(Icons.navigation_outlined, size: 14, color: AppColors.textSecondary),
                    const SizedBox(width: 4),
                    Text("Sizdan ${item.distanceKm}",
                        style: const TextStyle(color: AppColors.textSecondary, fontSize: 12.5)),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(context).push(slideUpRoute(QrScanScreen(item: item))),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                      elevation: 0,
                    ),
                    child: const Text("Mashg'ulotni tasdiqlash",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton.icon(
                      onPressed: () => shareInvite(
                        context,
                        "Menga ${item.gymName}dagi \"${item.title}\" mashg'ulotiga qo'shiling — 1Fit orqali! https://1fit.uz",
                      ),
                      icon: const Icon(Icons.person_add_alt_1_rounded, size: 17, color: AppColors.primary),
                      label: const Text("Taklif qilish", style: TextStyle(color: AppColors.primary)),
                    ),
                    TextButton.icon(
                      onPressed: () => showComingSoon(context, "Taksi chaqirish"),
                      icon: const Icon(Icons.local_taxi_outlined, size: 17, color: AppColors.accentAmber),
                      label: const Text("Taksida", style: TextStyle(color: AppColors.accentAmber)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ConfirmedCard extends StatelessWidget {
  final ScheduleItem item;
  const _ConfirmedCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: () => showBookingDetailSheet(context, item),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.accentGreen.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.accentGreen.withValues(alpha: 0.25)),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.check_circle_rounded, color: AppColors.accentGreen, size: 18),
                const SizedBox(width: 6),
                const Expanded(
                  child: Text("Siz mashg'ulotni tasdiqladingiz",
                      style: TextStyle(color: AppColors.accentGreen, fontWeight: FontWeight.w600, fontSize: 13)),
                ),
                const Icon(Icons.more_horiz_rounded, color: AppColors.textSecondary),
              ],
            ),
            const SizedBox(height: 12),
            Text(item.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.calendar_today_outlined, size: 14, color: AppColors.textSecondary),
                const SizedBox(width: 4),
                Text(item.date, style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                const SizedBox(width: 12),
                const Icon(Icons.access_time_rounded, size: 14, color: AppColors.textSecondary),
                const SizedBox(width: 4),
                Text(item.time, style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
              ],
            ),
            const SizedBox(height: 4),
            Text(item.gymName.toUpperCase(),
                style: const TextStyle(color: AppColors.textSecondary, fontSize: 12, letterSpacing: 0.5)),
            const SizedBox(height: 12),
            const Row(
              children: [
                Icon(Icons.add_circle, color: AppColors.primary, size: 18),
                SizedBox(width: 6),
                Text("Mashg'ulotdan surat qo'shish",
                    style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600, fontSize: 13)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SimpleCard extends StatelessWidget {
  final ScheduleItem item;
  const _SimpleCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () => showBookingDetailSheet(context, item),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(16)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(item.status,
                      style: const TextStyle(color: AppColors.primary, fontSize: 12, fontWeight: FontWeight.w600)),
                ),
                const Spacer(),
                Text(item.date, style: const TextStyle(color: AppColors.textSecondary)),
              ],
            ),
            const SizedBox(height: 10),
            Text(item.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 6),
            Row(
              children: [
                const Icon(Icons.place_outlined, size: 14, color: AppColors.textSecondary),
                const SizedBox(width: 4),
                Text(item.gymName, style: const TextStyle(color: AppColors.textSecondary)),
                const SizedBox(width: 12),
                const Icon(Icons.access_time_rounded, size: 14, color: AppColors.textSecondary),
                const SizedBox(width: 4),
                Text(item.time, style: const TextStyle(color: AppColors.textSecondary)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _MapDotsPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white.withValues(alpha: 0.08);
    const spacing = 18.0;
    for (double x = 0; x < size.width; x += spacing) {
      for (double y = 0; y < size.height; y += spacing) {
        canvas.drawCircle(Offset(x, y), 1.2, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
