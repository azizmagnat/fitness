import 'package:flutter/material.dart';

enum AppLanguage { uz, ru, en }

/// Small app-wide settings store (theme + language) backed by ValueNotifiers,
/// so toggling them in Settings has a real, immediate effect across the app —
/// no fake "coming soon" here.
class AppSettings {
  AppSettings._();
  static final ValueNotifier<ThemeMode> themeMode = ValueNotifier(ThemeMode.dark);
  static final ValueNotifier<AppLanguage> language = ValueNotifier(AppLanguage.uz);

  static const Map<String, Map<AppLanguage, String>> _dict = {
    "nav_lenta": {AppLanguage.uz: "Lenta", AppLanguage.ru: "Лента", AppLanguage.en: "Feed"},
    "nav_qidirish": {AppLanguage.uz: "Qidirish", AppLanguage.ru: "Поиск", AppLanguage.en: "Search"},
    "nav_jadval": {AppLanguage.uz: "Jadval", AppLanguage.ru: "Расписание", AppLanguage.en: "Schedule"},
    "nav_dokon": {AppLanguage.uz: "Do'kon", AppLanguage.ru: "Магазин", AppLanguage.en: "Shop"},
    "nav_yana": {AppLanguage.uz: "Yana", AppLanguage.ru: "Ещё", AppLanguage.en: "More"},
    "settings_title": {AppLanguage.uz: "Sozlamalar", AppLanguage.ru: "Настройки", AppLanguage.en: "Settings"},
    "profile_title": {AppLanguage.uz: "Profil", AppLanguage.ru: "Профиль", AppLanguage.en: "Profile"},
    "subscription_title": {
      AppLanguage.uz: "Mening abonementim",
      AppLanguage.ru: "Моя подписка",
      AppLanguage.en: "My subscription",
    },
    "saved_title": {AppLanguage.uz: "Saqlangan", AppLanguage.ru: "Сохранённые", AppLanguage.en: "Saved"},
    "notifications_title": {
      AppLanguage.uz: "Bildirishnomalar",
      AppLanguage.ru: "Уведомления",
      AppLanguage.en: "Notifications",
    },
  };

  static String t(String key) => _dict[key]?[language.value] ?? key;

  static String get languageLabel {
    switch (language.value) {
      case AppLanguage.uz:
        return "O'zbekcha";
      case AppLanguage.ru:
        return "Русский";
      case AppLanguage.en:
        return "English";
    }
  }
}
