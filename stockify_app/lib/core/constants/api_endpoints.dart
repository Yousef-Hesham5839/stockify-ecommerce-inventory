class ApiEndpoints {
  // For Android Emulator:
  static const String baseUrl = 'http://10.0.2.2:5000/api/v1';

  // Auth
  static const String register = '$baseUrl/auth/register';
  static const String login = '$baseUrl/auth/login';
  static const String me = '$baseUrl/auth/me';

  // Products
  static const String products = '$baseUrl/products';

  // Invoices
  static const String invoices = '$baseUrl/invoices';
}