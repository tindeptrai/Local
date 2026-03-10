import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../widgets/section_title.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/single_selection_widget.dart';
import 'dialogs/api_config_dialog.dart';
import 'dialogs/api_logs_dialog.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _tokenController = TextEditingController();
  String _selectedAction = "check-in";

  @override
  void initState() {
    super.initState();
    // Controller sẽ được cập nhật trong builder
  }

  @override
  void dispose() {
    _tokenController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Check App"),
        elevation: 2,
        actions: [
          IconButton(
            icon: const Icon(Icons.api),
            tooltip: 'Cấu hình API',
            onPressed: () => _showApiConfigDialog(),
          ),
          IconButton(
            icon: const Icon(Icons.list_alt),
            tooltip: 'Xem API Logs',
            onPressed: () => _showApiLogsDialog(),
          ),
        ],
      ),
      body: Consumer<AppProvider>(
        builder: (context, provider, child) {
          // Cập nhật controller khi accessToken thay đổi
          if (_tokenController.text != provider.accessToken) {
            _tokenController.text = provider.accessToken;
          }

          return Stack(
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Token Management Section
                    const SectionTitle(title: "🔑 Access Token", icon: Icons.key),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: CustomTextField(
                          controller: _tokenController,
                          labelText: "Access Token",
                          prefixIcon: Icons.key,
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _tokenController.clear();
                              provider.updateAccessToken("");
                            },
                          ),
                          maxLines: 2,
                          onChanged: (value) => provider.updateAccessToken(value),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Actions Section
                    const SectionTitle(title: "⚡ Thao tác", icon: Icons.bolt),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            SizedBox(
                              width: double.infinity,
                              child: FilledButton.icon(
                                onPressed: provider.isLoading ? null : () => _refreshToken(),
                                icon: const Icon(Icons.refresh),
                                label: const Text("Refresh Token"),
                              ),
                            ),
                            const SizedBox(height: 16),
                            SingleSelectionWidget<String>(
                              title: "Chọn loại thao tác",
                              selectedValue: _selectedAction,
                              options: const [
                                SingleSelectionOption<String>(
                                  value: "check-in",
                                  label: "Check-in",
                                  icon: Icons.login,
                                ),
                                SingleSelectionOption<String>(
                                  value: "check-out",
                                  label: "Check-out",
                                  icon: Icons.logout,
                                ),
                              ],
                              onChanged: (value) {
                                setState(() {
                                  _selectedAction = value;
                                });
                              },
                            ),
                            const SizedBox(height: 12),
                            SizedBox(
                              width: double.infinity,
                              child: FilledButton.icon(
                                onPressed: (provider.isLoading || !provider.hasToken)
                                    ? null
                                    : () => _handleCheck(_selectedAction),
                                icon: Icon(
                                  _selectedAction == "check-in"
                                      ? Icons.login
                                      : Icons.logout,
                                ),
                                label: Text(
                                  _selectedAction == "check-in"
                                      ? "Thực hiện Check-in"
                                      : "Thực hiện Check-out",
                                ),
                                style: _selectedAction == "check-out"
                                    ? FilledButton.styleFrom(
                                        backgroundColor:
                                            Theme.of(context).colorScheme.error,
                                        foregroundColor:
                                            Theme.of(context).colorScheme.onError,
                                      )
                                    : null,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Loading overlay
              if (provider.isLoading)
                Container(
                  color: Colors.black.withValues(),
                  child: const Center(
                    child: Card(
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CircularProgressIndicator(),
                            SizedBox(height: 16),
                            Text('Đang xử lý...'),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  void _showApiConfigDialog() {
    showDialog(
      context: context,
      builder: (context) => const ApiConfigDialog(),
    );
  }

  void _showApiLogsDialog() {
    showDialog(
      context: context,
      builder: (context) => const ApiLogsDialog(),
    );
  }

  Future<void> _refreshToken() async {
    final success = await context.read<AppProvider>().refreshToken();
    if (mounted) {
      _showSnackBar(
        success
            ? "🔁 Token đã được cập nhật và lưu!"
            : "❌ Refresh token thất bại!",
      );
    }
  }

  Future<void> _handleCheck(String type) async {
    final provider = context.read<AppProvider>();
    final result = type == "check-in"
        ? await provider.checkIn()
        : await provider.checkOut();
    if (mounted) {
      final message = result['message'] as String;
      _showSnackBar(message);

      // Hiển thị thông báo đặc biệt nếu có auto refresh
      if (result['autoRefreshed'] == true) {
        Future.delayed(const Duration(seconds: 1), () {
          if (mounted) {
            _showSnackBar("🔄 Đã tự động refresh token thành công!");
          }
        });
      }
    }
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
