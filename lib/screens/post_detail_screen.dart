import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/post_model.dart';
import '../services/storage_service.dart';
import '../theme/app_theme.dart';
import '../widgets/avatar_widget.dart';
import '../widgets/toast_widget.dart';

class PostDetailScreen extends StatefulWidget {
  final PostModel post;
  const PostDetailScreen({super.key, required this.post});

  @override
  State<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  final TextEditingController _commentController = TextEditingController();
  bool _isLiked = false;
  bool _hasCommentText = false;
  late List<Map<String, String>> _comments;
  late String _viewCount;

  // 根据帖子 id 生成稳定但看起来真实的评论
  static List<Map<String, String>> _generateComments(String postId) {
    final pool = [
      {'author': '猫耳控2046',  'seed': 'NekoMimi', 'text': '求同款！',                         'time': '6分钟前',   'likes': '14'},
      {'author': '老宅一枚',    'seed': 'Otaku',    'text': '哈哈哈哈太真实了',                  'time': '19分钟前',  'likes': '6'},
      {'author': '像素猎手',    'seed': 'Pixel',    'text': '同感，完全戳到我了',                'time': '37分钟前',  'likes': '9'},
      {'author': '抚子酱',      'seed': 'Nadeko',   'text': '收藏了，下次试试',                  'time': '52分钟前',  'likes': '3'},
      {'author': '富士胶片控',  'seed': 'Camera',   'text': '这个角度拍得真好，用的什么设备？',  'time': '1小时前',   'likes': '21'},
      {'author': '凌晨三点',    'seed': 'Night',    'text': '深夜刷到这个，破防了',              'time': '1小时前',   'likes': '17'},
      {'author': '追星星的人',  'seed': 'Star',     'text': '太有共鸣了',                        'time': '2小时前',   'likes': '5'},
      {'author': 'GR3摄影党',   'seed': 'Cyber',    'text': '氛围感拉满',                        'time': '2小时前',   'likes': '11'},
      {'author': '老宅一枚',    'seed': 'Old',      'text': '这个梗我懂哈哈',                    'time': '3小时前',   'likes': '8'},
      {'author': '动森岛主',    'seed': 'Island',   'text': '好治愈，谢谢分享',                  'time': '4小时前',   'likes': '4'},
      {'author': '星野kiraa',   'seed': 'Kira',     'text': '每次看你的帖子都很开心',            'time': '5小时前',   'likes': '7'},
      {'author': '谷子收纳控',  'seed': 'Bag',      'text': '已关注',                            'time': '6小时前',   'likes': '2'},
      {'author': '芙莉莲粉',    'seed': 'Elf',      'text': '意难平+1',                          'time': '7小时前',   'likes': '19'},
      {'author': 'V家老粉',     'seed': 'Miku',     'text': '这个真的绝了',                      'time': '8小时前',   'likes': '13'},
      {'author': '电锯人出没',  'seed': 'Dog',      'text': '下次漫展一起去！',                  'time': '9小时前',   'likes': '6'},
      {'author': '匿名_茶',     'seed': 'Tree',     'text': '说出了我的心声',                    'time': '10小时前',  'likes': '31'},
      {'author': '动森岛主',    'seed': 'Island',   'text': '哈哈哈哈哈哈',                      'time': '11小时前',  'likes': '8'},
      {'author': '富士胶片控',  'seed': 'Camera',   'text': '这配色真的好看',                    'time': '12小时前',  'likes': '5'},
    ];
    final seed = postId.hashCode.abs();
    final count = 3 + (seed % 6);
    final result = <Map<String, String>>[];
    for (var i = 0; i < count; i++) {
      result.add(pool[(seed + i * 7) % pool.length]);
    }
    return result;
  }

  static String _generateViewCount(String postId) {
    final n = 1200 + (postId.hashCode.abs() % 28000);
    if (n >= 10000) return '${(n / 10000).toStringAsFixed(1)}w';
    return n.toString();
  }

  @override
  void initState() {
    super.initState();
    _comments = _generateComments(widget.post.id);
    _viewCount = _generateViewCount(widget.post.id);
    _isLiked = widget.post.isLiked;
    _commentController.addListener(() {
      final hasText = _commentController.text.trim().isNotEmpty;
      if (hasText != _hasCommentText) setState(() => _hasCommentText = hasText);
    });
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void _showMoreMenu(BuildContext ctx) {
    final post = widget.post;
    showModalBottomSheet(
      context: ctx,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 32),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            Container(
              width: 36, height: 4,
              decoration: BoxDecoration(
                color: AppColors.divider,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 8),
            _sheetItem(Icons.flag_outlined, '举报内容', Colors.orange, () {
              Navigator.pop(ctx);
              showAppToast(ctx, '举报已提交，感谢反馈');
            }),
            const Divider(height: 1, indent: 56, color: AppColors.divider),
            _sheetItem(Icons.block_outlined, '拉黑该用户', Colors.redAccent, () async {
              Navigator.pop(ctx);
              await StorageService.addToBlacklist(post.id, post.author, post.avatarSeed);
              if (mounted) showAppToast(context, '已将 ${post.author} 加入黑名单');
            }),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _sheetItem(IconData icon, String label, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: Colors.transparent,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        child: Row(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 14),
            Text(label, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: color)),
          ],
        ),
      ),
    );
  }

  void _sendComment() {
    final text = _commentController.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _comments.insert(0, {
        'author': StorageService.getNickname(),
        'seed': StorageService.getAvatarSeed(),
        'text': text,
        'time': '刚刚',
        'likes': '0',
      });
    });
    _commentController.clear();
    showAppToast(context, '评论成功');
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
              boxShadow: [
                BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 10),
              ],
            ),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: 32, height: 32,
                    decoration: BoxDecoration(color: AppColors.bg, borderRadius: BorderRadius.circular(10)),
                    child: const Icon(Icons.chevron_left, color: AppColors.textColor),
                  ),
                ),
                const Expanded(
                  child: Text('动态详情',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.textColor)),
                ),
                GestureDetector(
                  onTap: () => _showMoreMenu(context),
                  child: Container(
                    width: 32, height: 32,
                    decoration: BoxDecoration(color: AppColors.bg, borderRadius: BorderRadius.circular(10)),
                    child: const Icon(Icons.more_horiz, color: AppColors.textColor),
                  ),
                ),
              ],
            ),
          ),
          // Content
          Expanded(
            child: ListView(
              padding: const EdgeInsets.only(bottom: 80),
              children: [
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          AvatarWidget(seed: widget.post.avatarSeed, size: 42),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(widget.post.author,
                                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textColor)),
                                Text('${widget.post.time} · ${widget.post.tag}',
                                    style: const TextStyle(fontSize: 11, color: AppColors.subtext)),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Text('关注',
                                style: TextStyle(fontSize: 12, color: AppColors.primary, fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      Text(widget.post.content,
                          style: const TextStyle(fontSize: 14, color: AppColors.textColor, height: 1.7)),
                      if (widget.post.imageUrl != null) ...[
                        const SizedBox(height: 12),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.network(
                            widget.post.imageUrl!,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              height: 200, color: AppColors.bg,
                              child: const Center(child: Icon(Icons.image_not_supported, color: AppColors.subtext)),
                            ),
                          ),
                        ),
                      ],
                      const SizedBox(height: 14),
                      const Divider(color: AppColors.divider),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.remove_red_eye_outlined, size: 14, color: AppColors.subtext),
                          const SizedBox(width: 4),
                          Text(_viewCount, style: const TextStyle(fontSize: 12, color: AppColors.subtext)),
                          const SizedBox(width: 16),
                          GestureDetector(
                            onTap: () {
                              setState(() => _isLiked = !_isLiked);
                              HapticFeedback.lightImpact();
                            },
                            child: Row(
                              children: [
                                Icon(
                                  _isLiked ? Icons.favorite : Icons.favorite_border,
                                  size: 14,
                                  color: _isLiked ? AppColors.secondary : AppColors.subtext,
                                ),
                                const SizedBox(width: 4),
                                Text(widget.post.likesDisplay,
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: _isLiked ? AppColors.secondary : AppColors.subtext)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('全部评论 (${_comments.length + widget.post.comments})',
                          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.textColor)),
                      const SizedBox(height: 16),
                      ..._comments.map((c) => _buildComment(c)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Bottom input
          Container(
            padding: EdgeInsets.only(
              left: 16, right: 16, top: 12,
              bottom: MediaQuery.of(context).padding.bottom + 12,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 10, offset: const Offset(0, -2)),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: AppColors.bg,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: AppColors.divider),
                    ),
                    child: TextField(
                      controller: _commentController,
                      decoration: const InputDecoration.collapsed(
                        hintText: '说说你的想法...',
                        hintStyle: TextStyle(color: AppColors.subtext, fontSize: 13),
                      ),
                      style: const TextStyle(fontSize: 13),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: _hasCommentText ? _sendComment : null,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 40, height: 40,
                    decoration: BoxDecoration(
                      color: _hasCommentText ? AppColors.primary : AppColors.subtext.withValues(alpha: 0.25),
                      shape: BoxShape.circle,
                      boxShadow: _hasCommentText
                          ? [BoxShadow(color: AppColors.primary.withValues(alpha: 0.3), blurRadius: 10)]
                          : [],
                    ),
                    child: const Icon(Icons.send, color: Colors.white, size: 18),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildComment(Map<String, String> comment) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AvatarWidget(seed: comment['seed']!, size: 32),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(comment['author']!,
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textColor)),
                    Row(
                      children: [
                        const Icon(Icons.favorite_border, size: 12, color: AppColors.subtext),
                        const SizedBox(width: 3),
                        Text(comment['likes']!, style: const TextStyle(fontSize: 11, color: AppColors.subtext)),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(comment['text']!,
                    style: const TextStyle(fontSize: 13, color: Color(0xFF4A5568), height: 1.5)),
                const SizedBox(height: 4),
                Text(comment['time']!, style: const TextStyle(fontSize: 10, color: AppColors.subtext)),
                const SizedBox(height: 12),
                const Divider(color: AppColors.divider, height: 1),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
