import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../state/comments_store.dart';
import '../state/user_profile.dart';

Future<void> showCommentsSheet(BuildContext context, String postId) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: AppColors.surfaceLight,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
    builder: (_) => _CommentsSheet(postId: postId),
  );
}

class _CommentsSheet extends StatefulWidget {
  final String postId;
  const _CommentsSheet({required this.postId});

  @override
  State<_CommentsSheet> createState() => _CommentsSheetState();
}

class _CommentsSheetState extends State<_CommentsSheet> {
  final _controller = TextEditingController();
  late final ValueListenable<List<PostComment>> _comments;

  @override
  void initState() {
    super.initState();
    _comments = CommentsStore.listenable(widget.postId);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _send() {
    final text = _controller.text;
    if (text.trim().isEmpty) return;
    CommentsStore.add(widget.postId, UserProfile.name.value, text);
    _controller.clear();
  }

  String _relativeTime(DateTime t) {
    final diff = DateTime.now().difference(t);
    if (diff.inSeconds < 60) return "hozirgina";
    if (diff.inMinutes < 60) return "${diff.inMinutes} daqiqa oldin";
    if (diff.inHours < 24) return "${diff.inHours} soat oldin";
    return "${diff.inDays} kun oldin";
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: DraggableScrollableSheet(
        initialChildSize: 0.65,
        minChildSize: 0.4,
        maxChildSize: 0.92,
        expand: false,
        builder: (context, scrollController) {
          return Column(
            children: [
              const SizedBox(height: 10),
              Container(width: 40, height: 4, decoration: BoxDecoration(color: AppColors.divider, borderRadius: BorderRadius.circular(2))),
              const SizedBox(height: 14),
              ValueListenableBuilder<List<PostComment>>(
                valueListenable: _comments,
                builder: (context, comments, _) => Text("Izohlar (${comments.length})",
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ),
              const SizedBox(height: 10),
              const Divider(height: 1, color: AppColors.divider),
              Expanded(
                child: ValueListenableBuilder<List<PostComment>>(
                  valueListenable: _comments,
                  builder: (context, comments, _) {
                    if (comments.isEmpty) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(24),
                          child: Text("Hali izohlar yo'q. Birinchi bo'lib yozing!",
                              style: TextStyle(color: AppColors.textSecondary)),
                        ),
                      );
                    }
                    return ListView.builder(
                      controller: scrollController,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      itemCount: comments.length,
                      itemBuilder: (context, i) {
                        final c = comments[i];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CircleAvatar(
                                radius: 16,
                                backgroundColor: AppColors.primary,
                                child: Text(c.author.isNotEmpty ? c.author[0].toUpperCase() : "?",
                                    style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(c.author, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                                        const SizedBox(width: 8),
                                        Text(_relativeTime(c.time),
                                            style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                                      ],
                                    ),
                                    const SizedBox(height: 3),
                                    Text(c.text, style: const TextStyle(fontSize: 14.5, height: 1.3)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
              const Divider(height: 1, color: AppColors.divider),
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 16,
                      backgroundColor: AppColors.primary,
                      child: ValueListenableBuilder<String>(
                        valueListenable: UserProfile.name,
                        builder: (context, name, _) => Text(name.isNotEmpty ? name[0].toUpperCase() : "?",
                            style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        style: const TextStyle(fontSize: 14.5),
                        decoration: const InputDecoration(
                          hintText: "Izoh yozing...",
                          isDense: true,
                          border: InputBorder.none,
                        ),
                        onSubmitted: (_) => _send(),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.send_rounded, color: AppColors.primary),
                      onPressed: _send,
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
