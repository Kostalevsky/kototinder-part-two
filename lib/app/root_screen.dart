import 'package:flutter/material.dart';
import 'package:kototinder/features/auth/data/auth_local_data_source.dart';
import 'package:kototinder/features/auth/presentation/screens/login_screen.dart';
import 'package:kototinder/features/auth/presentation/screens/register_screen.dart';
import 'package:kototinder/features/home/presentation/screens/main_navigation_screen.dart';
import 'package:kototinder/features/onboarding/data/onboarding_local_data_source.dart';
import 'package:kototinder/features/onboarding/presentation/screens/onboarding_screen.dart';

enum AppLaunchState { loading, onboarding, login, register, home }

class RootScreen extends StatefulWidget {
  const RootScreen({super.key});

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  final _onboardingLocalDataSource = OnboardingLocalDataSource();
  final _authLocalDataSource = AuthLocalDataSource();

  AppLaunchState _state = AppLaunchState.loading;

  @override
  void initState() {
    super.initState();
    _resolveStartScreen();
  }

  Future<void> _resolveStartScreen() async {
    final onboardingCompleted = await _onboardingLocalDataSource.isCompleted();

    if (!onboardingCompleted) {
      setState(() {
        _state = AppLaunchState.onboarding;
      });
      return;
    }

    final isLoggedIn = await _authLocalDataSource.isLoggedIn();

    if (isLoggedIn) {
      setState(() {
        _state = AppLaunchState.home;
      });
      return;
    }

    setState(() {
      _state = AppLaunchState.login;
    });
  }

  void _goToLogin() {
    setState(() {
      _state = AppLaunchState.login;
    });
  }

  void _goToRegister() {
    setState(() {
      _state = AppLaunchState.register;
    });
  }

  void _goToHome() {
    setState(() {
      _state = AppLaunchState.home;
    });
  }

  @override
  Widget build(BuildContext context) {
    switch (_state) {
      case AppLaunchState.loading:
        return const Scaffold(body: Center(child: CircularProgressIndicator()));

      case AppLaunchState.onboarding:
        return OnboardingScreen(onCompleted: _goToLogin);

      case AppLaunchState.login:
        return LoginScreen(
          onLoginSuccess: _goToHome,
          onOpenRegistration: _goToRegister,
        );

      case AppLaunchState.register:
        return RegisterScreen(onRegisterSuccess: _goToHome);

      case AppLaunchState.home:
        return MainNavigationScreen(onLogout: _goToLogin);
    }
  }
}
