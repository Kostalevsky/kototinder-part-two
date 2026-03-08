import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kototinder/features/onboarding/presentation/screens/onboarding_screen.dart';

void main() {
  testWidgets(
    'Онбординг показывает первую страницу и переключается на вторую',
    (WidgetTester tester) async {
      var completedCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: OnboardingScreen(
            onCompleted: () {
              completedCalled = true;
            },
          ),
        ),
      );

      expect(find.text('Свайпайте котиков'), findsOneWidget);
      expect(
        find.textContaining('Смотрите карточки с котиками'),
        findsOneWidget,
      );
      expect(find.text('Далее'), findsOneWidget);

      await tester.tap(find.text('Далее'));
      await tester.pumpAndSettle();

      expect(find.text('Лайкайте понравившихся'), findsOneWidget);
      expect(find.textContaining('Ставьте лайки котикам'), findsOneWidget);

      expect(completedCalled, false);
    },
  );
}
