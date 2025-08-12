import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import '../widgets/auth_button.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/auth_text_link.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  bool isChecked = false;

  void _logoutAndGoBack() {
    context.read<AuthBloc>().add(LogoutEvent());
    context.go('/sign-in');
  }

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
                  const SizedBox(height: 16),

                  // Top row with back arrow left & ECOM box right
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF4A5CF4)),
                        onPressed: _logoutAndGoBack,
                      ),
                      Material(
                        elevation: 4,
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: const Color(0xFF4A5CF4), width: 2),
                          ),
                          child: const Text(
                            'ECOM',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF4A5CF4),
                              fontFamily: 'CaveatBrush',
                              letterSpacing: 2,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 40),

                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Text(
                            'Create your account',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                          ),

                          const SizedBox(height: 30),

                          // Name Label + Input
                          const Text(
                            'Name',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                          AuthTextField(
                            controller: nameController,
                            labelText: '',
                            hintText: 'ex: jon smith',
                          ),

                          const SizedBox(height: 20),

                          // Email Label + Input
                          const Text(
                            'Email',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                          AuthTextField(
                            controller: emailController,
                            labelText: '',
                            hintText: 'ex: jon.smith@email.com',
                          ),

                          const SizedBox(height: 20),

                          // Password Label + Input
                          const Text(
                            'Password',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                          AuthTextField(
                            controller: passwordController,
                            labelText: '',
                            hintText: '********',
                            obscureText: true,
                          ),

                          const SizedBox(height: 20),

                          // Confirm Password Label + Input
                          const Text(
                            'Confirm password',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                          AuthTextField(
                            controller: confirmPasswordController,
                            labelText: '',
                            hintText: '********',
                            obscureText: true,
                          ),

                          const SizedBox(height: 20),

                          Row(
                            children: [
                              Checkbox(
                                value: isChecked,
                                onChanged: (value) {
                                  setState(() {
                                    isChecked = value ?? false;
                                  });
                                },
                              ),
                              Expanded(
                                child: RichText(
                                  text: const TextSpan(
                                    text: 'I understood the ',
                                    style: TextStyle(color: Colors.black),
                                    children: [
                                      TextSpan(
                                        text: 'terms & policy.',
                                        style: TextStyle(
                                          color: Color(0xFF4A5CF4),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 20),

                          AuthButton(
                            onPressed: state is AuthLoading
                                ? null
                                : () {
                                    final name = nameController.text.trim();
                                    final email = emailController.text.trim();
                                    final password = passwordController.text.trim();
                                    final confirmPassword = confirmPasswordController.text.trim();

                                    if (name.isNotEmpty &&
                                        email.isNotEmpty &&
                                        password.isNotEmpty &&
                                        confirmPassword.isNotEmpty &&
                                        password == confirmPassword &&
                                        isChecked) {
                                      context.read<AuthBloc>().add(
                                            SignUpEvent(
                                              name: name,
                                              email: email,
                                              password: password,
                                            ),
                                          );
                                    }
                                  },
                            isLoading: state is AuthLoading,
                            text: 'SIGN UP',
                          ),

                          const SizedBox(height: 20),

                          // Wrap AuthTextLink in Builder to ensure correct BuildContext
                          Builder(
                            builder: (BuildContext context) {
                              return AuthTextLink(
                                text: 'Have an account? ',
                                linkText: 'SIGN IN',
                                onTap: () {
                                  debugPrint('AuthTextLink tapped, navigating to /sign-in');
                                  context.go('/sign-in');
                                },
                              );
                            },
                          ),

                          const SizedBox(height: 20),
                        ],
                      ),
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