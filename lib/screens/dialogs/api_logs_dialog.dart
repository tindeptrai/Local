import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_provider.dart';

class ApiLogsDialog extends StatelessWidget {
  const ApiLogsDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final logs = context.watch<AppProvider>().apiLogs;

    return AlertDialog(
      title: const Text('📋 API Logs'),
      content: SizedBox(
        width: double.maxFinite,
        height: 400,
        child: logs.isEmpty
            ? const Center(child: Text('Chưa có log nào'))
            : ListView.builder(
                itemCount: logs.length,
                itemBuilder: (context, index) {
                  final log = logs[logs.length - 1 - index]; // Hiển thị log mới nhất trước
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Text(
                      log,
                      style: const TextStyle(
                        fontSize: 12,
                        fontFamily: 'monospace',
                        color: Colors.black87,
                      ),
                    ),
                  );
                },
              ),
      ),
      actions: [
        TextButton(
          onPressed: () => context.read<AppProvider>().clearApiLogs(),
          style: TextButton.styleFrom(
            foregroundColor: Theme.of(context).colorScheme.error,
          ),
          child: const Text('Xóa logs'),
        ),
        ElevatedButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Đóng'),
        ),
      ],
    );
  }
}