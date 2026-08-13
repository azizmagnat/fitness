import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../data/mock_data.dart';
import '../models/models.dart';
import '../state/preferences_store.dart';
import '../widgets/feedback.dart';
import '../widgets/page_transitions.dart';
import '../widgets/shop_section.dart';
import 'category_results_screen.dart';
import 'map_view_screen.dart';
import 'notifications_screen.dart';
import 'saved_screen.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Qidirish"),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none_rounded),
            onPressed: () => Navigator.of(context).push(slideRightRoute(const NotificationsScreen())),
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 24),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                const Icon(Icons.search, color: AppColors.textSecondary),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    style: const TextStyle(color: AppColors.textPrimary),
                    decoration: const InputDecoration(
                      hintText: "City Gym yoki suzish",
                      hintStyle: TextStyle(color: AppColors.textSecondary),
                      border: InputBorder.none,
                      isDense: true,
                    ),
                    onSubmitted: (q) {
                      if (q.trim().isEmpty) return;
                      Navigator.of(context).push(slideRightRoute(
                        CategoryResultsScreen(category: "\"$q\" bo'yicha natijalar", gyms: MockData.searchGyms(q)),
                      ));
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          _ChipRow(items: MockData.searchFilters1, big: true),
          const SizedBox(height: 10),
          _ChipRow(items: MockData.searchFilters2, big: false),
          const SizedBox(height: 26),
          const Text("Mashg'ulotlar turi", style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold)),
          const SizedBox(height: 14),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.6,
            children: MockData.workoutTypes.map((c) => _CategoryTile(c)).toList(),
          ),
          const SizedBox(height: 26),
          Row(
            children: const [
              Expanded(
                child: Text("Bonusli mashg'ulot turlari",
                    style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold)),
              ),
              Icon(Icons.info_outline_rounded, size: 18, color: AppColors.textSecondary),
            ],
          ),
          const SizedBox(height: 14),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.6,
            children: MockData.bonusWorkoutTypes.map((c) => _CategoryTile(c)).toList(),
          ),
              ],
            ),
          ),
          const SizedBox(height: 26),
          const ShopSection(),
        ],
      ),
    );
  }
}

const Map<String, Color> _filterIconColors = {
  "Yangi": Color(0xFF22C55E),
  "Siz uchun": Color(0xFFF5A623),
  "Uy yonida": Color(0xFFF5A623),
  "Ishxona yonida": Color(0xFF3DB4F2),
  "Ayollar uchun": Color(0xFFD946EF),
  "Erkaklar uchun": Color(0xFF3DB4F2),
};

class _ChipRow extends StatelessWidget {
  final List<SearchCategory> items;
  final bool big;
  const _ChipRow({required this.items, required this.big});

  void _openResults(BuildContext context, String title, List<Gym> gyms) {
    Navigator.of(context).push(slideRightRoute(CategoryResultsScreen(category: title, gyms: gyms)));
  }

  void _onTap(BuildContext context, SearchCategory item) {
    if (big) {
      switch (item.label) {
        case "Saqlanganlar":
          Navigator.of(context).push(slideRightRoute(const SavedScreen()));
        case "Xaritada":
          Navigator.of(context).push(slideRightRoute(const MapViewScreen()));
        case "Zallar va mashg'ulotlar":
          _openResults(context, "Zallar va mashg'ulotlar", MockData.allGyms);
        default:
          showComingSoon(context, item.label);
      }
      return;
    }

    switch (item.label) {
      case "Siz uchun":
        final favorites = PreferencesStore.favoriteCategories.value;
        if (favorites.isEmpty) {
          showComingSoon(context, "Avval Sozlamalar > Sevimli mashg'ulot turlarini tanlang");
          return;
        }
        final gyms = <Gym>{};
        for (final label in favorites) {
          gyms.addAll(MockData.gymsByCategory(label));
        }
        _openResults(context, "Siz uchun", gyms.toList());

      case "Yangi":
        // The most recently added venues in the catalogue.
        final gyms =
            MockData.allGyms.where((g) => g.name == "SPACE FITNESS" || g.name == "GRAND DIOR HOTEL").toList();
        _openResults(context, "Yangi qo'shilgan zallar", gyms);

      case "Uy yonida":
        if (PreferencesStore.address.value == null || PreferencesStore.address.value!.isEmpty) {
          showComingSoon(context, "Avval Sozlamalar > Manzilni o'zgartirishda uyingiz manzilini kiriting");
          return;
        }
        _openResults(context, "Uy yonida", MockData.allGyms);

      case "Ishxona yonida":
        if (PreferencesStore.address.value == null || PreferencesStore.address.value!.isEmpty) {
          showComingSoon(context, "Avval Sozlamalar > Manzilni o'zgartirishda manzilingizni kiriting");
          return;
        }
        _openResults(context, "Ishxona yonida", MockData.allGyms);

      case "Ayollar uchun":
      case "Erkaklar uchun":
        final wantsWomen = item.label == "Ayollar uchun";
        final gyms = MockData.allGyms.where((g) {
          return g.sessions.any((s) {
            final r = s.restriction.toLowerCase();
            return wantsWomen ? r.contains("ayol") : r.contains("erkak");
          });
        }).toList();
        if (gyms.isEmpty) {
          showComingSoon(context, item.label);
          return;
        }
        _openResults(context, item.label, gyms);

      default:
        showComingSoon(context, item.label);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final item in items) ...[
          Expanded(
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () => _onTap(context, item),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AspectRatio(
                    aspectRatio: 1.0,
                    child: Container(
                      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(16)),
                      alignment: Alignment.center,
                      child: Icon(item.icon, color: _filterIconColors[item.label] ?? AppColors.primary, size: big ? 30 : 26),
                    ),
                  ),
                  SizedBox(height: big ? 8 : 6),
                  Text(item.label,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: big ? 12.5 : 11.5, color: AppColors.textPrimary, height: 1.15)),
                ],
              ),
            ),
          ),
          if (item != items.last) const SizedBox(width: 8),
        ],
      ],
    );
  }
}

// Colors sampled directly from the original app's video (pixel-picked from
// its Qidirish category tiles), used only where no real emoji match exists.
const Map<String, Color> _categoryIconColors = {
  "Stretching va Pilates": Color(0xFFAE206A),
  "Jang san'ati": Color(0xFF16A34A),
  "Ochiq havoda shug'ullanish": Color(0xFF0EA5E9),
  "Jamoaviy sport turlari": Color(0xFF2441BF),
  "Dam olish va tiklanish": Color(0xFF3DDC84),
  "Uskunani ijaraga olish": Color(0xFF9CA3AF),
};

class _CategoryTile extends StatelessWidget {
  final SearchCategory category;
  const _CategoryTile(this.category);

  @override
  Widget build(BuildContext context) {
    final color = _categoryIconColors[category.label] ?? AppColors.primary;
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () => Navigator.of(context).push(slideRightRoute(CategoryResultsScreen(category: category.label))),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(16)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            category.emoji != null
                ? Text(category.emoji!, style: const TextStyle(fontSize: 26))
                : Icon(category.icon, color: color, size: 26),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(category.label,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                if (category.count.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(category.count, style: const TextStyle(fontSize: 11.5, color: AppColors.textSecondary)),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}

