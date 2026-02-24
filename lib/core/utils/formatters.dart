import 'dart:math';
import '../constants/app_constants.dart';

class Formatters {
  static String truncateToken(String token, {int maxLength = AppConstants.maxTokenDisplayLength}) {
    if (token.length <= maxLength) return token;
    return '${token.substring(0, maxLength)}...';
  }

  static Position getRandomNearbyPosition(double lat, double lng, double radiusInMeters) {
    final random = Random();

    final radiusInDegrees = radiusInMeters / 111320.0;

    final u = random.nextDouble();
    final v = random.nextDouble();
    final w = radiusInDegrees * sqrt(u);
    final t = 2 * pi * v;

    final deltaLat = w * cos(t);
    final deltaLng = w * sin(t) / cos(lat * pi / 180);

    final newLat = lat + deltaLat;
    final newLng = lng + deltaLng;

    return Position(
        latitude: newLat,
        longitude: newLng,
        timestamp: DateTime.now(),
        altitude: 0.0,
        accuracy: 0.0,
        heading: 0.0,
        speed: 0.0,
        speedAccuracy: 0.0,
        altitudeAccuracy: 0.0,
        headingAccuracy: 0.0
    );
  }

  static bool isValidUrl(String url) {
    try {
      final uri = Uri.parse(url);
      return uri.scheme == 'http' || uri.scheme == 'https';
    } catch (e) {
      return false;
    }
  }

  static String normalizeUrl(String url) {
    return url.endsWith('/') ? url : '$url/';
  }
}

class Position {
  final double latitude;
  final double longitude;
  final DateTime timestamp;
  final double altitude;
  final double accuracy;
  final double heading;
  final double speed;
  final double speedAccuracy;
  final double altitudeAccuracy;
  final double headingAccuracy;

  Position({
    required this.latitude,
    required this.longitude,
    required this.timestamp,
    required this.altitude,
    required this.accuracy,
    required this.heading,
    required this.speed,
    required this.speedAccuracy,
    required this.altitudeAccuracy,
    required this.headingAccuracy,
  });
}