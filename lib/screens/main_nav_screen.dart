import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../state/app_settings.dart';
import '../widgets/sound.dart';
import 'feed_screen.dart';
import 'search_screen.dart';
import 'schedule_screen.dart';
import 'shop_screen.dart';
import 'more_sheet.dart';

class MainNavScreen extends StatefulWidget {
  const MainNavScreen({super.key});

  /// Set to a tab index to programmatically switch tabs from anywhere
  /// (e.g. the Jadval empty-state "Mashg'ulotni topish" button → Qidirish).
  static final ValueNotifier<int?> tabRequest = ValueNotifier<int?>(null);

  @override
  State<MainNavScreen> createState() => _MainNavScreenState();
}

class _MainNavScreenState extends State<MainNavScreen> {
  int _index = 0;
  bool _moreSelected = false;

  @override
  void initState() {
    super.initState();
    MainNavScreen.tabRequest.addListener(_onTabRequest);
  }

  @override
  void dispose() {
    MainNavScreen.tabRequest.removeListener(_onTabRequest);
    super.dispose();
  }

  void _onTabRequest() {
    final i = MainNavScreen.tabRequest.value;
    if (i == null || !mounted) return;
    setState(() {
      _index = i;
      _moreSelected = false;
    });
    MainNavScreen.tabRequest.value = null;
  }

  final _screens = const [
    FeedScreen(),
    SearchScreen(),
    ScheduleScreen(),
    ShopScreen(),
  ];

  final _items = const [
    _NavItem(Icons.home_rounded, "nav_lenta"),
    _NavItem(Icons.search_rounded, "nav_qidirish"),
    _NavItem(Icons.calendar_today_rounded, "nav_jadval"),
    _NavItem(Icons.storefront_rounded, "nav_dokon"),
    _NavItem(Icons.more_horiz_rounded, "nav_yana"),
  ];

  void _onTap(int i) async {
    AppSound.tap();
    if (i == 4) {
      setState(() => _moreSelected = true);
      await showMoreSheet(context);
      if (mounted) setState(() => _moreSelected = false);
    } else {
      setState(() {
        _index = i;
        _moreSelected = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: IndexedStack(index: _index, children: _screens),
      bottomNavigationBar: DecoratedBox(
        decoration: const BoxDecoration(
          color: Colors.black,
          border: Border(top: BorderSide(color: AppColors.divider, width: 0.5)),
        ),
        child: SafeArea(
          child: SizedBox(
            height: 70,
            child: ValueListenableBuilder<AppLanguage>(
              valueListenable: AppSettings.language,
              builder: (context, _, __) => Row(
                children: List.generate(_items.length, (i) {
                  final selected = i == 4 ? _moreSelected : (i == _index && !_moreSelected);
                  final item = _items[i];
                  return Expanded(
                    child: InkWell(
                      onTap: () => _onTap(i),
                      borderRadius: BorderRadius.circular(24),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 260),
                          curve: Curves.easeOut,
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          decoration: BoxDecoration(
                            color: selected ? AppColors.navPill : Colors.transparent,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                item.icon,
                                color: selected ? AppColors.primary : AppColors.textSecondary,
                                size: 23,
                              ),
                              const SizedBox(height: 3),
                              Text(
                                AppSettings.t(item.label),
                                style: TextStyle(
                                  color: selected ? AppColors.primary : AppColors.textSecondary,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final String label;
  const _NavItem(this.icon, this.label);
}
