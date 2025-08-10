import 'package:ecommerce_app/features/auth/domain/entities/user.dart';
import 'package:ecommerce_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:ecommerce_app/features/auth/presentation/bloc/auth_event.dart';
import 'package:ecommerce_app/features/auth/presentation/bloc/auth_state.dart';
import 'package:ecommerce_app/features/auth/presentation/pages/sign_in_page.dart';
import 'package:ecommerce_app/features/auth/presentation/widgets/auth_button.dart';
import 'package:ecommerce_app/features/auth/presentation/widgets/auth_text_field.dart';
import 'package:ecommerce_app/features/auth/presentation/widgets/auth_text_link.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';

// Mock classes
class MockAuthBloc extends Mock implements AuthBloc {}
class MockGoRouter extends Mock implements GoRouter {}
class MockUser extends Mock implements User {}
class MockGoRouterDelegate extends Mock implements GoRouterDelegate {}
class MockRouteInformationParser extends Mock implements GoRouteInformationParser {}
class MockRouteInformationProvider extends Mock implements GoRouteInformationProvider {}

// Fake class for AuthEvent
class FakeAuthEvent extends Fake implements AuthEvent {}

void main() {
  late MockAuthBloc mockAuthBloc;
  late MockGoRouter mockGoRouter;
  late MockUser mockUser;
  late MockGoRouterDelegate mockRouterDelegate;
  late MockRouteInformationParser mockRouteInformationParser;
  late MockRouteInformationProvider mockRouteInformationProvider;

  setUpAll(() {
    // Register fallback value for AuthEvent
    registerFallbackValue(FakeAuthEvent());
  });

  setUp(() {
    mockAuthBloc = MockAuthBloc();
    mockGoRouter = MockGoRouter();
    mockUser = MockUser();
    mockRouterDelegate = MockGoRouterDelegate();
    mockRouteInformationParser = MockRouteInformationParser();
    mockRouteInformationProvider = MockRouteInformationProvider();

    // Mock the go method
    when(() => mockGoRouter.go(any())).thenReturn(null);
    // Mock GoRouter properties
    when(() => mockGoRouter.routerDelegate).thenReturn(mockRouterDelegate);
    when(() => mockGoRouter.routeInformationParser).thenReturn(mockRouteInformationParser);
    when(() => mockGoRouter.routeInformationProvider).thenReturn(mockRouteInformationProvider);
    // Mock RouteInformationProvider properties
    when(() => mockRouteInformationProvider.value).thenReturn(RouteInformation());
  });

  // Helper method to create the widget under test
  Widget buildTestableWidget(Widget child) {
    return MaterialApp(
      home: BlocProvider<AuthBloc>.value(
        value: mockAuthBloc,
        child: Router(
          routerDelegate: mockRouterDelegate,
          backButtonDispatcher: RootBackButtonDispatcher(),
          routeInformationParser: mockRouteInformationParser,
          routeInformationProvider: mockRouteInformationProvider,
        ),
      ),
    );
  }

  group('SignInPage Widget Tests', () {
    testWidgets('renders ECOM logo correctly', (WidgetTester tester) async {
      // Arrange
      when(() => mockAuthBloc.state).thenReturn(AuthInitial());

      // Act
      await tester.pumpWidget(buildTestableWidget(SignInPage()));
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('ECOM'), findsOneWidget);
      expect(find.byType(Material), findsWidgets);
      final material = tester.widget<Material>(find.byType(Material).first);
      expect(material.elevation, equals(4.0));
    });

    testWidgets('renders email and password fields', (WidgetTester tester) async {
      // Arrange
      when(() => mockAuthBloc.state).thenReturn(AuthInitial());

      // Act
      await tester.pumpWidget(buildTestableWidget(SignInPage()));
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
      expect(find.byType(AuthTextField), findsNWidgets(2));
      expect(find.text('ex: jon.smith@email.com'), findsOneWidget);
      expect(find.text('********'), findsOneWidget);
    });

    testWidgets('renders sign in button and sign up link', (WidgetTester tester) async {
      // Arrange
      when(() => mockAuthBloc.state).thenReturn(AuthInitial());

      // Act
      await tester.pumpWidget(buildTestableWidget(SignInPage()));
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(AuthButton), findsOneWidget);
      expect(find.text('SIGN IN'), findsOneWidget);
      expect(find.byType(AuthTextLink), findsOneWidget);
      expect(find.text('Don’t have an account? SIGN UP'), findsOneWidget);
    });

    testWidgets('disables sign in button when AuthLoading state', (WidgetTester tester) async {
      // Arrange
      when(() => mockAuthBloc.state).thenReturn(AuthLoading());

      // Act
      await tester.pumpWidget(buildTestableWidget(SignInPage()));
      await tester.pumpAndSettle();

      // Assert
      final authButton = tester.widget<AuthButton>(find.byType(AuthButton));
      expect(authButton.onPressed, isNull);
      expect(authButton.isLoading, isTrue);
    });

    testWidgets('triggers LoginEvent on sign in button press with valid input', (WidgetTester tester) async {
      // Arrange
      when(() => mockAuthBloc.state).thenReturn(AuthInitial());
      when(() => mockAuthBloc.add(any())).thenReturn(null);

      await tester.pumpWidget(buildTestableWidget(SignInPage()));
      await tester.pumpAndSettle();

      // Act
      await tester.enterText(find.byType(AuthTextField).first, 'test@email.com');
      await tester.enterText(find.byType(AuthTextField).last, 'password123');
      await tester.tap(find.byType(AuthButton));
      await tester.pumpAndSettle();

      // Assert
      verify(() => mockAuthBloc.add(LoginEvent(email: 'test@email.com', password: 'password123'))).called(1);
    });

    testWidgets('navigates to home on AuthAuthenticated state', (WidgetTester tester) async {
      // Arrange
      when(() => mockAuthBloc.state).thenReturn(AuthInitial());
      await tester.pumpWidget(buildTestableWidget(SignInPage()));
      await tester.pumpAndSettle();

      // Act
      when(() => mockAuthBloc.state).thenReturn(AuthAuthenticated(mockUser));
      await tester.pump();

      // Assert
      verify(() => mockGoRouter.go('/home')).called(1);
    });

    testWidgets('shows error snackbar on AuthError state', (WidgetTester tester) async {
      // Arrange
      when(() => mockAuthBloc.state).thenReturn(AuthInitial());
      await tester.pumpWidget(buildTestableWidget(SignInPage()));
      await tester.pumpAndSettle();

      // Act
      when(() => mockAuthBloc.state).thenReturn(AuthError('Invalid credentials'));
      await tester.pump();

      // Assert
      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.text('Invalid credentials'), findsOneWidget);
    });

    testWidgets('navigates to sign up page on sign up link tap', (WidgetTester tester) async {
      // Arrange
      when(() => mockAuthBloc.state).thenReturn(AuthInitial());
      await tester.pumpWidget(buildTestableWidget(SignInPage()));
      await tester.pumpAndSettle();

      // Act
      await tester.tap(find.byType(AuthTextLink));
      await tester.pumpAndSettle();

      // Assert
      verify(() => mockGoRouter.go('/sign-up')).called(1);
    });
  });
}