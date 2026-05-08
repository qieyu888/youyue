import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class AvatarWidget extends StatelessWidget {
  final String seed;
  final double size;
  final double borderWidth;

  const AvatarWidget({
    super.key,
    required this.seed,
    this.size = 40,
    this.borderWidth = 1,
  });

  @override
  Widget build(BuildContext context) {
    final url = 'https://api.dicebear.com/7.x/adventurer/png?seed=$seed&size=128';
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.divider, width: borderWidth),
        color: AppColors.bg,
      ),
      child: ClipOval(
        child: Image.network(
          url,
          width: size,
          height: size,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => Container(
            color: AppColors.primary.withValues(alpha: 0.2),
            child: Icon(
              Icons.person,
              size: size * 0.5,
              color: AppColors.primary,
            ),
          ),
          loadingBuilder: (_, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Container(
              color: AppColors.bg,
              child: Center(
                child: SizedBox(
                  width: size * 0.35,
                  height: size * 0.35,
                  child: CircularProgressIndicator(
                    strokeWidth: 1.5,
                    color: AppColors.primary.withValues(alpha: 0.4),
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes!
                        : null,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
