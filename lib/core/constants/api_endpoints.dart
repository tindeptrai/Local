class ApiEndpoints {
  // Default endpoints
  static const String defaultBaseUrl = "";
  static const String defaultRefreshEndpoint = "";
  static const String defaultCheckInEndpoint = "";
  static const String defaultCheckOutEndpoint = "";
}

class ApiHeaders {
  static const String contentType = "application/json";
  static const String acceptLanguage = "en-VN;q=1.0, vi-VN;q=0.9";
  static const String acceptEncoding = "gzip;q=1.0, compress;q=0.5";
  static const String connection = "keep-alive";

  // Refresh token specific headers
  static const String host = "";
  static const String accept = "/";
  static const String map = "[object Object]";
  static const String priority = "u=3, i";
  static const String redirect = "follow";
  static const String refreshAcceptLanguage = "vi-VN,vi;q=0.9";
}