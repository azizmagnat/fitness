import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_theme.dart';
import '../data/gym_visuals.dart';
import '../models/models.dart';
import '../state/saved_store.dart';
import '../state/visits_store.dart';
import '../widgets/app_actions.dart';
import '../widgets/feedback.dart';
import '../widgets/gym_map.dart';
import '../widgets/page_transitions.dart';
import 'gym_story_viewer_screen.dart';
import 'map_view_screen.dart';
import 'time_slot_screen.dart';
import 'visit_history_screen.dart';

class GymDetailScreen extends StatefulWidget {
  final Gym gym;
  const GymDetailScreen({super.key, required this.gym});

  @override
  State<GymDetailScreen> createState() => _GymDetailScreenState();
}

class _GymDetailScreenState extends State<GymDetailScreen> {
  int _photoIndex = 0;
  bool _descExpanded = false;
  bool _showingOriginal = false;

  String get _phoneNumber {
    if (widget.gym.phone != null) return widget.gym.phone!;
    final seed = widget.gym.name.codeUnits.fold<int>(0, (a, b) => a + b);
    final part1 = 90 + (seed % 10);
    final part2 = 100 + (seed * 7 % 900);
    final part3 = 10 + (seed * 3 % 90);
    final part4 = 10 + (seed * 11 % 90);
    return "+998 $part1 $part2 $part3 $part4";
  }

  String get _distance {
    if (widget.gym.distance != null) return widget.gym.distance!;
    final seed = widget.gym.name.codeUnits.fold<int>(0, (a, b) => a + b);
    return "${(seed % 42 + 6) / 10} km";
  }

  void _showCallDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surfaceLight,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Bog'lanish", style: TextStyle(color: AppColors.textSecondary, fontSize: 15)),
              const SizedBox(height: 14),
              Text(_phoneNumber, style: const TextStyle(fontSize: 23, fontWeight: FontWeight.w600)),
              const SizedBox(height: 26),
              Center(
                child: TextButton(
                  onPressed: () => Navigator.of(ctx).pop(),
                  child: const Text("Bekor qilish",
                      style: TextStyle(color: AppColors.primary, fontSize: 17, fontWeight: FontWeight.w600)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final gym = widget.gym;

    return Scaffold(
      body: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.only(bottom: 110),
            children: [
              _buildHeader(gym),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(gym.name, style: const TextStyle(fontSize: 33, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Text(gym.rating.toStringAsFixed(1),
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
                        const SizedBox(width: 5),
                        const Icon(Icons.star, color: AppColors.accentGreen, size: 17),
                        const SizedBox(width: 12),
                        Text(gym.category,
                            style: const TextStyle(color: AppColors.textPrimary, fontSize: 17)),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(gym.address, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const Icon(Icons.navigation_outlined, size: 17, color: AppColors.textSecondary),
                        const SizedBox(width: 6),
                        Text("Sizdan $_distance",
                            style: const TextStyle(color: AppColors.textSecondary, fontSize: 16)),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const Divider(height: 1, color: AppColors.divider),
                    if (gym.visitsUsed > 0) ...[
                      const SizedBox(height: 20),
                      ValueListenableBuilder<Map<String, int>>(
                        valueListenable: VisitsStore.remaining,
                        builder: (context, _, __) {
                          final max = VisitsStore.maxFor(gym.name);
                          final left = VisitsStore.remainingFor(gym.name);
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text("${max}dan $left tashrif qoldi",
                                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 19)),
                                  ),
                                  InkWell(
                                    borderRadius: BorderRadius.circular(6),
                                    onTap: () => Navigator.of(context)
                                        .push(slideRightRoute(VisitHistoryScreen(gymName: gym.name))),
                                    child: const Text("Batafsilroq",
                                        style: TextStyle(
                                            color: AppColors.primary,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600)),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: LinearProgressIndicator(
                                  value: max == 0 ? 0 : (left / max).clamp(0.0, 1.0),
                                  minHeight: 7,
                                  backgroundColor: AppColors.surfaceLight,
                                  valueColor: const AlwaysStoppedAnimation(AppColors.primary),
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text("Shu yerda va shu oyda qoldi",
                                  style: TextStyle(color: AppColors.textSecondary, fontSize: 15)),
                            ],
                          );
                        },
                      ),
                    ],
                    if (gym.description.isNotEmpty) ...[
                      const SizedBox(height: 30),
                      const Text("Tavsif", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26)),
                      const SizedBox(height: 12),
                      GestureDetector(
                        onTap: () => setState(() => _descExpanded = !_descExpanded),
                        child: _descExpanded
                            ? Text(gym.description,
                                style: const TextStyle(
                                    color: AppColors.textPrimary, fontSize: 16.5, height: 1.45))
                            : Text.rich(
                                TextSpan(
                                  children: [
                                    TextSpan(
                                        text: gym.description.length > 190
                                            ? "${gym.description.substring(0, 190)}... "
                                            : gym.description),
                                    if (gym.description.length > 190)
                                      const TextSpan(
                                          text: "Hammasini o'qish",
                                          style: TextStyle(
                                              color: AppColors.primary, fontWeight: FontWeight.w600)),
                                  ],
                                ),
                                style: const TextStyle(
                                    color: AppColors.textPrimary, fontSize: 16.5, height: 1.45),
                              ),
                      ),
                      const SizedBox(height: 16),
                      GestureDetector(
                        onTap: () => setState(() => _showingOriginal = !_showingOriginal),
                        child: Row(
                          children: [
                            const Icon(Icons.translate_rounded, size: 19, color: AppColors.textPrimary),
                            const SizedBox(width: 8),
                            Text(_showingOriginal ? "Tarjimani ko'rsatish" : "Aslini ko'rsatish",
                                style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    decoration: TextDecoration.underline)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                          _showingOriginal
                              ? "Bu — matnning asl nusxasi"
                              : "AI yordamida tarjima qilindi",
                          style: const TextStyle(color: AppColors.textSecondary, fontSize: 15)),
                    ],
                    if (gym.ratingBreakdown.isNotEmpty) ...[
                      const SizedBox(height: 30),
                      const Text("Mashg'ulot reytingi",
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26)),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(18),
                        decoration:
                            BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(16)),
                        child: Row(
                          children: [
                            Text(gym.rating.toStringAsFixed(1),
                                style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold)),
                            const SizedBox(width: 16),
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Ajoyib!",
                                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                                  SizedBox(height: 2),
                                  Text("100+ ta fikr",
                                      style: TextStyle(color: AppColors.textSecondary, fontSize: 14.5)),
                                ],
                              ),
                            ),
                            Container(
                              width: 46,
                              height: 46,
                              decoration:
                                  const BoxDecoration(color: AppColors.accentGreen, shape: BoxShape.circle),
                              child: const Icon(Icons.star_rounded, color: Colors.black, size: 26),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 14),
                      ...gym.ratingBreakdown.map((r) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 9),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 48,
                                  child: Text(r.$2.toStringAsFixed(1),
                                      style: const TextStyle(fontSize: 17.5, fontWeight: FontWeight.w600)),
                                ),
                                Expanded(
                                    child: Text(r.$1,
                                        style: const TextStyle(
                                            color: AppColors.textPrimary, fontSize: 17.5))),
                              ],
                            ),
                          )),
                    ],
                    const SizedBox(height: 30),
                    const Text("Manzili", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26)),
                    const SizedBox(height: 14),
                    InkWell(
                      onTap: () => Navigator.of(context).push(slideRightRoute(const MapViewScreen())),
                      borderRadius: BorderRadius.circular(16),
                      child: GymMapPreview(gym: gym),
                    ),
                    const SizedBox(height: 14),
                    Text(gym.address, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const Icon(Icons.navigation_outlined, size: 17, color: AppColors.textSecondary),
                        const SizedBox(width: 6),
                        Text("Sizdan $_distance",
                            style: const TextStyle(color: AppColors.textSecondary, fontSize: 16)),
                      ],
                    ),
                    const SizedBox(height: 18),
                    InkWell(
                      borderRadius: BorderRadius.circular(6),
                      onTap: () => openMapsDirections(context, "${gym.name}, ${gym.address}"),
                      child: const Text("Marshrut qurish",
                          style: TextStyle(
                              color: AppColors.primary, fontSize: 19, fontWeight: FontWeight.w600)),
                    ),
                    if (gym.amenities.isNotEmpty) ...[
                      const SizedBox(height: 30),
                      const Text("Qulayliklar", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26)),
                      const SizedBox(height: 16),
                      Wrap(
                        spacing: 10,
                        runSpacing: 11,
                        children: gym.amenities.map((a) {
                          final (label, available) = a;
                          final color = available ? AppColors.textPrimary : const Color(0xFF5A5B60);
                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 11),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(color: AppColors.divider),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(_amenityIcon(label), size: 18, color: color),
                                const SizedBox(width: 8),
                                Text(
                                  label,
                                  style: TextStyle(
                                    fontSize: 15.5,
                                    fontWeight: FontWeight.w500,
                                    color: color,
                                    decoration: available ? null : TextDecoration.lineThrough,
                                    decorationColor: const Color(0xFF5A5B60),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                    const SizedBox(height: 30),
                    Row(
                      children: [
                        InkWell(
                          borderRadius: BorderRadius.circular(28),
                          onTap: () => _showCallDialog(context),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 15),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(28),
                              border: Border.all(color: AppColors.divider),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.call_rounded, size: 20, color: Color(0xFF22C55E)),
                                SizedBox(width: 10),
                                Text("Bog'lanish",
                                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
                              ],
                            ),
                          ),
                        ),
                        const Spacer(),
                        InkWell(
                          borderRadius: BorderRadius.circular(28),
                          onTap: () =>
                              openWhatsApp(context, _phoneNumber, "Salom, ${gym.name} haqida so'ramoqchi edim"),
                          child: Container(
                            width: 56,
                            height: 56,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: AppColors.divider),
                            ),
                            child: const Icon(Icons.chat_rounded, color: Color(0xFF22C55E), size: 24),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 26),
                    InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: () =>
                          Navigator.of(context).push(slideRightRoute(ReportIssueScreen(gymName: gym.name))),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 17),
                        decoration: BoxDecoration(
                            color: AppColors.surface, borderRadius: BorderRadius.circular(16)),
                        child: const Row(
                          children: [
                            Icon(Icons.report_gmailerrorred_rounded,
                                size: 24, color: Color(0xFF8E8FA8)),
                            SizedBox(width: 12),
                            Expanded(
                                child: Text("Xato topdingizmi?",
                                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500))),
                            Icon(Icons.chevron_right_rounded, color: AppColors.textSecondary),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          // Pinned "Jadval" button over the content, like the original.
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [AppColors.background.withValues(alpha: 0), AppColors.background],
                  stops: const [0, 0.4],
                ),
              ),
              child: SafeArea(
                top: false,
                child: SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () =>
                        Navigator.of(context).push(slideRightRoute(TimeSlotScreen(gym: gym))),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                      elevation: 0,
                    ),
                    child: const Text("Jadval",
                        style: TextStyle(fontSize: 17.5, fontWeight: FontWeight.w600)),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(Gym gym) {
    return Column(
      children: [
        // Icon bar lives on the black background ABOVE the photo, matching
        // the original — the photo never slides behind the status bar.
        SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_rounded, color: Colors.white, size: 28),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.share_outlined, color: Colors.white, size: 26),
                      onPressed: () async {
                        await Clipboard.setData(ClipboardData(text: "https://1fit.uz/gym/${gym.name}"));
                        if (context.mounted) showConfirmed(context, "Havola nusxalandi");
                      },
                    ),
                    ValueListenableBuilder<Set<String>>(
                      valueListenable: SavedStore.saved,
                      builder: (context, saved, _) {
                        final isSaved = saved.contains(gym.name);
                        return IconButton(
                          icon: Icon(isSaved ? Icons.bookmark_rounded : Icons.bookmark_add_outlined,
                              color: isSaved ? const Color(0xFFE0218A) : Colors.white, size: 26),
                          onPressed: () async {
                            final nowSaved = await SavedStore.toggle(gym.name);
                            if (context.mounted) {
                              showConfirmed(
                                  context, nowSaved ? "Saqlandi" : "Saqlanganlardan olib tashlandi");
                            }
                          },
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 6),
        Stack(
          children: [
            SizedBox(
              height: 245,
              width: double.infinity,
              child: gym.photoAssets.isEmpty
                  ? GymPhoto(
                      category: gym.tags.isNotEmpty ? gym.tags.first : gym.category,
                      iconSize: 72,
                    )
                  : PageView.builder(
                      onPageChanged: (i) => setState(() => _photoIndex = i),
                      itemCount: gym.photoAssets.length,
                      itemBuilder: (context, i) => Image.asset(gym.photoAssets[i], fit: BoxFit.cover),
                    ),
            ),
            if (gym.photoAssets.length > 1)
              Positioned(
                right: 14,
                bottom: 14,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                  decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(14)),
                  child: Text("${_photoIndex + 1} / ${gym.photoAssets.length}",
                      style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600)),
                ),
              ),
            // Gym story circle with pink ring and blue "+" badge, bottom-left.
            if (gym.photoAssets.isNotEmpty)
              Positioned(
                left: 16,
                bottom: 14,
                child: InkWell(
                  customBorder: const CircleBorder(),
                  onTap: () => Navigator.of(context).push(slideUpRoute(
                      GymStoryViewerScreen(gymName: gym.name, photoAssets: gym.photoAssets))),
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        width: 84,
                        height: 84,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: const Color(0xFFE0218A), width: 3.5),
                        ),
                        padding: const EdgeInsets.all(3),
                        child: ClipOval(
                          child: Image.asset(gym.photoAssets.last, fit: BoxFit.cover),
                        ),
                      ),
                      Positioned(
                        right: -1,
                        bottom: -1,
                        child: Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            color: const Color(0xFF2F6BFF),
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.black, width: 2),
                          ),
                          child: const Icon(Icons.add_rounded, color: Colors.white, size: 17),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }

  static IconData _amenityIcon(String label) {
    switch (label) {
      case "Yaqin atrofda metro":
        return Icons.directions_subway_filled_rounded;
      case "Bepul Wi-Fi":
        return Icons.wifi_rounded;
      case "Fen":
        return Icons.air_rounded;
      case "Konditsionerlar":
        return Icons.ac_unit_rounded;
      case "Dush":
        return Icons.bathtub_outlined;
      case "Avtoturargoh":
        return Icons.directions_car_outlined;
      case "Bola bilan mumkin":
        return Icons.family_restroom_rounded;
      case "Bepul xalatlar":
        return Icons.checkroom_rounded;
      case "Toza suv":
        return Icons.water_drop_outlined;
      case "Namozxona":
        return Icons.mosque_outlined;
      case "Sauna":
        return Icons.spa_outlined;
      case "Bepul choy":
        return Icons.emoji_food_beverage_outlined;
      case "Zalda musiqa":
        return Icons.music_note_rounded;
      case "Bepul sochiqlar":
        return Icons.dry_cleaning_outlined;
      case "Fitnes-bar":
        return Icons.local_cafe_outlined;
      default:
        return Icons.check_rounded;
    }
  }
}

/// "Qandaydir xatolik bormi?" screen, matching the original's error-report list.
class ReportIssueScreen extends StatelessWidget {
  final String gymName;
  const ReportIssueScreen({super.key, required this.gymName});

  static const _items = [
    (Icons.place_outlined, "Manzil noto'g'ri"),
    (Icons.access_time_rounded, "Jadvalda xatolik bor"),
    (Icons.phone_outlined, "Telefon raqami noto'g'ri"),
    (Icons.weekend_outlined, "Qulayliklari mos kelmaydi"),
    (Icons.image_outlined, "Soxta fotosuratlar"),
    (Icons.fence_rounded, "Zal yopiq"),
    (Icons.chat_outlined, "Qo'llab-quvvatlashga yozish"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Qandaydir xatolik bormi?")),
      body: ListView.separated(
        itemCount: _items.length,
        separatorBuilder: (_, __) => const Divider(height: 1, color: AppColors.divider),
        itemBuilder: (context, i) {
          final (icon, label) = _items[i];
          return InkWell(
            onTap: () => showConfirmed(context, "Xabaringiz yuborildi. Rahmat!"),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
              child: Row(
                children: [
                  Icon(icon, size: 26, color: const Color(0xFF8E8FA8)),
                  const SizedBox(width: 18),
                  Expanded(
                      child:
                          Text(label, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500))),
                  const Icon(Icons.chevron_right_rounded, color: AppColors.textSecondary),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
