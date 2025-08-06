class ApiEndpoints {
  // Base URLs
  // static const String baseUrl = 'https://erpapi.33holdings.global';
  static const String customerApiBaseUrl = 'http://devapi.abm4trades.com';

  // Authentication Endpoints - Currently Used
  static const String customerLogin =
      '$customerApiBaseUrl/auth/Login/CustomerLogin';
  static const String transporterLogin =
      '$customerApiBaseUrl/auth/Login/TransporterLogin';
}
