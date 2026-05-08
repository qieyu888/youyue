import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class AgreementScreen extends StatelessWidget {
  final bool isPrivacy;
  const AgreementScreen({super.key, this.isPrivacy = false});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Column(
        children: [
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
                Expanded(
                  child: Text(
                    isPrivacy ? '隐私政策' : '用户协议',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.textColor),
                  ),
                ),
                const SizedBox(width: 32),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
              child: isPrivacy ? _buildPrivacy() : _buildTerms(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTerms() {
    return _buildContent('用户协议', [
      _Section('一、总则', '欢迎使用 友约（以下简称"本应用"）。本协议是您与 友约之间关于使用本应用服务所订立的协议。请您仔细阅读本协议，使用本应用即表示您同意本协议的全部条款。'),
      _Section('二、用户资格', '本应用仅面向年满 18 周岁的成年用户开放。未满 18 周岁的用户不得注册或使用本应用。您在使用本应用时，即表示您已满 18 周岁，并具有完全民事行为能力。'),
      _Section('三、账号注册与使用', '用户需提供真实、准确的注册信息。用户应妥善保管账号信息，不得将账号转让或出借给他人。用户对其账号下的所有行为承担全部责任。'),
      _Section('四、内容规范', '用户发布的内容须符合中华人民共和国相关法律法规。禁止发布违法、违规、侵权、骚扰、诽谤等内容。本应用有权对违规内容进行删除处理，情节严重者将封禁账号。'),
      _Section('五、知识产权', '本应用的所有内容，包括但不限于文字、图片、音频、视频、软件等，均受知识产权法律保护。用户发布的原创内容，其知识产权归用户所有，但用户授予本应用免费的、非独家的使用许可。'),
      _Section('六、免责声明', '本应用对用户发布的内容不承担任何责任。本应用不保证服务的连续性和稳定性。因不可抗力或第三方原因导致的服务中断，本应用不承担责任。'),
      _Section('七、协议修改', '本应用有权随时修改本协议。修改后的协议将在应用内公告，继续使用本应用即表示您接受修改后的协议。'),
      _Section('八、适用法律', '本协议的订立、执行和解释及争议的解决均应适用中华人民共和国法律。'),
    ]);
  }

  Widget _buildPrivacy() {
    return _buildContent('隐私政策', [
      _Section('一、信息收集', '我们收集您主动提供的信息（如昵称、头像）以及您使用本应用时产生的行为数据（如点赞、收藏记录）。我们不收集您的真实姓名、身份证号、银行卡等敏感个人信息。'),
      _Section('二、信息使用', '我们使用收集的信息为您提供个性化服务、改善产品体验、保障账号安全。我们不会将您的个人信息出售给第三方。'),
      _Section('三、信息存储', '您的数据主要存储在您的设备本地。我们采用行业标准的安全措施保护您的信息，防止未经授权的访问、披露或破坏。'),
      _Section('四、信息共享', '除以下情况外，我们不会与第三方共享您的个人信息：（1）获得您的明确同意；（2）法律法规要求；（3）保护本应用或用户的合法权益。'),
      _Section('五、Cookie 与本地存储', '本应用使用本地存储技术保存您的偏好设置和登录状态，以提供更好的使用体验。您可以通过清除应用数据来删除这些信息。'),
      _Section('六、未成年人保护', '本应用不面向未满 18 周岁的未成年人。如果我们发现未成年人使用本应用，将立即删除相关账号和数据。'),
      _Section('七、您的权利', '您有权访问、更正、删除您的个人信息。您可以通过"注销账号"功能删除您在本应用的所有数据。'),
      _Section('八、政策更新', '我们可能会不时更新本隐私政策。重大变更时，我们将在应用内显著位置通知您。'),
      _Section('九、联系我们', '如您对本隐私政策有任何疑问，请通过应用内反馈功能联系我们。'),
    ]);
  }

  Widget _buildContent(String title, List<_Section> sections) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: const TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textColor)),
        const SizedBox(height: 4),
        Text('最后更新：2025年1月1日',
            style: const TextStyle(fontSize: 11, color: AppColors.subtext)),
        const SizedBox(height: 20),
        ...sections.map((s) => Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(s.title,
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textColor)),
              const SizedBox(height: 8),
              Text(s.content,
                  style: const TextStyle(
                      fontSize: 13, color: Color(0xFF4A5568), height: 1.7)),
            ],
          ),
        )),
      ],
    );
  }
}

class _Section {
  final String title;
  final String content;
  const _Section(this.title, this.content);
}
