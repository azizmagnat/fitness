import 'package:flutter/material.dart';
import '../data/mock_data.dart';
import '../models/models.dart';

class FeedPost {
  final String id;
  final String authorInitial;
  final String title;
  final String body;
  final String meta;
  const FeedPost(
      {required this.id, required this.authorInitial, required this.title, required this.body, required this.meta});
}

/// Local, in-memory feed state (posts + stories) so "Post yaratish" and
/// "Story qo'shish" have a real, visible effect instead of a snackbar.
class FeedStore {
  FeedStore._();

  static final ValueNotifier<List<FeedPost>> posts = ValueNotifier<List<FeedPost>>([]);
  static int _nextId = 1;

  /// Builds the post and assigns it a stable id (used to key its comments),
  /// so callers never have to invent one themselves.
  static FeedPost addPost({
    required String authorInitial,
    required String title,
    required String body,
    required String meta,
  }) {
    final post = FeedPost(id: "user_${_nextId++}", authorInitial: authorInitial, title: title, body: body, meta: meta);
    posts.value = [post, ...posts.value];
    return post;
  }

  static final ValueNotifier<List<StoryItem>> stories = ValueNotifier<List<StoryItem>>(List.of(MockData.stories));

  static void addPhotoStory(String path) {
    final list = List<StoryItem>.of(stories.value);
    var insertAt = list.indexWhere((s) => !s.isAdd);
    if (insertAt == -1) insertAt = list.length;
    list.insert(insertAt, StoryItem(name: "Siz", imageUrl: path));
    stories.value = list;
  }

  static void markViewed(int index) {
    final list = List<StoryItem>.of(stories.value);
    if (index < 0 || index >= list.length) return;
    final s = list[index];
    if (s.isAdd || s.viewed) return;
    list[index] = StoryItem(name: s.name, imageUrl: s.imageUrl, isAdd: s.isAdd, viewed: true);
    stories.value = list;
  }
}
