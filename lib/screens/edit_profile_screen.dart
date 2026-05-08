import 'package:flutter/material.dart';
import '../services/storage_service.dart';
import '../theme/app_theme.dart';
import '../widgets/avatar_widget.dart';
import '../widgets/toast_widget.dart';

class EditProfileScreen extends StatefulWidget {
  final String nickname;
  final String avatarSeed;
  final String bio;

  const EditProfileScreen({
    super.key,
    required this.nickname,
    required this.avatarSeed,
    required this.bio,
  });

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController _nicknameCtrl;
  late TextEditingController _bioCtrl;
  late String _selectedSeed;
  bool _saving = false;

  // 预设头像 seed 列表
  static const List<Map<String, String>> _avatarPresets = [
    {'seed': 'YouYue', 'label': '探险家'},
    {'seed': 'NekoMimi', 'label': '猫耳'},
    {'seed': 'Kira', 'label': '星光'},
    {'seed': 'Pixel', 'label': '像素'},
    {'seed': 'Cyber', 'label': '赛博'},
    {'seed': 'Nadeko', 'label': '抚子'},
    {'seed': 'Miku', 'label': '初音'},
    {'seed': 'Elf', 'label': '精灵'},
    {'seed': 'Night', 'label': '夜猫'},
    {'seed': 'Star', 'label': '星空'},
    {'seed': 'Camera', 'label': '胶片'},
    {'seed': 'Anime', 'label': '动漫'},
    {'seed': 'Gal', 'label': 'Gal'},
    {'seed': 'Holo', 'label': 'Vtuber'},
    {'seed': 'Island', 'label': '岛主'},
    {'seed': 'RPG', 'label': 'RPG'},
  ];

  @override
  void initState() {
    super.initState();
    _nicknameCtrl = TextEditingController(text: widget.nickname);
    _bioCtrl = TextEditingController(text: widget.bio);
    _selectedSeed = widget.avatarSeed;
  }

  @override
  void dispose() {
    _nicknameCtrl.dispose();
    _bioCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final name = _nicknameCtrl.text.trim();
    if (name.isEmpty) {
      showAppToast(context, '昵称不能为空');
      return;
    }
    if (name.length > 20) {
      showAppToast(context, '昵称不能超过20个字符');
      return;
    }
    setState(() => _saving = true);
    await StorageService.setNickname(name);
    await StorageService.setAvatarSeed(_selectedSeed);
    await StorageService.setBio(_bioCtrl.text.trim());
    if (mounted) {
      setState(() => _saving = false);
      showAppToast(context, '保存成功');
      // 返回 true 通知上层刷新
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 40),
              children: [
                // 当前头像大图预览
                Center(
                  child: Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 3),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withValues(alpha: 0.2),
                              blurRadius: 20,
                            ),
                          ],
                        ),
                        child: AvatarWidget(seed: _selectedSeed, size: 88, borderWidth: 0),
                      ),
                      Positioned(
                        bottom: 0, right: 0,
                        child: Container(
                          width: 26, height: 26,
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                          child: const Icon(Icons.edit, color: Colors.white, size: 13),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                const Center(
                  child: Text('选择头像', style: TextStyle(fontSize: 12, color: AppColors.subtext)),
                ),
                const SizedBox(height: 16),
                // 头像选择网格
                Container(
                  padding: const EdgeInsets.all(12),
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
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 0.8,
                    ),
                    itemCount: _avatarPresets.length,
                    itemBuilder: (_, i) {
                      final preset = _avatarPresets[i];
                      final isSelected = _selectedSeed == preset['seed'];
                      return GestureDetector(
                        onTap: () => setState(() => _selectedSeed = preset['seed']!),
                        child: Column(
                          children: [
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 150),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: isSelected ? AppColors.primary : Colors.transparent,
                                  width: 2.5,
                                ),
                                boxShadow: isSelected
                                    ? [BoxShadow(
                                        color: AppColors.primary.withValues(alpha: 0.3),
                                        blurRadius: 8,
                                      )]
                                    : [],
                              ),
                              child: AvatarWidget(seed: preset['seed']!, size: 52, borderWidth: 0),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              preset['label']!,
                              style: TextStyle(
                                fontSize: 10,
                                color: isSelected ? AppColors.primary : AppColors.subtext,
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),
                // 昵称输入
                _buildInputSection(
                  label: '昵称',
                  controller: _nicknameCtrl,
                  hint: '请输入昵称',
                  maxLength: 20,
                ),
                const SizedBox(height: 12),
                // 简介输入
                _buildInputSection(
                  label: '个人简介',
                  controller: _bioCtrl,
                  hint: '介绍一下自己吧...',
                  maxLength: 50,
                  maxLines: 2,
                ),
                const SizedBox(height: 32),
                // 保存按钮
                GestureDetector(
                  onTap: _saving ? null : _save,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    height: 52,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: _saving
                            ? [AppColors.subtext, AppColors.subtext]
                            : [AppColors.primary, AppColors.accent],
                      ),
                      borderRadius: BorderRadius.circular(26),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.3),
                          blurRadius: 16, offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Center(
                      child: _saving
                          ? const SizedBox(
                              width: 20, height: 20,
                              child: CircularProgressIndicator(
                                  color: Colors.white, strokeWidth: 2),
                            )
                          : const Text(
                              '保存修改',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold),
                            ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
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
            child: Text('编辑资料',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.textColor)),
          ),
          const SizedBox(width: 32),
        ],
      ),
    );
  }

  Widget _buildInputSection({
    required String label,
    required TextEditingController controller,
    required String hint,
    required int maxLength,
    int maxLines = 1,
  }) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: const TextStyle(
                  fontSize: 11, fontWeight: FontWeight.bold,
                  color: AppColors.subtext, letterSpacing: 0.5)),
          const SizedBox(height: 8),
          TextField(
            controller: controller,
            maxLength: maxLength,
            maxLines: maxLines,
            style: const TextStyle(fontSize: 14, color: AppColors.textColor),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(color: AppColors.subtext, fontSize: 14),
              border: InputBorder.none,
              isDense: true,
              contentPadding: EdgeInsets.zero,
              counterStyle: const TextStyle(fontSize: 10, color: AppColors.subtext),
            ),
          ),
        ],
      ),
    );
  }
}
