import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import '../services/storage_service.dart';
import '../theme/app_theme.dart';
import 'agreement_screen.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  bool _agreed = false;
  bool _entering = false;
  late AnimationController _pulseCtrl;
  late Animation<double> _pulseAnim;

  @override
  void initState() {
    super.initState();
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);
    _pulseAnim = Tween(begin: 0.97, end: 1.03).animate(
      CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseCtrl.dispose();
    super.dispose();
  }

  Future<void> _enter() async {
    if (!_agreed) {
      _showAgreementHint();
      return;
    }
    setState(() => _entering = true);
    await StorageService.setLoggedIn(true);
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => const HomeScreen(),
        transitionDuration: const Duration(milliseconds: 600),
        transitionsBuilder: (_, anim, __, child) => FadeTransition(
          opacity: CurvedAnimation(parent: anim, curve: Curves.easeOut),
          child: child,
        ),
      ),
    );
  }

  void _showAgreementHint() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('请先阅读并同意用户协议和隐私政策',
            style: TextStyle(fontSize: 13)),
        backgroundColor: const Color(0xFF2D3436),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 24),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _openAgreement(bool isPrivacy) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => AgreementScreen(isPrivacy: isPrivacy),
        transitionsBuilder: (_, anim, __, child) => SlideTransition(
          position: Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero)
              .animate(CurvedAnimation(parent: anim, curve: Curves.easeOutCubic)),
          child: child,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Stack(
        children: [
          // 背景光晕
          Positioned(
            top: -120, left: -80,
            child: Container(
              width: 360, height: 360,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(colors: [
                  AppColors.primary.withValues(alpha: 0.2),
                  Colors.transparent,
                ]),
              ),
            ),
          ),
          Positioned(
            bottom: -80, right: -60,
            child: Container(
              width: 280, height: 280,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(colors: [
                  AppColors.secondary.withValues(alpha: 0.15),
                  Colors.transparent,
                ]),
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                const Spacer(flex: 2),
                // Logo 区域
                AnimatedBuilder(
                  animation: _pulseAnim,
                  builder: (_, child) => Transform.scale(
                    scale: _pulseAnim.value,
                    child: child,
                  ),
                  child: Column(
                    children: [
                      ShaderMask(
                        shaderCallback: (bounds) => const LinearGradient(
                          colors: [AppColors.primary, AppColors.accent],
                        ).createShader(bounds),
                        child: const Text(
                          '友约.',
                          style: TextStyle(
                            fontSize: 64,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            letterSpacing: -2,
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        '越过边界，遇见同类',
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.subtext,
                          letterSpacing: 2,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(flex: 2),
                // 卡片区域
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.8),
                      borderRadius: BorderRadius.circular(28),
                      border: Border.all(color: Colors.white.withValues(alpha: 0.6)),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          blurRadius: 30, offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('进入夜次元',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold,
                                color: AppColors.textColor)),
                        const SizedBox(height: 4),
                        const Text('本社区仅限 18 周岁以上成年人使用',
                            style: TextStyle(fontSize: 12, color: AppColors.subtext)),
                        const SizedBox(height: 20),
                        // 协议勾选
                        GestureDetector(
                          onTap: () => setState(() => _agreed = !_agreed),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                width: 20, height: 20,
                                decoration: BoxDecoration(
                                  color: _agreed ? AppColors.primary : Colors.transparent,
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(
                                    color: _agreed ? AppColors.primary : AppColors.subtext,
                                    width: 1.5,
                                  ),
                                ),
                                child: _agreed
                                    ? const Icon(Icons.check, color: Colors.white, size: 13)
                                    : null,
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: RichText(
                                  text: TextSpan(
                                    style: const TextStyle(
                                        fontSize: 12, color: AppColors.subtext, height: 1.5),
                                    children: [
                                      const TextSpan(text: '我已年满 18 周岁，已阅读并同意 '),
                                      TextSpan(
                                        text: '《用户协议》',
                                        style: const TextStyle(
                                            color: AppColors.primary,
                                            fontWeight: FontWeight.bold),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () => _openAgreement(false),
                                      ),
                                      const TextSpan(text: ' 和 '),
                                      TextSpan(
                                        text: '《隐私政策》',
                                        style: const TextStyle(
                                            color: AppColors.primary,
                                            fontWeight: FontWeight.bold),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () => _openAgreement(true),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        // 进入按钮
                        GestureDetector(
                          onTap: _entering ? null : _enter,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            height: 52,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: _agreed
                                    ? [AppColors.primary, AppColors.accent]
                                    : [
                                        AppColors.subtext.withValues(alpha: 0.3),
                                        AppColors.subtext.withValues(alpha: 0.3),
                                      ],
                              ),
                              borderRadius: BorderRadius.circular(26),
                              boxShadow: _agreed
                                  ? [
                                      BoxShadow(
                                        color: AppColors.primary.withValues(alpha: 0.35),
                                        blurRadius: 16, offset: const Offset(0, 6),
                                      )
                                    ]
                                  : [],
                            ),
                            child: Center(
                              child: _entering
                                  ? const SizedBox(
                                      width: 22, height: 22,
                                      child: CircularProgressIndicator(
                                          color: Colors.white, strokeWidth: 2),
                                    )
                                  : const Text(
                                      '进入夜次元',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 1),
                                    ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const Spacer(flex: 1),
                Padding(
                  padding: const EdgeInsets.only(bottom: 24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () => _openAgreement(false),
                        child: const Text('用户协议',
                            style: TextStyle(fontSize: 11, color: AppColors.subtext)),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: Text('·', style: TextStyle(color: AppColors.subtext)),
                      ),
                      GestureDetector(
                        onTap: () => _openAgreement(true),
                        child: const Text('隐私政策',
                            style: TextStyle(fontSize: 11, color: AppColors.subtext)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
