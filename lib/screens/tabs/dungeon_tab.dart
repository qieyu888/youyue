import 'package:flutter/material.dart';
import '../../models/circle_model.dart';
import '../../services/storage_service.dart';
import '../../theme/app_theme.dart';
import '../../widgets/toast_widget.dart';
import '../circle_detail_screen.dart';

class DungeonTab extends StatefulWidget {
  const DungeonTab({super.key});

  @override
  State<DungeonTab> createState() => _DungeonTabState();
}

class _DungeonTabState extends State<DungeonTab> {
  final List<CircleModel> _circles = List.from(kCircleData);
  final TextEditingController _searchController = TextEditingController();
  String _query = '';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() => _query = _searchController.text.toLowerCase());
    });
    // 从持久化恢复加入状态
    for (final c in _circles) {
      c.isJoined = StorageService.isCircleJoined(c.id);
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<CircleModel> get _filtered {
    if (_query.isEmpty) return _circles;
    return _circles
        .where((c) => c.name.toLowerCase().contains(_query))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '兴趣结界',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textColor,
                  ),
                ),
                const SizedBox(height: 2),
                const Text(
                  '找到你的专属同好圈',
                  style: TextStyle(fontSize: 12, color: AppColors.subtext),
                ),
                const SizedBox(height: 14),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.08),
                        blurRadius: 16,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      hintText: '搜索圈子、话题...',
                      hintStyle:
                          TextStyle(color: AppColors.subtext, fontSize: 13),
                      prefixIcon: Icon(Icons.search,
                          color: AppColors.subtext, size: 18),
                      border: InputBorder.none,
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.85,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final circle = _filtered[index];
                return _CircleCard(
                  circle: circle,
                  onTap: () => Navigator.push(
                    context,
                    _slideRoute(CircleDetailScreen(circle: circle)),
                  ),
                  onJoin: () async {
                    await StorageService.toggleJoinCircle(circle.id);
                    if (!mounted) return;
                    setState(() => circle.isJoined = StorageService.isCircleJoined(circle.id));
                    showAppToast(context, circle.isJoined ? '加入成功 🎉' : '已退出结界');
                  },
                );
              },
              childCount: _filtered.length,
            ),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 80)),
      ],
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

class _CircleCard extends StatelessWidget {
  final CircleModel circle;
  final VoidCallback onTap;
  final VoidCallback onJoin;

  const _CircleCard({
    required this.circle,
    required this.onTap,
    required this.onJoin,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.07),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(color: Colors.white),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: circle.iconBg,
                shape: BoxShape.circle,
              ),
              child: Icon(circle.icon, color: circle.iconColor, size: 22),
            ),
            const SizedBox(height: 10),
            Text(
              circle.name,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: AppColors.textColor,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              '${circle.memberCount} 成员',
              style: const TextStyle(fontSize: 10, color: AppColors.subtext),
            ),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: () {
                onJoin();
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 7),
                decoration: BoxDecoration(
                  color: circle.isJoined
                      ? const Color(0xFFF0F0F0)
                      : circle.iconColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: circle.isJoined
                        ? const Color(0xFFDDDDDD)
                        : circle.iconColor.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (circle.isJoined)
                      const Icon(Icons.check, size: 11, color: AppColors.subtext),
                    if (circle.isJoined) const SizedBox(width: 3),
                    Text(
                      circle.isJoined ? '已加入' : '加入',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: circle.isJoined ? AppColors.subtext : circle.iconColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
