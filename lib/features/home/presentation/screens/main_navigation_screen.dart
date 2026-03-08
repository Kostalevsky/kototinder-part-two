import 'package:flutter/material.dart';
import 'package:kototinder/features/auth/data/auth_local_data_source.dart';
import 'package:kototinder/features/breeds/presentation/screens/breeds_screen.dart';
import 'package:kototinder/features/cats/presentation/screens/cat_screen.dart';
import 'package:kototinder/core/services/analytics_service.dart';

class MainNavigationScreen extends StatefulWidget {
  final VoidCallback? onLogout;

  const MainNavigationScreen({super.key, this.onLogout});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  final _authLocalDataSource = AuthLocalDataSource();

  int _currentIndex = 0;

  late final List<Widget> _pages = [const CatScreen(), const BreedsScreen()];

  Future<void> _logout() async {
    await _authLocalDataSource.logout();
    await AnalyticsService.logLogout();
    if (!mounted) return;

    widget.onLogout?.call();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_currentIndex == 0 ? 'Кототиндер' : 'Список пород'),
        actions: [
          IconButton(
            onPressed: _logout,
            icon: const Icon(Icons.logout),
            tooltip: 'Выйти',
          ),
        ],
      ),
      body: IndexedStack(index: _currentIndex, children: _pages),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (newIndex) {
          setState(() {
            _currentIndex = newIndex;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.pets), label: 'Котики'),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Породы'),
        ],
      ),
    );
  }
}
