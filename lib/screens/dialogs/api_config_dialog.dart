import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_provider.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/config_row.dart';

class ApiConfigDialog extends StatefulWidget {
  const ApiConfigDialog({super.key});

  @override
  State<ApiConfigDialog> createState() => _ApiConfigDialogState();
}

class _ApiConfigDialogState extends State<ApiConfigDialog> {
  final _baseUrlController = TextEditingController();
  final _refreshEndpointController = TextEditingController();
  final _checkInEndpointController = TextEditingController();
  final _checkOutEndpointController = TextEditingController();
  final _userAgentController = TextEditingController();
  final _authBearerTokenController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final apiService = context.read<AppProvider>().apiService;
    _baseUrlController.text = apiService.baseUrl;
    _refreshEndpointController.text = apiService.refreshTokenEndpoint;
    _checkInEndpointController.text = apiService.checkInEndpoint;
    _checkOutEndpointController.text = apiService.checkOutEndpoint;
    _userAgentController.text = apiService.userAgent;
    _authBearerTokenController.text = apiService.authBearerToken;
  }

  @override
  void dispose() {
    _baseUrlController.dispose();
    _refreshEndpointController.dispose();
    _checkInEndpointController.dispose();
    _checkOutEndpointController.dispose();
    _userAgentController.dispose();
    _authBearerTokenController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final apiService = context.read<AppProvider>().apiService;

    return AlertDialog(
      title: const Text('⚙️ Cấu hình API'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Current Configuration Display
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Theme.of(context).colorScheme.outline.withValues()),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '📋 Cấu hình hiện tại:',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ConfigRow(label: '🌐 Base URL', value: apiService.baseUrl),
                  ConfigRow(label: '🔄 Refresh', value: apiService.refreshTokenEndpoint),
                  ConfigRow(label: '📥 Check-in', value: apiService.checkInEndpoint),
                  ConfigRow(label: '📤 Check-out', value: apiService.checkOutEndpoint),
                  ConfigRow(label: '🤖 User-Agent', value: apiService.userAgent),
                  ConfigRow(
                    label: '🔑 Auth Bearer',
                    value: apiService.authBearerToken.isEmpty ? '(trống)' : apiService.authBearerToken,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Edit Configuration Section
            Text(
              '✏️ Chỉnh sửa cấu hình:',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            CustomTextField(
              controller: _baseUrlController,
              labelText: 'Base URL',
              hintText: 'https://your-api-domain.com/',
              prefixIcon: Icons.link,
              keyboardType: TextInputType.url,
            ),
            const SizedBox(height: 12),

            CustomTextField(
              controller: _refreshEndpointController,
              labelText: 'Refresh Token Endpoint',
              hintText: 'api/login-ms/refreshTokenAdfs',
              prefixIcon: Icons.refresh,
            ),
            const SizedBox(height: 12),

            CustomTextField(
              controller: _checkInEndpointController,
              labelText: 'Check-in Endpoint',
              hintText: 'api/fpt-services-ms/public/working-onsite/check-in',
              prefixIcon: Icons.login,
            ),
            const SizedBox(height: 12),

            CustomTextField(
              controller: _checkOutEndpointController,
              labelText: 'Check-out Endpoint',
              hintText: 'api/fpt-services-ms/public/working-onsite/check-out',
              prefixIcon: Icons.logout,
            ),
            const SizedBox(height: 12),

            CustomTextField(
              controller: _userAgentController,
              labelText: 'User-Agent',
              hintText: 'MyFXRelease/1 CFNetwork/3860.300.31 Darwin/25.2.0',
              prefixIcon: Icons.smartphone,
            ),
            const SizedBox(height: 12),

            CustomTextField(
              controller: _authBearerTokenController,
              labelText: 'Auth Bearer Token',
              hintText: 'Nhập auth bearer token cho refresh token',
              prefixIcon: Icons.vpn_key,
              maxLines: 2,
            ),

            const SizedBox(height: 16),
            Text(
              '💡 Endpoint không cần bắt đầu bằng /\nVí dụ: api/fpt-services-ms/public/...',
              style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurfaceVariant),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => _resetAll(),
          style: TextButton.styleFrom(
            foregroundColor: Theme.of(context).colorScheme.error,
          ),
          child: const Text('Reset All'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Hủy'),
        ),
        ElevatedButton(
          onPressed: _saveAll,
          child: const Text('Lưu Tất Cả'),
        ),
      ],
    );
  }

  void _resetAll() {
    context.read<AppProvider>().resetToDefaults();
    Navigator.pop(context);
    _showSnackBar('🔄 Đã reset về cấu hình mặc định');
  }

  void _saveAll() {
    final baseUrl = _baseUrlController.text.trim();
    final refresh = _refreshEndpointController.text.trim();
    final checkIn = _checkInEndpointController.text.trim();
    final checkOut = _checkOutEndpointController.text.trim();
    final userAgent = _userAgentController.text.trim();
    final authBearerToken = _authBearerTokenController.text.trim();

    // Validate inputs
    if (baseUrl.isEmpty || refresh.isEmpty || checkIn.isEmpty || checkOut.isEmpty) {
      _showSnackBar('❌ Tất cả trường không được để trống!');
      return;
    }

    if (!context.read<AppProvider>().apiService.isValidUrl(baseUrl)) {
      _showSnackBar('❌ URL không hợp lệ! Phải bắt đầu bằng http:// hoặc https://');
      return;
    }

    // Save all
    context.read<AppProvider>().updateBaseUrl(baseUrl);
    context.read<AppProvider>().updateEndpoints(
      refresh: refresh,
      checkIn: checkIn,
      checkOut: checkOut,
    );
    context.read<AppProvider>().updateUserAgent(userAgent);
    context.read<AppProvider>().updateAuthBearerToken(authBearerToken);

    Navigator.pop(context);
    _showSnackBar('✅ Đã cập nhật tất cả cấu hình');
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}