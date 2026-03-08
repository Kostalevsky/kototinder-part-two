import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kototinder/features/auth/presentation/screens/login_screen.dart';

void main() {
  testWidgets('Экран авторизации показывает поля и ошибку при пустом вводе',
      (WidgetTester tester) async {
    var loginSuccess = false;
    var openRegister = false;

    await tester.pumpWidget(
      MaterialApp(
        home: LoginScreen(
          onLoginSuccess: () {
            loginSuccess = true;
          },
          onOpenRegistration: () {
            openRegister = true;
          },
        ),
      ),
    );

    expect(find.text('Вход'), findsOneWidget);
    expect(find.text('Логин'), findsOneWidget);
    expect(find.text('Пароль'), findsOneWidget);
    expect(find.text('Войти'), findsOneWidget);
    expect(find.textContaining('Зарегистр'), findsOneWidget);

    await tester.tap(find.text('Войти'));
    await tester.pump();

    expect(find.textContaining('Заполни'), findsOneWidget);
    expect(loginSuccess, false);
    expect(openRegister, false);
  });

  testWidgets('Экран авторизации открывает регистрацию',
      (WidgetTester tester) async {
    var openRegister = false;

    await tester.pumpWidget(
      MaterialApp(
        home: LoginScreen(
          onLoginSuccess: () {},
          onOpenRegistration: () {
            openRegister = true;
          },
        ),
      ),
    );

    await tester.tap(find.textContaining('Зарегистр'));
    await tester.pump();

    expect(openRegister, true);
  });
}