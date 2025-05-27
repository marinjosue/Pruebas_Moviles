import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'views/home_view.dart';

void main() => runApp(const MandilonApp());

class MandilonApp extends StatelessWidget {
  const MandilonApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'El Mandilón Ventas',
      theme: AppTheme.lightTheme,
      home: const HomeView(),
      debugShowCheckedModeBanner: false,
    );
  }
}
