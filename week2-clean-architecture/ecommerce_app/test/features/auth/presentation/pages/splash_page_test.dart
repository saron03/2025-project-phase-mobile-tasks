import 'package:ecommerce_app/features/auth/presentation/pages/splash_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

void main() {
  testWidgets('SplashScreen UI and navigation test', (WidgetTester tester) async {
    // Create a GoRouter with a mock route for /sign-in
    final router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const SplashScreen(),
        ),
        GoRoute(
          path: '/sign-in',
          builder: (context, state) => const Scaffold(body: Text('Sign In Page')),
        ),
      ],
    );

    // Build the app with the router
    await tester.pumpWidget(MaterialApp.router(
      routerConfig: router,
    ));

    // Verify background image is present (by type)
    expect(find.byType(Image), findsOneWidget);

    // Verify "ECOM" and "ECOMMERCE APP" texts appear
    expect(find.text('ECOM'), findsOneWidget);
    expect(find.text('ECOMMERCE APP'), findsOneWidget);

    // Verify CircularProgressIndicator is visible
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // Let the animation and delay run (2 seconds)
    await tester.pump(const Duration(seconds: 2));

    // Wait for navigation to happen and UI to rebuild
    await tester.pumpAndSettle();

    // Verify navigation to '/sign-in' occurred by checking for sign-in text
    expect(find.text('Sign In Page'), findsOneWidget);
  });
}
