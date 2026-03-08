import 'package:flutter/material.dart';
import 'package:kototinder/features/auth/data/auth_local_data_source.dart';

class LoginScreen extends StatefulWidget {
  final VoidCallback onLoginSuccess;
  final VoidCallback onOpenRegistration;

  const LoginScreen({
    super.key,
    required this.onLoginSuccess,
    required this.onOpenRegistration,
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authLocalDataSource = AuthLocalDataSource();

  String? errorText;
  bool isLoading = false;

  Future<void> _login() async {
    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      setState(() {
        errorText = 'Заполните все поля';
      });
      return;
    }

    setState(() {
      errorText = null;
      isLoading = true;
    });

    final success = await _authLocalDataSource.login(username, password);

    if (!mounted) return;

    setState(() {
      isLoading = false;
    });

    if (success) {
      widget.onLoginSuccess();
    } else {
      setState(() {
        errorText = 'Неверный логин или пароль';
      });
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Вход')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(
                labelText: 'Логин',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Пароль',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            if (errorText != null)
              Text(errorText!, style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: isLoading ? null : _login,
              child: isLoading
                  ? const CircularProgressIndicator()
                  : const Text('Войти'),
            ),
            TextButton(
              onPressed: widget.onOpenRegistration,
              child: const Text('Нет аккаунта? Зарегистрироваться'),
            ),
          ],
        ),
      ),
    );
  }
}
