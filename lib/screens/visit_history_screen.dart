import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/models.dart';
import '../state/bookings_store.dart';
import 'booking_detail_screen.dart';
import 'main_nav_screen.dart';

class VisitHistoryScreen extends StatelessWidget {
  final String? gymName;
  const VisitHistoryScreen({super.key, this.gymName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Tashriflar tarixi")),
      body: ValueListenableBuilder<List<ScheduleItem>>(
        valueListenable: BookingsStore.items,
        builder: (context, items, _) {
          final visits = items
              .where((i) => i.status == "Tasdiqlandi" && (gymName == null || i.gymName == gymName))
              .toList();
          if (visits.isEmpty) {
            return const _EmptyHistory();
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: visits.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, i) {
              final v = visits[i];
              return InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () => showBookingDetailSheet(context, v),
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.accentGreen.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.accentGreen.withValues(alpha: 0.25)),
                  ),
                  padding: const EdgeInsets.all(14),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: const BoxDecoration(color: AppColors.accentGreen, shape: BoxShape.circle),
                        alignment: Alignment.center,
                        child: const Icon(Icons.check_rounded, color: Colors.white, size: 20),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(v.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                            const SizedBox(height: 2),
                            Text("${v.gymName} • ${v.date}, ${v.time}",
                                style: const TextStyle(color: AppColors.textSecondary, fontSize: 12.5)),
                          ],
                        ),
                      ),
                      const Icon(Icons.chevron_right_rounded, color: AppColors.textSecondary, size: 20),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _EmptyHistory extends StatelessWidget {
  const _EmptyHistory();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 130,
              height: 130,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 130,
                    height: 130,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primary.withValues(alpha: 0.08),
                    ),
                  ),
                  Container(
                    width: 96,
                    height: 96,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        colors: [AppColors.primary, AppColors.accentPurple],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: const Icon(Icons.history_rounded, color: Colors.white, size: 42),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 26),
            const Text("Hali tasdiqlangan tashrif yo'q",
                textAlign: TextAlign.center, style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            const Text("Tasdiqlagan tashriflaringiz\nshu yerda paydo bo'ladi",
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.textSecondary, fontSize: 15.5, height: 1.35)),
            const SizedBox(height: 26),
            SizedBox(
              height: 54,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).popUntil((r) => r.isFirst);
                  MainNavScreen.tabRequest.value = 1;
                },
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
