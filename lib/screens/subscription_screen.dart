import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../data/mock_data.dart';
import '../state/subscription_store.dart';
import '../state/visits_store.dart';
import '../widgets/feedback.dart';
import '../widgets/page_transitions.dart';
import 'notifications_screen.dart';
import 'settings_detail_screens.dart';

Future<void> _confirmDemoPurchase(BuildContext context, String label) async {
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Text(label),
      content: const Text(
        "Bu — demo rejim, haqiqiy to'lov amalga oshmaydi. Obunani lokal ravishda faollashtiramizmi?",
        style: TextStyle(color: AppColors.textSecondary),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text("Bekor qilish")),
        TextButton(onPressed: () => Navigator.of(context).pop(true), child: const Text("Tasdiqlash")),
      ],
    ),
  );
  if (confirmed == true && context.mounted) {
    SubscriptionStore.recordPurchase(label);
    SubscriptionStore.frozen.value = false;
    showConfirmed(context, "$label faollashtirildi (demo)");
  }
}

class SubscriptionScreen extends StatelessWidget {
  const SubscriptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: const Icon(Icons.notifications_none_rounded, size: 26),
                    onPressed: () => Navigator.of(context).push(slideRightRoute(const NotificationsScreen())),
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(4, 24, 4, 18),
              child: Text("Mening abonementim", style: TextStyle(fontSize: 31, fontWeight: FontWeight.bold)),
            ),
            Container(
              height: 260,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(22),
                gradient: const LinearGradient(
                  colors: [Color(0xFF2E7CF6), Color(0xFF6D28D9), Color(0xFFA21CAF)],
                  begin: Alignment.centerLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("365",
                          style: TextStyle(
                            color: Color(0xFF7DD3FC),
                            fontSize: 58,
                            fontWeight: FontWeight.w900,
                            fontStyle: FontStyle.italic,
                            height: 1,
                            shadows: [
                              Shadow(color: Color(0xFF166534), offset: Offset(3, 3)),
                              Shadow(color: Color(0xFF14532D), offset: Offset(-1, -1)),
                            ],
                          )),
                      const Spacer(),
                      InkWell(
                        borderRadius: BorderRadius.circular(22),
                        onTap: () => Navigator.of(context).push(slideRightRoute(const PurchaseHistoryScreen())),
                        child: Container(
                          width: 44,
                          height: 44,
                          decoration: const BoxDecoration(color: Colors.white38, shape: BoxShape.circle),
                          child: const Icon(Icons.chevron_right_rounded, color: Colors.white, size: 26),
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text("12 oylik",
                                style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold)),
                            SizedBox(height: 4),
                            Text("354 kun qoldi", style: TextStyle(color: Colors.white, fontSize: 15.5)),
                          ],
                        ),
                      ),
                      ValueListenableBuilder<bool>(
                        valueListenable: SubscriptionStore.frozen,
                        builder: (context, frozen, _) => Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                          decoration:
                              BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(22)),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 20,
                                height: 20,
                                decoration:
                                    const BoxDecoration(color: Color(0xFF8B5CF6), shape: BoxShape.circle),
                                alignment: Alignment.center,
                                child: const Text("B",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 12, fontWeight: FontWeight.w900)),
                              ),
                              const SizedBox(width: 6),
                              Text(frozen ? "Muzlatilgan" : "30 kun",
                                  style: const TextStyle(
                                      color: Color(0xFF8B5CF6), fontWeight: FontWeight.w700, fontSize: 15)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
              decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(14)),
              child: const Row(
                children: [
                  Expanded(
                    child: Text("Abonementni boshqalarga bermang",
                        style: TextStyle(color: AppColors.textSecondary, fontSize: 15)),
                  ),
                  Icon(Icons.info_outline_rounded, size: 20, color: Color(0xFF3B82F6)),
                ],
              ),
            ),
            const SizedBox(height: 22),
            // Live per-gym allowance, so the limit system is visible in one
            // place instead of only on each gym's page.
            ValueListenableBuilder<Map<String, int>>(
              valueListenable: VisitsStore.remaining,
              builder: (context, remaining, _) {
                final gyms = MockData.allGyms.where((g) => g.visitsUsed > 0).toList();
                if (gyms.isEmpty) return const SizedBox.shrink();
                return Container(
                  padding: const EdgeInsets.fromLTRB(16, 14, 16, 6),
                  decoration:
                      BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(14)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Expanded(
                            child: Text("Zallar bo'yicha limitlar",
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          ),
                          GestureDetector(
                            onTap: () async {
                              await VisitsStore.resetAll();
                              if (context.mounted) showConfirmed(context, "Barcha limitlar yangilandi");
                            },
                            child: const Text("Yangilash",
                                style: TextStyle(
                                    color: AppColors.primary, fontWeight: FontWeight.w600, fontSize: 14.5)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      for (final gym in gyms)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(gym.name,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(fontSize: 15)),
                              ),
                              SizedBox(
                                width: 96,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(3),
                                  child: LinearProgressIndicator(
                                    value: VisitsStore.remainingFor(gym.name) / VisitsStore.maxFor(gym.name),
                                    minHeight: 5,
                                    backgroundColor: AppColors.surfaceLight,
                                    valueColor: const AlwaysStoppedAnimation(AppColors.primary),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                  "${VisitsStore.remainingFor(gym.name)}/${VisitsStore.maxFor(gym.name)}",
                                  style: const TextStyle(
                                      color: AppColors.textSecondary,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600)),
                            ],
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 26),
            const Text("Yangi bonus kunlari ishlash",
                style: TextStyle(color: AppColors.textSecondary, fontSize: 15.5)),
            const SizedBox(height: 12),
            _MenuTile(
              iconWidget: Container(
                width: 34,
                height: 34,
                decoration:
                    BoxDecoration(color: const Color(0xFF8B5CF6), borderRadius: BorderRadius.circular(9)),
                child: const Icon(Icons.card_giftcard_rounded, color: Colors.white, size: 19),
              ),
              label: "Mehmon abonementini sovg'a qilish",
              onTap: () => showConfirmed(context, "Sovg'a havolasi tayyorlandi"),
            ),
            _MenuTile(
              iconWidget: const Icon(Icons.send_rounded, color: Color(0xFF38BDF8), size: 28),
              label: "Promokod bilan bo'lishish",
              onTap: () => showConfirmed(context, "Promokod nusxalandi"),
            ),
            const SizedBox(height: 22),
            const Text("Abonement sotib olish", style: TextStyle(color: AppColors.textSecondary, fontSize: 15.5)),
            const SizedBox(height: 12),
            _MenuTile(
              iconWidget: Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFF22C55E), width: 2.5),
                ),
                alignment: Alignment.center,
                child: const Text("\$",
                    style: TextStyle(color: Color(0xFF22C55E), fontWeight: FontWeight.w900, fontSize: 17)),
              ),
              label: "Bir martalik tashrif sotib olish",
              onTap: () => _confirmDemoPurchase(context, "Bir martalik tashrif"),
            ),
            _MenuTile(
              iconWidget: const Icon(Icons.shopping_bag_rounded, color: Color(0xFF2F6BFF), size: 27),
              label: "Abonement sotib olish",
              chevronColor: const Color(0xFF2F6BFF),
              onTap: () => _confirmDemoPurchase(context, "Abonement"),
            ),
            _MenuTile(
              iconWidget: Container(
                width: 34,
                height: 34,
                decoration: const BoxDecoration(color: Color(0xFF22C55E), shape: BoxShape.circle),
                alignment: Alignment.center,
                child: const Text("%",
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 17)),
              ),
              label: "Promokodni faollashtirish",
              onTap: () => showConfirmed(context, "Promokod faollashtirildi (demo)"),
            ),
            _MenuTile(
              iconWidget: Container(
                width: 34,
                height: 34,
                decoration:
                    BoxDecoration(color: const Color(0xFFEF4444), borderRadius: BorderRadius.circular(9)),
                child: const Icon(Icons.redeem_rounded, color: Colors.white, size: 19),
              ),
              label: "Sovg'a abonement sotib olish",
              onTap: () => _confirmDemoPurchase(context, "Sovg'a abonement"),
            ),
            const SizedBox(height: 22),
            _MenuTile(
              iconWidget: Container(
                width: 34,
                height: 34,
                decoration: const BoxDecoration(color: Color(0xFF3F3F46), shape: BoxShape.circle),
                alignment: Alignment.center,
                child: const Text("?",
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 16)),
              ),
              label: "Savollar va javoblar",
              onTap: () => Navigator.of(context).push(slideRightRoute(const SupportScreen())),
            ),
          ],
        ),
      ),
    );
  }
}

class _MenuTile extends StatelessWidget {
  final Widget iconWidget;
  final String label;
  final Color chevronColor;
  final VoidCallback onTap;
  const _MenuTile({
    required this.iconWidget,
    required this.label,
    this.chevronColor = AppColors.textSecondary,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
          child: Row(
            children: [
              SizedBox(width: 36, height: 36, child: Center(child: iconWidget)),
              const SizedBox(width: 14),
              Expanded(
                child: Text(label, style: const TextStyle(fontSize: 16.5, fontWeight: FontWeight.w600)),
              ),
              Icon(Icons.chevron_right_rounded, color: chevronColor),
            ],
          ),
        ),
      ),
    );
  }
}
