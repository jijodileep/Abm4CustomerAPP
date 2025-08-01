import '../models/auth_model.dart';
import '../models/user.dart';
import '../services/auth_service.dart';

class AuthRepository {
  final AuthService _authService;

  AuthRepository(this._authService);

  Future<LoginResponse> login(LoginRequest request) async {
    return await _authService.login(request);
  }

  Future<bool> forgotPassword(ForgotPasswordRequest request) async {
    return await _authService.forgotPassword(request);
  }

  Future<void> logout() async {
    await _authService.logout();
  }

  Future<bool> isLoggedIn() async {
    return await _authService.isLoggedIn();
  }

  Future<User?> getCurrentUser() async {
    return await _authService.getCurrentUser();
  }

  Future<String?> getToken() async {
    return await _authService.getToken();
  }

  Future<bool> refreshToken() async {
    return await _authService.refreshToken();
  }

  Future<void> initializeAuth() async {
    await _authService.initializeAuth();
  }
}
