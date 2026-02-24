import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../constants/api_endpoints.dart';
import '../constants/app_constants.dart';
import '../utils/api_logger.dart';
import '../utils/formatters.dart';
import 'storage_service.dart';

class ApiService {
  String baseUrl = ApiEndpoints.defaultBaseUrl;
  String refreshTokenEndpoint = ApiEndpoints.defaultRefreshEndpoint;
  String checkInEndpoint = ApiEndpoints.defaultCheckInEndpoint;
  String checkOutEndpoint = ApiEndpoints.defaultCheckOutEndpoint;
  String userAgent = AppConstants.defaultUserAgent;
  String authBearerToken = "";

  // Initialize from storage
  Future<void> initialize() async {
    final savedBaseUrl = await StorageService.loadBaseUrl();
    if (savedBaseUrl != null && savedBaseUrl.isNotEmpty) {
      baseUrl = Formatters.normalizeUrl(savedBaseUrl);
    }

    final endpoints = await StorageService.loadEndpoints();
    refreshTokenEndpoint = endpoints['refresh'] ?? ApiEndpoints.defaultRefreshEndpoint;
    checkInEndpoint = endpoints['checkIn'] ?? ApiEndpoints.defaultCheckInEndpoint;
    checkOutEndpoint = endpoints['checkOut'] ?? ApiEndpoints.defaultCheckOutEndpoint;

    final savedUserAgent = await StorageService.loadUserAgent();
    if (savedUserAgent != null && savedUserAgent.isNotEmpty) {
      userAgent = savedUserAgent;
    }

    final savedAuthBearerToken = await StorageService.loadAuthBearerToken();
    if (savedAuthBearerToken != null) {
      authBearerToken = savedAuthBearerToken;
    }
  }

  // Save configuration
  Future<void> saveBaseUrl(String url) async {
    baseUrl = Formatters.normalizeUrl(url);
    await StorageService.saveBaseUrl(baseUrl);
  }

  Future<void> saveEndpoints({
    required String refresh,
    required String checkIn,
    required String checkOut,
  }) async {
    refreshTokenEndpoint = refresh;
    checkInEndpoint = checkIn;
    checkOutEndpoint = checkOut;
    await StorageService.saveEndpoints(
      refreshEndpoint: refresh,
      checkInEndpoint: checkIn,
      checkOutEndpoint: checkOut,
    );
  }

  Future<void> saveUserAgent(String ua) async {
    userAgent = AppConstants.defaultUserAgent;
    await StorageService.saveUserAgent(ua);
  }

  Future<void> saveAuthBearerToken(String token) async {
    authBearerToken = token;
    await StorageService.saveAuthBearerToken(token);
  }

  // Reset to defaults
  Future<void> resetToDefaults() async {
    baseUrl = ApiEndpoints.defaultBaseUrl;
    refreshTokenEndpoint = ApiEndpoints.defaultRefreshEndpoint;
    checkInEndpoint = ApiEndpoints.defaultCheckInEndpoint;
    checkOutEndpoint = ApiEndpoints.defaultCheckOutEndpoint;
    userAgent = AppConstants.defaultUserAgent;
    authBearerToken = "";

    await StorageService.saveBaseUrl(baseUrl);
    await StorageService.saveEndpoints(
      refreshEndpoint: refreshTokenEndpoint,
      checkInEndpoint: checkInEndpoint,
      checkOutEndpoint: checkOutEndpoint,
    );
    await StorageService.saveUserAgent(userAgent);
    await StorageService.saveAuthBearerToken(authBearerToken);
  }

  // API Calls
  Future<http.Response?> _post({
    required String endpoint,
    Map<String, dynamic>? body,
    Map<String, String>? customHeaders,
    String logType = "",
  }) async {
    final startTime = DateTime.now();

    try {
      final uri = Uri.parse(baseUrl + endpoint);
      final headers = customHeaders ?? await _getDefaultHeaders();

      final requestLog = ApiLogger.formatRequestLog(
        startTime: startTime,
        uri: uri,
        method: "POST",
        headers: headers,
        body: body != null ? jsonEncode(body) : null,
      );

      print(requestLog);
      ApiLogger.addLog(requestLog);

      final response = await http.post(
        uri,
        headers: headers,
        body: body != null ? jsonEncode(body) : null,
      );

      final responseLog = ApiLogger.formatResponseLog(
        startTime: startTime,
        statusCode: response.statusCode,
        headers: response.headers,
        body: response.body,
        type: logType,
      );

      print(responseLog);
      ApiLogger.addLog(responseLog);

      return response;
    } catch (e) {
      final errorLog = ApiLogger.formatErrorLog(
        startTime: startTime,
        error: e,
        type: logType,
      );

      print(errorLog);
      ApiLogger.addLog(errorLog);

      return null;
    }
  }

  Future<Map<String, String>> _getDefaultHeaders() async {
    return {
      "Content-Type": ApiHeaders.contentType,
      "x-access-token": "", // Will be set by caller
      "User-Agent": userAgent,
      "Accept-Language": ApiHeaders.acceptLanguage,
      "Accept-Encoding": ApiHeaders.acceptEncoding,
      "Connection": ApiHeaders.connection,
    };
  }

  Future<Map<String, String>> _getRefreshHeaders() async {
    return {
      "Host": ApiHeaders.host,
      "content-type": ApiHeaders.contentType,
      "accept": ApiHeaders.accept,
      "map": ApiHeaders.map,
      "priority": ApiHeaders.priority,
      "redirect": ApiHeaders.redirect,
      "auth-bearer-token": authBearerToken,
      "accept-language": ApiHeaders.refreshAcceptLanguage,
      "user-agent": userAgent,
    };
  }

  // Public API methods
  Future<http.Response?> checkIn({
    required String accessToken,
    required String buildingId,
    required String buildingName,
    required String customerName,
  }) async {
    final position = Formatters.getRandomNearbyPosition(
      AppConstants.targetLat,
      AppConstants.targetLng,
      AppConstants.randomRadiusMeters,
    );

    final body = {
      "lat": position.latitude,
      "lng": position.longitude,
      "type": "GPS",
      "buildingId": buildingId,
      "beaconKey": null,
      "building_name": buildingName,
      "customer_name": customerName,
      "time_zone": "+07:00",
    };

    final headers = await _getDefaultHeaders();
    headers["x-access-token"] = accessToken;

    return await _post(
      endpoint: checkInEndpoint,
      body: body,
      customHeaders: headers,
    );
  }

  Future<http.Response?> checkOut({
    required String accessToken,
    required String buildingId,
    required String buildingName,
    required String customerName,
  }) async {
    final position = Formatters.getRandomNearbyPosition(
      AppConstants.targetLat,
      AppConstants.targetLng,
      AppConstants.randomRadiusMeters,
    );

    final body = {
      "lat": position.latitude,
      "lng": position.longitude,
      "type": "GPS",
      "buildingId": buildingId,
      "beaconKey": null,
      "building_name": buildingName,
      "customer_name": customerName,
      "time_zone": "+07:00",
    };

    final headers = await _getDefaultHeaders();
    headers["x-access-token"] = accessToken;

    return await _post(
      endpoint: checkOutEndpoint,
      body: body,
      customHeaders: headers,
    );
  }

  Future<http.Response?> refreshToken() async {
    final headers = await _getRefreshHeaders();

    return await _post(
      endpoint: refreshTokenEndpoint,
      customHeaders: headers,
      logType: "REFRESH TOKEN",
    );
  }

  // Utility methods
  bool isValidUrl(String url) => Formatters.isValidUrl(url);
  String normalizeUrl(String url) => Formatters.normalizeUrl(url);
}