import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../data/mock_data.dart';
import '../data/gym_visuals.dart';
import '../models/models.dart';
import '../widgets/common.dart';
import '../widgets/page_transitions.dart';
import 'gym_detail_screen.dart';
import 'time_slot_screen.dart';

class CategoryResultsScreen extends StatelessWidget {
  final String category;
  final List<Gym>? gyms;
  const CategoryResultsScreen({super.key, required this.category, this.gyms});

  @override
  Widget build(BuildContext context) {
    final gyms = this.gyms ?? MockData.gymsByCategory(category);
    return Scaffold(
      appBar: AppBar(title: Text(category)),
      body: gyms.isEmpty
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.search_off_rounded, color: AppColors.textSecondary, size: 36),
                  const SizedBox(height: 12),
                  Text("$category bo'yicha zallar topilmadi",
                      style: const TextStyle(color: AppColors.textSecondary)),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: gyms.length,
              itemBuilder: (context, i) {
                final gym = gyms[i];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () => Navigator.of(context).push(slideRightRoute(GymDetailScreen(gym: gym))),
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(16)),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 56,
                            height: 56,
                            child: GymPhoto(
                              category: gym.category,
                              iconSize: 26,
                              borderRadius: BorderRadius.circular(12),
                              imageAsset: gym.photoAssets.isNotEmpty ? gym.photoAssets.first : null,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(gym.name,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    RatingBadge(rating: gym.rating),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(gym.address,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(color: AppColors.textSecondary, fontSize: 12.5)),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                InkWell(
                                  onTap: () => Navigator.of(context).push(slideRightRoute(TimeSlotScreen(gym: gym))),
                                  child: const Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text("Jadval", style: TextStyle(color: AppColors.primary, fontSize: 12.5, fontWeight: FontWeight.w600)),
                                      Icon(Icons.chevron_right_rounded, color: AppColors.primary, size: 16),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
