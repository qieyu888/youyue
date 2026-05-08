import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class SplashScreen extends StatefulWidget {
  final VoidCallback onUnlock;

  const SplashScreen({super.key, required this.onUnlock});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnim;
  bool _unlocking = false;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    )..repeat(reverse: true);
    _pulseAnim = Tween(begin: 1.0, end: 0.92).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void _unlock() async {
    if (_unlocking) return;
    setState(() => _unlocking = true);
    await Future.delayed(const Duration(milliseconds: 500));
    widget.onUnlock();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Stack(
        children: [
          // Background glow
          Positioned(
            top: -150,
            left: -100,
            child: Container(
              width: 400,
              height: 400,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.primary.withValues(alpha: 0.25),
                    AppColors.bg.withValues(alpha: 0),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: -100,
            right: -50,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.accent.withValues(alpha: 0.2),
                    AppColors.bg.withValues(alpha: 0),
                  ],
                ),
              ),
            ),
          ),
          // Content
          SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                // Logo
                ShaderMask(
                  shaderCallback: (bounds) => const LinearGradient(
                    colors: [AppColors.primary, AppColors.accent],
                  ).createShader(bounds),
                  child: const Text(
                    '友约.',
                    style: TextStyle(
                      fontSize: 52,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      letterSpacing: -1,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'SECRET GARDEN',
                  style: TextStyle(
                    fontSize: 11,
                    color: AppColors.subtext,
                    letterSpacing: 4,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 60),
                // Glass card
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.7),
                      borderRadius: BorderRadius.circular(28),
                      border: Border.all(
                          color: Colors.white.withValues(alpha: 0.5), width: 1),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          blurRadius: 30,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: AppColors.secondary.withValues(alpha: 0.2),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.eco_outlined,
                            color: AppColors.secondary,
                            size: 24,
                          ),
                        ),
                        const SizedBox(height: 14),
                        const Text(
                          '静谧之境',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textColor,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          '前方是专属于成年人的精神角落。\n请确认您已满 18 周岁，即可轻触解锁。',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 13,
                            color: AppColors.subtext,
                            height: 1.6,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const Spacer(),
                // Fingerprint button
                GestureDetector(
                  onTap: _unlock,
                  child: AnimatedBuilder(
                    animation: _pulseAnim,
                    builder: (_, child) => Transform.scale(
                      scale: _unlocking ? 1.0 : _pulseAnim.value,
                      child: child,
                    ),
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.3),
                            blurRadius: 25,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Center(
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          child: _unlocking
                              ? const Icon(
                                  Icons.check,
                                  key: ValueKey('check'),
                                  color: AppColors.accent,
                                  size: 32,
                                )
                              : const Icon(
                                  Icons.fingerprint,
                                  key: ValueKey('fp'),
                                  color: AppColors.primary,
                                  size: 36,
                                ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'TOUCH TO OPEN',
                  style: TextStyle(
                    fontSize: 10,
                    color: AppColors.subtext,
                    letterSpacing: 3,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 48),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
