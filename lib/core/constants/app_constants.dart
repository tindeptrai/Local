class AppConstants {
  // Storage keys
  static const String accessTokenKey = "access_token";
  static const String membersKey = "members";
  static const String baseUrlKey = "base_url";
  static const String refreshEndpointKey = "refresh_endpoint";
  static const String checkInEndpointKey = "checkin_endpoint";
  static const String checkOutEndpointKey = "checkout_endpoint";
  static const String userAgentKey = "user_agent";
  static const String authBearerTokenKey = "auth_bearer_token";

  // Default values
  static const String defaultUserAgent = "MyFXRelease/1 CFNetwork/3860.300.31 Darwin/25.2.0";

  // API settings
  static const double randomRadiusMeters = 10.0;
  static const double targetLat = 10.7293;
  static const double targetLng = 106.7212;

  // UI constants
  static const int maxApiLogs = 100;
  static const int snackBarDurationSeconds = 2;
  static const int maxTokenDisplayLength = 30;
}