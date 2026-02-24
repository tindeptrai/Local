import 'dart:convert';
import 'package:flutter/material.dart';
import '../core/services/api_service.dart';
import '../core/services/storage_service.dart';
import '../core/utils/api_logger.dart';

class AppProvider extends ChangeNotifier {
  // Services
  final ApiService _apiService = ApiService();
  ApiService get apiService => _apiService;

  // State
  String _accessToken = "";
  bool _isLoading = false;

  // Getters
  String get accessToken => _accessToken;
  bool get isLoading => _isLoading;
  List<String> get apiLogs => ApiLogger.getLogs();
  bool get hasToken => _accessToken.isNotEmpty;

  // Initialize
  Future<void> initialize() async {
    await _apiService.initialize();
    await _loadAccessToken();
  }

  // Loading state
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  // Access Token
  Future<void> _loadAccessToken() async {
    final token = await StorageService.loadAccessToken();
    if (token != null && token.isNotEmpty) {
      _accessToken = token;
      notifyListeners();
    }
  }

  Future<void> updateAccessToken(String token) async {
    _accessToken = token;
    await StorageService.saveAccessToken(token);
    notifyListeners();
  }


  // API Operations
  Future<Map<String, dynamic>> checkIn() async {
    if (_accessToken.isEmpty) {
      return {'success': false, 'message': '❌ Chưa có access token'};
    }

    _setLoading(true);
    try {
      final response = await _apiService.checkIn(
        accessToken: _accessToken,
        buildingId: "17",
        buildingName: "Tòa nhà 678",
        customerName: "FRT",
      );

      // Auto refresh nếu gặp lỗi 440 (token expired)
      if (response?.statusCode == 440) {
        final refreshSuccess = await refreshToken();
        if (refreshSuccess) {
          // Retry check-in với token mới
          final retryResponse = await _apiService.checkIn(
            accessToken: _accessToken,
            buildingId: "17",
            buildingName: "Tòa nhà 678",
            customerName: "FRT",
          );

          _setLoading(false);
          final success = retryResponse?.statusCode == 200;
          return {
            'success': success,
            'message': success ? '✅ Check-in thành công!' : '❌ Check-in thất bại!',
            'autoRefreshed': true
          };
        } else {
          _setLoading(false);
          return {'success': false, 'message': '❌ Không thể refresh token tự động'};
        }
      }

      _setLoading(false);
      final success = response?.statusCode == 200;
      return {
        'success': success,
        'message': success ? '✅ Check-in thành công!' : '❌ Check-in thất bại!',
        'autoRefreshed': false
      };
    } catch (e) {
      _setLoading(false);
      return {'success': false, 'message': '⚠️ Lỗi: ${e.toString().split(':').first}'};
    }
  }

  Future<Map<String, dynamic>> checkOut() async {
    if (_accessToken.isEmpty) {
      return {'success': false, 'message': '❌ Chưa có access token'};
    }

    _setLoading(true);
    try {
      final response = await _apiService.checkOut(
        accessToken: _accessToken,
        buildingId: "17",
        buildingName: "Tòa nhà 678",
        customerName: "FRT",
      );

      // Auto refresh nếu gặp lỗi 440 (token expired)
      if (response?.statusCode == 440) {
        final refreshSuccess = await refreshToken();
        if (refreshSuccess) {
          // Retry check-out với token mới
          final retryResponse = await _apiService.checkOut(
            accessToken: _accessToken,
            buildingId: "17",
            buildingName: "Tòa nhà 678",
            customerName: "FRT",
          );

          _setLoading(false);
          final success = retryResponse?.statusCode == 200;
          return {
            'success': success,
            'message': success ? '✅ Check-out thành công!' : '❌ Check-out thất bại!',
            'autoRefreshed': true
          };
        } else {
          _setLoading(false);
          return {'success': false, 'message': '❌ Không thể refresh token tự động'};
        }
      }

      _setLoading(false);
      final success = response?.statusCode == 200;
      return {
        'success': success,
        'message': success ? '✅ Check-out thành công!' : '❌ Check-out thất bại!',
        'autoRefreshed': false
      };
    } catch (e) {
      _setLoading(false);
      return {'success': false, 'message': '⚠️ Lỗi: ${e.toString().split(':').first}'};
    }
  }

  Future<bool> refreshToken() async {
    _setLoading(true);
    try {
      final response = await _apiService.refreshToken();

      if (response?.statusCode == 200) {
        try {
          final data = jsonDecode(response!.body);
          final newToken = data['token'];
          if (newToken != null) {
            await updateAccessToken(newToken);
            _setLoading(false);
            return true;
          }
        } catch (e) {
          // Handle JSON parsing error
        }
      }

      _setLoading(false);
      return false;
    } catch (e) {
      _setLoading(false);
      return false;
    }
  }

  // Configuration
  Future<void> updateBaseUrl(String url) async {
    if (_apiService.isValidUrl(url)) {
      await _apiService.saveBaseUrl(url);
      notifyListeners();
    }
  }

  Future<void> updateEndpoints({
    required String refresh,
    required String checkIn,
    required String checkOut,
  }) async {
    await _apiService.saveEndpoints(
      refresh: refresh,
      checkIn: checkIn,
      checkOut: checkOut,
    );
    notifyListeners();
  }

  Future<void> updateUserAgent(String userAgent) async {
    await _apiService.saveUserAgent(userAgent);
    notifyListeners();
  }

  Future<void> updateAuthBearerToken(String token) async {
    await _apiService.saveAuthBearerToken(token);
    notifyListeners();
  }

  Future<void> resetToDefaults() async {
    await _apiService.resetToDefaults();
    notifyListeners();
  }

  // Logs
  void clearApiLogs() {
    ApiLogger.clearLogs();
    notifyListeners();
  }
}