import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'theme/app_theme.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'services/storage_service.dart';
import 'services/iap_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await StorageService.init();
  await IAPService().init();
  runApp(const YouYueApp());
}

class YouYueApp extends StatelessWidget {
  const YouYueApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '友约',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      home: StorageService.isLoggedIn()
          ? const HomeScreen()
          : const LoginScreen(),
    );
  }
}
