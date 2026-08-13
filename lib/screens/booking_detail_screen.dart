import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import '../theme/app_theme.dart';
import '../data/mock_data.dart';
import '../models/models.dart';
import '../widgets/common.dart';
import '../widgets/feedback.dart';
import '../widgets/page_transitions.dart';
import '../state/bookings_store.dart';
import '../state/visits_store.dart';
import 'booking_success_screen.dart';
import 'settings_detail_screens.dart';

Future<void> showBookingDetailSheet(BuildContext context, ScheduleItem item) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black.withValues(alpha: 0.55),
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
    builder: (_) => BookingDetailScreen(item: item),
  );
}

class BookingDetailScreen extends StatefulWidget {
  final ScheduleItem item;
  const BookingDetailScreen({super.key, required this.item});

  @override
  State<BookingDetailScreen> createState() => _BookingDetailScreenState();
}

class _BookingDetailScreenState extends State<BookingDetailScreen> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    return Container(
      height: MediaQuery.of(context).size.height * 0.93,
      decoration: const BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      clipBehavior: Clip.antiAlias,
      child: SafeArea(
        top: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.textSecondary.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 16, 0),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.close_rounded),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  const SizedBox(width: 4),
                  const Text("Qani tekshiraylik",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
                children: [
                  Text(item.title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Text(item.date,
                          style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600)),
                      const SizedBox(width: 10),
                      Text(item.time, style: const TextStyle(color: AppColors.textSecondary)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.star, color: AppColors.accentGreen, size: 16),
                      const SizedBox(width: 4),
                      Text(item.rating > 0 ? item.rating.toStringAsFixed(1) : "9.5",
                          style: const TextStyle(fontWeight: FontWeight.w600)),
                      const SizedBox(width: 6),
                      Text(item.gymName, style: const TextStyle(color: AppColors.textSecondary)),
                    ],
                  ),
                  const SizedBox(height: 20),
                  SectionCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.shield_outlined, color: AppColors.accentPurple),
                            SizedBox(width: 10),
                            Text("Tashrif qoidalari", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          ],
                        ),
                        const SizedBox(height: 14),
                        ...MockData.visitRules.map((r) => _RuleRow(icon: Icons.access_time, text: r)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                  SectionCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Sizga nima kerak bo'ladi?", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        const SizedBox(height: 14),
                        ...MockData.bringRules.map((r) => _RuleRow(icon: Icons.check_circle_outline, text: r)),
                        if (_expanded)
                          ...MockData.bringRulesExtra.map((r) => _RuleRow(icon: Icons.check_circle_outline, text: r)),
                        const SizedBox(height: 6),
                        InkWell(
                          onTap: () => setState(() => _expanded = !_expanded),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(_expanded ? "Kamroq ko'rish" : "Hammasini ko'rish",
                                  style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600)),
                              Icon(_expanded ? Icons.expand_less_rounded : Icons.expand_more_rounded,
                                  color: AppColors.primary, size: 20),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceLight,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text.rich(
                      TextSpan(
                        style: const TextStyle(color: AppColors.textSecondary),
                        children: [
                          const TextSpan(text: "Siz "),
                          TextSpan(
                            text: "zal qoidalariga",
                            style: const TextStyle(color: AppColors.primary, decoration: TextDecoration.underline),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () => Navigator.of(context).push(slideRightRoute(const RulesScreen())),
                          ),
                          const TextSpan(text: " rozilik bildiryapsiz"),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
              child: ValueListenableBuilder<List<ScheduleItem>>(
                valueListenable: BookingsStore.items,
                builder: (context, booked, _) {
                  final already = booked.any((b) =>
                      b.gymName == item.gymName && b.title == item.title && b.time == item.time && b.date == item.date);
                  if (already) {
                    return Column(
                      children: [
                        const Text("Siz bu mashg'ulotga allaqachon yozilgansiz",
                            style: TextStyle(color: AppColors.accentGreen, fontWeight: FontWeight.w600)),
                        const SizedBox(height: 10),
                        PrimaryButton(
                          label: "Yozilishni bekor qilish",
                          color: AppColors.surfaceLight,
                          onPressed: () {
                            BookingsStore.cancel(item);
                            showConfirmed(context, "Yozilish bekor qilindi");
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  }
                  return Column(
                    children: [
                      ValueListenableBuilder<Map<String, int>>(
                        valueListenable: VisitsStore.remaining,
                        builder: (context, _, __) => Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Text(
                            "Abonementingizda shu zal uchun ${VisitsStore.remainingFor(item.gymName)} tashrif qoldi",
                            style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
                          ),
                        ),
                      ),
                      PrimaryButton(
                        label: "Yozilish",
                        onPressed: () {
                          BookingsStore.add(item.copyWith(status: "Tasdiqlash kerak", needsConfirmation: true));
                          Navigator.of(context).pushReplacement(slideUpRoute(BookingSuccessScreen(item: item)));
                        },
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RuleRow extends StatelessWidget {
  final IconData icon;
  final String text;
  const _RuleRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, color: AppColors.textSecondary, size: 18),
          const SizedBox(width: 10),
          Expanded(child: Text(text, style: const TextStyle(color: AppColors.textSecondary))),
        ],
      ),
    );
  }
}
