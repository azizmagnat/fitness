import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../theme/app_theme.dart';
import '../data/mock_data.dart';
import '../models/models.dart';
import '../widgets/app_actions.dart';
import '../widgets/feedback.dart';

class BookingSuccessScreen extends StatelessWidget {
  final ScheduleItem item;
  const BookingSuccessScreen({super.key, required this.item});

  static const _friends = ["Farangiz", "G'ayrat", "Diyora"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.accentGreen, Color(0xFF0B6E36), AppColors.background],
            begin: Alignment.topLeft,
            end: Alignment(0.2, 0.9),
            stops: [0, 0.35, 0.7],
          ),
        ),
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.close_rounded, color: Colors.white, size: 28),
                    onPressed: () => Navigator.of(context).popUntil((r) => r.isFirst),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Expanded(
                    child: Text(
                      "Siz mashg'ulotga yozildingiz",
                      style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold, height: 1.2),
                    ),
                  ),
                  Container(
                    width: 52,
                    height: 52,
                    decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                    child: const Icon(Icons.check_rounded, color: AppColors.accentGreen, size: 30),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(color: Colors.black45, borderRadius: BorderRadius.circular(14)),
                child: const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.warning_amber_rounded, color: AppColors.accentAmber, size: 20),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        "Mashg'ulotni boshlanishidan kamida 2 soat oldin bekor qilishingiz mumkin",
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 13.5),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              const Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.face_retouching_natural_rounded, color: Colors.white70, size: 20),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      "Mashg'ulot boshlanishidan oldin 30 daqiqa ichida mashg'ulotni tasdiqlang. Agar mashg'ulotga kechiksangiz, sizni kiritmasliklari mumkin",
                      style: TextStyle(color: Colors.white70, fontSize: 13.5, height: 1.4),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("💔", style: TextStyle(fontSize: 18)),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      "Mashg'ulotni o'tkazib yuborish yoki bekor qilish davomat statusingizni pasaytiradi",
                      style: TextStyle(color: Colors.white70, fontSize: 13.5, height: 1.4),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              InkWell(
                borderRadius: BorderRadius.circular(14),
                onTap: () async {
                  final uri = Uri.https("calendar.google.com", "/calendar/render", {
                    "action": "TEMPLATE",
                    "text": item.title,
                    "details": "1Fit: ${item.gymName}",
                    "location": item.gymName,
                  });
                  final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
                  if (!ok && context.mounted) showComingSoon(context, "Google Kalendar");
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(color: Colors.black38, borderRadius: BorderRadius.circular(14)),
                  child: const Row(
                    children: [
                      Icon(Icons.calendar_month_rounded, color: Colors.white, size: 20),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text("Mashg'ulotni Google-kalendariga qo'shish",
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 13.5)),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 28),
              const Text("Do'stlaringizni mashg'ulotga taklif qiling",
                  style: TextStyle(color: Colors.white, fontSize: 19, fontWeight: FontWeight.bold)),
              const SizedBox(height: 14),
              SizedBox(
                height: 176,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    Container(
                      width: 150,
                      padding: const EdgeInsets.all(14),
                      margin: const EdgeInsets.only(right: 12),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(colors: [AppColors.primary, AppColors.accentPurple]),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.group_add_rounded, color: Colors.white, size: 26),
                          const SizedBox(height: 10),
                          const Expanded(
                            child: Text("Telefon raqami orqali yoki mehmon abonementini hadya qiling",
                                style: TextStyle(color: Colors.white, fontSize: 12.5, fontWeight: FontWeight.w600)),
                          ),
                          SizedBox(
                            width: double.infinity,
                            height: 34,
                            child: ElevatedButton(
                              onPressed: () => shareInvite(
                                context,
                                "Menga ${item.gymName}dagi \"${item.title}\" mashg'ulotiga qo'shiling — 1Fit orqali! https://1fit.uz",
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: AppColors.primary,
                                padding: EdgeInsets.zero,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(17)),
                              ),
                              child: const Text("Taklif qilish", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                            ),
                          ),
                        ],
                      ),
                    ),
                    ..._friends.map((name) => Container(
                          width: 130,
                          padding: const EdgeInsets.all(14),
                          margin: const EdgeInsets.only(right: 12),
                          decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(18)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CircleAvatar(
                                radius: 20,
                                backgroundColor: AppColors.primary,
                                child: Text(name[0], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                              ),
                              const SizedBox(height: 10),
                              Expanded(
                                child: Text(name,
                                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 13)),
                              ),
                              SizedBox(
                                width: double.infinity,
                                height: 34,
                                child: ElevatedButton(
                                  onPressed: () => shareInvite(
                                    context,
                                    "Salom $name! Menga ${item.gymName}dagi \"${item.title}\" mashg'ulotiga qo'shiling — 1Fit orqali! https://1fit.uz",
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.primary,
                                    foregroundColor: Colors.white,
                                    padding: EdgeInsets.zero,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(17)),
                                  ),
                                  child: const Text("Taklif qilish", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                                ),
                              ),
                            ],
                          ),
                        )),
                  ],
                ),
              ),
              const SizedBox(height: 28),
              const Text("Yutuqli o'yinlar", style: TextStyle(color: Colors.white, fontSize: 19, fontWeight: FontWeight.bold)),
              const SizedBox(height: 14),
              SizedBox(
                height: 90,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: MockData.gamePrizes.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemBuilder: (context, i) {
                    final g = MockData.gamePrizes[i];
                    return Container(
                      width: 220,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(14)),
                      child: Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(color: AppColors.surfaceLight, borderRadius: BorderRadius.circular(10)),
                            alignment: Alignment.center,
                            child: Icon(g.icon, color: AppColors.primary, size: 18),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(g.title,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(color: Colors.white, fontSize: 11.5, fontWeight: FontWeight.w600)),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 28),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).popUntil((r) => r.isFirst),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                    elevation: 0,
                  ),
                  child: const Text("Jadvalga o'tish", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
