import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/user.dart';
import '../../domain/usecases/login.dart';
import '../../domain/usecases/logout.dart';
import '../../domain/usecases/signup.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final Login login;
  final SignUp signUp;
  final Logout logout;

  AuthBloc({
    required this.login,
    required this.signUp,
    required this.logout,
  }) : super(AuthUnauthenticated()) {
    on<LoginEvent>(_onLoginEvent);
    on<SignUpEvent>(_onSignUpEvent);
    on<LogoutEvent>(_onLogoutEvent);
    on<CheckAuthStatusEvent>(_onCheckAuthStatusEvent);
  }

  Future<void> _onLoginEvent(LoginEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final result = await login(email: event.email, password: event.password);
    emit(result.fold(
      (failure) => AuthError(_mapFailureToMessage(failure)),
      (user) => AuthAuthenticated(user),
    ));
  }

  Future<void> _onSignUpEvent(SignUpEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final result = await signUp(
      name: event.name,
      email: event.email,
      password: event.password,
      id: event.id,
    );
    emit(result.fold(
      (failure) => AuthError(_mapFailureToMessage(failure)),
      (user) => AuthAuthenticated(user),
    ));
  }

  Future<void> _onLogoutEvent(LogoutEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await logout();
      emit(AuthUnauthenticated());
    } catch (e) {
      emit(AuthError('Logout failed. Please try again.'));
    }
  }

  Future<void> _onCheckAuthStatusEvent(CheckAuthStatusEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      debugPrint('Auth token: $token');
      if (token != null && token.isNotEmpty) {
        final user = const User(id: 'placeholder_id', name: 'Placeholder User', email: 'placeholder@example.com');
        emit(AuthAuthenticated(user));
      } else {
        emit(AuthUnauthenticated());
      }
    } catch (e) {
      debugPrint('CheckAuthStatus error: $e');
      emit(AuthUnauthenticated());
    }
  }

  String _mapFailureToMessage(Failure failure) {
    if (failure is NetworkFailure) {
      return 'No internet connection. Please check your network.';
    } else if (failure is ServerFailure) {
      return 'Server error. Please try again later.';
    } else {
      return 'An unexpected error occurred.';
    }
  }
}