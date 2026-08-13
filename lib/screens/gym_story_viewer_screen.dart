import 'package:flutter/material.dart';
import '../widgets/app_actions.dart';

/// Instagram-style auto-advancing viewer for a gym's own photo set, opened by
/// tapping the pink story ring on its detail page. Mirrors StoryViewerScreen's
/// look, but walks a plain photo-asset list instead of the personal feed's
/// story model.
class GymStoryViewerScreen extends StatefulWidget {
  final String gymName;
  final List<String> photoAssets;
  final int initialIndex;
  const GymStoryViewerScreen({
    super.key,
    required this.gymName,
    required this.photoAssets,
    this.initialIndex = 0,
  });

  @override
  State<GymStoryViewerScreen> createState() => _GymStoryViewerScreenState();
}

class _GymStoryViewerScreenState extends State<GymStoryViewerScreen> with SingleTickerProviderStateMixin {
  late int _index;
  late AnimationController _progress;

  @override
  void initState() {
    super.initState();
    _index = widget.initialIndex.clamp(0, widget.photoAssets.length - 1);
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
  }

  void _next() {
    if (_index >= widget.photoAssets.length - 1) {
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
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(widget.photoAssets[_index], fit: BoxFit.cover),
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
                children: List.generate(widget.photoAssets.length, (i) {
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
                  const Icon(Icons.fitness_center_rounded, color: Colors.white, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                      child: Text(widget.gymName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                  IconButton(
                    icon: const Icon(Icons.share_outlined, color: Colors.white, size: 26),
                    onPressed: () => shareInvite(context, "1Fit'da ${widget.gymName} zalini ko'ring! https://1fit.uz"),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded, color: Colors.white, size: 26),
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
