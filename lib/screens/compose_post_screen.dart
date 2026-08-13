import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../state/feed_store.dart';
import '../state/user_profile.dart';
import '../widgets/common.dart';

class ComposePostScreen extends StatefulWidget {
  const ComposePostScreen({super.key});

  @override
  State<ComposePostScreen> createState() => _ComposePostScreenState();
}

class _ComposePostScreenState extends State<ComposePostScreen> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    FeedStore.addPost(
      authorInitial: UserProfile.initial,
      title: UserProfile.name.value,
      body: text,
      meta: "hozirgina",
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Yangi post"),
        actions: [
          TextButton(
            onPressed: _submit,
            child: const Text("Ulashish", style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(radius: 16, backgroundColor: AppColors.primary, child: Text(UserProfile.initial)),
                const SizedBox(width: 10),
                ValueListenableBuilder<String>(
                  valueListenable: UserProfile.name,
                  builder: (context, name, _) => Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _controller,
              autofocus: true,
              maxLines: 6,
              maxLength: 280,
              style: const TextStyle(fontSize: 16),
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: "Bugun qanday mashg'ulot qildingiz?",
                hintStyle: TextStyle(color: AppColors.textSecondary),
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: PrimaryButton(label: "Ulashish", onPressed: _submit),
            ),
          ],
        ),
      ),
    );
  }
}
