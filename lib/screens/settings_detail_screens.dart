import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../data/mock_data.dart';
import '../state/preferences_store.dart';
import '../state/subscription_store.dart';
import '../widgets/common.dart';
import '../widgets/feedback.dart';
import '../widgets/sound.dart';

class _ToggleRow extends StatelessWidget {
  final String title;
  final String subtitle;
  final ValueNotifier<bool> notifier;
  final Future<void> Function(bool) onChanged;
  const _ToggleRow({required this.title, required this.subtitle, required this.notifier, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: notifier,
      builder: (context, value, _) => SwitchListTile(
        value: value,
        onChanged: (v) => onChanged(v),
        activeThumbColor: AppColors.primary,
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14.5)),
        subtitle: Text(subtitle, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12.5)),
      ),
    );
  }
}

class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Maxfiylik")),
      body: ListView(
        children: [
          _ToggleRow(
            title: "Profilni ommaviy qilish",
            subtitle: "Boshqalar sizning profilingizni ko'ra oladi",
            notifier: PreferencesStore.profilePublic,
            onChanged: PreferencesStore.setProfilePublic,
          ),
          const Divider(height: 1, color: AppColors.divider),
          _ToggleRow(
            title: "Faollikni ko'rsatish",
            subtitle: "Do'stlaringiz mashg'ulotlaringizni ko'radi",
            notifier: PreferencesStore.showActivity,
            onChanged: PreferencesStore.setShowActivity,
          ),
          const Divider(height: 1, color: AppColors.divider),
          _ToggleRow(
            title: "Joylashuvni ulashish",
            subtitle: "Yaqin atrofdagi zallarni topishga yordam beradi",
            notifier: PreferencesStore.shareLocation,
            onChanged: PreferencesStore.setShareLocation,
          ),
        ],
      ),
    );
  }
}

class FeedSettingsScreen extends StatelessWidget {
  const FeedSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Lentani sozlash")),
      body: ListView(
        children: [
          _ToggleRow(
            title: "Story'larni avtomatik o'ynatish",
            subtitle: "Story ochilganda avtomatik boshlanadi",
            notifier: PreferencesStore.feedAutoplay,
            onChanged: PreferencesStore.setFeedAutoplay,
          ),
          const Divider(height: 1, color: AppColors.divider),
          _ToggleRow(
            title: "Story bildirishnomalari",
            subtitle: "Yangi story qo'shilganda xabar bering",
            notifier: PreferencesStore.storyNotifications,
            onChanged: PreferencesStore.setStoryNotifications,
          ),
          const Divider(height: 1, color: AppColors.divider),
          _ToggleRow(
            title: "Tavsiyalar",
            subtitle: "Sizga mos zallar va mashg'ulotlarni ko'rsatish",
            notifier: PreferencesStore.feedRecommendations,
            onChanged: PreferencesStore.setFeedRecommendations,
          ),
        ],
      ),
    );
  }
}

class CityScreen extends StatelessWidget {
  const CityScreen({super.key});

  static const _cities = [
    "Toshkent", "Samarqand", "Buxoro", "Andijon", "Farg'ona",
    "Namangan", "Qarshi", "Xiva", "Nukus", "Termiz",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Shaharni tanlang")),
      body: ValueListenableBuilder<String?>(
        valueListenable: PreferencesStore.city,
        builder: (context, selected, _) => ListView.separated(
          itemCount: _cities.length,
          separatorBuilder: (_, __) => const Divider(height: 1, color: AppColors.divider),
          itemBuilder: (context, i) {
            final c = _cities[i];
            return ListTile(
              title: Text(c),
              trailing: c == selected ? const Icon(Icons.check_circle_rounded, color: AppColors.primary) : null,
              onTap: () {
                AppSound.tap();
                PreferencesStore.setCity(c);
                Navigator.of(context).pop();
              },
            );
          },
        ),
      ),
    );
  }
}

class AddressScreen extends StatefulWidget {
  const AddressScreen({super.key});

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: PreferencesStore.address.value ?? "");
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Manzilni o'zgartirish")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Uy manzilingiz", style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
            const SizedBox(height: 8),
            TextField(
              controller: _controller,
              autofocus: true,
              decoration: InputDecoration(
                filled: true,
                fillColor: AppColors.surface,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
                hintText: "Ko'cha, uy raqami",
                hintStyle: const TextStyle(color: AppColors.textSecondary),
              ),
            ),
            const SizedBox(height: 20),
            PrimaryButton(
              label: "Saqlash",
              onPressed: () async {
                await PreferencesStore.setAddress(_controller.text);
                if (context.mounted) {
                  showConfirmed(context, "Manzil saqlandi");
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class GoalScreen extends StatelessWidget {
  const GoalScreen({super.key});

  static const _goals = [
    ("Vazn yo'qotish", Icons.monitor_weight_outlined),
    ("Mushak massasi orttirish", Icons.fitness_center_rounded),
    ("Chidamlilikni oshirish", Icons.directions_run_rounded),
    ("Sog'lom turmush tarzi", Icons.favorite_border_rounded),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Maqsadingizni tanlang")),
      body: ValueListenableBuilder<String?>(
        valueListenable: PreferencesStore.goal,
        builder: (context, selected, _) => ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: _goals.length,
          separatorBuilder: (_, __) => const SizedBox(height: 10),
          itemBuilder: (context, i) {
            final (label, icon) = _goals[i];
            final isSelected = label == selected;
            return InkWell(
              borderRadius: BorderRadius.circular(14),
              onTap: () {
                AppSound.tap();
                PreferencesStore.setGoal(label);
                Navigator.of(context).pop();
              },
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary.withValues(alpha: 0.15) : AppColors.surface,
                  borderRadius: BorderRadius.circular(14),
                  border: isSelected ? Border.all(color: AppColors.primary) : null,
                ),
                child: Row(
                  children: [
                    Icon(icon, color: isSelected ? AppColors.primary : AppColors.textSecondary),
                    const SizedBox(width: 12),
                    Expanded(child: Text(label, style: const TextStyle(fontWeight: FontWeight.w600))),
                    if (isSelected) const Icon(Icons.check_circle_rounded, color: AppColors.primary),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class FavoriteCategoriesScreen extends StatelessWidget {
  const FavoriteCategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final all = [...MockData.workoutTypes, ...MockData.bonusWorkoutTypes];
    return Scaffold(
      appBar: AppBar(title: const Text("Sevimli mashg'ulot turlari")),
      body: ValueListenableBuilder<List<String>>(
        valueListenable: PreferencesStore.favoriteCategories,
        builder: (context, favorites, _) => ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: all.length,
          separatorBuilder: (_, __) => const SizedBox(height: 10),
          itemBuilder: (context, i) {
            final c = all[i];
            final selected = favorites.contains(c.label);
            return InkWell(
              borderRadius: BorderRadius.circular(14),
              onTap: () => PreferencesStore.toggleFavoriteCategory(c.label),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: selected ? AppColors.primary.withValues(alpha: 0.15) : AppColors.surface,
                  borderRadius: BorderRadius.circular(14),
                  border: selected ? Border.all(color: AppColors.primary) : null,
                ),
                child: Row(
                  children: [
                    Icon(c.icon, color: selected ? AppColors.primary : AppColors.textSecondary),
                    const SizedBox(width: 12),
                    Expanded(child: Text(c.label, style: const TextStyle(fontWeight: FontWeight.w600))),
                    Icon(selected ? Icons.check_circle_rounded : Icons.add_circle_outline_rounded,
                        color: selected ? AppColors.primary : AppColors.textSecondary),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class PurchaseHistoryScreen extends StatelessWidget {
  const PurchaseHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Xarid tarixi")),
      body: ValueListenableBuilder<List<String>>(
        valueListenable: SubscriptionStore.purchaseHistory,
        builder: (context, purchases, _) {
          if (purchases.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: const BoxDecoration(color: AppColors.surface, shape: BoxShape.circle),
                    child: const Icon(Icons.receipt_long_outlined, color: AppColors.textSecondary, size: 28),
                  ),
                  const SizedBox(height: 14),
                  const Text("Hali xaridlar yo'q", style: TextStyle(color: AppColors.textSecondary)),
                ],
              ),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: purchases.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, i) => SectionCard(
              child: Row(
                children: [
                  const Icon(Icons.check_circle_rounded, color: AppColors.accentGreen, size: 18),
                  const SizedBox(width: 12),
                  Expanded(child: Text(purchases[i], style: const TextStyle(fontWeight: FontWeight.w600))),
                  const Text("demo", style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class CalendarInfoScreen extends StatelessWidget {
  const CalendarInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Google-kalendar")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SectionCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(Icons.calendar_month_rounded, color: AppColors.primary, size: 26),
                  SizedBox(width: 10),
                  Text("Kalendar integratsiyasi", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                ],
              ),
              const SizedBox(height: 12),
              const Text(
                "Har safar mashg'ulotga yozilganingizda, tasdiqlash ekranida \"Google-kalendariga qo'shish\" tugmasi orqali mashg'ulot vaqtini kalendaringizga qo'shishingiz mumkin. Alohida hisobga ulanish shart emas.",
                style: TextStyle(color: AppColors.textSecondary, height: 1.4),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DocumentsScreen extends StatelessWidget {
  const DocumentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Hujjatlar")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          _DocTile(title: "Foydalanish shartlari",
              body: "1Fit ilovasidan foydalanish orqali siz zallarning ichki tartib-qoidalariga, tashrif vaqtida "
                  "kech qolmaslik va band qilingan mashg'ulotni o'z vaqtida tasdiqlash talablariga rozilik bildirasiz."),
          SizedBox(height: 12),
          _DocTile(title: "Maxfiylik siyosati",
              body: "Sizning shaxsiy ma'lumotlaringiz (ism, profil surati) faqat ilova ichida, qurilmangizda saqlanadi "
                  "va uchinchi tomonlarga uzatilmaydi."),
          SizedBox(height: 12),
          _DocTile(title: "Bekor qilish siyosati",
              body: "Mashg'ulotni boshlanishidan kamida 2 soat oldin bekor qilishingiz mumkin. Aks holda davomat "
                  "statusingiz pasayishi mumkin."),
        ],
      ),
    );
  }
}

class _DocTile extends StatelessWidget {
  final String title;
  final String body;
  const _DocTile({required this.title, required this.body});

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          const SizedBox(height: 8),
          Text(body, style: const TextStyle(color: AppColors.textSecondary, height: 1.4)),
        ],
      ),
    );
  }
}

class PartnerScreen extends StatefulWidget {
  const PartnerScreen({super.key});

  @override
  State<PartnerScreen> createState() => _PartnerScreenState();
}

class _PartnerScreenState extends State<PartnerScreen> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _messageController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Hamkor bo'lish")),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            "Zalingizni 1Fit tarmog'iga qo'shmoqchimisiz? Ma'lumotlaringizni qoldiring — jamoamiz siz bilan bog'lanadi.",
            style: TextStyle(color: AppColors.textSecondary, height: 1.4),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _nameController,
            decoration: InputDecoration(
              filled: true,
              fillColor: AppColors.surface,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
              hintText: "Zal nomi",
              hintStyle: const TextStyle(color: AppColors.textSecondary),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _phoneController,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              filled: true,
              fillColor: AppColors.surface,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
              hintText: "Telefon raqami",
              hintStyle: const TextStyle(color: AppColors.textSecondary),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _messageController,
            maxLines: 4,
            decoration: InputDecoration(
              filled: true,
              fillColor: AppColors.surface,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
              hintText: "Qo'shimcha ma'lumot",
              hintStyle: const TextStyle(color: AppColors.textSecondary),
            ),
          ),
          const SizedBox(height: 20),
          PrimaryButton(
            label: "Ariza yuborish",
            onPressed: () {
              if (_nameController.text.trim().isEmpty || _phoneController.text.trim().isEmpty) {
                showWarning(context, "Iltimos, zal nomi va telefon raqamini kiriting");
                return;
              }
              showConfirmed(context, "Arizangiz qabul qilindi — tez orada bog'lanamiz");
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Ilova haqida")),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Center(
            child: Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(20),
              ),
              alignment: Alignment.center,
              child: const Text("1F", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 26)),
            ),
          ),
          const SizedBox(height: 16),
          const Center(child: Text("1Fit", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20))),
          const SizedBox(height: 4),
          const Center(child: Text("Versiya 1.0.0", style: TextStyle(color: AppColors.textSecondary))),
          const SizedBox(height: 24),
          const Text(
            "1Fit — bitta obuna bilan yuzlab sport zallari, basseynlar va fitnes studiyalariga kirish imkonini beruvchi ilova.",
            style: TextStyle(color: AppColors.textSecondary, height: 1.4),
          ),
        ],
      ),
    );
  }
}

class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

  static const _faq = [
    ("Mashg'ulotni qanday bekor qilaman?", "Jadval bo'limida mashg'ulotni oching va \"Bekor qilish\" tugmasini bosing."),
    ("Tasdiqlashda muammo bo'lsa-chi?", "QR yoki yuz orqali tasdiqlay olmasangiz, ekrandagi \"Qo'lda tasdiqlash\" tugmasidan foydalaning."),
    ("Obunani qanday muzlataman?", "Do'kon bo'limidagi \"Muzlatish\" orqali."),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Qo'llab-quvvatlash")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text("Ko'p beriladigan savollar", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 12),
          ..._faq.map((f) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: SectionCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(f.$1, style: const TextStyle(fontWeight: FontWeight.w600)),
                      const SizedBox(height: 6),
                      Text(f.$2, style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                    ],
                  ),
                ),
              )),
          const SizedBox(height: 10),
          PrimaryButton(
            label: "Xabar yozish",
            onPressed: () => showReportIssueDialog(context, "Qo'llab-quvvatlash"),
          ),
        ],
      ),
    );
  }
}

class RulesScreen extends StatelessWidget {
  const RulesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Zal qoidalari")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ...MockData.visitRules.map((r) => _RuleTile(r)),
          ...MockData.bringRules.map((r) => _RuleTile(r)),
          ...MockData.bringRulesExtra.map((r) => _RuleTile(r)),
        ],
      ),
    );
  }
}

class _RuleTile extends StatelessWidget {
  final String text;
  const _RuleTile(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.check_circle_outline_rounded, color: AppColors.primary, size: 18),
          const SizedBox(width: 10),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}
