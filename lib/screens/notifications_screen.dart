import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../state/app_settings.dart';
import '../widgets/feedback.dart';
import '../widgets/page_transitions.dart';
import 'shop_screen.dart';

class _Notif {
  final IconData icon;
  final String title;
  final String body;
  final String date;
  final String category;
  final bool recent;
  final bool hasRequestButton;
  const _Notif(this.icon, this.title, this.body, this.date, this.category,
      {this.recent = true, this.hasRequestButton = false});
}

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  static const _tabs = ["Lenta", "Mashg'ulotlar", "Yutuqlar", "Aksiyalar"];
  int _tab = 0;

  static const _items = [
    _Notif(Icons.notifications_none_rounded, "Tabriklaymiz! 🎉", "Sizda 1 yangi yutuq bor", "28-iyul, 20:03",
        "Yutuqlar"),
    _Notif(
        Icons.chat_bubble_outline_rounded,
        "Mashg'ulot yaxshi bo'ldimi, Azizbek?",
        "Taassurotlaringiz bilan bo'lishing, shunda biz nimani yaxshilash kerakligini biladigan bo'lamiz 💙",
        "28-iyul, 19:19",
        "Mashg'ulotlar"),
    _Notif(Icons.notifications_none_rounded, "Tabriklaymiz! 🎉", "Sizda 1 yangi yutuq bor", "27-iyul, 15:13",
        "Yutuqlar"),
    _Notif(Icons.place_outlined, "Sizning yaqiningizda", "yangi zal qo'shildi", "27-iyul, 16:07", "Lenta"),
    _Notif(Icons.person_outline_rounded, "Farangiz", "obuna so'rovingizni qabul qildi ✨", "26-iyul, 15:14", "Lenta",
        hasRequestButton: true),
    _Notif(Icons.person_outline_rounded, "Farangiz", "sizga obuna bo'ldi ✨", "26-iyul, 15:14", "Lenta",
        hasRequestButton: true),
    _Notif(
        Icons.access_time_rounded,
        "Azizbek, mashg'ulotga tayyormisiz?",
        "20:00da sizni Afrosiyob Hotelda kutamiz. Iltimos, kechikmang",
        "24-iyul, 18:31",
        "Mashg'ulotlar"),
    _Notif(Icons.notifications_none_rounded, "Tabriklaymiz! 🎉", "Sizda 2 yangi yutuq bor", "23-iyul, 17:16",
        "Yutuqlar"),
    _Notif(
        Icons.bolt_rounded,
        "Sir tufayli Nurmuhammad endi 1Fit'ni sinab ko'radi ⚡",
        "Agar u abonement xarid qilsa, sizga bonus kunlar qo'shiladi",
        "21-iyul, 17:47",
        "Lenta",
        recent: false),
    _Notif(Icons.auto_awesome_rounded, "Ajoyib start!", "Biz bilan uzoq vaqt birga bo'lishingizga umid qilamiz 💙",
        "20-iyul, 17:43", "Lenta",
        recent: false),
    _Notif(
        Icons.emoji_events_outlined,
        "BYD Yuan Up, Dyson, iPhone yoki PS5 yutib oling",
        "1Fit'ning 12 oylik abonementini oyiga atigi 557 500 so'mdan to'lov asosida xarid qiling va sovrinli o'yinda ishtirok eting!",
        "20-iyul, 16:32",
        "Aksiyalar",
        recent: false),
    _Notif(
        Icons.support_agent_rounded,
        "Suhbatingiz yaxshi bo'ldimi?",
        "1Fit menejeri yaqinda sizga qo'ng'iroq qilgan edi. Iltimos, ushbu suhbat qanchalik foydali bo'lganini baholang",
        "18-iyul, 17:52",
        "Mashg'ulotlar",
        recent: false),
    _Notif(Icons.favorite_border_rounded, "Va'da qilganimizdek 💙",
        "Azizbek Tuymurodov, abonementingizga 30 kun qo'shildi", "18-iyul, 17:32", "Lenta",
        recent: false),
    _Notif(
        Icons.credit_card_rounded,
        "Barcha sport turlari endi Yandex Split orqali 💙",
        "Sport zallari, basseynlar, yoga va boks — barchasi bitta abonementda, oyiga atigi 540 833 so'mdan. Yandex Split rasmiylashtiring va keyinroq to'lang!",
        "17-iyul, 14:41",
        "Aksiyalar",
        recent: false),
    _Notif(
        Icons.credit_card_rounded,
        "1Fit abonementini Payloter orqali rasmiylashtirish mumkinligini bilarmiding?",
        "Ichida 500+ zal va sportning turli yo'nalishlari bor. Eng yaxshi tomoni — muddatli to'lovni 19 yoshdan boshlab rasmiylashtirish mumkin",
        "15-iyul, 20:54",
        "Aksiyalar",
        recent: false),
  ];

  @override
  Widget build(BuildContext context) {
    final visible = _tab == 0 ? _items : _items.where((n) => n.category == _tabs[_tab]).toList();
    final recent = visible.where((n) => n.recent).toList();
    final older = visible.where((n) => !n.recent).toList();

    return Scaffold(
      appBar: AppBar(
        title: ValueListenableBuilder<AppLanguage>(
          valueListenable: AppSettings.language,
          builder: (context, _, __) => Text(AppSettings.t("notifications_title")),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
        children: [
          SizedBox(
            height: 38,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _tabs.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, i) {
                final selected = i == _tab;
                return InkWell(
                  borderRadius: BorderRadius.circular(19),
                  onTap: () => setState(() => _tab = i),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: selected ? AppColors.textPrimary : AppColors.surface,
                      borderRadius: BorderRadius.circular(19),
                    ),
                    child: Text(_tabs[i],
                        style: TextStyle(
                            color: selected ? Colors.black : AppColors.textSecondary,
                            fontWeight: FontWeight.w600,
                            fontSize: 13.5)),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 14),
          _ProPromoCard(),
          if (recent.isNotEmpty) ...[
            const Padding(
              padding: EdgeInsets.fromLTRB(0, 22, 0, 12),
              child: Text("Oxirgi 7 kun", style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold)),
            ),
            for (final n in recent) _NotifTile(n),
          ],
          if (older.isNotEmpty) ...[
            const Padding(
              padding: EdgeInsets.fromLTRB(0, 22, 0, 12),
              child: Text("Oxirgi 30 kun", style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold)),
            ),
            for (final n in older) _NotifTile(n),
          ],
        ],
      ),
    );
  }
}

class _ProPromoCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF10214D),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF2F6BFF), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                      colors: [Color(0xFF2F6BFF), Color(0xFF1E3FBF)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight),
                  borderRadius: BorderRadius.circular(11),
                ),
                alignment: Alignment.center,
                child: const Text("PRO",
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 11)),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("1Fit Pro obunasi",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.white)),
                    SizedBox(height: 3),
                    Text("Har kun uchun mashg'ulotlar va ovqatlanish rejangiz",
                        style: TextStyle(color: Colors.white70, fontSize: 13)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.only(left: 52),
            child: InkWell(
              onTap: () => Navigator.of(context).push(slideRightRoute(const ShopScreen())),
              child: const Text("Rasmiylashtirish",
                  style: TextStyle(color: Color(0xFF6FA7FF), fontWeight: FontWeight.w600, fontSize: 14)),
            ),
          ),
        ],
      ),
    );
  }
}

class _NotifTile extends StatelessWidget {
  final _Notif n;
  const _NotifTile(this.n);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () => showComingSoon(context, n.title),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: const BoxDecoration(color: AppColors.surface, shape: BoxShape.circle),
              alignment: Alignment.center,
              child: Icon(n.icon, color: AppColors.textSecondary, size: 21),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(n.title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14.5, height: 1.3)),
                  const SizedBox(height: 3),
                  Text(n.body, style: const TextStyle(color: AppColors.textSecondary, fontSize: 13.5, height: 1.35)),
                  const SizedBox(height: 5),
                  Text(n.date, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                  if (n.hasRequestButton) ...[
                    const SizedBox(height: 8),
                    InkWell(
                      borderRadius: BorderRadius.circular(18),
                      onTap: () => showConfirmed(context, "So'rov yuborildi"),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: const Text("So'rov yuborish",
                            style:
                                TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600, fontSize: 13)),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
