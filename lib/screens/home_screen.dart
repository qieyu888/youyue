import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_theme.dart';
import 'tabs/feed_tab.dart';
import 'tabs/dungeon_tab.dart';
import 'tabs/radio_tab.dart';
import 'tabs/profile_tab.dart';
import 'send_radio_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  late AnimationController _tabAnimController;
  late Animation<double> _tabFadeAnim;

  final List<Widget> _tabs = const [
    FeedTab(),
    DungeonTab(),
    RadioTab(),
    ProfileTab(),
  ];

  @override
  void initState() {
    super.initState();
    _tabAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _tabFadeAnim = CurvedAnimation(
      parent: _tabAnimController,
      curve: Curves.easeOut,
    );
    _tabAnimController.forward();
  }

  @override
  void dispose() {
    _tabAnimController.dispose();
    super.dispose();
  }

  void _switchTab(int index) {
    if (index == _currentIndex) return;
    _tabAnimController.forward(from: 0);
    setState(() => _currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Stack(
        children: [
          // Background glows
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
                    AppColors.primary.withValues(alpha: 0.15),
                    Colors.transparent,
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
                    AppColors.accent.withValues(alpha: 0.12),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          // Main content
          Column(
            children: [
              _buildHeader(),
              Expanded(
                child: FadeTransition(
                  opacity: _tabFadeAnim,
                  child: _tabs[_currentIndex],
                ),
              ),
            ],
          ),
          // Floating nav bar
          Positioned(
            bottom: MediaQuery.of(context).padding.bottom + 16,
            left: 0,
            right: 0,
            child: Center(child: _buildNavBar()),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 8,
        left: 20,
        right: 20,
        bottom: 12,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.75),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
          ),
        ],
      ),
      child: ShaderMask(
        shaderCallback: (bounds) => const LinearGradient(
          colors: [AppColors.primary, AppColors.accent],
        ).createShader(bounds),
        child: const Text(
          '友约.',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w900,
            color: Colors.white,
            letterSpacing: -0.5,
          ),
        ),
      ),
    );
  }

  Widget _buildNavBar() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.85,
      height: 64,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: Colors.white.withValues(alpha: 0.6)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 30,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _navItem(0, Icons.layers_outlined, Icons.layers),
          _navItem(1, Icons.explore_outlined, Icons.explore),
          _centerBtn(),
          _navItem(2, Icons.send_outlined, Icons.send),
          _navItem(3, Icons.person_outline, Icons.person),
        ],
      ),
    );
  }

  Widget _navItem(int index, IconData icon, IconData activeIcon) {
    final isActive = _currentIndex == index;
    return GestureDetector(
      onTap: () => _switchTab(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: isActive ? AppColors.primary.withValues(alpha: 0.1) : Colors.transparent,
          shape: BoxShape.circle,
        ),
        child: Icon(
          isActive ? activeIcon : icon,
          color: isActive ? AppColors.primary : AppColors.subtext.withValues(alpha: 0.5),
          size: 22,
        ),
      ),
    );
  }

  Widget _centerBtn() {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => const SendRadioScreen(),
          transitionsBuilder: (_, anim, __, child) => SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 1),
              end: Offset.zero,
            ).animate(
                CurvedAnimation(parent: anim, curve: Curves.easeOutCubic)),
            child: child,
          ),
        ),
      ),
      child: Transform.translate(
        offset: const Offset(0, -16),
        child: Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AppColors.primary, AppColors.accent],
            ),
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.bg, width: 3),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.35),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const Icon(Icons.add, color: Colors.white, size: 26),
        ),
      ),
    );
  }
}
