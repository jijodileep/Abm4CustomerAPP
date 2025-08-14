class ApiEndpoints {
  // Environment-based configuration
  static const String _devBaseUrl = 'http://devapi.abm4trades.com';
  // static const String _prodBaseUrl = 'https://api.abm4trades.com'; // Use HTTPS for production

  // Get base URL based on build mode or environment variable
  static String get baseUrl {
    // Check for environment variable first
    const String? apiUrl = String.fromEnvironment('API_URL');
    if (apiUrl != null && apiUrl.isNotEmpty) {
      return apiUrl;
    }

    // Temporarily use dev URL for both debug and release builds
    // TODO: Switch back to production URL when production server is ready
    return _devBaseUrl;

    // Use build mode to determine URL (commented out temporarily)
    // const bool isProduction = bool.fromEnvironment('dart.vm.product');
    // return isProduction ? _prodBaseUrl : _devBaseUrl;
  }

  // Authentication Endpoints - Currently Used
  static String get customerLogin => '$baseUrl/auth/Login/CustomerLogin';
  static String get transporterLogin => '$baseUrl/auth/Login/TransporterLogin';
  static String get refreshToken => '$baseUrl/auth/Login/Refresh';

  // Search Endpoints
  static String get itemSearch => '$baseUrl/General/Item/Search';

  // Other endpoints (for future use)
  static const String forgotPassword = '/auth/forgot-password';
  static const String logout = '/auth/logout';

  // Full URLs for other endpoints
  static String get forgotPasswordUrl => '$baseUrl$forgotPassword';
  static String get logoutUrl => '$baseUrl$logout';
}
