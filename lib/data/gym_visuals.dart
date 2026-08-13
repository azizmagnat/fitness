import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Maps a workout-type / gym category label to a distinct icon + gradient,
/// used as a stand-in "photo" everywhere a real venue photo would appear
/// (no real photo assets are bundled, so each gym stays visually distinct
/// by category instead of showing a repeated generic gray box).
class GymVisual {
  final IconData icon;
  final List<Color> gradient;
  const GymVisual(this.icon, this.gradient);
}

const Map<String, GymVisual> _visuals = {
  "Sportzal": GymVisual(Icons.fitness_center_rounded, [Color(0xFF3447F6), Color(0xFF1D2A8F)]),
  "Trenajyor zali": GymVisual(Icons.fitness_center_rounded, [Color(0xFF3447F6), Color(0xFF1D2A8F)]),
  "Suv mashg'ulotlari": GymVisual(Icons.pool_rounded, [Color(0xFF00BAED), Color(0xFF0B6E8C)]),
  "Basseyn": GymVisual(Icons.pool_rounded, [Color(0xFF00BAED), Color(0xFF0B6E8C)]),
  "Yoga": GymVisual(Icons.self_improvement_rounded, [Color(0xFFEC4899), Color(0xFF9D2B67)]),
  "Stretching va Pilates": GymVisual(Icons.accessibility_new_rounded, [Color(0xFF8B5CF6), Color(0xFF4C2E8F)]),
  "Har xil tadbirlar": GymVisual(Icons.celebration_rounded, [Color(0xFFF5A524), Color(0xFF9C6710)]),
  "Intensiv darslar": GymVisual(Icons.local_fire_department_rounded, [Color(0xFFF22742), Color(0xFF8C1420)]),
  "Raqs": GymVisual(Icons.music_note_rounded, [Color(0xFFEC4899), Color(0xFF8B5CF6)]),
  "Jang san'ati": GymVisual(Icons.sports_martial_arts_rounded, [Color(0xFF404145), Color(0xFF17181C)]),
  "Ochiq havoda shug'ullanish": GymVisual(Icons.park_rounded, [Color(0xFF0FA44D), Color(0xFF0B6E36)]),
  "Jamoaviy sport turlari": GymVisual(Icons.groups_rounded, [Color(0xFF3447F6), Color(0xFF00BAED)]),
  "Dam olish va tiklanish": GymVisual(Icons.spa_rounded, [Color(0xFF0EA5A0), Color(0xFF0B6E8C)]),
  "Uskunani ijaraga olish": GymVisual(Icons.handyman_rounded, [Color(0xFF404145), Color(0xFF232428)]),
  "Ko'ngilochar mashg'ulotlar": GymVisual(Icons.celebration_rounded, [Color(0xFFF5A524), Color(0xFFEC4899)]),
  "Fitnes": GymVisual(Icons.fitness_center_rounded, [Color(0xFF3447F6), Color(0xFF1D2A8F)]),
};

GymVisual visualForCategory(String category) =>
    _visuals[category] ?? const GymVisual(Icons.fitness_center_rounded, [AppColors.primary, AppColors.primaryDark]);

class GymPhoto extends StatelessWidget {
  final String category;
  final double iconSize;
  final BorderRadius? borderRadius;
  final String? imageAsset;
  const GymPhoto({super.key, required this.category, this.iconSize = 28, this.borderRadius, this.imageAsset});

  @override
  Widget build(BuildContext context) {
    if (imageAsset != null) {
      return ClipRRect(
        borderRadius: borderRadius ?? BorderRadius.zero,
        child: Image.asset(imageAsset!, fit: BoxFit.cover, width: double.infinity, height: double.infinity),
      );
    }
    final v = visualForCategory(category);
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: v.gradient, begin: Alignment.topLeft, end: Alignment.bottomRight),
        borderRadius: borderRadius,
      ),
      alignment: Alignment.center,
      child: Icon(v.icon, color: Colors.white, size: iconSize),
    );
  }
}
