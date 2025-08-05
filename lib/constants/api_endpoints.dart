class ApiEndpoints {
  // Base URLs
  static const String baseUrl = 'https://erpapi.33holdings.global';
  static const String customerApiBaseUrl = 'http://devapi.abm4trades.com';

  // Authentication Endpoints
  static const String customerLogin =
      '$customerApiBaseUrl/auth/Login/CustomerLogin';
  static const String transporterLogin =
      '$customerApiBaseUrl/auth/Login/TransporterLogin';
  static const String login = '/auth/Login';
  static const String logout = '/auth/logout';
  static const String forgotPassword = '/auth/forgot-password';
  static const String refreshToken = '/auth/refresh-token';

  // User Endpoints
  static const String userProfile = '/user/profile';
  static const String updateProfile = '/user/update-profile';

  // Dealer Endpoints
  static const String dealerDashboard = '/dealer/dashboard';
  static const String dealerOrders = '/dealer/orders';
  static const String placeOrder = '/dealer/place-order';
  static const String orderHistory = '/dealer/order-history';
  static const String inventory = '/dealer/inventory';
  static const String pricing = '/dealer/pricing';
  static const String promotions = '/dealer/promotions';
  static const String newArrivals = '/dealer/new-arrivals';

  // Transporter Endpoints
  static const String transporterDashboard = '/transporter/dashboard';
  static const String transporterOrders = '/transporter/orders';
  static const String deliveries = '/transporter/deliveries';
  static const String transporterProfile = '/transporter/profile';

  // Common Endpoints
  static const String notifications = '/notifications';
  static const String support = '/support';
  static const String settings = '/settings';
}
