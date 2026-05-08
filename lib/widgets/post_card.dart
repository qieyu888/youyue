import 'package:flutter/material.dart';
import '../models/post_model.dart';
import '../theme/app_theme.dart';
import '../widgets/avatar_widget.dart';
import '../widgets/toast_widget.dart';

class PostCard extends StatefulWidget {
  final PostModel post;
  final VoidCallback onTap;
  final Function(bool)? onLikeChanged;
  final Function(bool)? onBookmarkChanged;

  const PostCard({
    super.key,
    required this.post,
    required this.onTap,
    this.onLikeChanged,
    this.onBookmarkChanged,
  });

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _likeController;
  late Animation<double> _likeScale;

  @override
  void initState() {
    super.initState();
    _likeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    _likeScale = TweenSequence([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.35), weight: 40),
      TweenSequenceItem(tween: Tween(begin: 1.35, end: 1.0), weight: 60),
    ]).animate(CurvedAnimation(
      parent: _likeController,
      curve: Curves.easeOut,
    ));
    // 动画完成后自动 reset，避免 scale 卡住
    _likeController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _likeController.reset();
      }
    });
  }

  @override
  void dispose() {
    _likeController.dispose();
    super.dispose();
  }

  void _toggleLike() {
    setState(() {
      widget.post.isLiked = !widget.post.isLiked;
    });
    if (widget.post.isLiked) {
      _likeController.forward(from: 0);
    }
    // fire-and-forget，不阻塞 UI
    widget.onLikeChanged?.call(widget.post.isLiked);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.post.type == 'text') {
      return _buildTextCard(context);
    }
    return _buildNormalCard(context);
  }

  Widget _buildNormalCard(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.08),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(color: Colors.white),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              const SizedBox(height: 10),
              Text(
                widget.post.content,
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.textColor,
                  height: 1.6,
                ),
              ),
              if (widget.post.imageUrl != null) ...[
                const SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.network(
                    widget.post.imageUrl!,
                    height: 180,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      height: 180,
                      color: AppColors.bg,
                      child: const Center(
                        child: Icon(Icons.image_not_supported,
                            color: AppColors.subtext),
                      ),
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 12),
              _buildActions(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextCard(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.white, Color(0xFFF8FAFC)],
          ),
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.08),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(color: Colors.white),
        ),
        child: Stack(
          children: [
            Positioned(
              top: 12,
              right: 16,
              child: Icon(
                Icons.format_quote,
                size: 40,
                color: AppColors.primary.withValues(alpha: 0.1),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(context),
                  const SizedBox(height: 14),
                  Text(
                    widget.post.content,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textColor,
                      height: 1.8,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.3,
                    ),
                  ),
                  const SizedBox(height: 14),
                  const Divider(color: AppColors.divider, height: 1),
                  const SizedBox(height: 12),
                  _buildActions(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        AvatarWidget(seed: widget.post.avatarSeed),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    widget.post.author,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textColor,
                    ),
                  ),
                  if (widget.post.level != null) ...[
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        widget.post.level!,
                        style: const TextStyle(
                          fontSize: 10,
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 2),
              Text(
                '${widget.post.time} · ${widget.post.tag}',
                style: const TextStyle(
                  fontSize: 11,
                  color: AppColors.subtext,
                ),
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: () {
            setState(() {
              widget.post.isBookmarked = !widget.post.isBookmarked;
            });
            showAppToast(context, widget.post.isBookmarked ? '已收藏' : '已取消收藏');
            // fire-and-forget
            widget.onBookmarkChanged?.call(widget.post.isBookmarked);
          },
          child: Icon(
            widget.post.isBookmarked
                ? Icons.bookmark
                : Icons.bookmark_border,
            color: widget.post.isBookmarked
                ? AppColors.primary
                : AppColors.subtext.withValues(alpha: 0.5),
            size: 18,
          ),
        ),
      ],
    );
  }

  Widget _buildActions(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: _toggleLike,
          child: AnimatedBuilder(
            animation: _likeController,
            builder: (_, child) => Transform.scale(
              scale: _likeController.isAnimating ? _likeScale.value : 1.0,
              child: child,
            ),
            child: Row(
              children: [
                Icon(
                  widget.post.isLiked
                      ? Icons.favorite
                      : Icons.favorite_border,
                  size: 16,
                  color: widget.post.isLiked
                      ? AppColors.secondary
                      : AppColors.subtext,
                ),
                const SizedBox(width: 4),
                Text(
                  widget.post.likesDisplay,
                  style: TextStyle(
                    fontSize: 13,
                    color: widget.post.isLiked
                        ? AppColors.secondary
                        : AppColors.subtext,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 20),
        GestureDetector(
          onTap: widget.onTap,
          child: Row(
            children: [
              const Icon(Icons.chat_bubble_outline,
                  size: 16, color: AppColors.subtext),
              const SizedBox(width: 4),
              Text(
                '${widget.post.comments}',
                style: const TextStyle(fontSize: 13, color: AppColors.subtext),
              ),
            ],
          ),
        ),
        const Spacer(),
        GestureDetector(
          onTap: () => showAppToast(context, '已复制分享链接'),
          child: const Icon(Icons.send_outlined,
              size: 16, color: AppColors.subtext),
        ),
      ],
    );
  }
}
