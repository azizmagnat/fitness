import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../state/app_settings.dart';
import '../state/user_profile.dart';
import '../widgets/feedback.dart';
import '../widgets/page_transitions.dart';
import 'edit_profile_screen.dart';
import 'settings_detail_screens.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  static const _items = [
    (Icons.person_outline_rounded, "Shaxsiy ma'lumotlar"),
    (Icons.verified_user_outlined, "Maxfiylik"),
    (Icons.grid_view_rounded, "Lentani sozlash"),
    (Icons.apartment_rounded, "Shaharni o'zgartirish"),
    (Icons.location_on_outlined, "Manzilni o'zgartirish"),
    (Icons.wb_sunny_outlined, "Mavzuni o'zgartirish"),
    (Icons.track_changes_rounded, "Maqsadni o'zgartirish"),
    (Icons.favorite_border_rounded, "Sevimli mashg'ulot turlari"),
    (Icons.public_rounded, "Tilni o'zgartirish"),
    (Icons.attach_money_rounded, "Xarid tarixi"),
    (Icons.calendar_month_rounded, "Google-kalendar"),
  ];

  static const _plainItems = ["Hujjatlar", "Hamkor bo'lish", "Ilova haqida"];

  void _confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text("Chiqishni xohlaysizmi?"),
        content: const Text("Hisobingizdan chiqasiz.", style: TextStyle(color: AppColors.textSecondary)),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text("Bekor qilish")),
          TextButton(
            onPressed: () async {
              Navigator.of(ctx).pop();
              await UserProfile.resetToDefault();
              if (context.mounted) {
                Navigator.of(context).popUntil((r) => r.isFirst);
                showConfirmed(context, "Tizimdan chiqdingiz");
              }
            },
            child: const Text("Chiqish", style: TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
    );
  }

  void _pickTheme(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text("Mavzuni tanlang"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<bool>(
              value: true,
              groupValue: true,
              activeColor: AppColors.primary,
              title: const Text("Tungi rejim", style: TextStyle(color: AppColors.textPrimary)),
              onChanged: (_) => Navigator.of(ctx).pop(),
            ),
            const ListTile(
              enabled: false,
              title: Text("Kunduzgi rejim", style: TextStyle(color: AppColors.textSecondary)),
              trailing: Text("Tez orada", style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
            ),
          ],
        ),
      ),
    );
  }

  void _openScreen(BuildContext context, Widget screen) {
    Navigator.of(context).push(slideRightRoute(screen));
  }

  void _pickLanguage(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text("Tilni tanlang"),
        content: ValueListenableBuilder<AppLanguage>(
          valueListenable: AppSettings.language,
          builder: (context, current, _) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: AppLanguage.values.map((lang) {
                final label = switch (lang) {
                  AppLanguage.uz => "O'zbekcha",
                  AppLanguage.ru => "Русский",
                  AppLanguage.en => "English",
                };
                return RadioListTile<AppLanguage>(
                  value: lang,
                  groupValue: current,
                  activeColor: AppColors.primary,
                  title: Text(label, style: const TextStyle(color: AppColors.textPrimary)),
                  onChanged: (v) {
                    if (v == null) return;
                    AppSettings.language.value = v;
                    Navigator.of(ctx).pop();
                    showConfirmed(context, "Til $label ga o'zgartirildi");
                  },
                );
              }).toList(),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: ValueListenableBuilder<AppLanguage>(
          valueListenable: AppSettings.language,
          builder: (context, _, __) => Text(AppSettings.t("settings_title")),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8),
        children: [
          ..._items.map((it) => _SettingsTile(
                icon: it.$1,
                label: it.$2,
                iconColor: AppColors.primary,
                onTap: () {
                  switch (it.$2) {
                    case "Shaxsiy ma'lumotlar":
                      _openScreen(context, const EditProfileScreen());
                      break;
                    case "Maxfiylik":
                      _openScreen(context, const PrivacyScreen());
                      break;
                    case "Lentani sozlash":
                      _openScreen(context, const FeedSettingsScreen());
                      break;
                    case "Shaharni o'zgartirish":
                      _openScreen(context, const CityScreen());
                      break;
                    case "Manzilni o'zgartirish":
                      _openScreen(context, const AddressScreen());
                      break;
                    case "Mavzuni o'zgartirish":
                      _pickTheme(context);
                      break;
                    case "Maqsadni o'zgartirish":
                      _openScreen(context, const GoalScreen());
                      break;
                    case "Sevimli mashg'ulot turlari":
                      _openScreen(context, const FavoriteCategoriesScreen());
                      break;
                    case "Tilni o'zgartirish":
                      _pickLanguage(context);
                      break;
                    case "Xarid tarixi":
                      _openScreen(context, const PurchaseHistoryScreen());
                      break;
                    case "Google-kalendar":
                      _openScreen(context, const CalendarInfoScreen());
                      break;
                    default:
                      showComingSoon(context, it.$2);
                  }
                },
              )),
          const SizedBox(height: 12),
          ..._plainItems.map((label) => _SettingsTile(
                label: label,
                onTap: () {
                  switch (label) {
                    case "Hujjatlar":
                      _openScreen(context, const DocumentsScreen());
                      break;
                    case "Hamkor bo'lish":
                      _openScreen(context, const PartnerScreen());
                      break;
                    case "Ilova haqida":
                      _openScreen(context, const AboutScreen());
                      break;
                    default:
                      showComingSoon(context, label);
                  }
                },
              )),
          const SizedBox(height: 28),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text("1Fit ijtimoiy tarmoqlari",
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
          ),
          const SizedBox(height: 14),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                _SocialCircle(
                    color: const Color(0xFFE1306C),
                    icon: Icons.camera_alt_rounded,
                    onTap: () => showComingSoon(context, "Instagram")),
                const SizedBox(width: 14),
                _SocialCircle(
                    color: const Color(0xFF229ED9),
                    icon: Icons.send_rounded,
                    onTap: () => showComingSoon(context, "Telegram")),
                const SizedBox(width: 14),
                _SocialCircle(
                    color: Colors.black,
                    icon: Icons.music_note_rounded,
                    onTap: () => showComingSoon(context, "TikTok")),
              ],
            ),
          ),
          const SizedBox(height: 32),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: GestureDetector(
              onTap: () => _confirmLogout(context),
              child: const Text("Chiqish",
                  style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.w600, fontSize: 15)),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData? icon;
  final String label;
  final Color? iconColor;
  final VoidCallback? onTap;
  const _SettingsTile({this.icon, required this.label, this.iconColor, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: icon != null ? Icon(icon, color: iconColor ?? AppColors.textPrimary) : null,
          minLeadingWidth: icon != null ? 24 : 0,
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: icon == null ? 0 : 4),
          title: Text(label, style: const TextStyle(fontSize: 15)),
          trailing: const Icon(Icons.chevron_right_rounded, color: AppColors.textSecondary),
          onTap: onTap ?? () => showComingSoon(context, label),
        ),
        const Divider(height: 1, color: AppColors.divider),
      ],
    );
  }
}

class _SocialCircle extends StatelessWidget {
  final Color color;
  final IconData icon;
  final VoidCallback onTap;
  const _SocialCircle({required this.color, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(22),
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }
}
