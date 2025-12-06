import 'package:flutter/material.dart';
import 'screens/cat_screen.dart';
import 'screens/breeds_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'kototinder',
      theme: ThemeData(
        colorScheme: .fromSeed(seedColor: Colors.orange),
        scaffoldBackgroundColor: const Color(0xFFF5F5F5),
        useMaterial3: true,
      ),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _curr = 0;

  @override
  Widget build(BuildContext context) {
    final pages = <Widget>[const CatScreen(), const BreedsScreen()];

    return Scaffold(
      appBar: AppBar(title: Text(_curr == 0 ? 'Кототиндер' : 'Список пород')),
      body: IndexedStack(index: _curr, children: pages),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _curr,
        onTap: (newIndex) {
          setState(() {
            _curr = newIndex;
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
