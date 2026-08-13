import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/models.dart';
import '../widgets/common.dart';
import '../widgets/page_transitions.dart';
import 'booking_detail_screen.dart';
import 'subscription_screen.dart';

class TimeSlotScreen extends StatefulWidget {
  final Gym gym;
  const TimeSlotScreen({super.key, required this.gym});

  @override
  State<TimeSlotScreen> createState() => _TimeSlotScreenState();
}

class _TimeSlotScreenState extends State<TimeSlotScreen> {
  static const _weekdayShort = ["Dush", "Sesh", "Chor", "Pay", "Jum", "Shan", "Yak"];
  static const _monthNames = [
    "yanvar", "fevral", "mart", "aprel", "may", "iyun",
    "iyul", "avgust", "sentabr", "oktabr", "noyabr", "dekabr",
  ];
  int _dayIndex = 0;

  /// Tab captions: "Bugun" for today, weekday + day number afterwards.
  List<String> get _days {
    final now = DateTime.now();
    return List.generate(6, (i) {
      if (i == 0) return "Bugun";
      final d = now.add(Duration(days: i));
      return "${_weekdayShort[d.weekday - 1]} ${d.day}";
    });
  }

  /// The calendar date a booking is actually for ("23-iyul"). Confirmation
  /// screens and the schedule list show this, never the "Bugun" tab caption.
  String _dateLabel(int dayIndex) {
    final d = DateTime.now().add(Duration(days: dayIndex));
    return "${d.day}-${_monthNames[d.month - 1]}";
  }

  static const _genericSlots = [
    ("00:00", 0, false), ("01:00", 0, false),
    ("02:00", 0, false), ("03:00", 0, false),
    ("04:00", 15, true), ("05:00", 12, true),
    ("06:00", 12, true), ("07:00", 15, true),
    ("08:00", 20, true), ("09:00", 17, true),
    ("10:00", 18, true), ("11:00", 18, true),
    ("12:00", 19, true), ("13:00", 20, true),
    ("14:00", 19, true), ("15:00", 18, true),
    ("16:00", 44, true), ("17:00", 45, true),
    ("18:00", 55, true), ("19:00", 43, true),
    ("20:00", 42, true), ("21:00", 53, true),
    ("22:00", 55, true), ("23:00", 55, true),
  ];

  // A slot is "ended" only for today's tab, and only once its session window
  // (start + duration) has fully passed — matches the real app: a slot
  // stays bookable right up to its scheduled end time, not just its start.
  bool _isEnded(TimeSlot slot, int durationMin) {
    if (_dayIndex != 0) return false;
    final now = DateTime.now();
    DateTime? start;
    DateTime? end;
    if (slot.time.contains(' - ')) {
      final parts = slot.time.split(' - ');
      start = _parseTimeToday(parts[0], now);
      end = _parseTimeToday(parts[1], now);
    } else {
      start = _parseTimeToday(slot.time, now);
      end = start?.add(Duration(minutes: durationMin));
    }
    if (end == null) return slot.ended;
    return end.isBefore(now);
  }

  DateTime? _parseTimeToday(String hhmm, DateTime now) {
    final parts = hhmm.trim().split(':');
    if (parts.length != 2) return null;
    final h = int.tryParse(parts[0]);
    final m = int.tryParse(parts[1]);
    if (h == null || m == null) return null;
    return DateTime(now.year, now.month, now.day, h, m);
  }

  List<WorkoutSession> get _sessions {
    if (widget.gym.sessions.isNotEmpty) return widget.gym.sessions;
    return [
      WorkoutSession(
        title: "Trenajyor zalida mustaqil mashg'ulotlar",
        durationMin: 120,
        slots: _genericSlots
            .where((s) => s.$3)
            .map((s) => TimeSlot(s.$1, s.$2))
            .toList(),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.gym.name)),
      body: Column(
        children: [
          SizedBox(
            height: 52,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: _days.length,
              separatorBuilder: (_, __) => const SizedBox(width: 30),
              itemBuilder: (_, i) {
                final selected = i == _dayIndex;
                return InkWell(
                  onTap: () => setState(() => _dayIndex = i),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(_days[i],
                          style: TextStyle(
                            fontSize: 18,
                            color: selected ? AppColors.textPrimary : AppColors.textSecondary,
                            fontWeight: selected ? FontWeight.bold : FontWeight.w500,
                          )),
                      const SizedBox(height: 8),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        height: 4,
                        width: selected ? 52 : 0,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          const Divider(height: 1, color: AppColors.divider),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: _sessions.length + 1,
              separatorBuilder: (_, __) => const SizedBox(height: 34),
              itemBuilder: (context, i) {
                if (i == _sessions.length) return const _PlansBanner();
                return _buildSessionBlock(_sessions[i]);
              },
            ),
          ),
        ],
      ),
    );
  }

  // Slots that were already past when the reference schedule was captured
  // have seatsLeft: 0 baked into the mock data (the original just showed
  // "Tugadi" with no seat count for them). That's only meaningful for
  // today's already-passed hours — on any day where the slot isn't actually
  // ended, fall back to this session's typical capacity instead of 0 so
  // future days read as genuinely open, not perpetually sold out.
  int _sessionCapacity(WorkoutSession session) {
    final real = session.slots.map((s) => s.seatsLeft).where((n) => n > 0);
    return real.isEmpty ? 20 : real.reduce((a, b) => a > b ? a : b);
  }

  Widget _buildSessionBlock(WorkoutSession session) {
    final capacity = _sessionCapacity(session);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(session.title, style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold, height: 1.2)),
        const SizedBox(height: 8),
        Row(
          children: [
            if (session.restriction.isNotEmpty) ...[
              Builder(builder: (context) {
                final (icon, color) = restrictionVisual(session.restriction);
                return Row(
                  children: [
                    Icon(icon, size: 18, color: color),
                    const SizedBox(width: 3),
                    Text(session.restriction, style: TextStyle(color: color, fontSize: 16.5)),
                  ],
                );
              }),
              const SizedBox(width: 14),
            ],
            Text("${session.durationMin} min",
                style: const TextStyle(color: AppColors.textSecondary, fontSize: 16.5)),
          ],
        ),
        const SizedBox(height: 18),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 2.15,
          children: session.slots.map((slot) {
            final ended = _isEnded(slot, session.durationMin);
            final seats = (!ended && slot.seatsLeft == 0 && slot.ended) ? capacity : slot.seatsLeft;
            final open = !ended && seats > 0;
            return InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: open
                  ? () {
                      showBookingDetailSheet(
                        context,
                        ScheduleItem(
                          title: session.title,
                          gymName: widget.gym.name,
                          date: _dateLabel(_dayIndex),
                          time: "${slot.time}, ${session.durationMin} min",
                          status: "Band qilinmagan",
                          rating: widget.gym.rating,
                          restriction: session.restriction,
                        ),
                      );
                    }
                  : null,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                ),
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(slot.time,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 19,
                            color: open ? AppColors.textPrimary : AppColors.textSecondary)),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        if (open) ...[
                          const Icon(Icons.person_rounded, size: 16, color: AppColors.textSecondary),
                          const SizedBox(width: 4),
                          Text("$seats joy qoldi",
                              style: const TextStyle(color: AppColors.textSecondary, fontSize: 14.5)),
                        ] else
                          Text(ended ? "Tugadi" : "Joy yo'q",
                              style: const TextStyle(color: AppColors.textSecondary, fontSize: 14.5)),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

/// "1Fit abonementlari" promo banner at the end of the schedule, with the
/// tilted 90/180/365 plan stickers and % badges like the original.
class _PlansBanner extends StatelessWidget {
  const _PlansBanner();

  Widget _sticker(String label, List<Color> colors, double angle) {
    return Transform.rotate(
      angle: angle,
      child: Container(
        width: 74,
        height: 60,
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: colors, begin: Alignment.topLeft, end: Alignment.bottomRight),
          borderRadius: BorderRadius.circular(14),
        ),
        alignment: Alignment.center,
        child: Text(label,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.w900, fontStyle: FontStyle.italic, fontSize: 22)),
      ),
    );
  }

  Widget _percentBadge() {
    return Container(
      width: 34,
      height: 34,
      decoration: const BoxDecoration(color: Color(0xFF4ADE80), shape: BoxShape.circle),
      alignment: Alignment.center,
      child: const Text("%",
          style: TextStyle(color: Color(0xFF14532D), fontWeight: FontWeight.w900, fontSize: 17)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 190,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          colors: [Color(0xFF1230B8), Color(0xFF2E5BFF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: [
          Positioned(right: 46, top: -6, child: _sticker("90", const [Color(0xFF4ADE80), Color(0xFF16A34A)], 0.25)),
          Positioned(right: 78, top: 62, child: _sticker("180", const [Color(0xFFF472B6), Color(0xFFDB2777)], -0.2)),
          Positioned(right: 8, bottom: -8, child: _sticker("365", const [Color(0xFF34D399), Color(0xFF0EA5E9)], 0.35)),
          Positioned(right: 8, top: 28, child: _percentBadge()),
          Positioned(right: 150, bottom: 10, child: _percentBadge()),
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 18, 150, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("1Fit abonementlari",
                    style: TextStyle(color: Colors.white, fontSize: 21, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                const Text("Turli sport turlari bo'yicha cheksiz mashg'ulotlar",
                    style: TextStyle(color: Colors.white, fontSize: 14.5, height: 1.3)),
                const Spacer(),
                InkWell(
                  borderRadius: BorderRadius.circular(24),
                  onTap: () => Navigator.of(context).push(slideRightRoute(const SubscriptionScreen())),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 11),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24)),
                    child: const Text("O'zingiznikini tanlang",
                        style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600, fontSize: 14.5)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
