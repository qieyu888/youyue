import 'package:flutter/material.dart';
import '../../models/post_model.dart';
import '../../services/storage_service.dart';
import '../../widgets/post_card.dart';
import '../post_detail_screen.dart';

class FeedTab extends StatefulWidget {
  const FeedTab({super.key});

  @override
  State<FeedTab> createState() => _FeedTabState();
}

class _FeedTabState extends State<FeedTab> {
  late List<PostModel> _posts;
  bool _isRefreshing = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _posts = List.from(kFeedData);
    _syncLikeBookmarkState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _syncLikeBookmarkState() {
    for (final post in _posts) {
      post.isLiked = StorageService.isPostLiked(post.id);
      post.isBookmarked = StorageService.isPostBookmarked(post.id);
    }
  }

  Future<void> _onRefresh() async {
    setState(() => _isRefreshing = true);
    await Future.delayed(const Duration(milliseconds: 800));
    setState(() {
      _posts = List.from(kFeedData)..shuffle();
      _syncLikeBookmarkState();
      _isRefreshing = false;
    });
    // 刷新后回到顶部
    if (_scrollController.hasClients) {
      _scrollController.animateTo(0,
          duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: const Color(0xFF7AB2D3),
      onRefresh: _onRefresh,
      child: ListView.builder(
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
        itemCount: _posts.length + (_isRefreshing ? 0 : 1),
        itemBuilder: (context, index) {
          if (index == _posts.length) {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Center(
                child: Text('— 已经到底了 —',
                    style: TextStyle(fontSize: 12, color: Color(0xFF8395A7))),
              ),
            );
          }
          final post = _posts[index];
          return PostCard(
            post: post,
            onLikeChanged: (liked) {
              StorageService.toggleLikePost(post.id); // fire-and-forget
            },
            onBookmarkChanged: (bookmarked) {
              StorageService.toggleBookmarkPost(post.id); // fire-and-forget
            },
            onTap: () => Navigator.push(
              context,
              _slideRoute(PostDetailScreen(post: post)),
            ),
          );
        },
      ),
    );
  }

  Route _slideRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (_, __, ___) => page,
      transitionsBuilder: (_, anim, __, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1, 0),
            end: Offset.zero,
          ).animate(CurvedAnimation(parent: anim, curve: Curves.easeOutCubic)),
          child: child,
        );
      },
    );
  }
}
