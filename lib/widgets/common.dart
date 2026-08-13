import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'sound.dart';

(IconData, Color) restrictionVisual(String restriction) {
  final lower = restriction.toLowerCase();
  if (lower.contains("erkak")) return (Icons.male_rounded, AppColors.primary);
  if (lower.contains("ayol")) return (Icons.female_rounded, AppColors.accentPink);
  return (Icons.info_outline_rounded, AppColors.textSecondary);
}

class SectionCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;
  const SectionCard({super.key, required this.child, this.padding = const EdgeInsets.all(16)});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: child,
    );
  }
}

class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final Color? color;
  const PrimaryButton({super.key, required this.label, required this.onPressed, this.color});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton(
        onPressed: () {
          AppSound.tap();
          onPressed();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: color ?? AppColors.primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
          elevation: 0,
        ),
        child: Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
      ),
    );
  }
}

class RatingBadge extends StatelessWidget {
  final double rating;
  const RatingBadge({super.key, required this.rating});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(rating.toString(),
            style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold)),
        const SizedBox(width: 4),
        const Icon(Icons.star, color: AppColors.accentGreen, size: 16),
      ],
    );
  }
}
