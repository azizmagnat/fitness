import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import '../theme/app_theme.dart';
import '../data/achievements.dart';
import '../models/models.dart';
import '../state/bookings_store.dart';
import '../state/user_profile.dart';
import '../state/social_store.dart';
import '../state/feed_store.dart';
import '../state/visits_store.dart';
import '../widgets/app_actions.dart';
import '../widgets/common.dart';
import '../widgets/feedback.dart';
import '../widgets/page_transitions.dart';
import '../widgets/shop_section.dart';
import 'edit_profile_screen.dart';
import 'info_screens.dart';
import 'settings_screen.dart';
import 'compose_post_screen.dart';
import 'visit_history_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _tab = 0;

  Future<void> _addStory() async {
    try {
      final file = await ImagePicker().pickImage(source: ImageSource.gallery, maxWidth: 1080, imageQuality: 85);
      if (file != null) {
        FeedStore.addPhotoStory(file.path);
        if (mounted) showConfirmed(context, "Story qo'shildi");
      }
    } catch (_) {
      if (mounted) showComingSoon(context, "Story qo'shish");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                height: 190,
                width: double.infinity,
                color: Colors.black,
                child: CustomPaint(
                  painter: const _ZigzagBannerPainter(),
                  child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.add_box_outlined, color: Colors.white),
                              onPressed: () => Navigator.of(context).push(slideUpRoute(const ComposePostScreen())),
                            ),
                            IconButton(
                              icon: const Icon(Icons.edit_outlined, color: Colors.white),
                              onPressed: () => Navigator.of(context).push(slideRightRoute(const EditProfileScreen())),
                            ),
                            IconButton(
                              icon: const Icon(Icons.settings_outlined, color: Colors.white),
                              onPressed: () => Navigator.of(context).push(slideRightRoute(const SettingsScreen())),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                ),
              ),
              Positioned(
                left: 16,
                bottom: -38,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.of(context).push(slideRightRoute(const EditProfileScreen())),
                      child: ValueListenableBuilder<String?>(
                        valueListenable: UserProfile.photoPath,
                        builder: (context, photoPath, _) {
                          return Container(
                            width: 76,
                            height: 76,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: AppColors.background, width: 3),
                              color: AppColors.primary,
                              image: photoPath != null
                                  ? DecorationImage(image: FileImage(File(photoPath)), fit: BoxFit.cover)
                                  : null,
                            ),
                            alignment: Alignment.center,
                            child: photoPath == null
                                ? ValueListenableBuilder<String>(
                                    valueListenable: UserProfile.name,
                                    builder: (context, _, __) => Text(UserProfile.initial,
                                        style: const TextStyle(
                                            color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
                                  )
                                : null,
                          );
                        },
                      ),
                    ),
                    Positioned(
                      right: -2,
                      bottom: -2,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: _addStory,
                        child: Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColors.background, width: 2),
                          ),
                          child: const Icon(Icons.add, color: Colors.white, size: 15),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 46),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    ValueListenableBuilder<String>(
                      valueListenable: UserProfile.name,
                      builder: (context, name, _) =>
                          Text(name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(width: 6),
                    const Icon(Icons.auto_awesome, color: AppColors.accentPurple, size: 16),
                  ],
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceLight,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.military_tech_rounded, size: 15, color: Color(0xFFCD7F32)),
                      SizedBox(width: 4),
                      Text("Bronza", style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                const Row(
                  children: [
                    _StatItem(value: "3", label: "Obunachilar"),
                    SizedBox(width: 28),
                    _StatItem(value: "9", label: "Obunalar"),
                    SizedBox(width: 28),
                    _StatItem(value: "12", label: "Ko'rganlar"),
                  ],
                ),
                const SizedBox(height: 14),
                ValueListenableBuilder<String>(
                  valueListenable: UserProfile.bio,
                  builder: (context, bio, _) => GestureDetector(
                    onTap: () => Navigator.of(context).push(slideRightRoute(const EditProfileScreen())),
                    child: bio.isEmpty
                        ? const Text("Biografiya qo'shish", style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600))
                        : Text(bio, style: const TextStyle(color: AppColors.textSecondary, fontSize: 13.5)),
                  ),
                ),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: () => _openSocialLinksSheet(context),
                  child: ValueListenableBuilder<String?>(
                    valueListenable: SocialStore.instagram,
                    builder: (context, ig, _) => ValueListenableBuilder<String?>(
                      valueListenable: SocialStore.tiktok,
                      builder: (context, tt, __) => Row(
                        children: [
                          const Icon(Icons.camera_alt_outlined, size: 16, color: AppColors.textSecondary),
                          const SizedBox(width: 4),
                          Text(ig ?? "Instagram", style: TextStyle(color: ig == null ? AppColors.textSecondary : AppColors.primary, fontSize: 13)),
                          const SizedBox(width: 16),
                          Icon(tt == null ? Icons.add : Icons.music_note_rounded, size: 14, color: AppColors.primary),
                          Text(" ${tt ?? "TikTok"}", style: const TextStyle(color: AppColors.primary, fontSize: 13, fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => shareInvite(context, "Men 1Fit'da mashg'ulot qilyapman — qo'shiling! https://1fit.uz"),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: AppColors.divider),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                        ),
                        child: const Text("Do'stlaringizni qo'shish", style: TextStyle(color: AppColors.textPrimary)),
                      ),
                    ),
                    const SizedBox(width: 10),
                    InkWell(
                      borderRadius: BorderRadius.circular(23),
                      onTap: () async {
                        await Clipboard.setData(const ClipboardData(text: "https://1fit.uz"));
                        if (context.mounted) showConfirmed(context, "Havola nusxalandi");
                      },
                      child: Container(
                        width: 46,
                        height: 46,
                        decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: AppColors.divider)),
                        child: const Icon(Icons.ios_share_rounded, size: 18),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 22),
          Row(
            children: [
              Expanded(child: _TabButton(label: "O'sish", selected: _tab == 0, onTap: () => setState(() => _tab = 0))),
              Expanded(child: _TabButton(label: "Postlar", selected: _tab == 1, onTap: () => setState(() => _tab = 1))),
            ],
          ),
          const Divider(height: 1, color: AppColors.divider),
          const SizedBox(height: 18),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                _InfoCard(
                  title: "Mening reytingim",
                  onTap: () => Navigator.of(context).push(slideRightRoute(const BonusScreen())),
                  child: Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: const BoxDecoration(color: AppColors.accentAmber, shape: BoxShape.circle),
                        alignment: Alignment.center,
                        child: const Icon(Icons.star_rounded, color: Colors.white),
                      ),
                      const SizedBox(width: 12),
                      const Text("200", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                      const SizedBox(width: 4),
                      const Text("ball", style: TextStyle(color: AppColors.textSecondary)),
                      const Spacer(),
                      const Icon(Icons.local_fire_department_rounded, size: 16, color: AppColors.accentAmber),
                      const SizedBox(width: 4),
                      const Text("2 hafta", style: TextStyle(color: AppColors.textSecondary)),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                _InfoCard(
                  title: "Mashg'ulotlar",
                  onTap: () => Navigator.of(context).push(slideRightRoute(const VisitHistoryScreen())),
                  child: ValueListenableBuilder<int>(
                    valueListenable: VisitsStore.totalVisits,
                    builder: (context, total, _) => ValueListenableBuilder<List<ScheduleItem>>(
                      valueListenable: BookingsStore.items,
                      builder: (context, bookings, __) {
                        final confirmed = bookings.where((b) => b.status == "Tasdiqlandi").length;
                        return Row(
                          children: [
                            Expanded(
                                child: _MiniStat(
                                    value: "$total",
                                    icon: Icons.star,
                                    color: AppColors.accentGreen,
                                    label: "Barcha mashg'ulotlar soni")),
                            Expanded(
                                child: _MiniStat(
                                    value: "${VisitsStore.visitedGyms.value.length}",
                                    icon: Icons.place,
                                    color: const Color(0xFF60A5FA),
                                    label: "Tashrif buyurgan zallar")),
                            Expanded(
                                child: _MiniStat(
                                    value: "$confirmed",
                                    icon: Icons.cyclone_rounded,
                                    color: const Color(0xFFA855F7),
                                    label: "Bu haftadagi mashg'ulotlar")),
                          ],
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Badge unlock state is derived from real activity, so rebuild
                // this block whenever a visit is recorded.
                ValueListenableBuilder<int>(
                  valueListenable: VisitsStore.totalVisits,
                  builder: (context, _, __) {
                    final unlocked = achievements.where((a) => !a.locked).length;
                    return Column(
                      children: [
                        GestureDetector(
                          onTap: () => _showAchievementDetail(context, achievements.first),
                          child: Row(
                            children: [
                              const Expanded(
                                child: Text("Yutuqlar",
                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
                              ),
                              Text("$unlocked / ${achievements.length} yutuq",
                                  style: const TextStyle(color: AppColors.primary)),
                              const Icon(Icons.chevron_right_rounded, color: AppColors.primary, size: 20),
                            ],
                          ),
                        ),
                        const SizedBox(height: 14),
                        SizedBox(
                          height: 70,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: achievements.length,
                            separatorBuilder: (_, __) => const SizedBox(width: 12),
                            itemBuilder: (context, i) {
                              final a = achievements[i];
                              return _BadgeIcon(
                                icon: a.icon,
                                locked: a.locked,
                                color: a.locked ? null : a.color,
                                onTap: () => _showAchievementDetail(context, a),
                              );
                            },
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 26),
          const ShopSection(),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

void _showAchievementDetail(BuildContext context, Achievement a) {
  showModalBottomSheet(
    context: context,
    backgroundColor: AppColors.surfaceLight,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
    builder: (ctx) => SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: a.locked ? AppColors.surface : a.color.withValues(alpha: 0.18),
                border: Border.all(color: a.locked ? AppColors.divider : a.color, width: 1.5),
              ),
              alignment: Alignment.center,
              child: Icon(a.icon, size: 30, color: a.locked ? AppColors.textSecondary : a.color),
            ),
            const SizedBox(height: 14),
            Text(a.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
            const SizedBox(height: 8),
            Text(a.description, textAlign: TextAlign.center, style: const TextStyle(color: AppColors.textSecondary)),
            const SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: (a.progress / a.target).clamp(0.0, 1.0),
                minHeight: 6,
                backgroundColor: AppColors.surface,
                valueColor: AlwaysStoppedAnimation(a.locked ? AppColors.textSecondary : a.color),
              ),
            ),
            const SizedBox(height: 8),
            Text(a.locked ? "${a.progress} / ${a.target}" : "Qo'lga kiritildi ✓",
                style: TextStyle(
                    color: a.locked ? AppColors.textSecondary : a.color, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
          ],
        ),
      ),
    ),
  );
}

void _openSocialLinksSheet(BuildContext context) {
  final igController = TextEditingController(text: SocialStore.instagram.value ?? "");
  final ttController = TextEditingController(text: SocialStore.tiktok.value ?? "");
  showModalBottomSheet(
    context: context,
    backgroundColor: AppColors.surfaceLight,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
    builder: (ctx) => Padding(
      padding: EdgeInsets.fromLTRB(24, 24, 24, MediaQuery.of(ctx).viewInsets.bottom + 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Ijtimoiy tarmoqni ulash", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
          const SizedBox(height: 16),
          TextField(
            controller: igController,
            decoration: const InputDecoration(prefixIcon: Icon(Icons.camera_alt_outlined), hintText: "Instagram foydalanuvchi nomi"),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: ttController,
            decoration: const InputDecoration(prefixIcon: Icon(Icons.music_note_rounded), hintText: "TikTok foydalanuvchi nomi"),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: PrimaryButton(
              label: "Saqlash",
              onPressed: () async {
                await SocialStore.setInstagram(igController.text);
                await SocialStore.setTiktok(ttController.text);
                if (ctx.mounted) Navigator.of(ctx).pop();
              },
            ),
          ),
        ],
      ),
    ),
  );
}

/// Black banner with thick neon zigzag streaks, like the original profile
/// header (purple/blue/magenta lightning pattern).
class _ZigzagBannerPainter extends CustomPainter {
  const _ZigzagBannerPainter();

  @override
  void paint(Canvas canvas, Size size) {
    const colors = [Color(0xFF8B5CF6), Color(0xFF3B82F6), Color(0xFFD946EF)];
    for (var s = 0; s < 3; s++) {
      final paint = Paint()
        ..color = colors[s]
        ..strokeWidth = 30
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..style = PaintingStyle.stroke;
      final baseY = -20.0 + s * 52;
      final path = Path()..moveTo(-30, baseY + 40);
      var up = true;
      for (double x = -30; x < size.width + 60; x += 90) {
        path.lineTo(x + 90, up ? baseY - 26 : baseY + 66);
        up = !up;
      }
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _ZigzagBannerPainter oldDelegate) => false;
}

class _StatItem extends StatelessWidget {
  final String value;
  final String label;
  const _StatItem({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
      ],
    );
  }
}

class _TabButton extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _TabButton({required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Text(label,
                style: TextStyle(
                    color: selected ? AppColors.textPrimary : AppColors.textSecondary,
                    fontWeight: selected ? FontWeight.bold : FontWeight.normal)),
          ),
          Container(height: 2, width: 60, color: selected ? AppColors.primary : Colors.transparent),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String title;
  final Widget child;
  final VoidCallback? onTap;
  const _InfoCard({required this.title, required this.child, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15))),
              GestureDetector(
                onTap: onTap ?? () => showComingSoon(context, title),
                child: const Row(
                  children: [
                    Text("Batafsilroq", style: TextStyle(color: AppColors.primary, fontSize: 13)),
                    Icon(Icons.chevron_right_rounded, color: AppColors.primary, size: 20),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  final String value;
  final IconData icon;
  final Color color;
  final String label;
  const _MiniStat({required this.value, required this.icon, this.color = AppColors.accentGreen, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(width: 3),
            Icon(icon, size: 13, color: color),
          ],
        ),
        const SizedBox(height: 2),
        Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 10.5), maxLines: 2),
      ],
    );
  }
}

class _BadgeIcon extends StatelessWidget {
  final IconData icon;
  final bool locked;
  final Color? color;
  final VoidCallback onTap;
  const _BadgeIcon({required this.icon, this.locked = false, this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(30),
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: locked ? AppColors.surfaceLight : (color ?? AppColors.primary).withValues(alpha: 0.18),
          border: Border.all(color: locked ? AppColors.divider : (color ?? AppColors.primary), width: 1.5),
        ),
        alignment: Alignment.center,
        child: Icon(icon, size: 26, color: locked ? AppColors.textSecondary : (color ?? AppColors.primary)),
      ),
    );
  }
}

class SectionCardPromo extends StatelessWidget {
  final String title;
  final String subtitle;
  final String days;
  final VoidCallback onTap;
  const SectionCardPromo({super.key, required this.title, required this.subtitle, required this.days, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(14)),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  const SizedBox(height: 4),
                  Text(subtitle, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                  const SizedBox(height: 4),
                  Text(days, style: const TextStyle(color: AppColors.accentGreen, fontSize: 12)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: AppColors.textSecondary, size: 20),
          ],
        ),
      ),
    );
  }
}
