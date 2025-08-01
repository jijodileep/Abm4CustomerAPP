import 'package:flutter_bloc/flutter_bloc.dart';
import '../../services/auth_service.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthService _authService;

  AuthBloc(this._authService) : super(const AuthInitial()) {
    on<AuthInitialized>(_onAuthInitialized);
    on<AuthLoginRequested>(_onAuthLoginRequested);
    on<AuthLogoutRequested>(_onAuthLogoutRequested);
    on<AuthForgotPasswordRequested>(_onAuthForgotPasswordRequested);
    on<AuthTokenRefreshRequested>(_onAuthTokenRefreshRequested);
    on<AuthStatusChecked>(_onAuthStatusChecked);
  }

  Future<void> _onAuthInitialized(
    AuthInitialized event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    
    try {
      await _authService.initializeAuth();
      
      final isLoggedIn = await _authService.isLoggedIn();
      if (isLoggedIn) {
        final user = await _authService.getCurrentUser();
        final token = await _authService.getToken();
        
        if (user != null && token != null) {
          emit(AuthAuthenticated(user: user, token: token));
        } else {
          emit(const AuthUnauthenticated());
        }
      } else {
        emit(const AuthUnauthenticated());
      }
    } catch (e) {
      emit(AuthError('Failed to initialize authentication: ${e.toString()}'));
    }
  }

  Future<void> _onAuthLoginRequested(
    AuthLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    
    try {
      final response = await _authService.login(event.loginRequest);
      
      if (response.success && response.user != null && response.token != null) {
        emit(AuthAuthenticated(
          user: response.user!,
          token: response.token!,
        ));
      } else {
        emit(AuthError(response.error ?? 'Login failed'));
      }
    } catch (e) {
      emit(AuthError('Login failed: ${e.toString()}'));
    }
  }

  Future<void> _onAuthLogoutRequested(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    
    try {
      await _authService.logout();
      emit(const AuthUnauthenticated());
    } catch (e) {
      // Even if logout fails, we should still clear local state
      emit(const AuthUnauthenticated());
    }
  }

  Future<void> _onAuthForgotPasswordRequested(
    AuthForgotPasswordRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    
    try {
      final success = await _authService.forgotPassword(event.forgotPasswordRequest);
      
      if (success) {
        emit(const AuthForgotPasswordSuccess(
          'Password reset instructions have been sent to your registered mobile number.',
        ));
      } else {
        emit(const AuthForgotPasswordError(
          'Failed to send password reset instructions. Please try again.',
        ));
      }
    } catch (e) {
      emit(AuthForgotPasswordError(
        'Failed to process forgot password request: ${e.toString()}',
      ));
    }
  }

  Future<void> _onAuthTokenRefreshRequested(
    AuthTokenRefreshRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      final success = await _authService.refreshToken();
      
      if (!success) {
        // If token refresh fails, logout the user
        add(const AuthLogoutRequested());
      }
      // If successful, the token is already updated in storage
      // and the current state remains the same
    } catch (e) {
      // If token refresh fails, logout the user
      add(const AuthLogoutRequested());
    }
  }

  Future<void> _onAuthStatusChecked(
    AuthStatusChecked event,
    Emitter<AuthState> emit,
  ) async {
    try {
      final isLoggedIn = await _authService.isLoggedIn();
      
      if (!isLoggedIn) {
        emit(const AuthUnauthenticated());
      } else {
        final user = await _authService.getCurrentUser();
        final token = await _authService.getToken();
        
        if (user != null && token != null) {
          emit(AuthAuthenticated(user: user, token: token));
        } else {
          emit(const AuthUnauthenticated());
        }
      }
    } catch (e) {
      emit(const AuthUnauthenticated());
    }
  }
}