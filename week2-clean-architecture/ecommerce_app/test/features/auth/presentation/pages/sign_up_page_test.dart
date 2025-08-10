import 'package:bloc_test/bloc_test.dart';
import 'package:ecommerce_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:ecommerce_app/features/auth/presentation/bloc/auth_event.dart';
import 'package:ecommerce_app/features/auth/presentation/bloc/auth_state.dart';
import 'package:ecommerce_app/features/auth/presentation/pages/sign_up_page.dart';
import 'package:ecommerce_app/features/auth/presentation/widgets/auth_text_link.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:go_router/go_router.dart';

// Mock classes for AuthBloc
class MockAuthBloc extends Mock implements AuthBloc {}

void main() {
  late MockAuthBloc mockAuthBloc;

  // Helper to extract full text from TextSpan recursively
  String extractTextFromTextSpan(TextSpan span) {
    final buffer = StringBuffer();
    void extract(TextSpan s) {
      if (s.text != null) buffer.write(s.text);
      if (s.children != null) {
        for (final child in s.children!) {
          if (child is TextSpan) extract(child);
        }
      }
    }

    extract(span);
    return buffer.toString();
  }

  // Widget wrapper to provide bloc and routing (adjust if needed)
  Widget createWidgetUnderTest() {
    final router = GoRouter(
      routes: [
        GoRoute(
          path: '/sign-in',
          builder: (_, __) =>
              const Scaffold(body: Center(child: Text('Sign In Page'))),
        ),
        GoRoute(path: '/sign-up', builder: (_, __) => const SignUpPage()),
      ],
    );

    return BlocProvider<AuthBloc>.value(
      value: mockAuthBloc,
      child: MaterialApp.router(
        routerConfig: router,
      ),
    );
  }

  setUp(() {
    mockAuthBloc = MockAuthBloc();
    when(() => mockAuthBloc.state).thenReturn(AuthInitial());
    whenListen(mockAuthBloc, const Stream<AuthState>.empty());
  });

  testWidgets('SignUpPage renders correctly and elements exist', (
    tester,
  ) async {
    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pumpAndSettle();

    // Check main header text
    expect(find.text('Create your account'), findsOneWidget);

    // Check the terms & policy RichText by extracting TextSpan content
    final termsFinder = find.byWidgetPredicate((widget) {
      if (widget is RichText) {
        final textSpan = widget.text;
        if (textSpan is TextSpan) {
          final combinedText = extractTextFromTextSpan(textSpan);
          return combinedText.contains('terms & policy');
        }
      }
      return false;
    });
    expect(termsFinder, findsOneWidget);

    // Check presence of AuthTextLink (for SIGN IN)
    expect(find.byType(AuthTextLink), findsOneWidget);
  });

  testWidgets('Clicking SIGN IN navigates to sign-in page', (tester) async {
    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pumpAndSettle();

    final signInLinkFinder = find.byType(AuthTextLink);
    expect(signInLinkFinder, findsOneWidget);

    await tester.tap(signInLinkFinder);
    await tester.pumpAndSettle();

    // After tap, we expect to navigate to /sign-in which shows "Sign In Page" text
    expect(find.text('Sign In Page'), findsOneWidget);
  });

  testWidgets('Clicking logout icon triggers logout event and navigates', (
    tester,
  ) async {
    when(() => mockAuthBloc.add(any())).thenReturn(null);

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pumpAndSettle();

    final logoutIconFinder = find.byIcon(Icons.arrow_back_ios);
    expect(logoutIconFinder, findsOneWidget);

    await tester.tap(logoutIconFinder);
    await tester.pumpAndSettle();

    // Verify logout event was added to bloc
    verify(() => mockAuthBloc.add(any(that: isA<LogoutEvent>()))).called(1);

    // We also expect navigation to sign-in page
    expect(find.text('Sign In Page'), findsOneWidget);
  });
}
