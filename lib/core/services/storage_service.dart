import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_constants.dart';

class StorageService {
  static Future<SharedPreferences> get _prefs async => await SharedPreferences.getInstance();

  // Access Token
  static Future<void> saveAccessToken(String token) async {
    final prefs = await _prefs;
    await prefs.setString(AppConstants.accessTokenKey, token);
  }

  static Future<String?> loadAccessToken() async {
    final prefs = await _prefs;
    return prefs.getString(AppConstants.accessTokenKey);
  }


  // Base URL
  static Future<void> saveBaseUrl(String url) async {
    final prefs = await _prefs;
    await prefs.setString(AppConstants.baseUrlKey, url);
  }

  static Future<String?> loadBaseUrl() async {
    final prefs = await _prefs;
    return prefs.getString(AppConstants.baseUrlKey);
  }

  // Endpoints
  static Future<void> saveEndpoints({
    required String refreshEndpoint,
    required String checkInEndpoint,
    required String checkOutEndpoint,
  }) async {
    final prefs = await _prefs;
    await prefs.setString(AppConstants.refreshEndpointKey, refreshEndpoint);
    await prefs.setString(AppConstants.checkInEndpointKey, checkInEndpoint);
    await prefs.setString(AppConstants.checkOutEndpointKey, checkOutEndpoint);
  }

  static Future<Map<String, String?>> loadEndpoints() async {
    final prefs = await _prefs;
    return {
      'refresh': prefs.getString(AppConstants.refreshEndpointKey),
      'checkIn': prefs.getString(AppConstants.checkInEndpointKey),
      'checkOut': prefs.getString(AppConstants.checkOutEndpointKey),
    };
  }

  // User Agent
  static Future<void> saveUserAgent(String userAgent) async {
    final prefs = await _prefs;
    await prefs.setString(AppConstants.userAgentKey, userAgent);
  }

  static Future<String?> loadUserAgent() async {
    final prefs = await _prefs;
    return prefs.getString(AppConstants.userAgentKey);
  }

  // Auth Bearer Token
  static Future<void> saveAuthBearerToken(String token) async {
    final prefs = await _prefs;
    await prefs.setString(AppConstants.authBearerTokenKey, token);
  }

  static Future<String?> loadAuthBearerToken() async {
    final prefs = await _prefs;
    return prefs.getString(AppConstants.authBearerTokenKey);
  }
}