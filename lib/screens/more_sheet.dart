import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../data/mock_data.dart';
import '../widgets/feedback.dart';
import '../widgets/page_transitions.dart';
import 'info_screens.dart';
import 'settings_detail_screens.dart';
import 'subscription_screen.dart';
import 'profile_screen.dart';

Future<void> showMoreSheet(BuildContext context) {
  return showModalBottomSheet(
    context: context,
    backgroundColor: AppColors.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) => const _MoreSheetContent(),
  );
}

class _MoreSheetContent extends StatelessWidget {
  const _MoreSheetContent();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(MockData.moreMenuItems.length, (i) {
          final item = MockData.moreMenuItems[i];
          return Column(
            children: [
              ListTile(
                leading: Icon(item.$1, color: AppColors.textPrimary),
                title: Text(item.$2, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
                subtitle: Text(item.$3, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12.5)),
                trailing: const Icon(Icons.chevron_right_rounded, color: AppColors.textSecondary),
                onTap: () {
                  Navigator.of(context).pop();
                  switch (item.$2) {
                    case "Yutuqli o'yinlar":
                      Navigator.of(context).push(slideRightRoute(const GamePrizesScreen()));
                      break;
                    case "Qo'llab-quvvatlash xizmati":
                      Navigator.of(context).push(slideRightRoute(const SupportScreen()));
                      break;
                    case "Abonement":
                      Navigator.of(context).push(slideRightRoute(const SubscriptionScreen()));
                      break;
                    case "Profil":
                      Navigator.of(context).push(slideRightRoute(const ProfileScreen()));
                      break;
                    default:
                      showComingSoon(context, item.$2);
                  }
                },
              ),
              if (i == 0) const Divider(height: 1, color: AppColors.divider),
            ],
          );
        }),
      ),
    );
  }
}
