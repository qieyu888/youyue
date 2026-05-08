import 'package:flutter/material.dart';
import '../models/post_model.dart';
import '../theme/app_theme.dart';
import '../widgets/post_card.dart';
import '../services/storage_service.dart';
import 'post_detail_screen.dart';

class MyBookmarksScreen extends StatefulWidget {
  final List<PostModel> bookmarked;
  final String title;
  final String emptyText;
  final String emptySubText;

  const MyBookmarksScreen({
    super.key,
    required this.bookmarked,
    this.title = '我的收藏',
    this.emptyText = '还没有收藏任何内容',
    this.emptySubText = '点击帖子右上角的书签即可收藏',
  });

  @override
  State<MyBookmarksScreen> createState() => _MyBookmarksScreenState();
}

class _MyBookmarksScreenState extends State<MyBookmarksScreen> {
  late List<PostModel> _posts;

  @override
  void initState() {
    super.initState();
    _posts = List.from(widget.bookmarked);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Column(
        children: [
          // Header
          Container(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 8,
              left: 16, right: 16, bottom: 12,
            ),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.85),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: 32, height: 32,
                    decoration: BoxDecoration(
                        color: AppColors.bg, borderRadius: BorderRadius.circular(10)),
                    child: const Icon(Icons.chevron_left, color: AppColors.textColor),
                  ),
                ),
                Expanded(
                  child: Text(widget.title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.textColor)),
                ),
                Text('${_posts.length} 条',
                    style: const TextStyle(fontSize: 12, color: AppColors.subtext)),
              ],
            ),
          ),
          Expanded(
            child: _posts.isEmpty
                ? _buildEmpty()
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
                    itemCount: _posts.length,
                    itemBuilder: (ctx, i) {
                      final post = _posts[i];
                      return PostCard(
                        post: post,
                        onLikeChanged: (liked) async {
                          await StorageService.toggleLikePost(post.id);
                          setState(() {});
                        },
                        onBookmarkChanged: (bookmarked) async {
                          await StorageService.toggleBookmarkPost(post.id);
                          // 如果取消收藏，从列表移除
                          if (!bookmarked && widget.title == '我的收藏') {
                            setState(() => _posts.removeAt(i));
                          }
                        },
                        onTap: () => Navigator.push(
                          ctx,
                          PageRouteBuilder(
                            pageBuilder: (_, __, ___) => PostDetailScreen(post: post),
                            transitionsBuilder: (_, anim, __, child) => SlideTransition(
                              position: Tween<Offset>(
                                      begin: const Offset(1, 0), end: Offset.zero)
                                  .animate(CurvedAnimation(
                                      parent: anim, curve: Curves.easeOutCubic)),
                              child: child,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            widget.title == '我的收藏'
                ? Icons.bookmark_border
                : Icons.favorite_border,
            size: 56,
            color: AppColors.subtext.withValues(alpha: 0.3),
          ),
          const SizedBox(height: 12),
          Text(widget.emptyText,
              style: const TextStyle(color: AppColors.subtext, fontSize: 14)),
          const SizedBox(height: 6),
          Text(widget.emptySubText,
              style: const TextStyle(color: AppColors.subtext, fontSize: 12)),
        ],
      ),
    );
  }
}
