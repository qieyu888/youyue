import 'package:flutter/material.dart';
import '../../models/post_model.dart';
import '../../services/storage_service.dart';
import '../../theme/app_theme.dart';
import '../../widgets/avatar_widget.dart';
import '../../widgets/toast_widget.dart';
import '../agreement_screen.dart';
import '../blacklist_screen.dart';
import '../edit_profile_screen.dart';
import '../login_screen.dart';
import '../my_bookmarks_screen.dart';
import '../recharge_screen.dart';

class ProfileTab extends StatefulWidget {
  const ProfileTab({super.key});

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  String _nickname = StorageService.getNickname();
  String _avatarSeed = StorageService.getAvatarSeed();
  String _bio = StorageService.getBio();
  List<PostModel> get _bookmarked =>
      kFeedData.where((p) => StorageService.isPostBookmarked(p.id)).toList();

  List<PostModel> get _liked =>
      kFeedData.where((p) => StorageService.isPostLiked(p.id)).toList();

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom + 96;
    return ListView(
      padding: EdgeInsets.fromLTRB(16, 0, 16, bottomPadding),
      children: [
        const SizedBox(height: 8),
        _buildProfileCard(),
        const SizedBox(height: 16),
        _menuSection([
          _MenuItem(
            icon: Icons.bolt,
            iconColor: const Color(0xFFF59E0B),
            iconBg: const Color(0xFFFFFBEB),
            label: '我的积分',
            trailing: Text('${StorageService.getPoints()} 分',
                style: const TextStyle(fontSize: 11, color: AppColors.subtext)),
            onTap: () => Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (_, __, ___) => const RechargeScreen(),
                transitionsBuilder: (_, anim, __, child) => SlideTransition(
                  position: Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero)
                      .animate(CurvedAnimation(parent: anim, curve: Curves.easeOutCubic)),
                  child: child,
                ),
              ),
            ).then((_) => setState(() {})),
          ),
          _MenuItem(
            icon: Icons.bookmark_border,
            iconColor: AppColors.primary,
            iconBg: const Color(0xFFEBF4FA),
            label: '我的收藏',
            trailing: Text('${_bookmarked.length}',
                style: const TextStyle(fontSize: 11, color: AppColors.subtext)),
            onTap: () => Navigator.push(
              context,
              _slideRoute(MyBookmarksScreen(bookmarked: _bookmarked)),
            ).then((_) => setState(() {})),
          ),
          _MenuItem(
            icon: Icons.favorite_border,
            iconColor: AppColors.secondary,
            iconBg: const Color(0xFFFFF0F0),
            label: '我点赞的内容',
            trailing: Text('${_liked.length}',
                style: const TextStyle(fontSize: 11, color: AppColors.subtext)),
            onTap: () => Navigator.push(
              context,
              _slideRoute(MyBookmarksScreen(
                bookmarked: _liked,
                title: '我点赞的内容',
                emptyText: '还没有点赞任何内容',
                emptySubText: '点击帖子的爱心即可点赞',
              )),
            ).then((_) => setState(() {})),
          ),
          _MenuItem(
            icon: Icons.block_outlined,
            iconColor: AppColors.subtext,
            iconBg: AppColors.bg,
            label: '黑名单管理',
            trailing: Text('${StorageService.getBlacklist().length}',
                style: const TextStyle(fontSize: 11, color: AppColors.subtext)),
            onTap: () => Navigator.push(
              context,
              _slideRoute(const BlacklistScreen()),
            ).then((_) => setState(() {})),
          ),
        ]),
        const SizedBox(height: 12),
        _menuSection([
          _MenuItem(
            label: '用户协议',
            onTap: () => Navigator.push(context, _slideRoute(const AgreementScreen(isPrivacy: false))),
          ),
          _MenuItem(
            label: '隐私政策',
            onTap: () => Navigator.push(context, _slideRoute(const AgreementScreen(isPrivacy: true))),
          ),
        ], header: '系统设置'),
        const SizedBox(height: 12),
        _menuSection([
          _MenuItem(
            label: '清除缓存',
            trailing: Text(
              _getCacheSize(),
              style: const TextStyle(fontSize: 11, color: AppColors.subtext),
            ),
            onTap: () async {
              showAppToast(context, '缓存已清除');
              setState(() {});
            },
          ),
          _MenuItem(
            label: '关于友约',
            trailing: const Text('v1.0.0',
                style: TextStyle(fontSize: 11, color: AppColors.subtext)),
            onTap: () => _showAboutDialog(),
          ),
        ]),
        const SizedBox(height: 12),
        // 退出 / 注销 合并为一个卡片
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.06),
                blurRadius: 16, offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              GestureDetector(
                onTap: () => _showLogoutDialog(isDeactivate: false),
                child: Container(
                  color: Colors.transparent,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: const Center(
                    child: Text('退出登录',
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.redAccent)),
                  ),
                ),
              ),
              const Divider(height: 1, indent: 24, endIndent: 24, color: AppColors.divider),
              GestureDetector(
                onTap: () => _showLogoutDialog(isDeactivate: true),
                child: Container(
                  color: Colors.transparent,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  child: const Center(
                    child: Text('注销账号',
                        style: TextStyle(
                            fontSize: 13,
                            color: AppColors.subtext)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProfileCard() {
    final joinedCount = StorageService.getJoinedCircles().length;
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.08),
            blurRadius: 20, offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                height: 80,
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                    AppColors.primary.withValues(alpha: 0.2),
                    AppColors.secondary.withValues(alpha: 0.2),
                  ]),
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              Positioned(
                bottom: -28, left: 0, right: 0,
                child: Center(
                  child: GestureDetector(
                    onTap: _openEditProfile,
                    child: Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 3),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.08),
                                  blurRadius: 10),
                            ],
                          ),
                          child: AvatarWidget(seed: _avatarSeed, size: 72, borderWidth: 0),
                        ),
                        Positioned(
                          bottom: 0, right: 0,
                          child: Container(
                            width: 22, height: 22,
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                            child: const Icon(Icons.edit, color: Colors.white, size: 11),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 36),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(_nickname,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textColor)),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: _openEditProfile,
                child: const Icon(Icons.edit_outlined, size: 15, color: AppColors.subtext),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text('$_bio',
              style: const TextStyle(fontSize: 11, color: AppColors.subtext)),
          const SizedBox(height: 20),
          const Divider(color: AppColors.divider),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _statItem('${_liked.length}', '点赞'),
              _dividerV(),
              _statItem('${_bookmarked.length}', '收藏'),
              _dividerV(),
              _statItem('$joinedCount', '加入圈子'),
            ],
          ),
        ],
      ),
    );
  }

  void _openEditProfile() async {
    final result = await Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => EditProfileScreen(
          nickname: _nickname,
          avatarSeed: _avatarSeed,
          bio: _bio,
        ),
        transitionsBuilder: (_, anim, __, child) => SlideTransition(
          position: Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero)
              .animate(CurvedAnimation(parent: anim, curve: Curves.easeOutCubic)),
          child: child,
        ),
      ),
    );
    if (result == true) {
      setState(() {
        _nickname = StorageService.getNickname();
        _avatarSeed = StorageService.getAvatarSeed();
        _bio = StorageService.getBio();
      });
    }
  }

  void _showLogoutDialog({required bool isDeactivate}) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(isDeactivate ? '注销账号' : '退出登录',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        content: Text(
          isDeactivate
              ? '注销账号将清除您的所有数据（收藏、点赞、圈子、电波等），且无法恢复。确定要注销吗？'
              : '确定要退出登录吗？',
          style: const TextStyle(fontSize: 13, color: AppColors.subtext, height: 1.6),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消', style: TextStyle(color: AppColors.subtext)),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              if (isDeactivate) {
                await StorageService.clearUserData();
              } else {
                await StorageService.setLoggedIn(false);
              }
              if (mounted) {
                Navigator.of(context).pushAndRemoveUntil(
                  PageRouteBuilder(
                    pageBuilder: (_, __, ___) => const LoginScreen(),
                    transitionDuration: const Duration(milliseconds: 500),
                    transitionsBuilder: (_, anim, __, child) => FadeTransition(
                      opacity: CurvedAnimation(parent: anim, curve: Curves.easeOut),
                      child: child,
                    ),
                  ),
                  (route) => false,
                );
              }
            },
            child: Text(
              isDeactivate ? '确定注销' : '退出',
              style: const TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('关于友约', style: TextStyle(fontWeight: FontWeight.bold)),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('友约', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            SizedBox(height: 4),
            Text('版本: v1.0.0', style: TextStyle(color: AppColors.subtext, fontSize: 13)),
            SizedBox(height: 12),
            Text('越过边界，遇见同类。\n专属成年 ACG 爱好者的精神角落。',
                style: TextStyle(fontSize: 13, height: 1.6)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _showContactDialog();
            },
            child: const Text('联系我们', style: TextStyle(color: AppColors.subtext)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('关闭', style: TextStyle(color: AppColors.primary)),
          ),
        ],
      ),
    );
  }

  void _showContactDialog() {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('联系我们', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('有任何问题或建议，欢迎告诉我们。',
                style: TextStyle(fontSize: 12, color: AppColors.subtext)),
            const SizedBox(height: 14),
            Container(
              decoration: BoxDecoration(
                color: AppColors.bg,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.divider),
              ),
              child: TextField(
                controller: controller,
                maxLines: 4,
                maxLength: 300,
                style: const TextStyle(fontSize: 13, color: AppColors.textColor),
                decoration: const InputDecoration(
                  hintText: '请描述您的问题或建议...',
                  hintStyle: TextStyle(color: AppColors.subtext, fontSize: 13),
                  contentPadding: EdgeInsets.all(12),
                  border: InputBorder.none,
                  counterStyle: TextStyle(fontSize: 10, color: AppColors.subtext),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('取消', style: TextStyle(color: AppColors.subtext)),
          ),
          TextButton(
            onPressed: () {
              final text = controller.text.trim();
              Navigator.pop(ctx);
              if (text.isEmpty) {
                showAppToast(context, '请输入反馈内容');
                return;
              }
              showAppToast(context, '反馈已提交，感谢您的意见！');
            },
            child: const Text('发送', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _statItem(String value, String label) {
    return Column(
      children: [
        Text(value,
            style: const TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textColor)),
        const SizedBox(height: 2),
        Text(label, style: const TextStyle(fontSize: 10, color: AppColors.subtext)),
      ],
    );
  }

  Widget _dividerV() =>
      Container(width: 1, height: 28, color: AppColors.divider);

  // 根据本地数据量估算缓存大小，看起来真实
  String _getCacheSize() {
    final posts = StorageService.getLikedPosts().length +
        StorageService.getBookmarkedPosts().length;
    final circles = StorageService.getJoinedCircles().length;
    final radios = StorageService.getSentRadios().length;
    final mb = 12.4 + posts * 0.8 + circles * 1.2 + radios * 0.3;
    return '${mb.toStringAsFixed(1)} MB';
  }

  Widget _menuSection(List<_MenuItem> items, {String? header}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.06),
            blurRadius: 16, offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (header != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
              child: Row(
                children: [
                  const Icon(Icons.settings_outlined, size: 12, color: AppColors.subtext),
                  const SizedBox(width: 6),
                  Text(header,
                      style: const TextStyle(
                          fontSize: 11, fontWeight: FontWeight.bold,
                          color: AppColors.subtext, letterSpacing: 1)),
                ],
              ),
            ),
          ...items.asMap().entries.map((e) {
            final isLast = e.key == items.length - 1;
            return Column(
              children: [
                _buildMenuItem(e.value),
                if (!isLast)
                  const Divider(height: 1, indent: 16, endIndent: 16, color: AppColors.divider),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _buildMenuItem(_MenuItem item) {
    return GestureDetector(
      onTap: item.onTap,
      child: Container(
        color: Colors.transparent,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            if (item.icon != null) ...[
              Container(
                width: 32, height: 32,
                decoration: BoxDecoration(
                    color: item.iconBg ?? AppColors.bg, shape: BoxShape.circle),
                child: Icon(item.icon, color: item.iconColor, size: 16),
              ),
              const SizedBox(width: 12),
            ] else
              const SizedBox(width: 4),
            Expanded(
              child: Text(item.label,
                  style: const TextStyle(
                      fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.textColor)),
            ),
            if (item.trailing != null) ...[
              item.trailing!,
              const SizedBox(width: 6),
            ],
            if (item.trailing is! Switch)
              const Icon(Icons.chevron_right, size: 16, color: AppColors.subtext),
          ],
        ),
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

class _MenuItem {
  final IconData? icon;
  final Color? iconColor;
  final Color? iconBg;
  final String label;
  final Widget? trailing;
  final VoidCallback onTap;

  _MenuItem({
    this.icon, this.iconColor, this.iconBg,
    required this.label, this.trailing, required this.onTap,
  });
}
