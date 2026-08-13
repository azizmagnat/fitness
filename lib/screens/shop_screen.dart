import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../data/mock_data.dart';
import '../state/subscription_store.dart';
import '../widgets/feedback.dart';
import '../widgets/page_transitions.dart';
import '../widgets/shop_section.dart';
import 'subscription_screen.dart';

class ShopScreen extends StatelessWidget {
  const ShopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: false,
            floating: false,
            expandedHeight: 210,
            backgroundColor: AppColors.background,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(gradient: shopBrandGradient),
                child: const SafeArea(
                  child: Padding(
                    padding: EdgeInsets.only(left: 16, top: 8),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text("Do'kon", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            sliver: SliverToBoxAdapter(
              child: Column(
                children: [
                  const Text("🛍️ 1Fit Do'koni",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white)),
                  const SizedBox(height: 10),
                  const Text(
                    "Sog'lik va maqsadlarga erishish uchun",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white70, fontSize: 17),
                  ),
                  const SizedBox(height: 24),
                  Wrap(
                    spacing: 14,
                    runSpacing: 14,
                    children: MockData.shopSections.map((s) {
                      return SizedBox(
                        width: (MediaQuery.of(context).size.width - 32 - 14) / 2,
                        child: _ShopSectionCard(icon: s.$1, title: s.$2, subtitle: s.$3),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ShopSectionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  const _ShopSectionCard({required this.icon, required this.title, required this.subtitle});

  Widget _iconTile() {
    switch (title) {
      case "Muzlatish":
        return Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
                colors: [Color(0xFF60A5FA), Color(0xFF2563EB)], begin: Alignment.topLeft, end: Alignment.bottomRight),
            borderRadius: BorderRadius.circular(15),
          ),
          alignment: Alignment.center,
          child: const Icon(Icons.ac_unit_rounded, color: Colors.white, size: 30),
        );
      case "1Fit Pro":
        return Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
                colors: [Color(0xFF2F6BFF), Color(0xFF1E3FBF)], begin: Alignment.topLeft, end: Alignment.bottomRight),
            borderRadius: BorderRadius.circular(15),
          ),
          alignment: Alignment.center,
          child: const Text("PRO✦", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 14)),
        );
      case "Abonementlar":
      default:
        return Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
                colors: [Color(0xFF7C3AED), Color(0xFF3B82F6)], begin: Alignment.topLeft, end: Alignment.bottomRight),
            borderRadius: BorderRadius.circular(15),
          ),
          alignment: Alignment.center,
          child: const Text("365",
              style: TextStyle(
                  color: Colors.white, fontWeight: FontWeight.w900, fontStyle: FontStyle.italic, fontSize: 18)),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () {
        switch (title) {
          case "Abonementlar":
          case "1Fit Pro":
            Navigator.of(context).push(slideRightRoute(const SubscriptionScreen()));
            break;
          case "Muzlatish":
            SubscriptionStore.toggleFrozen();
            showConfirmed(context, SubscriptionStore.frozen.value ? "Abonement muzlatildi" : "Abonement qayta faollashtirildi");
            break;
          default:
            showComingSoon(context, title);
        }
      },
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(20)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _iconTile(),
            const SizedBox(height: 16),
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 21)),
            const SizedBox(height: 8),
            Text(subtitle,
                style: const TextStyle(color: AppColors.textSecondary, fontSize: 14.5, height: 1.3), maxLines: 3),
            const SizedBox(height: 26),
            Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(color: AppColors.surfaceLight, shape: BoxShape.circle),
              child: const Icon(Icons.chevron_right_rounded, color: AppColors.textSecondary, size: 22),
            ),
          ],
        ),
      ),
    );
  }
}
