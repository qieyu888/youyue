import 'package:flutter/material.dart';
import '../models/post_model.dart';
import '../models/circle_model.dart';
import '../theme/app_theme.dart';
import '../widgets/avatar_widget.dart';
import 'post_detail_screen.dart';
import 'circle_detail_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  late TabController _tabController;
  final ScrollController _scrollController = ScrollController();
  String _query = '';

  final List<String> _hotTags = [
    '漫展', 'Cosplay', '主机游戏', '深夜番', 'Galgame',
    'Vtuber', '胶片摄影', 'OOTD', '痛包', '圣地巡礼',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _controller.addListener(() {
      final newQuery = _controller.text.trim().toLowerCase();
      if (newQuery != _query) {
        setState(() => _query = newQuery);
        if (newQuery.isEmpty && _scrollController.hasClients) {
          _scrollController.animateTo(0,
              duration: const Duration(milliseconds: 200), curve: Curves.easeOut);
        }
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  List<PostModel> get _matchedPosts {
    if (_query.isEmpty) return [];
    return kFeedData.where((p) =>
      p.content.toLowerCase().contains(_query) ||
      p.author.toLowerCase().contains(_query) ||
      p.tag.toLowerCase().contains(_query)
    ).toList();
  }

  List<CircleModel> get _matchedCircles {
    if (_query.isEmpty) return [];
    return kCircleData.where((c) =>
      c.name.toLowerCase().contains(_query) ||
      c.description.toLowerCase().contains(_query)
    ).toList();
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
            color: Colors.white,
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.bg,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: TextField(
                      controller: _controller,
                      autofocus: true,
                      decoration: const InputDecoration(
                        hintText: '搜索帖子、圈子、用户...',
                        hintStyle: TextStyle(color: AppColors.subtext, fontSize: 13),
                        prefixIcon: Icon(Icons.search, color: AppColors.subtext, size: 18),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 10),
                      ),
                      style: const TextStyle(fontSize: 13, color: AppColors.textColor),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Text(
                    '取消',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Tabs when searching
          if (_query.isNotEmpty)
            Container(
              color: Colors.white,
              child: TabBar(
                controller: _tabController,
                labelColor: AppColors.primary,
                unselectedLabelColor: AppColors.subtext,
                indicatorColor: AppColors.primary,
                indicatorSize: TabBarIndicatorSize.label,
                labelStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                tabs: [
                  Tab(text: '帖子 (${_matchedPosts.length})'),
                  Tab(text: '圈子 (${_matchedCircles.length})'),
                ],
              ),
            ),
          Expanded(
            child: _query.isEmpty ? _buildHotTags() : _buildResults(),
          ),
        ],
      ),
    );
  }

  Widget _buildHotTags() {
    return ListView(
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          '热门话题',
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.subtext, letterSpacing: 1),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _hotTags.map((tag) => GestureDetector(
            onTap: () {
              _controller.text = tag;
              _controller.selection = TextSelection.fromPosition(
                TextPosition(offset: tag.length),
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.08),
                    blurRadius: 8, offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.local_fire_department, size: 12, color: AppColors.secondary),
                  const SizedBox(width: 4),
                  Text(tag, style: const TextStyle(fontSize: 13, color: AppColors.textColor)),
                ],
              ),
            ),
          )).toList(),
        ),
      ],
    );
  }

  Widget _buildResults() {
    return TabBarView(
      controller: _tabController,
      children: [
        // Posts
        _matchedPosts.isEmpty
            ? _emptyState('没有找到相关帖子')
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _matchedPosts.length,
                itemBuilder: (ctx, i) {
                  final post = _matchedPosts[i];
                  return GestureDetector(
                    onTap: () => Navigator.push(ctx, _slideRoute(PostDetailScreen(post: post))),
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [BoxShadow(color: AppColors.primary.withValues(alpha: 0.06), blurRadius: 12, offset: const Offset(0, 3))],
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AvatarWidget(seed: post.avatarSeed, size: 36),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(post.author, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textColor)),
                                const SizedBox(height: 4),
                                Text(post.content, maxLines: 2, overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(fontSize: 13, color: AppColors.textColor, height: 1.4)),
                                const SizedBox(height: 6),
                                Row(children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                    decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
                                    child: Text(post.tag, style: const TextStyle(fontSize: 10, color: AppColors.primary)),
                                  ),
                                ]),
                              ],
                            ),
                          ),
                          if (post.imageUrl != null)
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(post.imageUrl!, width: 60, height: 60, fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => const SizedBox()),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
        // Circles
        _matchedCircles.isEmpty
            ? _emptyState('没有找到相关圈子')
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _matchedCircles.length,
                itemBuilder: (ctx, i) {
                  final circle = _matchedCircles[i];
                  return GestureDetector(
                    onTap: () => Navigator.push(ctx, _slideRoute(CircleDetailScreen(circle: circle))),
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [BoxShadow(color: AppColors.primary.withValues(alpha: 0.06), blurRadius: 12, offset: const Offset(0, 3))],
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 44, height: 44,
                            decoration: BoxDecoration(color: circle.iconBg, shape: BoxShape.circle),
                            child: Icon(circle.icon, color: circle.iconColor, size: 20),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(circle.name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textColor)),
                                const SizedBox(height: 3),
                                Text(circle.description, maxLines: 1, overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(fontSize: 11, color: AppColors.subtext)),
                                const SizedBox(height: 3),
                                Text('${circle.memberCount} 成员', style: const TextStyle(fontSize: 10, color: AppColors.subtext)),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                            decoration: BoxDecoration(
                              color: circle.isJoined ? AppColors.bg : circle.iconColor.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Text(
                              circle.isJoined ? '已加入' : '加入',
                              style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold,
                                  color: circle.isJoined ? AppColors.subtext : circle.iconColor),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ],
    );
  }

  Widget _emptyState(String msg) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.search_off, size: 48, color: AppColors.subtext.withValues(alpha: 0.4)),
          const SizedBox(height: 12),
          Text(msg, style: const TextStyle(color: AppColors.subtext, fontSize: 14)),
        ],
      ),
    );
  }

  Route _slideRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (_, __, ___) => page,
      transitionsBuilder: (_, anim, __, child) => SlideTransition(
        position: Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero)
            .animate(CurvedAnimation(parent: anim, curve: Curves.easeOutCubic)),
        child: child,
      ),
    );
  }
}
