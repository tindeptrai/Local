import 'dart:convert';
import 'dart:math';
import '../constants/app_constants.dart';

class ApiLogger {
  static List<String> _logs = [];

  static void addLog(String log) {
    final timestamp = DateTime.now().toString();
    _logs.add("[$timestamp] $log");

    // Giữ chỉ số log gần nhất
    if (_logs.length > AppConstants.maxApiLogs) {
      _logs.removeAt(0);
    }
  }

  static List<String> getLogs() => _logs;

  static void clearLogs() => _logs.clear();

  static String formatJson(String jsonString) {
    try {
      final dynamic jsonData = jsonDecode(jsonString);
      const JsonEncoder encoder = JsonEncoder.withIndent('   ');
      return encoder.convert(jsonData);
    } catch (e) {
      return '   $jsonString';
    }
  }

  static String formatRequestLog({
    required DateTime startTime,
    required Uri uri,
    required String method,
    required Map<String, String> headers,
    String? body,
  }) {
    final headersLog = headers.entries
        .map((entry) => "   ${entry.key}: ${entry.value}")
        .join("\n");

    return '''
🚀 ──────────────────────────────────────────────────────────────────────
📡 API REQUEST
──────────────────────────────────────────────────────────────────────
⏰ Time: ${startTime.toString()}
🌐 URL: $uri
📝 Method: $method

📋 HEADERS:
$headersLog

📦 BODY:
${body != null ? formatJson(body) : '   (empty)'}
──────────────────────────────────────────────────────────────────────''';
  }

  static String formatResponseLog({
    required DateTime startTime,
    required int statusCode,
    required Map<String, String> headers,
    required String body,
    String type = "",
  }) {
    final endTime = DateTime.now();
    final duration = endTime.difference(startTime);

    final headersLog = headers.entries
        .map((entry) => "   ${entry.key}: ${entry.value}")
        .join("\n");

    final statusIcon = statusCode >= 200 && statusCode < 300 ? "✅" : "❌";
    final statusColor = statusCode >= 200 && statusCode < 300 ? "SUCCESS" : "ERROR";

    return '''
📥 ──────────────────────────────────────────────────────────────────────
📡 API RESPONSE${type.isNotEmpty ? ' ($type)' : ''}
──────────────────────────────────────────────────────────────────────
⏱️  Duration: ${duration.inMilliseconds}ms
📊 Status Code: $statusIcon $statusCode

📋 RESPONSE HEADERS:
$headersLog

📦 RESPONSE BODY:
${formatJson(body)}
──────────────────────────────────────────────────────────────────────
🏁 REQUEST COMPLETED${type.isNotEmpty ? ' ($type)' : ''}
''';
  }

  static String formatErrorLog({
    required DateTime startTime,
    required Object error,
    String type = "",
  }) {
    final endTime = DateTime.now();
    final duration = endTime.difference(startTime);

    final errorType = error.runtimeType;
    final errorMessage = error.toString();

    return '''
💥 ──────────────────────────────────────────────────────────────────────
🚨 API ERROR OCCURRED${type.isNotEmpty ? ' ($type)' : ''}
──────────────────────────────────────────────────────────────────────
⏱️  Duration: ${duration.inMilliseconds}ms
❌ Error Type: $errorType
📝 Error Message: $errorMessage

🔧 STACK TRACE:
${StackTrace.current.toString().split('\n').take(5).join('\n   ')}
──────────────────────────────────────────────────────────────────────
🏁 ERROR LOGGED${type.isNotEmpty ? ' ($type)' : ''}
''';
  }
}