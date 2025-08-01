import '../models/auth_model.dart';
import '../models/user.dart';
import 'api_service.dart';
import 'storage_service.dart';

class AuthService {
  final ApiService _apiService;
  final StorageService _storageService;

  AuthService(this._apiService, this._storageService);

  Future<LoginResponse> login(LoginRequest request) async {
    try {
      final response = await _apiService.post('/auth/login', data: request.toJson());
      
      if (response.statusCode == 200) {
        final loginResponse = LoginResponse.fromJson(response.data);
        
        if (loginResponse.success && loginResponse.token != null) {
          // Store token and user data
          await _storageService.setToken(loginResponse.token!);
          if (loginResponse.user != null) {
            await _storageService.setUser(loginResponse.user!);
          }
          
          // Set auth token for future requests
          _apiService.setAuthToken(loginResponse.token!);
        }
        
        return loginResponse;
      } else {
        return LoginResponse.failure(
          error: 'Login failed with status: ${response.statusCode}',
        );
      }
    } on ApiException catch (e) {
      return LoginResponse.failure(error: e.message);
    } catch (e) {
      return LoginResponse.failure(error: 'An unexpected error occurred');
    }
  }

  Future<bool> forgotPassword(ForgotPasswordRequest request) async {
    try {
      final response = await _apiService.post('/auth/forgot-password', data: request.toJson());
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  Future<void> logout() async {
    try {
      // Call logout API if needed
      await _apiService.post('/auth/logout');
    } catch (e) {
      // Continue with local logout even if API call fails
    } finally {
      // Clear local storage
      await _storageService.clearToken();
      await _storageService.clearUser();
      
      // Remove auth token from API service
      _apiService.removeAuthToken();
    }
  }

  Future<bool> isLoggedIn() async {
    final token = await _storageService.getToken();
    return token != null && token.isNotEmpty;
  }

  Future<User?> getCurrentUser() async {
    return await _storageService.getUser();
  }

  Future<String?> getToken() async {
    return await _storageService.getToken();
  }

  Future<bool> refreshToken() async {
    try {
      final currentToken = await getToken();
      if (currentToken == null) return false;

      final response = await _apiService.post('/auth/refresh-token');
      
      if (response.statusCode == 200) {
        final newToken = response.data['token'] as String?;
        if (newToken != null) {
          await _storageService.setToken(newToken);
          _apiService.setAuthToken(newToken);
          return true;
        }
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<void> initializeAuth() async {
    final token = await getToken();
    if (token != null) {
      _apiService.setAuthToken(token);
    }
  }
}