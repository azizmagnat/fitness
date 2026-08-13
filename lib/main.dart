import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'screens/splash_screen.dart';
import 'state/user_profile.dart';
import 'state/social_store.dart';
import 'state/preferences_store.dart';
import 'state/visits_store.dart';
import 'state/saved_store.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await UserProfile.load();
  await SocialStore.load();
  await PreferencesStore.load();
  await VisitsStore.load();
  await SavedStore.load();
  runApp(const OneFitApp());
}

class OneFitApp extends StatelessWidget {
  const OneFitApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '1FIT',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      home: const SplashScreen(),
    );
  }
}
