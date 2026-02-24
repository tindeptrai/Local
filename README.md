# Check App - Flutter Refactored

Ứng dụng check-in/check-out với cấu trúc code sạch và UI hiện đại.

## 📁 Cấu trúc Project

```
lib/
├── main.dart                    # Entry point - chỉ setup app
├── core/                        # Core functionality
│   ├── constants/
│   │   ├── api_endpoints.dart   # API URLs và headers
│   │   └── app_constants.dart   # Constants và default values
│   ├── utils/
│   │   ├── api_logger.dart      # Logging API requests/responses
│   │   └── formatters.dart      # Utility functions
│   └── services/
│       ├── api_service.dart     # API calls logic
│       └── storage_service.dart # SharedPreferences wrapper
├── models/
│   └── member.dart              # Member data model
├── providers/
│   └── app_provider.dart        # State management (Provider)
├── screens/
│   ├── home_screen.dart         # Main screen
│   └── dialogs/                 # Dialog screens
│       ├── add_member_dialog.dart
│       ├── api_config_dialog.dart
│       ├── api_logs_dialog.dart
│       └── delete_member_dialog.dart
├── widgets/
│   ├── section_title.dart       # Reusable section title
│   ├── custom_text_field.dart   # Custom text field
│   └── config_row.dart          # Config display row
└── config/
    └── theme_config.dart        # App themes (Material 3)
```

## ✨ Tính năng

- ✅ **Check-in/Check-out**: Tự động tạo vị trí ngẫu nhiên trong bán kính 10m
- ✅ **Quản lý thành viên**: Thêm/xóa/chọn thành viên với token riêng
- ✅ **Auto refresh token**: Tự động refresh khi gặp lỗi 401
- ✅ **Cấu hình linh hoạt**: Tùy chỉnh API endpoints, User-Agent, Auth Bearer Token
- ✅ **Logging chi tiết**: Theo dõi tất cả API requests/responses
- ✅ **UI hiện đại**: Material Design 3 với theme sáng/tối

## 🚀 Cách chạy

```bash
flutter pub get
flutter run
```

## 📱 Screenshots

*(Thêm screenshots ở đây)*

## 🛠️ Tech Stack

- **Flutter**: Framework chính
- **Provider**: State management
- **HTTP**: API calls
- **SharedPreferences**: Local storage
- **Material Design 3**: UI/UX

## 📝 License

This project is private.