import 'package:flutter/material.dart';
import '../services/storage_service.dart';
import '../theme/app_theme.dart';
import '../widgets/avatar_widget.dart';
import '../widgets/toast_widget.dart';

class BlacklistScreen extends StatefulWidget {
  const BlacklistScreen({super.key});

  @override
  State<BlacklistScreen> createState() => _BlacklistScreenState();
}

class _BlacklistScreenState extends State<BlacklistScreen> {
  late List<Map<String, String>> _blacklist;

  @override
  void initState() {
    super.initState();
    _blacklist = StorageService.getBlacklist();
  }

  Future<void> _removeUser(String userId) async {
    await StorageService.removeFromBlacklist(userId);
    setState(() => _blacklist = StorageService.getBlacklist());
    if (mounted) showAppToast(context, '已移出黑名单');
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
                  child: Text('黑名单管理',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.textColor)),
                ),
                const SizedBox(width: 32),
              ],
            ),
          ),
          Expanded(
            child: _blacklist.isEmpty
                ? _buildEmpty()
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
                    itemCount: _blacklist.length,
                    itemBuilder: (ctx, i) => _buildItem(_blacklist[i]),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.block_outlined, size: 56,
              color: AppColors.subtext.withValues(alpha: 0.3)),
          const SizedBox(height: 12),
          const Text('黑名单为空', style: TextStyle(color: AppColors.subtext, fontSize: 14)),
          const SizedBox(height: 6),
          const Text('在帖子详情页可以举报并拉黑用户',
              style: TextStyle(color: AppColors.subtext, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildItem(Map<String, String> user) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.06),
            blurRadius: 12, offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          AvatarWidget(seed: user['seed'] ?? user['name']!, size: 40),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(user['name']!,
                    style: const TextStyle(
                        fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.textColor)),
                Text('拉黑于 ${user['time'] ?? '未知时间'}',
                    style: const TextStyle(fontSize: 11, color: AppColors.subtext)),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => _showRemoveDialog(user),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Text('移出',
                  style: TextStyle(
                      fontSize: 12, fontWeight: FontWeight.bold, color: Colors.redAccent)),
            ),
          ),
        ],
      ),
    );
  }

  void _showRemoveDialog(Map<String, String> user) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('移出黑名单', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
        content: Text('确定将 ${user['name']} 移出黑名单吗？',
            style: const TextStyle(fontSize: 13, color: AppColors.subtext)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消', style: TextStyle(color: AppColors.subtext)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _removeUser(user['id']!);
            },
            child: const Text('确定移出', style: TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
    );
  }
}
