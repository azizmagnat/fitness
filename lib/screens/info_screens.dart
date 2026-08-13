import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../data/mock_data.dart';
import '../widgets/common.dart';
import '../widgets/app_actions.dart';

class GamePrizesScreen extends StatelessWidget {
  const GamePrizesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Yutuqli o'yinlar")),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: MockData.gamePrizes.length,
        separatorBuilder: (_, __) => const SizedBox(height: 14),
        itemBuilder: (context, i) {
          final g = MockData.gamePrizes[i];
          return SectionCard(
            child: Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                        colors: [AppColors.accentGreen, Color(0xFF17A64A)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  alignment: Alignment.center,
                  child: Icon(g.icon, color: Colors.white, size: 26),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(g.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                      const SizedBox(height: 4),
                      Text(g.subtitle, style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                      const SizedBox(height: 6),
                      Text(g.daysLeft, style: const TextStyle(color: AppColors.accentGreen, fontSize: 13, fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class PromotionsScreen extends StatelessWidget {
  const PromotionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Aksiyalar")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ...MockData.subscriptionPlans.where((p) => p.discountBadge != null).map((p) => Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: p.gradient, begin: Alignment.topLeft, end: Alignment.bottomRight),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("${p.title} obunaga ${p.discountBadge}",
                                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                            const SizedBox(height: 6),
                            Text(p.price, style: const TextStyle(color: Colors.white70)),
                          ],
                        ),
                      ),
                      const Icon(Icons.local_offer_rounded, color: Colors.white, size: 32),
                    ],
                  ),
                ),
              )),
          const SizedBox(height: 8),
          SectionCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Do'stingizni taklif qiling — bonus oling", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                const SizedBox(height: 8),
                const Text("Do'stingiz 1Fit orqali birinchi mashg'ulotga yozilsa, ikkalangiz ham bonus ball olasiz.",
                    style: TextStyle(color: AppColors.textSecondary)),
                const SizedBox(height: 14),
                PrimaryButton(
                  label: "Taklif qilish",
                  onPressed: () => shareInvite(context, "1Fit ilovasiga qo'shiling va birga mashg'ulot qilaylik! https://1fit.uz"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class BonusScreen extends StatelessWidget {
  const BonusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Bonuslar")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                  colors: [AppColors.accentPurple, Color(0xFF5B21B6)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight),
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Joriy balansingiz", style: TextStyle(color: Colors.white70)),
                SizedBox(height: 6),
                Text("200 ball", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 28)),
              ],
            ),
          ),
          const SizedBox(height: 18),
          const Text("Ball qanday to'planadi?", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 10),
          const _BonusTip(icon: Icons.check_circle_outline_rounded, text: "Har bir tasdiqlangan mashg'ulot uchun +10 ball"),
          const _BonusTip(icon: Icons.local_fire_department_rounded, text: "Haftalik seriya (streak) uchun bonus ball"),
          const _BonusTip(icon: Icons.person_add_alt_1_rounded, text: "Do'stingizni taklif qilsangiz +50 ball"),
        ],
      ),
    );
  }
}

class _BonusTip extends StatelessWidget {
  final IconData icon;
  final String text;
  const _BonusTip({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, color: AppColors.accentGreen, size: 20),
          const SizedBox(width: 10),
          Expanded(child: Text(text, style: const TextStyle(color: AppColors.textSecondary))),
        ],
      ),
    );
  }
}

class CommunityScreen extends StatefulWidget {
  const CommunityScreen({super.key});

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  bool _joined = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Hamjamiyat")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SectionCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.groups_rounded, color: AppColors.primary, size: 28),
                    SizedBox(width: 10),
                    Text("1Fit hamjamiyati", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
                  ],
                ),
                const SizedBox(height: 10),
                const Text(
                  "Boshqa foydalanuvchilar bilan tajriba almashing, birgalikda mashg'ulotlarga yoziling va motivatsiya toping.",
                  style: TextStyle(color: AppColors.textSecondary),
                ),
                const SizedBox(height: 16),
                PrimaryButton(
                  label: _joined ? "Siz a'zosiz" : "Qo'shilish",
                  color: _joined ? AppColors.accentGreen : null,
                  onPressed: () => setState(() => _joined = !_joined),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
