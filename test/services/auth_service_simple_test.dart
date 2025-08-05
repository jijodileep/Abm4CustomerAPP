import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:dio/dio.dart';

import 'package:abm4_customerapp/services/auth_service.dart';
import 'package:abm4_customerapp/services/api_service.dart';
import 'package:abm4_customerapp/features/auth/models/auth_model.dart';
import 'package:abm4_customerapp/features/auth/models/user.dart';
import 'package:abm4_customerapp/constants/api_endpoints.dart';

import '../test_helpers.dart';

void main() {
  late AuthService authService;
  late MockApiService mockApiService;

  setUp(() {
    mockApiService = MockApiService();
    authService = AuthService(mockApiService);
  });

  group('AuthService Simple Tests', () {
    test('should handle login success flow', () async {
      // Arrange
      const loginRequest = LoginRequest(
        mobileNumberOrId: 'test123',
        password: 'password123',
        userType: UserType.dealer,
      );

      final mockUser = User(
        id: '1',
        mobileNumber: 'test123',
        name: 'Test User',
        email: 'test@example.com',
        userType: UserType.dealer,
        createdAt: DateTime.now(),
      );

      final mockResponse = Response<Map<String, dynamic>>(
        data: {
          'success': true,
          'token': 'mock_token',
          'user': mockUser.toJson(),
        },
        statusCode: 200,
        requestOptions: RequestOptions(path: '/login'),
      );

      // Mock the API call with specific endpoint
      when(mockApiService.postCustomerLogin(ApiEndpoints.customerLogin, data: anyNamed('data')))
          .thenAnswer((_) async => mockResponse);

      // Act
      final result = await authService.login(loginRequest);

      // Assert
      expect(result.success, true);
      expect(result.token, 'mock_token');
      expect(result.user?.id, '1');
      
      // Verify calls were made
      verify(mockApiService.postCustomerLogin(ApiEndpoints.customerLogin, data: anyNamed('data')))
          .called(1);
      verify(mockApiService.setAuthToken('mock_token')).called(1);
    });

    test('should handle login failure', () async {
      // Arrange
      const loginRequest = LoginRequest(
        mobileNumberOrId: 'test123',
        password: 'wrong_password',
        userType: UserType.dealer,
      );

      final mockResponse = Response<Map<String, dynamic>>(
        data: {
          'success': false,
          'error': 'Invalid credentials',
        },
        statusCode: 200,
        requestOptions: RequestOptions(path: '/login'),
      );

      when(mockApiService.postCustomerLogin(ApiEndpoints.customerLogin, data: anyNamed('data')))
          .thenAnswer((_) async => mockResponse);

      // Act
      final result = await authService.login(loginRequest);

      // Assert
      expect(result.success, false);
      expect(result.error, isNotNull);
    });

    test('should handle logout', () async {
      // Arrange
      when(mockApiService.post('/auth/logout')).thenAnswer(
        (_) async => Response(
          data: <String, dynamic>{},
          statusCode: 200,
          requestOptions: RequestOptions(path: '/logout'),
        ),
      );

      // Act
      await authService.logout();

      // Assert
      verify(mockApiService.removeAuthToken()).called(1);
    });

    test('should refresh token successfully', () async {
      // Arrange - First login to set a token
      const loginRequest = LoginRequest(
        mobileNumberOrId: 'test123',
        password: 'password123',
        userType: UserType.dealer,
      );

      final mockUser = User(
        id: '1',
        mobileNumber: 'test123',
        name: 'Test User',
        email: 'test@example.com',
        userType: UserType.dealer,
        createdAt: DateTime.now(),
      );

      final loginResponse = Response<Map<String, dynamic>>(
        data: {
          'success': true,
          'token': 'old_token',
          'user': mockUser.toJson(),
        },
        statusCode: 200,
        requestOptions: RequestOptions(path: '/login'),
      );

      when(mockApiService.postCustomerLogin(ApiEndpoints.customerLogin, data: anyNamed('data')))
          .thenAnswer((_) async => loginResponse);

      // Login first to set a token
      await authService.login(loginRequest);

      final refreshResponse = Response<Map<String, dynamic>>(
        data: {'token': 'new_token'},
        statusCode: 200,
        requestOptions: RequestOptions(path: '/refresh'),
      );

      when(mockApiService.post('/auth/refresh-token'))
          .thenAnswer((_) async => refreshResponse);

      // Act
      final result = await authService.refreshToken();

      // Assert
      expect(result, true);
      verify(mockApiService.setAuthToken('new_token')).called(1);
    });
  });
}