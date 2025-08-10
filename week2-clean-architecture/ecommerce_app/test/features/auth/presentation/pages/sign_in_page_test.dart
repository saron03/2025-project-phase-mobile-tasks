import 'package:ecommerce_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:ecommerce_app/features/auth/presentation/bloc/auth_event.dart' show AuthEvent, LoginEvent;
import 'package:ecommerce_app/features/auth/presentation/bloc/auth_state.dart' show AuthState, AuthInitial;
import 'package:ecommerce_app/features/auth/presentation/pages/sign_in_page.dart' show SignInPage;
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
      initialLocation: '/sign-in',
      routes: [
        GoRoute(
          path: '/sign-in',
          builder: (_, __) => BlocProvider<AuthBloc>.value(
            value: mockAuthBloc,
            child: SignInPage(),
          ),
        ),
        GoRoute(
          path: '/sign-up',
          builder: (_, __) {
            debugPrint('Navigated to /sign-up route');
            return const Scaffold(body: Center(child: Text('Sign Up Page')));
          },
        ),
        GoRoute(
          path: '/home',
          builder: (_, __) => const Scaffold(body: Center(child: Text('Home Page'))),
        ),
      ],
    );

    return MaterialApp.router(
      routerConfig: router,
    );
  }

  testWidgets('Shows Sign into your account text', (tester) async {
    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pumpAndSettle();

    expect(find.text('Sign into your account'), findsOneWidget, reason: 'SignInPage should display "Sign into your account"');
  });

  // Helper to extract text from TextSpan
  String _extractTextFromTextSpan(TextSpan span) {
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

  testWidgets('Clicking SIGN UP navigates to sign-up page', (tester) async {
    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pumpAndSettle();

    // Verify AuthTextLink is present
    final authTextLinkFinder = find.byType(AuthTextLink);
    expect(authTextLinkFinder, findsOneWidget, reason: 'AuthTextLink should be present on SignInPage');

    // Debug: Check for "SIGN UP" text within RichText
    final richTextFinder = find.byType(RichText);
    expect(richTextFinder, findsWidgets, reason: 'RichText widgets should be present');
    final richTextWidget = tester.widget<RichText>(richTextFinder.last);
    final textSpan = richTextWidget.text as TextSpan;
    final fullText = _extractTextFromTextSpan(textSpan);
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

    // Check for Sign Up Page text
    expect(find.text('Sign Up Page'), findsOneWidget, reason: 'Should navigate to /sign-up and show Sign Up Page text');
  });

  testWidgets('Clicking SIGN IN button triggers LoginEvent', (tester) async {
    when(() => mockAuthBloc.add(any())).thenReturn(null);

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pumpAndSettle();

    // Enter email and password
    await tester.enterText(find.byType(TextField).at(0), 'test@example.com');
    await tester.enterText(find.byType(TextField).at(1), 'password123');
    await tester.pumpAndSettle();

    // Tap the SIGN IN button
    final signInButtonFinder = find.text('SIGN IN');
    expect(signInButtonFinder, findsOneWidget, reason: 'SIGN IN button should be present');
    await tester.tap(signInButtonFinder);
    await tester.pumpAndSettle();

    // Verify LoginEvent was triggered with correct parameters
    verify(() => mockAuthBloc.add(
          any(
            that: isA<LoginEvent>()
                .having((e) => e.email, 'email', 'test@example.com')
                .having((e) => e.password, 'password', 'password123'),
          ),
        )).called(1);
  });
}