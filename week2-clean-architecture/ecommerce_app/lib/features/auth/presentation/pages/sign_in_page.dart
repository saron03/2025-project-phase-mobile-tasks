import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import '../widgets/auth_button.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/auth_text_link.dart';

class SignInPage extends StatelessWidget {
  SignInPage({super.key});

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            context.go('/chat-list');
          } else if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  const SizedBox(height: 40),

                  // ECOM in white box with blue border, elevation, Caveat Brush font
                  Material(
                    elevation: 4,
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 40),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFF4A5CF4), width: 2),
                      ),
                      child: const Text(
                        'ECOM',
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF4A5CF4),
                          fontFamily: 'CaveatBrush',
                          letterSpacing: 2,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 60),

                  // The rest centered vertically and horizontally
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text(
                          'Sign into your account',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Label + input for Email
                        const Text(
                          'Email',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        AuthTextField(
                          controller: emailController,
                          labelText: '',  // label handled above
                          hintText: 'ex: jon.smith@email.com',
                        ),

                        const SizedBox(height: 20),

                        // Label + input for Password
                        const Text(
                          'Password',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        AuthTextField(
                          controller: passwordController,
                          labelText: '', // label handled above
                          hintText: '********',
                          obscureText: true,
                        ),

                        const SizedBox(height: 32),

                        AuthButton(
                          onPressed: state is AuthLoading
                              ? null
                              : () {
                                  final email = emailController.text.trim();
                                  final password = passwordController.text.trim();
                                  if (email.isNotEmpty && password.isNotEmpty) {
                                    context.read<AuthBloc>().add(
                                          LoginEvent(email: email, password: password),
                                        );
                                  }
                                },
                          isLoading: state is AuthLoading,
                          text: 'SIGN IN',
                        ),

                        const Spacer(),

                        AuthTextLink(
                          text: 'Don’t have an account? ',
                          linkText: 'SIGN UP',
                          onTap: () => context.go('/sign-up'),
                        ),

                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
