import 'dart:math';
import 'package:flutter/material.dart';
import '../../models/radio_model.dart';
import '../../services/storage_service.dart';
import '../../theme/app_theme.dart';
import '../send_radio_screen.dart';

class RadioTab extends StatefulWidget {
  const RadioTab({super.key});

  @override
  State<RadioTab> createState() => _RadioTabState();
}

class _RadioTabState extends State<RadioTab>
    with SingleTickerProviderStateMixin {
  late AnimationController _radarController;
  late List<RadioMessage> _messages;

  @override
  void initState() {
    super.initState();
    _radarController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();
    _loadMessages();
  }

  void _loadMessages() {
    final sent = StorageService.getSentRadios();
    final sentMsgs = sent.map((m) => RadioMessage(
      id: m['id']!,
      sender: m['sender']!,
      content: m['content']!,
      time: m['time']!,
      isReplied: m['isReplied'] == 'true',
    )).toList();
    _messages = [...sentMsgs, ...kRadioMessages];
  }

  @override
  void dispose() {
    _radarController.dispose();
    super.dispose();
  }

  Future<void> _openSendScreen() async {
    await Navigator.push(context, _bottomRoute(SendRadioScreen(
      onSent: (content) async {
        await StorageService.addSentRadio(content, '刚刚');
        if (mounted) setState(() => _loadMessages());
      },
    )));
  }

  void _replyToMessage(RadioMessage msg) async {
    await Navigator.push(context, _bottomRoute(SendRadioScreen(
      replyTo: msg.sender,
      onSent: (content) async {
        await StorageService.addSentRadio('回复 ${msg.sender}：$content', '刚刚');
        if (mounted) {
          setState(() {
            final idx = _messages.indexWhere((m) => m.id == msg.id);
            if (idx != -1) {
              _messages[idx] = RadioMessage(
                id: msg.id,
                sender: msg.sender,
                content: msg.content,
                time: msg.time,
                isReplied: true,
              );
            }
          });
        }
      },
    )));
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom + 96;
    return ListView(
      padding: EdgeInsets.fromLTRB(16, 0, 16, bottomPadding),
      children: [
        const Text('电波信箱',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textColor)),
        const SizedBox(height: 2),
        const Text('寻找同频灵魂',
            style: TextStyle(fontSize: 12, color: AppColors.subtext)),
        const SizedBox(height: 24),
        Center(child: _buildRadar()),
        const SizedBox(height: 32),
        Row(
          children: [
            const Text('已捕获的温柔电波',
                style: TextStyle(fontSize: 10, color: AppColors.subtext,
                    letterSpacing: 2, fontWeight: FontWeight.bold)),
            const Spacer(),
            Text('共 ${_messages.length} 条',
                style: const TextStyle(fontSize: 10, color: AppColors.subtext)),
          ],
        ),
        const SizedBox(height: 12),
        ..._messages.map((msg) => _buildMessageCard(msg)),
      ],
    );
  }

  Widget _buildRadar() {
    return SizedBox(
      width: 240,
      height: 240,
      child: Stack(
        alignment: Alignment.center,
        children: [
          _ring(240, 0.08),
          _ring(192, 0.12),
          _ring(128, 0.15),
          AnimatedBuilder(
            animation: _radarController,
            builder: (_, __) => Transform.rotate(
              angle: _radarController.value * 2 * pi,
              child: Container(
                width: 240,
                height: 240,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: SweepGradient(
                    colors: [
                      Colors.transparent,
                      AppColors.primary.withValues(alpha: 0.3),
                    ],
                    stops: const [0.7, 1.0],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 40, left: 48,
            child: _floatingIcon(Icons.mail_outline, AppColors.secondary, delay: 500),
          ),
          Positioned(
            bottom: 64, right: 32,
            child: _floatingIcon(Icons.music_note, AppColors.accent, delay: 1200, size: 32),
          ),
          GestureDetector(
            onTap: _openSendScreen,
            child: Container(
              width: 80, height: 80,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.2),
                  blurRadius: 20, spreadRadius: 2,
                )],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.cell_tower, color: AppColors.primary, size: 22),
                  const SizedBox(height: 2),
                  const Text('发射', style: TextStyle(
                      fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.primary)),
                  Text('-${StorageService.kCostPerRadio}分',
                      style: const TextStyle(fontSize: 8, color: AppColors.subtext)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _ring(double size, double opacity) {
    return Container(
      width: size, height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white.withValues(alpha: opacity * 5), width: 1),
        boxShadow: [BoxShadow(
          color: AppColors.primary.withValues(alpha: opacity),
          blurRadius: 8, spreadRadius: 1,
        )],
      ),
    );
  }

  Widget _floatingIcon(IconData icon, Color color, {int delay = 0, double size = 40}) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: 1500 + delay),
      curve: Curves.easeInOut,
      builder: (_, v, child) => Transform.translate(
        offset: Offset(0, sin(v * pi) * -6),
        child: child,
      ),
      child: Container(
        width: size, height: size,
        decoration: BoxDecoration(
          color: Colors.white, shape: BoxShape.circle,
          boxShadow: [BoxShadow(color: color.withValues(alpha: 0.2), blurRadius: 10)],
        ),
        child: Icon(icon, color: color, size: size * 0.45),
      ),
    );
  }

  Widget _buildMessageCard(RadioMessage msg) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white),
        boxShadow: [BoxShadow(
          color: AppColors.primary.withValues(alpha: 0.06),
          blurRadius: 12, offset: const Offset(0, 3),
        )],
      ),
      child: Stack(
        children: [
          Positioned(
            left: 0, top: 0, bottom: 0,
            child: Container(
              width: 3,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [AppColors.secondary, AppColors.secondary.withValues(alpha: 0)],
                ),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('"${msg.content}"',
                    style: const TextStyle(fontSize: 13, color: AppColors.textColor, height: 1.6),
                    maxLines: 3, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('来自: ${msg.sender}',
                            style: const TextStyle(fontSize: 11, color: AppColors.subtext)),
                        Text(msg.time,
                            style: const TextStyle(fontSize: 10, color: AppColors.subtext)),
                      ],
                    ),
                    GestureDetector(
                      onTap: msg.isReplied ? null : () => _replyToMessage(msg),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: msg.isReplied
                              ? AppColors.bg
                              : AppColors.secondary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          msg.isReplied ? '已回信 ✓' : '回信',
                          style: TextStyle(
                            fontSize: 11, fontWeight: FontWeight.bold,
                            color: msg.isReplied ? AppColors.subtext : AppColors.secondary,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Route _bottomRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (_, __, ___) => page,
      transitionsBuilder: (_, anim, __, child) => SlideTransition(
        position: Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero)
            .animate(CurvedAnimation(parent: anim, curve: Curves.easeOutCubic)),
        child: child,
      ),
    );
  }
}
