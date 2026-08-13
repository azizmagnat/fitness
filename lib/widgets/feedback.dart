import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'sound.dart';

/// Shows a lightweight snackbar for actions that are genuinely out of scope
/// for this prototype (post creation, promo-code sharing, etc). Keeps every
/// tap in the app giving the user real feedback instead of doing nothing.
void showComingSoon(BuildContext context, [String? feature]) {
  AppSound.tap();
  ScaffoldMessenger.of(context).hideCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: AppColors.surfaceLight,
      behavior: SnackBarBehavior.floating,
      duration: const Duration(seconds: 2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      content: Text(
        feature == null ? "Tez orada mavjud bo'ladi" : "$feature — tez orada mavjud bo'ladi",
        style: const TextStyle(color: AppColors.textPrimary),
      ),
    ),
  );
}

Future<void> showReportIssueDialog(BuildContext context, String subject) async {
  final controller = TextEditingController();
  final sent = await showDialog<bool>(
    context: context,
    builder: (context) => StatefulBuilder(
      builder: (context, setState) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text("$subject haqida xabar berish"),
        content: TextField(
          controller: controller,
          autofocus: true,
          maxLines: 4,
          maxLength: 300,
          onChanged: (_) => setState(() {}),
          decoration: const InputDecoration(hintText: "Nima noto'g'ri ekanini yozing..."),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text("Bekor qilish")),
          TextButton(
            onPressed: controller.text.trim().isEmpty ? null : () => Navigator.of(context).pop(true),
            child: const Text("Yuborish"),
          ),
        ],
      ),
    ),
  );
  if (sent == true && context.mounted) {
    showConfirmed(context, "Xabaringiz uchun rahmat");
  }
}

/// A warning snackbar for validation/user-error feedback — distinct from
/// [showComingSoon], which is only for genuinely unbuilt features.
void showWarning(BuildContext context, String message) {
  AppSound.tap();
  ScaffoldMessenger.of(context).hideCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: AppColors.accentAmber,
      behavior: SnackBarBehavior.floating,
      duration: const Duration(seconds: 2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      content: Row(
        children: [
          const Icon(Icons.error_outline_rounded, color: Colors.black87, size: 18),
          const SizedBox(width: 8),
          Expanded(child: Text(message, style: const TextStyle(color: Colors.black87))),
        ],
      ),
    ),
  );
}

void showConfirmed(BuildContext context, String message) {
  AppSound.success();
  ScaffoldMessenger.of(context).hideCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: AppColors.accentGreen,
      behavior: SnackBarBehavior.floating,
      duration: const Duration(seconds: 2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      content: Row(
        children: [
          const Icon(Icons.check_circle_rounded, color: Colors.white, size: 18),
          const SizedBox(width: 8),
          Expanded(child: Text(message, style: const TextStyle(color: Colors.white))),
        ],
      ),
    ),
  );
}
