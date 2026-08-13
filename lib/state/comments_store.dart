import 'package:flutter/material.dart';

class PostComment {
  final String author;
  final String text;
  final DateTime time;
  const PostComment({required this.author, required this.text, required this.time});
}

/// Local, in-memory comments per post, keyed by a stable postId. No backend —
/// same pattern as FeedStore's posts/stories — but it makes the "Izohlar"
/// button a real, working feature instead of a snackbar.
class CommentsStore {
  CommentsStore._();

  // A couple of seed comments on the two showcase feed posts, so they don't
  // read as freshly-empty on first launch — same spirit as their seeded
  // like/view counts.
  static final ValueNotifier<Map<String, List<PostComment>>> _byPost =
      ValueNotifier<Map<String, List<PostComment>>>({
    "demo_TahirovST": [
      PostComment(
          author: "dilnoza",
          text: "Vauw, juda chiroyli ekan! Qaysi tarifda bordingiz?",
          time: DateTime(2026, 7, 29, 15, 40)),
      PostComment(
          author: "botir_k",
          text: "Men ham shu hafta borishni rejalashtiryapman 🔥",
          time: DateTime(2026, 7, 29, 18, 12)),
    ],
    "demo__Phoenix_": [
      PostComment(
          author: "ash1228", text: "24/7 ishlashi juda qulay ekan", time: DateTime(2026, 7, 30, 9, 5)),
      PostComment(
          author: "afandi",
          text: "Kiyinish xonasi haqiqatan ham yaxshi, tasdiqlayman",
          time: DateTime(2026, 7, 30, 10, 22)),
    ],
  });

  static List<PostComment> forPost(String postId) => _byPost.value[postId] ?? const [];

  static void add(String postId, String author, String text) {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return;
    final map = Map<String, List<PostComment>>.of(_byPost.value);
    final list = List<PostComment>.of(map[postId] ?? const []);
    list.add(PostComment(author: author, text: trimmed, time: DateTime.now()));
    map[postId] = list;
    _byPost.value = map;
  }

  /// So a comment sheet can rebuild only when *its* post's comments change.
  /// Callers own the returned notifier and must dispose it.
  static ValueNotifier<List<PostComment>> listenable(String postId) {
    return _PostCommentsListenable(postId);
  }
}

class _PostCommentsListenable extends ValueNotifier<List<PostComment>> {
  final String postId;
  _PostCommentsListenable(this.postId) : super(CommentsStore.forPost(postId)) {
    CommentsStore._byPost.addListener(_sync);
  }

  void _sync() => value = CommentsStore.forPost(postId);

  @override
  void dispose() {
    CommentsStore._byPost.removeListener(_sync);
    super.dispose();
  }
}
