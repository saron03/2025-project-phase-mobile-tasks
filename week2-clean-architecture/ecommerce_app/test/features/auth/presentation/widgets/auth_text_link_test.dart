import 'package:ecommerce_app/features/auth/presentation/widgets/auth_text_link.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AuthTextLink', () {
    testWidgets('displays the text and linkText in RichText', (WidgetTester tester) async {
      const mainText = "Don't have an account? ";
      const linkText = 'Sign up';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AuthTextLink(
              text: mainText,
              linkText: linkText,
              onTap: () {},
            ),
          ),
        ),
      );

      final richTextFinder = find.byType(RichText);
      expect(richTextFinder, findsOneWidget);

      final RichText richText = tester.widget(richTextFinder);
      final TextSpan span = richText.text as TextSpan;

      expect(span.text, mainText);
      expect(span.children, isNotNull);
      expect(span.children!.length, 1);

      final TextSpan linkSpan = span.children!.first as TextSpan;
      expect(linkSpan.text, linkText);
    });

    testWidgets('calls onTap when linkText is tapped', (WidgetTester tester) async {
      bool tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AuthTextLink(
              text: 'Already have an account? ',
              linkText: 'Log in',
              onTap: () {
                tapped = true;
              },
            ),
          ),
        ),
      );

      final richTextFinder = find.byType(RichText);
      expect(richTextFinder, findsOneWidget);

      final rect = tester.getRect(richTextFinder);
      final tapPosition = Offset(rect.right - 5, rect.center.dy);

      await tester.tapAt(tapPosition);
      await tester.pump();

      expect(tapped, isTrue);
    });
  });
}
