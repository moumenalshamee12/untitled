import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:untitled/features/auth/presntaoin/pages/signup_view.dart';
import 'package:untitled/features/splash-view.dart';

void main() {
  testWidgets(
    'splash view navigates to registration after the animation finishes',
    (WidgetTester tester) async {
      await tester.pumpWidget(const GetMaterialApp(home: splashView()));

      expect(find.byType(splashView), findsOneWidget);

      await tester.pump(const Duration(seconds: 2));
      await tester.pumpAndSettle();

      expect(find.byType(SignupView), findsOneWidget);
    },
  );
}
