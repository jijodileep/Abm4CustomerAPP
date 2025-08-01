import 'package:flutter_bloc/flutter_bloc.dart';
import '../../services/auth_service.dart';
import '../../services/storage_service.dart';
import 'splash_event.dart' as splash_event;
import 'splash_state.dart' as splash_state;

class SplashBloc extends Bloc<splash_event.SplashEvent, splash_state.SplashState> {
  final AuthService _authService;
  final StorageService _storageService;

  SplashBloc(this._authService, this._storageService) : super(const splash_state.SplashInitial()) {
    on<splash_event.SplashStarted>(_onSplashStarted);
    on<splash_event.SplashCompleted>(_onSplashCompleted);
  }

  Future<void> _onSplashStarted(
    splash_event.SplashStarted event,
    Emitter<splash_state.SplashState> emit,
  ) async {
    emit(const splash_state.SplashLoading());
    
    // Simulate splash screen duration
    await Future.delayed(const Duration(seconds: 3));
    
    // Check authentication status
    try {
      await _authService.initializeAuth();
      final isAuthenticated = await _authService.isLoggedIn();
      
      // Mark first launch as completed
      await _storageService.setFirstLaunch(false);
      
      emit(splash_state.SplashCompleted(isAuthenticated: isAuthenticated));
    } catch (e) {
      // If there's an error, assume user is not authenticated
      emit(const splash_state.SplashCompleted(isAuthenticated: false));
    }
  }

  Future<void> _onSplashCompleted(
    splash_event.SplashCompleted event,
    Emitter<splash_state.SplashState> emit,
  ) async {
    // This event can be used for any cleanup or additional logic
    // when splash is manually completed
  }
}