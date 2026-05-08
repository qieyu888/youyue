import 'package:flutter/material.dart';
import '../services/storage_service.dart';
import '../theme/app_theme.dart';
import '../widgets/toast_widget.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late bool _notificationEnabled;

  @override
  void initState() {
    super.initState();
    _notificationEnabled = StorageService.getNotificationEnabled();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
              children: [
                _sectionTitle('通知设置'),
                const SizedBox(height: 8),
                _card([
                  _switchTile(
                    icon: Icons.notifications_outlined,
                    iconColor: AppColors.primary,
                    iconBg: const Color(0xFFEBF4FA),
                    label: '推送通知',
                    subtitle: '接收新电波、回信提醒',
                    value: _notificationEnabled,
                    onChanged: (v) async {
                      await StorageService.setNotificationEnabled(v);
                      setState(() => _notificationEnabled = v);
                      if (mounted) showAppToast(context, v ? '通知已开启' : '通知已关闭');
                    },
                  ),
                ]),
                const SizedBox(height: 20),
                _sectionTitle('隐私'),
                const SizedBox(height: 8),
                _card([
                  _navTile(
                    icon: Icons.block_outlined,
                    iconColor: AppColors.subtext,
                    iconBg: AppColors.bg,
                    label: '屏蔽词设置',
                    onTap: () => showAppToast(context, '功能开发中'),
                  ),
                ]),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
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
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 32, height: 32,
              decoration: BoxDecoration(
                  color: AppColors.bg, borderRadius: BorderRadius.circular(10)),
              child: const Icon(Icons.chevron_left, color: AppColors.textColor),
            ),
          ),
          const Expanded(
            child: Text('设置',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textColor)),
          ),
          const SizedBox(width: 32),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(title,
          style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: AppColors.subtext,
              letterSpacing: 1)),
    );
  }

  Widget _card(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.06),
            blurRadius: 16, offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }

  Widget _switchTile({
    required IconData icon,
    required Color iconColor,
    required Color iconBg,
    required String label,
    required String subtitle,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 36, height: 36,
            decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle),
            child: Icon(icon, color: iconColor, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textColor)),
                Text(subtitle,
                    style: const TextStyle(fontSize: 11, color: AppColors.subtext)),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: AppColors.primary,
            activeTrackColor: AppColors.primary.withValues(alpha: 0.3),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        ],
      ),
    );
  }

  Widget _navTile({
    required IconData icon,
    required Color iconColor,
    required Color iconBg,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: Colors.transparent,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 36, height: 36,
              decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle),
              child: Icon(icon, color: iconColor, size: 18),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(label,
                  style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textColor)),
            ),
            const Icon(Icons.chevron_right, size: 16, color: AppColors.subtext),
          ],
        ),
      ),
    );
  }

}
