import 'package:ecommerce_app/features/auth/presentation/widgets/auth_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AuthButton', () {
    testWidgets('displays text when not loading', (WidgetTester tester) async {
      bool pressed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AuthButton(
              text: 'Sign In',
              isLoading: false,
              onPressed: () {
                pressed = true;
              },
            ),
          ),
        ),
      );

      // Check that the text is shown
      expect(find.text('Sign In'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsNothing);

      // Tap the button
      await tester.tap(find.byType(ElevatedButton));
      await tester.pump(); // No need for pumpAndSettle here either

      // Verify callback was called
      expect(pressed, isTrue);
    });

    testWidgets('displays loading indicator when isLoading is true', (WidgetTester tester) async {
      bool pressed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AuthButton(
              text: 'Sign In',
              isLoading: true,
              onPressed: () {
                pressed = true;
              },
            ),
          ),
        ),
      );

      // Pump once to render — no pumpAndSettle (spinner never stops)
      await tester.pump();

      // Check that the progress indicator is shown instead of text
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Sign In'), findsNothing);

      // Try tapping the button (should be disabled)
      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      // Callback should NOT have been called
      expect(pressed, isFalse);
    });
  });
}
