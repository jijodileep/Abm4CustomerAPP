import 'package:equatable/equatable.dart';

abstract class SplashState extends Equatable {
  const SplashState();

  @override
  List<Object?> get props => [];
}

class SplashInitial extends SplashState {
  const SplashInitial();
}

class SplashLoading extends SplashState {
  const SplashLoading();
}

class SplashCompleted extends SplashState {
  final bool isAuthenticated;

  const SplashCompleted({required this.isAuthenticated});

  @override
  List<Object?> get props => [isAuthenticated];
}