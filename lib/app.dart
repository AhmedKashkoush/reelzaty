import 'package:flutter/material.dart';
import 'package:reelzaty/config/routes/router.dart';
import 'package:reelzaty/config/themes/themes.dart';

class ReelzatyApp extends StatelessWidget {
  const ReelzatyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: AppThemes.light,
      darkTheme: AppThemes.dark,
      themeMode: ThemeMode.system,
      routerConfig: AppRouter.router,
    );
  }
}
