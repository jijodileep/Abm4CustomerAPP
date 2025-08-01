import 'package:equatable/equatable.dart';
import '../../models/auth_model.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class AuthInitialized extends AuthEvent {
  const AuthInitialized();
}

class AuthLoginRequested extends AuthEvent {
  final LoginRequest loginRequest;

  const AuthLoginRequested(this.loginRequest);

  @override
  List<Object?> get props => [loginRequest];
}

class AuthLogoutRequested extends AuthEvent {
  const AuthLogoutRequested();
}

class AuthForgotPasswordRequested extends AuthEvent {
  final ForgotPasswordRequest forgotPasswordRequest;

  const AuthForgotPasswordRequested(this.forgotPasswordRequest);

  @override
  List<Object?> get props => [forgotPasswordRequest];
}

class AuthTokenRefreshRequested extends AuthEvent {
  const AuthTokenRefreshRequested();
}

class AuthStatusChecked extends AuthEvent {
  const AuthStatusChecked();
}