import 'package:flutter/material.dart';
import 'package:kototinder/app/root_screen.dart';

class KototinderApp extends StatelessWidget {
  const KototinderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kototinder',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
        scaffoldBackgroundColor: const Color(0xFFF5F5F5),
        useMaterial3: true,
      ),
      home: const RootScreen(),
    );
  }
}
