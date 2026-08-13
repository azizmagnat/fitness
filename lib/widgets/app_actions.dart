import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'feedback.dart';
import 'sound.dart';

Future<void> shareInvite(BuildContext context, String text) async {
  AppSound.tap();
  await SharePlus.instance.share(ShareParams(text: text));
}

Future<void> openMapsSearch(BuildContext context, String query) async {
  AppSound.tap();
  final uri = Uri.https("yandex.com", "/maps/", {"text": query});
  final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
  if (!ok && context.mounted) showComingSoon(context, "Xarita ilovasi");
}

Future<void> openMapsDirections(BuildContext context, String destination) async {
  AppSound.tap();
  final uri = Uri.https("yandex.com", "/maps/", {"rtext": "~$destination"});
  final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
  if (!ok && context.mounted) showComingSoon(context, "Xarita ilovasi");
}

Future<void> openWhatsApp(BuildContext context, String phone, [String message = ""]) async {
  AppSound.tap();
  final digits = phone.replaceAll(RegExp(r'[^0-9]'), '');
  final uri = Uri.https("wa.me", "/$digits", message.isEmpty ? null : {"text": message});
  final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
  if (!ok && context.mounted) showComingSoon(context, "WhatsApp");
}
