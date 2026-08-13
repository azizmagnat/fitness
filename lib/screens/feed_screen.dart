import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../theme/app_theme.dart';
import '../data/mock_data.dart';
import '../models/models.dart';
import '../state/comments_store.dart';
import '../state/feed_store.dart';
import '../widgets/app_actions.dart';
import '../widgets/comments_sheet.dart';
import '../widgets/feedback.dart';
import '../widgets/page_transitions.dart';
import 'compose_post_screen.dart';
import 'gym_detail_screen.dart';
import 'info_screens.dart';
import 'notifications_screen.dart';
import 'saved_screen.dart';
import 'shop_screen.dart';
import 'story_viewer_screen.dart';
import 'subscription_screen.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 8, 6),
              child: Row(
                children: [
                  const Text("Lenta", style: TextStyle(fontSize: 34, fontWeight: FontWeight.bold)),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.add_box_outlined, size: 26),
                    onPressed: () => Navigator.of(context).push(slideUpRoute(const ComposePostScreen())),
                  ),
                  IconButton(
                    icon: const Icon(Icons.bookmark_border_rounded, size: 26),
                    onPressed: () => Navigator.of(context).push(slideRightRoute(const SavedScreen())),
                  ),
                  IconButton(
                    icon: const Icon(Icons.notifications_none_rounded, size: 26),
                    onPressed: () => Navigator.of(context).push(slideRightRoute(const NotificationsScreen())),
                  ),
                ],
              ),
            ),
            Expanded(child: _buildContent(context)),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.only(bottom: 24),
      children: [
        const SizedBox(height: 6),
        const _StoriesRow(),
        const SizedBox(height: 22),
        _QuickActionsGrid(),
        const SizedBox(height: 22),
        _PromoBanner(),
        const SizedBox(height: 26),
        const _SectionHeader("Tavsiya etilgan postlar"),
        const SizedBox(height: 4),
        ValueListenableBuilder<List<FeedPost>>(
          valueListenable: FeedStore.posts,
          builder: (context, userPosts, _) => Column(
            children: [
              for (final p in userPosts) ...[
                _UserPostCard(post: p),
                const _PostDivider(),
              ],
            ],
          ),
        ),
        _DemoPost(
          author: "TahirovST",
          initial: "T",
          avatarColor: Color(0xFF8A6B4D),
          date: "29-iyul, kecha",
          text:
              "1Fit ajablantirishda davom etyapti 🌿\n\nBugun o'zim uchun GRAND DIOR HOTEL basseynini ochdim — his-tuyg'ular ajoyib...",
          photos: ["assets/gyms/grand_dior_1.jpg", "assets/gyms/grand_dior_6.jpg"],
          attachedSession: "Erkin suzish",
          attachedGymName: "GRAND DIOR HOTEL",
          likes: 49,
          views: "1.2k",
          reactionText: "49 foydalanuvchi reaksiya bildirdi",
        ),
        const _PostDivider(),
        const _SectionHeader("Yutuqli o'yinlar"),
        const SizedBox(height: 14),
        const _PrizeCardsRow(),
        const SizedBox(height: 10),
        const _PostDivider(),
        _DemoPost(
          author: "_Phoenix_",
          initial: "P",
          avatarColor: Color(0xFF4D6B8A),
          date: "30-iyul, bugun",
          text:
              "Navbatdagi zalimiz SPACE FITNESS deb mashhur bo'lgan... 24/7 ishlashi eng avzal tomoni, trenajorlar hammasi maromida ishlaydi, kiyinish xonasi judayam qulay...",
          photos: ["assets/gyms/space_fitness_1.jpg", "assets/gyms/space_fitness_3.jpg"],
          attachedSession: "Trenajyor zalida mustaqil mashg'ulotlar",
          attachedGymName: "SPACE FITNESS",
          likes: 12,
          views: "566",
          reactionText: "12 foydalanuvchi reaksiya bildirdi",
        ),
        const _PostDivider(),
        const _SectionHeader("1Fit abonementlari"),
        const SizedBox(height: 14),
        const _PlanCardsGrid(),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String text;
  const _SectionHeader(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(text, style: const TextStyle(fontSize: 19, fontWeight: FontWeight.bold)),
      ),
    );
  }
}

class _PostDivider extends StatelessWidget {
  const _PostDivider();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 6,
      margin: const EdgeInsets.symmetric(vertical: 14),
      color: AppColors.background,
    );
  }
}

// ---------------------------------------------------------------------------
// Stories
// ---------------------------------------------------------------------------

class _StoriesRow extends StatefulWidget {
  const _StoriesRow();

  @override
  State<_StoriesRow> createState() => _StoriesRowState();
}

class _StoriesRowState extends State<_StoriesRow> {
  static const double _size = 86;

  Future<void> _addStory() async {
    try {
      final file = await ImagePicker().pickImage(source: ImageSource.gallery, maxWidth: 1080, imageQuality: 85);
      if (file != null) {
        FeedStore.addPhotoStory(file.path);
        if (mounted) showConfirmed(context, "Story qo'shildi");
      }
    } catch (_) {
      if (mounted) showComingSoon(context, "Story qo'shish");
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: _size + 32,
      child: ValueListenableBuilder<List<StoryItem>>(
        valueListenable: FeedStore.stories,
        builder: (context, stories, _) => ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: stories.length,
          separatorBuilder: (_, __) => const SizedBox(width: 16),
          itemBuilder: (_, i) {
            final s = stories[i];
            final hasPhoto = s.imageUrl.isNotEmpty;
            if (s.isAdd) {
              return InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: _addStory,
                child: SizedBox(
                  width: _size,
                  child: Column(
                    children: [
                      SizedBox(
                        width: _size,
                        height: _size,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            CustomPaint(size: const Size(_size, _size), painter: _DashedCirclePainter()),
                            Container(
                              margin: const EdgeInsets.all(8),
                              decoration: const BoxDecoration(shape: BoxShape.circle, color: AppColors.primary),
                            ),
                            const Icon(Icons.add_rounded, color: Colors.white, size: 34),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(s.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 13, color: AppColors.textPrimary)),
                    ],
                  ),
                ),
              );
            }
            final is1Fit = s.name == "1Fit";
            return InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () => Navigator.of(context).push(slideUpRoute(StoryViewerScreen(initialIndex: i))),
              child: SizedBox(
                width: _size,
                child: Column(
                  children: [
                    Container(
                      width: _size,
                      height: _size,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: s.viewed ? AppColors.divider : AppColors.primary,
                          width: 3,
                        ),
                      ),
                      padding: const EdgeInsets.all(4),
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: is1Fit ? AppColors.primary : AppColors.surface,
                          image: hasPhoto ? DecorationImage(image: FileImage(File(s.imageUrl)), fit: BoxFit.cover) : null,
                        ),
                        child: hasPhoto
                            ? null
                            : Center(
                                child: is1Fit
                                    ? const Text("1F",
                                        style: TextStyle(
                                            fontSize: 26,
                                            fontWeight: FontWeight.w900,
                                            fontStyle: FontStyle.italic,
                                            color: Colors.white))
                                    : Text(s.name.isNotEmpty ? s.name[0].toUpperCase() : "?",
                                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                              ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(s.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 13, color: AppColors.textPrimary)),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Quick actions
// ---------------------------------------------------------------------------

class _QuickActionsGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 4,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      mainAxisSpacing: 14,
      crossAxisSpacing: 6,
      childAspectRatio: 0.82,
      children: MockData.quickActions.map((a) => _QuickActionTile(a)).toList(),
    );
  }
}

class _QuickActionTile extends StatelessWidget {
  final QuickAction action;
  const _QuickActionTile(this.action);

  Widget _icon() {
    switch (action.label) {
      case "1Fit Pro":
        return Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
                colors: [Color(0xFF2F6BFF), Color(0xFF1E3FBF)], begin: Alignment.topLeft, end: Alignment.bottomRight),
            borderRadius: BorderRadius.circular(15),
          ),
          alignment: Alignment.center,
          child: const Text("PRO✦",
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 13)),
        );
      case "Aksiyalar":
        return const Text("📣", style: TextStyle(fontSize: 40));
      case "Yutuqli o'yinlar":
        return Container(
          width: 52,
          height: 52,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                colors: [Color(0xFF4ADE80), AppColors.accentGreen], begin: Alignment.topLeft, end: Alignment.bottomRight),
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: const Text("%", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 24)),
        );
      case "Bonuslar":
        return Container(
          width: 52,
          height: 52,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                colors: [Color(0xFFA855F7), Color(0xFFEC4899)], begin: Alignment.topLeft, end: Alignment.bottomRight),
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: const Text("B", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 24)),
        );
      case "Do'kon":
        return const Text("🛍️", style: TextStyle(fontSize: 40));
      case "Mehmon abonementi":
        return Transform.rotate(
          angle: -0.12,
          child: const Text("Trial",
              style: TextStyle(
                  color: Color(0xFF38BDF8),
                  fontWeight: FontWeight.w900,
                  fontStyle: FontStyle.italic,
                  fontSize: 26,
                  shadows: [Shadow(color: Color(0xFF16A34A), offset: Offset(2, 2))])),
        );
      case "Bildirishnomalar":
        return ShaderMask(
          shaderCallback: (r) => const LinearGradient(
                  colors: [Color(0xFFA855F7), Color(0xFF7C3AED)], begin: Alignment.topLeft, end: Alignment.bottomRight)
              .createShader(r),
          child: const Icon(Icons.notifications_rounded, color: Colors.white, size: 44),
        );
      case "Hamjamiyat":
      default:
        return ShaderMask(
          shaderCallback: (r) => const LinearGradient(
                  colors: [Color(0xFF60A5FA), Color(0xFF2563EB)], begin: Alignment.topLeft, end: Alignment.bottomRight)
              .createShader(r),
          child: const Icon(Icons.groups_rounded, color: Colors.white, size: 44),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        switch (action.label) {
          case "Mehmon abonementi":
            Navigator.of(context).push(slideRightRoute(const SubscriptionScreen()));
            break;
          case "Yutuqli o'yinlar":
            Navigator.of(context).push(slideRightRoute(const GamePrizesScreen()));
            break;
          case "Aksiyalar":
            Navigator.of(context).push(slideRightRoute(const PromotionsScreen()));
            break;
          case "Bonuslar":
            Navigator.of(context).push(slideRightRoute(const BonusScreen()));
            break;
          case "Hamjamiyat":
            Navigator.of(context).push(slideRightRoute(const CommunityScreen()));
            break;
          case "Do'kon":
          case "1Fit Pro":
            Navigator.of(context).push(slideRightRoute(const ShopScreen()));
            break;
          case "Bildirishnomalar":
            Navigator.of(context).push(slideRightRoute(const NotificationsScreen()));
            break;
          default:
            showComingSoon(context, action.label);
        }
      },
      borderRadius: BorderRadius.circular(16),
      child: Column(
        children: [
          SizedBox(
            width: 56,
            height: 56,
            child: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                _icon(),
                if (action.hasBadge)
                  Positioned(
                    top: -1,
                    right: -1,
                    child: Container(
                      width: 11,
                      height: 11,
                      decoration: const BoxDecoration(color: Color(0xFFEF4444), shape: BoxShape.circle),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            action.label,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 12.5, color: AppColors.textPrimary, height: 1.15),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Promo banner
// ---------------------------------------------------------------------------

class _PromoBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        height: 170,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          gradient: const LinearGradient(
            colors: [Color(0xFF0A0D3D), Color(0xFF2A2E8F), Color(0xFF8B7BE8)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Stack(
          children: [
            const Positioned(
              right: 4,
              bottom: 6,
              child: Text("🚙", style: TextStyle(fontSize: 84)),
            ),
            const Positioned(
              right: 88,
              top: 26,
              child: Text("🎀", style: TextStyle(fontSize: 30)),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    width: 250,
                    child: Text(
                      "Abonement sotib oling — avtomobil yutib oling",
                      style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold, height: 1.25),
                    ),
                  ),
                  const Spacer(),
                  InkWell(
                    onTap: () => Navigator.of(context).push(slideRightRoute(const GamePrizesScreen())),
                    borderRadius: BorderRadius.circular(24),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 11),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.35),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: Colors.white24),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text("Batafsilroq",
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 15)),
                          SizedBox(width: 4),
                          Icon(Icons.chevron_right_rounded, color: Colors.white, size: 20),
                        ],
                      ),
                    ),
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

// ---------------------------------------------------------------------------
// Prize cards (Yutuqli o'yinlar)
// ---------------------------------------------------------------------------

class _PrizeCardsRow extends StatelessWidget {
  const _PrizeCardsRow();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final cardWidth = (width - 44) / 2;
    return SizedBox(
      height: 296,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: MockData.gamePrizes.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, i) {
          final p = MockData.gamePrizes[i];
          return Container(
            width: cardWidth,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF23242B), AppColors.surface],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 92,
                  height: 74,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                        colors: [Color(0xFF6D7CFF), Color(0xFF8B5CF6)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  alignment: Alignment.center,
                  child: Icon(p.icon, color: Colors.white, size: 38),
                ),
                const SizedBox(height: 12),
                Text(p.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 15.5, fontWeight: FontWeight.bold, height: 1.25)),
                const SizedBox(height: 8),
                Text(p.subtitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: AppColors.textSecondary, fontSize: 13.5)),
                const SizedBox(height: 6),
                Text(p.daysLeft,
                    style: const TextStyle(color: Color(0xFF4ADE80), fontSize: 13, fontWeight: FontWeight.w600)),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  height: 42,
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(context).push(slideRightRoute(const GamePrizesScreen())),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
                      elevation: 0,
                      padding: EdgeInsets.zero,
                    ),
                    child: const Text("Ishtirok et", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14.5)),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Subscription plan cards (1Fit abonementlari)
// ---------------------------------------------------------------------------

class _PlanCardsGrid extends StatelessWidget {
  const _PlanCardsGrid();

  static const _planIconGradients = [
    [Color(0xFF7C3AED), Color(0xFF3B82F6)],
    [Color(0xFFF9A8D4), Color(0xFFEC4899)],
    [Color(0xFF4ADE80), Color(0xFF10B981)],
  ];
  static const _planIconLabels = ["365", "180", "90"];

  @override
  Widget build(BuildContext context) {
    final plans = MockData.subscriptionPlans;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 0.68,
        ),
        itemCount: plans.length + 1,
        itemBuilder: (context, i) {
          if (i == plans.length) {
            return InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () => Navigator.of(context).push(slideRightRoute(const SubscriptionScreen())),
              child: Container(
                decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(20)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 52,
                      height: 52,
                      decoration: const BoxDecoration(color: Color(0xFF23242B), shape: BoxShape.circle),
                      child: const Icon(Icons.arrow_forward_rounded, color: AppColors.primary),
                    ),
                    const SizedBox(height: 14),
                    const Text("Hammasini ko'rish", style: TextStyle(color: AppColors.primary, fontSize: 14.5)),
                  ],
                ),
              ),
            );
          }
          final p = plans[i];
          return Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(20)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 92,
                  height: 74,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                        colors: _planIconGradients[i % 3], begin: Alignment.topLeft, end: Alignment.bottomRight),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  alignment: Alignment.center,
                  child: Text(_planIconLabels[i % 3],
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w900, fontStyle: FontStyle.italic, fontSize: 26)),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Text(p.title, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                    if (p.discountBadge != null) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration:
                            BoxDecoration(color: const Color(0xFF16A34A), borderRadius: BorderRadius.circular(12)),
                        child: Text(p.discountBadge!,
                            style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700)),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 8),
                Text(p.price,
                    style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700, fontSize: 14.5)),
                if (p.oldPrice != null) ...[
                  const SizedBox(height: 4),
                  Text(p.oldPrice!, style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                ],
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  height: 42,
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(context).push(slideRightRoute(const SubscriptionScreen())),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
                      elevation: 0,
                      padding: EdgeInsets.zero,
                    ),
                    child: const Text("Batafsilroq", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14.5)),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Posts
// ---------------------------------------------------------------------------

class _PostHeader extends StatelessWidget {
  final String author;
  final String initial;
  final Color avatarColor;
  final String date;
  const _PostHeader({required this.author, required this.initial, required this.avatarColor, required this.date});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.primary, width: 2.5),
          ),
          padding: const EdgeInsets.all(3),
          child: CircleAvatar(
            backgroundColor: avatarColor,
            child: Text(initial, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(author, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16.5)),
              const SizedBox(height: 2),
              Text(date, style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
            ],
          ),
        ),
        InkWell(
          onTap: () => showConfirmed(context, "Obuna bo'ldingiz"),
          child: const Text("Obuna bo'lish",
              style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600, fontSize: 14.5)),
        ),
        const SizedBox(width: 14),
        InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () => showComingSoon(context, "Post sozlamalari"),
          child: const Icon(Icons.more_horiz_rounded, color: AppColors.textSecondary),
        ),
      ],
    );
  }
}

class _PostStatsRow extends StatefulWidget {
  final String postId;
  final int likes;
  final String views;
  final String reactionText;
  final String shareText;
  const _PostStatsRow(
      {required this.postId,
      required this.likes,
      required this.views,
      required this.reactionText,
      required this.shareText});

  @override
  State<_PostStatsRow> createState() => _PostStatsRowState();
}

class _PostStatsRowState extends State<_PostStatsRow> {
  bool _liked = false;
  late final ValueNotifier<List<PostComment>> _comments = CommentsStore.listenable(widget.postId);

  @override
  void dispose() {
    _comments.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final likes = widget.likes + (_liked ? 1 : 0);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            InkWell(
              onTap: () => setState(() => _liked = !_liked),
              borderRadius: BorderRadius.circular(20),
              child: Row(
                children: [
                  Icon(_liked ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                      size: 24, color: _liked ? AppColors.accentPink : AppColors.textPrimary),
                  const SizedBox(width: 8),
                  Text("$likes", style: const TextStyle(fontSize: 16)),
                ],
              ),
            ),
            const SizedBox(width: 28),
            InkWell(
              onTap: () => showCommentsSheet(context, widget.postId),
              borderRadius: BorderRadius.circular(20),
              child: Row(
                children: [
                  const Icon(Icons.chat_bubble_outline_rounded, size: 24, color: AppColors.textPrimary),
                  const SizedBox(width: 8),
                  ValueListenableBuilder<List<PostComment>>(
                    valueListenable: _comments,
                    builder: (context, comments, _) => Text("${comments.length}", style: const TextStyle(fontSize: 16)),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 28),
            InkWell(
              onTap: () => shareInvite(context, widget.shareText),
              borderRadius: BorderRadius.circular(20),
              child: const Icon(Icons.share_outlined, size: 24, color: AppColors.textPrimary),
            ),
            const Spacer(),
            const Icon(Icons.visibility_outlined, size: 20, color: AppColors.textSecondary),
            const SizedBox(width: 6),
            Text(widget.views, style: const TextStyle(color: AppColors.textSecondary, fontSize: 15)),
          ],
        ),
        const SizedBox(height: 14),
        Row(
          children: [
            SizedBox(
              width: 56,
              height: 24,
              child: Stack(
                children: [
                  for (var i = 0; i < 3; i++)
                    Positioned(
                      left: i * 16.0,
                      child: Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: [const Color(0xFF7C3AED), const Color(0xFFDB2777), const Color(0xFF2563EB)][i],
                          border: Border.all(color: Colors.black, width: 1.5),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(width: 4),
            Expanded(
              child: Text(widget.reactionText,
                  style: const TextStyle(color: AppColors.textSecondary, fontSize: 13.5)),
            ),
          ],
        ),
      ],
    );
  }
}

class _AttachedGymCard extends StatelessWidget {
  final String session;
  final String gymName;
  const _AttachedGymCard({required this.session, required this.gymName});

  @override
  Widget build(BuildContext context) {
    final gym = MockData.allGyms.where((g) => g.name == gymName).firstOrNull;
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: gym == null ? null : () => Navigator.of(context).push(slideRightRoute(GymDetailScreen(gym: gym))),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: AppColors.surfaceLight, borderRadius: BorderRadius.circular(16)),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: SizedBox(
                width: 60,
                height: 52,
                child: gym != null && gym.photoAssets.isNotEmpty
                    ? Image.asset(gym.photoAssets.first, fit: BoxFit.cover)
                    : Container(color: AppColors.surfaceLight, child: const Icon(Icons.fitness_center_rounded)),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(session, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15.5)),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(gym != null ? gym.rating.toStringAsFixed(gym.rating == gym.rating.roundToDouble() ? 0 : 1) : "",
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5)),
                      const SizedBox(width: 3),
                      const Icon(Icons.star, color: AppColors.accentGreen, size: 16),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(gymName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(color: AppColors.textSecondary, fontSize: 13.5)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: AppColors.textSecondary),
          ],
        ),
      ),
    );
  }
}

class _DemoPost extends StatelessWidget {
  final String author;
  final String initial;
  final Color avatarColor;
  final String date;
  final String text;
  final List<String> photos;
  final String attachedSession;
  final String attachedGymName;
  final int likes;
  final String views;
  final String reactionText;
  const _DemoPost({
    required this.author,
    required this.initial,
    required this.avatarColor,
    required this.date,
    required this.text,
    required this.photos,
    required this.attachedSession,
    required this.attachedGymName,
    required this.likes,
    required this.views,
    required this.reactionText,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          _PostHeader(author: author, initial: initial, avatarColor: avatarColor, date: date),
          const SizedBox(height: 14),
          Text.rich(
            TextSpan(
              text: text,
              children: const [
                TextSpan(text: " Hammasini o'qish", style: TextStyle(color: AppColors.primary)),
              ],
            ),
            style: const TextStyle(fontSize: 16.5, height: 1.35),
          ),
          const SizedBox(height: 14),
          if (photos.isNotEmpty)
            SizedBox(
              height: 300,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                physics: const ClampingScrollPhysics(),
                itemCount: photos.length,
                separatorBuilder: (_, __) => const SizedBox(width: 10),
                itemBuilder: (_, i) => ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: Image.asset(photos[i],
                      height: 300, width: MediaQuery.of(context).size.width * 0.6, fit: BoxFit.cover),
                ),
              ),
            ),
          const SizedBox(height: 14),
          _AttachedGymCard(session: attachedSession, gymName: attachedGymName),
          const SizedBox(height: 16),
          _PostStatsRow(
            postId: "demo_$author",
            likes: likes,
            views: views,
            reactionText: reactionText,
            shareText: "1Fit'da $author postini ko'ring! https://1fit.uz",
          ),
        ],
      ),
    );
  }
}

class _UserPostCard extends StatelessWidget {
  final FeedPost post;
  const _UserPostCard({required this.post});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          _PostHeader(
              author: post.title, initial: post.authorInitial, avatarColor: AppColors.primary, date: post.meta),
          const SizedBox(height: 14),
          Text(post.body, style: const TextStyle(fontSize: 16.5, height: 1.35)),
          const SizedBox(height: 16),
          _PostStatsRow(
            postId: post.id,
            likes: 0,
            views: "12",
            reactionText: "Birinchi reaksiyani bildiring",
            shareText: "1Fit'da yangi post: \"${post.body}\" — ko'ring! https://1fit.uz",
          ),
        ],
      ),
    );
  }
}

class _DashedCirclePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 1.5;
    final paint = Paint()
      ..color = AppColors.primary
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    const dashCount = 14;
    for (var i = 0; i < dashCount; i++) {
      final start = (i / dashCount) * 2 * 3.14159265 - 3.14159265 / 2;
      final sweep = (2 * 3.14159265 / dashCount) * 0.55;
      canvas.drawArc(Rect.fromCircle(center: center, radius: radius), start, sweep, false, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
