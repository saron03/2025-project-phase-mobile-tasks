import 'package:ecommerce_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:ecommerce_app/features/auth/presentation/bloc/auth_event.dart' show AuthEvent, LogoutEvent;
import 'package:ecommerce_app/features/auth/presentation/bloc/auth_state.dart' show AuthState, AuthInitial;
import 'package:ecommerce_app/features/auth/presentation/pages/sign_up_page.dart' show SignUpPage;
import 'package:ecommerce_app/features/auth/presentation/widgets/auth_text_link.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';

// Mock classes
class MockAuthBloc extends Mock implements AuthBloc {}
class FakeAuthEvent extends Fake implements AuthEvent {}
class FakeAuthState extends Fake implements AuthState {}

void main() {
  late MockAuthBloc mockAuthBloc;

  setUpAll(() {
    registerFallbackValue(FakeAuthEvent());
    registerFallbackValue(FakeAuthState());
  });

  setUp(() {
    mockAuthBloc = MockAuthBloc();
    when(() => mockAuthBloc.stream).thenAnswer((_) => Stream.value(AuthInitial()));
    when(() => mockAuthBloc.state).thenReturn(AuthInitial());
  });

  Widget createWidgetUnderTest() {
    final router = GoRouter(
      initialLocation: '/sign-up',
      routes: [
        GoRoute(
          path: '/sign-in',
          builder: (_, __) {
            debugPrint('Navigated to /sign-in route');
            return const Scaffold(body: Center(child: Text('Sign In Page')));
          },
        ),
        GoRoute(
          path: '/sign-up',
          builder: (_, __) => BlocProvider<AuthBloc>.value(
            value: mockAuthBloc,
            child: const SignUpPage(),
          ),
        ),
      ],
    );

    return MaterialApp.router(
      routerConfig: router,
    );
  }

  testWidgets('Shows Create your account text', (tester) async {
    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pumpAndSettle();

    expect(find.text('Create your account'), findsOneWidget, reason: 'SignUpPage should display "Create your account"');
  });

  // Helper to extract text from TextSpan
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

  testWidgets('Clicking SIGN IN navigates to sign-in page', (tester) async {
    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pumpAndSettle();

    // Verify AuthTextLink is present
    final authTextLinkFinder = find.byType(AuthTextLink);
    expect(authTextLinkFinder, findsOneWidget, reason: 'AuthTextLink should be present on SignUpPage');

    // Debug: Check for "SIGN IN" text within RichText
    final richTextFinder = find.byType(RichText);
    expect(richTextFinder, findsWidgets, reason: 'RichText widgets should be present');
    final richTextWidget = tester.widget<RichText>(richTextFinder.last);
    final textSpan = richTextWidget.text as TextSpan;
    final fullText = extractTextFromTextSpan(textSpan);
    debugPrint('RichText content: $fullText');

    // Scroll to make AuthTextLink visible
    await tester.scrollUntilVisible(
      authTextLinkFinder,
      100,
      scrollable: find.byType(Scrollable).first,
    );

    // Debug: Verify the tap is attempted
    debugPrint('Tapping AuthTextLink');
    await tester.tap(authTextLinkFinder);
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pumpAndSettle();

    // Check for Sign In Page text
    expect(find.text('Sign In Page'), findsOneWidget, reason: 'Should navigate to /sign-in and show Sign In Page text');
  });

  testWidgets('Clicking back arrow triggers logout and navigates to sign-in', (tester) async {
    when(() => mockAuthBloc.add(any())).thenReturn(null);

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.arrow_back_ios));
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pumpAndSettle();

    verify(() => mockAuthBloc.add(any(that: isA<LogoutEvent>()))).called(1);
    expect(find.text('Sign In Page'), findsOneWidget, reason: 'Back arrow should trigger logout and navigate to sign-in');
  });
}