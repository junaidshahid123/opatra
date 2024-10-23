class ApiUrls {
  // Base API URL
  static const String baseUrl = 'https://opatra.fai-tech.online/api';

  // Authentication-related URLs
  static const String loginUrl = '$baseUrl/login';
  static const String registerUrl = '$baseUrl/auth/register';
  static const String logoutUrl = '$baseUrl/logout';
  static const String signUpUrl = '$baseUrl/register';

  // User-related URLs
  static const String userProfileUrl = '$baseUrl/user/profile';
  static const String userUpdateUrl = '$baseUrl/user/update';
  static const String userChangePasswordUrl = '$baseUrl/user/change-password';

  // Product-related URLs
  static const String productListUrl = '$baseUrl/products';
  static const String getLatestProducts = '$baseUrl/latest-products';
  static const String products = '$baseUrl/products';
  static const String productCategory = '$baseUrl/product-category';
  static const String banner = '$baseUrl/banner';
  static const String videoCategory = '$baseUrl/video-category';
  static const String userNotifications = '$baseUrl/user-notifications';
  static const String askExpert = '$baseUrl/ask-expert';

  static String productDetailsUrl(int id) => '$baseUrl/products/$id';

  // Order-related URLs
  static const String orderListUrl = '$baseUrl/orders';

  static String orderDetailsUrl(int id) => '$baseUrl/orders/$id';

  // Contact us URL
  static const String contactUsUrl = '$baseUrl/contact-us';
  static const String registerProduct = '$baseUrl/register-product';
  static const String warrantyClaims = '$baseUrl/warranty-claim';

  // Other URLs
  static const String termsAndConditionsUrl = '$baseUrl/terms-and-conditions';
  static const String privacyPolicyUrl = '$baseUrl/privacy-policy';

// You can add more URLs here as needed...
}
