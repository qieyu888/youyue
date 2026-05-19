import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'storage_service.dart';

/// 本地产品配置（积分数量）
class IAPProductConfig {
  final String id;
  final String label;
  final int points;
  final bool isPopular;

  const IAPProductConfig({
    required this.id,
    required this.label,
    required this.points,
    this.isPopular = false,
  });
}

class IAPService {
  static final IAPService _instance = IAPService._();
  factory IAPService() => _instance;
  IAPService._();

  final InAppPurchase _iap = InAppPurchase.instance;
  StreamSubscription<List<PurchaseDetails>>? _subscription;

  // 产品 ID
  static const String kProduct6  = 'com.card.score6';
  static const String kProduct18 = 'com.card.score18';
  static const String kProduct28 = 'com.card.score28';

  /// 本地配置（积分数量、标签），价格从 Store 获取
  static const List<IAPProductConfig> kConfigs = [
    IAPProductConfig(id: kProduct6,  label: '60 积分',  points: 60),
    IAPProductConfig(id: kProduct18, label: '200 积分', points: 200, isPopular: true),
    IAPProductConfig(id: kProduct28, label: '320 积分', points: 320),
  ];

  /// Store 返回的产品详情（含真实价格）
  List<ProductDetails> _storeProducts = [];
  bool _available = false;
  bool _productsLoaded = false;

  // 回调
  Function(int points)? onPurchaseSuccess;
  Function(String msg)? onPurchaseError;
  VoidCallback? onProductsLoaded;

  bool get isAvailable => _available;
  bool get productsLoaded => _productsLoaded;

  /// 根据产品 ID 获取 Store 价格字符串，未加载时返回 fallback
  String priceFor(String productId) {
    try {
      return _storeProducts.firstWhere((p) => p.id == productId).price;
    } catch (_) {
      // Store 未返回时显示 fallback
      const fallback = {
        kProduct6: '¥6',
        kProduct18: '¥18',
        kProduct28: '¥28',
      };
      return fallback[productId] ?? '--';
    }
  }

  Future<void> init() async {
    _available = await _iap.isAvailable();
    if (!_available) return;

    // 先注册购买流，再加载产品
    _subscription = _iap.purchaseStream.listen(
      _onPurchaseUpdate,
      onError: (e) => onPurchaseError?.call('购买流错误'),
    );

    await _loadProducts();
  }

  Future<void> _loadProducts() async {
    final ids = {kProduct6, kProduct18, kProduct28};
    try {
      final response = await _iap.queryProductDetails(ids);
      _storeProducts = response.productDetails;
      _productsLoaded = true;
      onProductsLoaded?.call();
    } catch (_) {
      _productsLoaded = true;
      onProductsLoaded?.call();
    }
  }

  void _onPurchaseUpdate(List<PurchaseDetails> purchases) {
    for (final purchase in purchases) {
      switch (purchase.status) {
        case PurchaseStatus.purchased:
        case PurchaseStatus.restored:
          _deliverProduct(purchase);
          if (purchase.pendingCompletePurchase) {
            _iap.completePurchase(purchase);
          }
        case PurchaseStatus.error:
          onPurchaseError?.call(purchase.error?.message ?? '购买失败，请重试');
        case PurchaseStatus.canceled:
          onPurchaseError?.call('已取消购买');
        case PurchaseStatus.pending:
          break;
      }
    }
  }

  void _deliverProduct(PurchaseDetails purchase) {
    try {
      final config = kConfigs.firstWhere((c) => c.id == purchase.productID);
      StorageService.addPoints(config.points);
      onPurchaseSuccess?.call(config.points);
    } catch (_) {
      onPurchaseError?.call('发放积分失败，请联系客服');
    }
  }

  /// 发起购买
  Future<void> buy(String productId) async {
    // Debug 模式直接发放积分
    if (kDebugMode && !_available) {
      try {
        final config = kConfigs.firstWhere((c) => c.id == productId);
        await StorageService.addPoints(config.points);
        onPurchaseSuccess?.call(config.points);
      } catch (_) {
        onPurchaseError?.call('产品未找到');
      }
      return;
    }

    if (!_available) {
      onPurchaseError?.call('内购服务不可用，请检查网络');
      return;
    }

    try {
      final storeProduct = _storeProducts.firstWhere((p) => p.id == productId);
      final param = PurchaseParam(productDetails: storeProduct);
      await _iap.buyConsumable(purchaseParam: param);
    } catch (_) {
      onPurchaseError?.call('产品信息加载失败，请稍后重试');
    }
  }

  void dispose() {
    _subscription?.cancel();
  }
}
