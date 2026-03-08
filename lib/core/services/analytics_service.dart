import 'package:firebase_analytics/firebase_analytics.dart';

class AnalyticsService {
  static final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  static Future<void> logRegisterSuccess() async {
    await _analytics.logEvent(name: 'register_success');
  }

  static Future<void> logLoginSuccess() async {
    await _analytics.logEvent(name: 'login_success');
  }

  static Future<void> logLoginFailed() async {
    await _analytics.logEvent(name: 'login_failed');
  }

  static Future<void> logLogout() async {
    await _analytics.logEvent(name: 'logout');
  }

  static Future<void> logOnboardingCompleted() async {
    await _analytics.logEvent(name: 'onboarding_completed');
  }

  static Future<void> logCatLiked() async {
    await _analytics.logEvent(name: 'cat_liked');
  }

  static Future<void> logBreedOpened(String breedName) async {
    await _analytics.logEvent(
      name: 'breed_opened',
      parameters: {
        'breed_name': breedName,
      },
    );
  }
}