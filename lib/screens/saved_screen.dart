import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../data/mock_data.dart';
import '../data/gym_visuals.dart';
import '../models/models.dart';
import '../state/app_settings.dart';
import '../state/saved_store.dart';
import '../widgets/common.dart';
import '../widgets/page_transitions.dart';
import '../widgets/shop_section.dart';
import 'gym_detail_screen.dart';
import 'main_nav_screen.dart';
import 'time_slot_screen.dart';

class SavedScreen extends StatefulWidget {
  const SavedScreen({super.key});

  @override
  State<SavedScreen> createState() => _SavedScreenState();
}

class _SavedScreenState extends State<SavedScreen> {
  int _tab = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: ValueListenableBuilder<AppLanguage>(
          valueListenable: AppSettings.language,
          builder: (context, _, __) => Text(AppSettings.t("saved_title")),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(child: _TabChip(label: "Mashg'ulotlar bo'yicha", selected: _tab == 0, onTap: () => setState(() => _tab = 0))),
                const SizedBox(width: 10),
                Expanded(child: _TabChip(label: "Zallar bo'yicha", selected: _tab == 1, onTap: () => setState(() => _tab = 1))),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: _tab == 0
                ? ListView(
                    padding: const EdgeInsets.only(bottom: 24),
                    children: const [
                      SizedBox(height: 40),
                      _EmptyState(),
                      SizedBox(height: 44),
                      ShopSection(),
                    ],
                  )
                : ValueListenableBuilder<Set<String>>(
                    valueListenable: SavedStore.saved,
                    builder: (context, saved, _) {
                      final gyms = MockData.savedGyms.where((g) => saved.contains(g.name)).toList();
                      if (gyms.isEmpty) {
                        return ListView(
                          padding: const EdgeInsets.only(bottom: 24),
                          children: const [
                            SizedBox(height: 40),
                            _EmptyState(),
                            SizedBox(height: 44),
                            ShopSection(),
                          ],
                        );
                      }
                      return ListView.separated(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                        itemCount: gyms.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 16),
                        itemBuilder: (_, i) => _GymCard(gyms[i]),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  Widget _ribbon({required double width, required double height, required bool center}) {
    return SizedBox(
      width: width,
      height: height,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          ClipPath(
            clipper: _RibbonClipper(),
            child: Container(
              width: width,
              height: height,
              decoration: BoxDecoration(
                gradient: center
                    ? const LinearGradient(
                        colors: [Color(0xFF3B82F6), Color(0xFF7C3AED)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight)
                    : null,
                color: center ? null : const Color(0xFF3A3B40),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: height * 0.22),
            child: Icon(Icons.favorite_rounded,
                color: center ? Colors.white : const Color(0xFF26272B), size: width * 0.42),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 18),
                  child: _ribbon(width: 58, height: 84, center: false),
                ),
                const SizedBox(width: 10),
                _ribbon(width: 74, height: 112, center: true),
                const SizedBox(width: 10),
                Padding(
                  padding: const EdgeInsets.only(top: 18),
                  child: _ribbon(width: 58, height: 84, center: false),
                ),
              ],
            ),
            const SizedBox(height: 26),
            const Text("Hali hech narsa saqlanmagan",
                textAlign: TextAlign.center, style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            const Text("Agar sizga mashg'ulot yoqsa, uni saqlang\nva u shu yerda paydo bo'ladi",
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.textSecondary, fontSize: 15.5, height: 1.35)),
            const SizedBox(height: 26),
            SizedBox(
              height: 54,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).popUntil((r) => r.isFirst);
                  MainNavScreen.tabRequest.value = 1;
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 44),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                  elevation: 0,
                ),
                child: const Text("Mashg'ulotni topish",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              ),
            ),
          ],
      ),
    );
  }
}

/// Bookmark-ribbon shape: rectangle with a triangular notch cut out of the
/// bottom edge, like the original's saved-empty illustration.
class _RibbonClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    return Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width, size.height)
      ..lineTo(size.width / 2, size.height * 0.78)
      ..lineTo(0, size.height)
      ..close();
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

class _TabChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _TabChip({required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? AppColors.textPrimary : AppColors.surface,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: selected ? Colors.black : AppColors.textSecondary,
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}

class _PhotoGrid extends StatelessWidget {
  final Gym gym;
  const _PhotoGrid(this.gym);

  @override
  Widget build(BuildContext context) {
    final photos = gym.photoAssets;
    final category = gym.tags.isNotEmpty ? gym.tags.first : gym.category;
    final left = photos.isNotEmpty ? photos[0] : null;
    final right = photos.length > 1 ? photos[1] : (photos.isNotEmpty ? photos[0] : null);
    return Row(
      children: [
        Expanded(child: GymPhoto(category: category, iconSize: 30, imageAsset: left)),
        const SizedBox(width: 2),
        Expanded(
          child: Stack(
            fit: StackFit.expand,
            children: [
              GymPhoto(category: category, iconSize: 30, imageAsset: right),
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.all(5),
                  decoration: const BoxDecoration(color: AppColors.accentPink, shape: BoxShape.circle),
                  child: const Icon(Icons.bookmark_rounded, color: Colors.white, size: 13),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _GymCard extends StatelessWidget {
  final Gym gym;
  const _GymCard(this.gym);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: () => Navigator.of(context).push(slideRightRoute(GymDetailScreen(gym: gym))),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(18),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 130, child: _PhotoGrid(gym)),
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(gym.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      RatingBadge(rating: gym.rating),
                      const SizedBox(width: 8),
                      const Icon(Icons.place_outlined, size: 14, color: AppColors.textSecondary),
                      Expanded(
                        child: Text(" ${gym.address}",
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                      ),
                    ],
                  ),
                  if (gym.metro != null) ...[
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Container(
                          width: 17,
                          height: 17,
                          decoration: BoxDecoration(color: gym.metroColor, shape: BoxShape.circle),
                          alignment: Alignment.center,
                          child: const Text("M",
                              style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w900)),
                        ),
                        const SizedBox(width: 7),
                        Expanded(
                          child: Text(gym.metro!,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                        ),
                      ],
                    ),
                  ],
                  const SizedBox(height: 12),
                  const Divider(height: 1, color: AppColors.divider),
                  const SizedBox(height: 12),
                  Center(
                    child: InkWell(
                      onTap: () => Navigator.of(context).push(slideRightRoute(TimeSlotScreen(gym: gym))),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text("Jadval",
                              style:
                                  TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600, fontSize: 15)),
                          Icon(Icons.chevron_right_rounded, color: AppColors.primary, size: 20),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
