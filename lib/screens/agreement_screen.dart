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
      _Section('一、总则', '欢迎使用友约。本协议是您与友约之间关于使用本应用服务所订立的协议。请仔细阅读，使用本应用即表示您同意本协议全部条款。'),
      _Section('二、用户资格', '本应用仅面向年满 18 周岁的成年用户。您在使用时即确认已满 18 周岁并具有完全民事行为能力。'),
      _Section('三、账号使用', '用户应妥善保管账号，不得转让或出借。用户对账号下的所有行为承担全部责任。'),
      _Section('四、内容规范', '用户发布的内容须符合相关法律法规。禁止发布违法、侵权、骚扰等内容。违规内容将被删除，情节严重者封禁账号。\n\n在圈子中禁止发布商业广告和引流内容。'),
      _Section('五、积分与内购', '积分为虚拟道具，用于发射电波功能，每次消耗 20 积分。积分购买后不支持退款。新用户默认赠送 60 积分。'),
      _Section('六、知识产权', '用户发布的原创内容，知识产权归用户所有，但用户授予本应用免费的非独家使用许可。'),
      _Section('七、免责声明', '本应用对用户发布的内容不承担责任。因不可抗力导致的服务中断，本应用不承担责任。'),
      _Section('八、协议修改', '本应用有权随时修改本协议，修改后在应用内公告，继续使用即表示接受。'),
    ]);
  }

  Widget _buildPrivacy() {
    return _buildContent('隐私政策', [
      _Section('一、信息收集', '我们收集您主动提供的信息（昵称、头像）以及使用行为数据（点赞、收藏、加入圈子记录）。不收集真实姓名、身份证号、银行卡等敏感信息。'),
      _Section('二、本地存储', '您的点赞、收藏、圈子加入状态、积分数据均存储在您的设备本地，不上传至服务器。'),
      _Section('三、信息使用', '收集的信息用于提供个性化服务和改善产品体验。不会将您的个人信息出售给第三方。'),
      _Section('四、信息共享', '除法律要求或保护用户合法权益外，不与第三方共享您的个人信息。'),
      _Section('五、未成年人保护', '本应用不面向未满 18 周岁的未成年人。发现未成年人使用将立即删除相关账号和数据。'),
      _Section('六、您的权利', '您可以随时修改昵称和头像。通过"注销账号"功能可删除本应用中的所有本地数据。'),
      _Section('七、政策更新', '重大变更时将在应用内显著位置通知您。'),
      _Section('八、联系我们', '如有疑问，请通过"关于友约 → 联系我们"功能反馈。'),
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
