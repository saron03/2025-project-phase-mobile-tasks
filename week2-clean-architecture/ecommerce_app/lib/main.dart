import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'core/di/injection_container.dart' as di;
import 'features/auth/domain/entities/user.dart';
import 'features/auth/domain/usecases/login.dart';
import 'features/auth/domain/usecases/logout.dart';
import 'features/auth/domain/usecases/signup.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/presentation/bloc/auth_event.dart';
import 'features/auth/presentation/pages/home_page.dart';
import 'features/auth/presentation/pages/sign_in_page.dart';
import 'features/auth/presentation/pages/sign_up_page.dart';
import 'features/auth/presentation/pages/splash_page.dart';
import 'features/chat/presentation/bloc/chat_bloc.dart';
import 'features/chat/presentation/pages/chat_list_page.dart';
import 'features/chat/presentation/pages/chat_messages_page.dart';
import 'features/product/presentation/bloc/product_bloc.dart';
import 'features/product/presentation/bloc/product_event.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final GoRouter router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const SplashScreen(),
        ),
        GoRoute(
          path: '/sign-in',
          builder: (context, state) => SignInPage(),
        ),
        GoRoute(
          path: '/sign-up',
          builder: (context, state) => const SignUpPage(),
        ),
        GoRoute(
          path: '/home',
          builder: (context, state) {
            return BlocProvider(
              create: (_) => ProductBloc(
                insertProduct: di.sl(),
                updateProduct: di.sl(),
                deleteProduct: di.sl(),
                getProduct: di.sl(),
                getAllProducts: di.sl(),
                inputConverter: di.sl(),
              )..add(const LoadAllProductEvent()),
              child: const HomePage(),
            );
          },
        ),
        GoRoute(
          path: '/chat-messages/:chatId',
          builder: (context, state) {
            final chatId = state.pathParameters['chatId']!;
            final otherUser = state.extra as User?;

            if (otherUser == null) {
              return const Text('Error: User not found');
            }
            return BlocProvider(
              create: (_) => di.sl<ChatBloc>(),
              child: ChatMessagesPage(
                chatId: chatId,
                otherUser: otherUser,
              ),
            );
          },
        ),

        GoRoute(
          path: '/chat-list',
          builder: (context, state) {
            return BlocProvider(
              create: (_) => di.sl<ChatBloc>(),
              child: const ChatListPage(),
            );
          },
        ),
      ],
    );

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => AuthBloc(
            login: di.sl<Login>(),
            signUp: di.sl<SignUp>(),
            logout: di.sl<Logout>(),
          )..add(CheckAuthStatusEvent()),
        ),
      ],
      child: MaterialApp.router(
        routerConfig: router,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primarySwatch: Colors.blue),
      ),
    );
  }
}