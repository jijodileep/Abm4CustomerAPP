class AppConstants {
  // App Information
  static const String appName = 'ABM4';
  static const String appVersion = '1.0.0';
  
  // API Configuration
  static const String baseUrl = 'https://api.yourapp.com';
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  
  // Storage Keys
  static const String tokenKey = 'auth_token';
  static const String userKey = 'user_data';
  static const String userTypeKey = 'user_type';
  static const String isFirstLaunchKey = 'is_first_launch';
  
  // Animation Durations
  static const Duration splashDuration = Duration(seconds: 3);
  static const Duration animationDuration = Duration(milliseconds: 300);
  static const Duration fadeAnimationDuration = Duration(seconds: 2);
  
  // UI Constants
  static const double defaultPadding = 16.0;
  static const double defaultMargin = 16.0;
  static const double defaultBorderRadius = 12.0;
  static const double buttonHeight = 48.0;
  static const double inputFieldHeight = 56.0;
  
  // Error Messages
  static const String networkError = 'No internet connection. Please check your network.';
  static const String serverError = 'Server error. Please try again later.';
  static const String unknownError = 'An unexpected error occurred.';
  static const String validationError = 'Please fill in all required fields.';
  static const String loginError = 'Invalid credentials. Please try again.';
  
  // Success Messages
  static const String loginSuccess = 'Login successful!';
  static const String logoutSuccess = 'Logged out successfully!';
  static const String forgotPasswordSuccess = 'Password reset instructions sent!';
  
  // Validation
  static const int minPasswordLength = 6;
  static const int maxPasswordLength = 20;
  static const int minMobileLength = 10;
  static const int maxMobileLength = 15;
  
  // Contact Information
  static const String supportPhone = '+1-800-123-4567';
  static const String supportEmail = 'support@company.com';
  static const String supportChat = 'Available 24/7';
}

class ApiEndpoints {
  static const String login = '/auth/login';
  static const String logout = '/auth/logout';
  static const String forgotPassword = '/auth/forgot-password';
  static const String refreshToken = '/auth/refresh-token';
  static const String profile = '/user/profile';
  static const String updateProfile = '/user/profile';
}

class RouteNames {
  static const String splash = '/splash';
  static const String auth = '/auth';
  static const String home = '/home';
  static const String profile = '/profile';
  static const String settings = '/settings';
}