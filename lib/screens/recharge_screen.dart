import 'package:flutter/material.dart';
import '../services/iap_service.dart';
import '../services/storage_service.dart';
import '../theme/app_theme.dart';
import '../widgets/toast_widget.dart';

class RechargeScreen extends StatefulWidget {
  const RechargeScreen({super.key});

  @override
  State<RechargeScreen> createState() => _RechargeScreenState();
}

class _RechargeScreenState extends State<RechargeScreen> {
  int _selectedIndex = 1;
  bool _loading = false;
  late int _currentPoints;

  @override
  void initState() {
    super.initState();
    _currentPoints = StorageService.getPoints();

    final iap = IAPService();

    // 产品加载完成后刷新价格显示
    iap.onProductsLoaded = () {
      if (mounted) setState(() {});
    };

    iap.onPurchaseSuccess = (points) {
      if (!mounted) return;
      setState(() {
        _currentPoints = StorageService.getPoints();
        _loading = false;
      });
      showAppToast(context, '充值成功！获得 $points 积分');
    };

    iap.onPurchaseError = (msg) {
      if (!mounted) return;
      setState(() => _loading = false);
      showAppToast(context, msg);
    };

    // 如果产品还没加载，触发一次加载
    if (!iap.productsLoaded) {
      iap.init();
    }
  }

  @override
  void dispose() {
    // 离开页面清除回调，避免内存泄漏
    final iap = IAPService();
    iap.onProductsLoaded = null;
    iap.onPurchaseSuccess = null;
    iap.onPurchaseError = null;
    super.dispose();
  }

  Future<void> _purchase() async {
    if (_loading) return;
    setState(() => _loading = true);
    final config = IAPService.kConfigs[_selectedIndex];
    await IAPService().buy(config.id);
    // 成功/失败由回调处理，超时兜底
    Future.delayed(const Duration(seconds: 30), () {
      if (mounted && _loading) setState(() => _loading = false);
    });
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
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
              children: [
                _buildPointsCard(),
                const SizedBox(height: 24),
                const Text('选择充值套餐',
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: AppColors.subtext,
                        letterSpacing: 0.5)),
                const SizedBox(height: 12),
                ...List.generate(IAPService.kConfigs.length, _buildProductTile),
                const SizedBox(height: 24),
                _buildPurchaseBtn(),
                const SizedBox(height: 20),
                _buildUsageInfo(),
                const SizedBox(height: 16),
                const Text(
                  '* 积分为虚拟道具，购买后不支持退款\n* 积分仅用于发射电波功能\n* 如有问题请通过关于页面联系我们',
                  style: TextStyle(fontSize: 11, color: AppColors.subtext, height: 1.8),
                  textAlign: TextAlign.center,
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
            child: Text('积分充值',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.textColor)),
          ),
          const SizedBox(width: 32),
        ],
      ),
    );
  }

  Widget _buildPointsCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primary, AppColors.accent],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.3),
            blurRadius: 20, offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.bolt, color: Colors.white, size: 36),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('当前积分',
                  style: TextStyle(color: Colors.white70, fontSize: 12)),
              const SizedBox(height: 4),
              Text('$_currentPoints',
                  style: const TextStyle(
                      color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
            ],
          ),
          const Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text('每次发射',
                  style: TextStyle(color: Colors.white70, fontSize: 11)),
              const SizedBox(height: 4),
              Text('消耗 ${StorageService.kCostPerRadio} 积分',
                  style: const TextStyle(
                      color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text('还可发射 ${(_currentPoints / StorageService.kCostPerRadio).floor()} 次',
                  style: const TextStyle(color: Colors.white70, fontSize: 11)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProductTile(int index) {
    final config = IAPService.kConfigs[index];
    final isSelected = _selectedIndex == index;
    // 价格从 Store 获取，未加载时显示 fallback
    final priceStr = IAPService().priceFor(config.id);

    return GestureDetector(
      onTap: () => setState(() => _selectedIndex = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary.withValues(alpha: 0.06) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.divider,
            width: isSelected ? 1.5 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: isSelected ? 0.1 : 0.04),
              blurRadius: 12, offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 22, height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? AppColors.primary : Colors.transparent,
                border: Border.all(
                  color: isSelected
                      ? AppColors.primary
                      : AppColors.subtext.withValues(alpha: 0.4),
                  width: 1.5,
                ),
              ),
              child: isSelected
                  ? const Icon(Icons.check, color: Colors.white, size: 13)
                  : null,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(config.label,
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: isSelected ? AppColors.primary : AppColors.textColor)),
                      if (config.isPopular) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.secondary.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text('推荐',
                              style: TextStyle(
                                  fontSize: 10,
                                  color: AppColors.secondary,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text('可发射 ${config.points ~/ StorageService.kCostPerRadio} 次电波',
                      style: const TextStyle(fontSize: 11, color: AppColors.subtext)),
                ],
              ),
            ),
            // 价格从 Store 返回，加载中显示小菊花
            IAPService().productsLoaded
                ? Text(priceStr,
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isSelected ? AppColors.primary : AppColors.textColor))
                : const SizedBox(
                    width: 18, height: 18,
                    child: CircularProgressIndicator(
                        strokeWidth: 1.5, color: AppColors.subtext)),
          ],
        ),
      ),
    );
  }

  Widget _buildPurchaseBtn() {
    final config = IAPService.kConfigs[_selectedIndex];
    final priceStr = IAPService().priceFor(config.id);

    return GestureDetector(
      onTap: _loading ? null : _purchase,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 54,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: _loading
                ? [AppColors.subtext, AppColors.subtext]
                : [AppColors.primary, AppColors.accent],
          ),
          borderRadius: BorderRadius.circular(27),
          boxShadow: _loading
              ? []
              : [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.35),
                    blurRadius: 16, offset: const Offset(0, 6),
                  ),
                ],
        ),
        child: Center(
          child: _loading
              ? const SizedBox(
                  width: 22, height: 22,
                  child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
              : Text(
                  '立即充值 $priceStr',
                  style: const TextStyle(
                      color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                ),
        ),
      ),
    );
  }

  Widget _buildUsageInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.1)),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline, size: 16, color: AppColors.primary),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              '积分用于发射电波。新用户默认赠送 ${StorageService.kDefaultPoints} 积分，每次发射消耗 ${StorageService.kCostPerRadio} 积分。',
              style: const TextStyle(fontSize: 12, color: AppColors.subtext, height: 1.5),
            ),
          ),
        ],
      ),
    );
  }
}
