import 'dart:io';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/models.dart';
import '../state/feed_store.dart';
import '../data/gym_visuals.dart';

class StoryViewerScreen extends StatefulWidget {
  final int initialIndex;
  const StoryViewerScreen({super.key, required this.initialIndex});

  @override
  State<StoryViewerScreen> createState() => _StoryViewerScreenState();
}

class _StoryViewerScreenState extends State<StoryViewerScreen> with SingleTickerProviderStateMixin {
  late int _index;
  late AnimationController _progress;
  late List<StoryItem> _viewable;

  @override
  void initState() {
    super.initState();
    _viewable = FeedStore.stories.value.where((s) => !s.isAdd).toList();
    final startName = FeedStore.stories.value[widget.initialIndex].name;
    _index = _viewable.indexWhere((s) => s.name == startName).clamp(0, _viewable.length - 1);
    _progress = AnimationController(vsync: this, duration: const Duration(seconds: 4))
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) _next();
      });
    _play();
  }

  void _play() {
    _progress
      ..reset()
      ..forward();
    final fullIndex = FeedStore.stories.value.indexWhere((s) => s.name == _viewable[_index].name);
    FeedStore.markViewed(fullIndex);
  }

  void _next() {
    if (_index >= _viewable.length - 1) {
      Navigator.of(context).pop();
      return;
    }
    setState(() => _index++);
    _play();
  }

  void _prev() {
    if (_index <= 0) return;
    setState(() => _index--);
    _play();
  }

  @override
  void dispose() {
    _progress.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final story = _viewable[_index];
    final visual = visualForCategory(story.name);
    final hasPhoto = story.imageUrl.isNotEmpty;
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: hasPhoto
                  ? Image.file(File(story.imageUrl), fit: BoxFit.cover)
                  : Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: visual.gradient,
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        story.name.isNotEmpty ? story.name[0].toUpperCase() : "?",
                        style: const TextStyle(color: Colors.white24, fontWeight: FontWeight.w900, fontSize: 140),
                      ),
                    ),
            ),
            Positioned.fill(
              child: Row(
                children: [
                  Expanded(child: GestureDetector(onTap: _prev, behavior: HitTestBehavior.translucent)),
                  Expanded(child: GestureDetector(onTap: _next, behavior: HitTestBehavior.translucent)),
                ],
              ),
            ),
            Positioned(
              top: 6,
              left: 10,
              right: 10,
              child: Row(
                children: List.generate(_viewable.length, (i) {
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(2),
                        child: SizedBox(
                          height: 3,
                          child: i < _index
                              ? const ColoredBox(color: Colors.white)
                              : i > _index
                                  ? ColoredBox(color: Colors.white.withValues(alpha: 0.3))
                                  : AnimatedBuilder(
                                      animation: _progress,
                                      builder: (context, _) => LinearProgressIndicator(
                                        value: _progress.value,
                                        backgroundColor: Colors.white.withValues(alpha: 0.3),
                                        valueColor: const AlwaysStoppedAnimation(Colors.white),
                                      ),
                                    ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
            Positioned(
              top: 18,
              left: 12,
              right: 12,
              child: Row(
                children: [
                  CircleAvatar(radius: 15, backgroundColor: AppColors.primary, child: Text(story.name.isNotEmpty ? story.name[0].toUpperCase() : "?")),
                  const SizedBox(width: 8),
                  Expanded(child: Text(story.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                  IconButton(
                    icon: const Icon(Icons.close_rounded, color: Colors.white),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
