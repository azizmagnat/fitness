import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../data/mock_data.dart';
import '../widgets/page_transitions.dart';
import '../screens/info_screens.dart';
import '../screens/subscription_screen.dart';

/// Shared radial gradient for the "1Fit Do'koni" brand header — reused by
/// both the standalone Do'kon tab (ShopScreen) and this embedded block so the
/// same feature is never branded with two different color schemes.
const shopBrandGradient = RadialGradient(
  center: Alignment(0, -1.2),
  radius: 1.5,
  colors: [Color(0xFF6D28D9), Color(0xFF11837A), AppColors.background],
  stops: [0, 0.55, 1],
);

/// The shared "1Fit Do'koni" block the original app appends to the bottom of
/// Qidirish, Saqlangan and Profil: gradient header, prize-game cards and
/// subscription-plan cards.
class ShopSection extends StatelessWidget {
  const ShopSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(24, 36, 24, 28),
          decoration: const BoxDecoration(gradient: shopBrandGradient),
          child: const Column(
            children: [
              Text("🛍️ 1Fit Do'koni",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white)),
              SizedBox(height: 10),
              Text(
                "Sog'liq va maqsadlarga erishish uchun. Hamda — yoqimli sovrinlar o'yini ham bor",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white70, fontSize: 14.5, height: 1.35),
              ),
            ],
          ),
        ),
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 8, 16, 14),
          child: Text("Yutuqli o'yinlar", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: _PrizeGrid(),
        ),
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 26, 16, 14),
          child: Text("1Fit abonementlari", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: _PlanGrid(),
        ),
      ],
    );
  }
}

class _PrizeGrid extends StatelessWidget {
  const _PrizeGrid();

  @override
  Widget build(BuildContext context) {
    final prizes = MockData.gamePrizes;
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 0.62,
      ),
      itemCount: prizes.length + 1,
      itemBuilder: (context, i) {
        if (i == prizes.length) {
          return _SeeAllTile(onTap: () => Navigator.of(context).push(slideRightRoute(const GamePrizesScreen())));
        }
        final p = prizes[i];
        return Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF23242B), Color(0xFF17181C)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 88,
                height: 70,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                      colors: [AppColors.accentPurple, Color(0xFF8B5CF6)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight),
                  borderRadius: BorderRadius.circular(16),
                ),
                alignment: Alignment.center,
                child: Icon(p.icon, color: Colors.white, size: 36),
              ),
              const SizedBox(height: 10),
              Text(p.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.bold, height: 1.25)),
              const SizedBox(height: 6),
              Text(p.subtitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: AppColors.textSecondary, fontSize: 12.5)),
              const SizedBox(height: 4),
              Text(p.daysLeft, style: const TextStyle(color: Color(0xFF4ADE80), fontSize: 12.5)),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 40,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).push(slideRightRoute(const GamePrizesScreen())),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(21)),
                    elevation: 0,
                    padding: EdgeInsets.zero,
                  ),
                  child: const Text("Ishtirok et", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _PlanGrid extends StatelessWidget {
  const _PlanGrid();

  static const _gradients = [
    [Color(0xFF7C3AED), Color(0xFF3B82F6)],
    [Color(0xFFF9A8D4), Color(0xFFEC4899)],
    [Color(0xFF4ADE80), Color(0xFF10B981)],
  ];
  static const _labels = ["365", "180", "90"];

  @override
  Widget build(BuildContext context) {
    final plans = MockData.subscriptionPlans;
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 0.68,
      ),
      itemCount: plans.length + 1,
      itemBuilder: (context, i) {
        if (i == plans.length) {
          return _SeeAllTile(onTap: () => Navigator.of(context).push(slideRightRoute(const SubscriptionScreen())));
        }
        final p = plans[i];
        return Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(color: const Color(0xFF17181C), borderRadius: BorderRadius.circular(20)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 88,
                height: 70,
                decoration: BoxDecoration(
                  gradient:
                      LinearGradient(colors: _gradients[i % 3], begin: Alignment.topLeft, end: Alignment.bottomRight),
                  borderRadius: BorderRadius.circular(16),
                ),
                alignment: Alignment.center,
                child: Text(_labels[i % 3],
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w900, fontStyle: FontStyle.italic, fontSize: 24)),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Text(p.title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  if (p.discountBadge != null) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration:
                          BoxDecoration(color: AppColors.accentGreen, borderRadius: BorderRadius.circular(12)),
                      child: Text(p.discountBadge!,
                          style: const TextStyle(color: Colors.white, fontSize: 11.5, fontWeight: FontWeight.w700)),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 6),
              Text(p.price,
                  style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700, fontSize: 13.5)),
              if (p.oldPrice != null) ...[
                const SizedBox(height: 3),
                Text(p.oldPrice!, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12.5)),
              ],
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 40,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).push(slideRightRoute(const SubscriptionScreen())),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(21)),
                    elevation: 0,
                    padding: EdgeInsets.zero,
                  ),
                  child: const Text("Batafsilroq", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _SeeAllTile extends StatelessWidget {
  final VoidCallback onTap;
  const _SeeAllTile({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(color: const Color(0xFF17181C), borderRadius: BorderRadius.circular(20)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: const BoxDecoration(color: Color(0xFF23242B), shape: BoxShape.circle),
              child: const Icon(Icons.arrow_forward_rounded, color: AppColors.primary),
            ),
            const SizedBox(height: 14),
            const Text("Hammasini ko'rish", style: TextStyle(color: AppColors.primary, fontSize: 14)),
          ],
        ),
      ),
    );
  }
}
