# Hướng dẫn sử dụng SQLite trong Flutter-ENGAPP

## 📝 Tóm tắt những thay đổi

### 1. **Database Layer (SQLite)**

#### DBHelper (`lib/core/data/db_helper.dart`)
- ✅ Tự động tạo database `kids_vocab.db` 
- ✅ Seed dữ liệu ban đầu (Animals, Fruits, Colors)
- ✅ Migration system (version 2)
- ✅ Thêm các cột: `isUserAdded`, `createdAt` để phân biệt từ vựng mặc định và do người dùng thêm

**Các phương thức chính:**
```dart
// Thêm từ vựng
await dbHelper.insertWord(item, 'Animals', imagePath: '/path/to/image');

// Lấy từ vựng theo category
List<GameItem> animals = await dbHelper.getWords('Animals');

// Xóa từ vựng
await dbHelper.deleteWord('item_id');

// Cập nhật từ vựng
await dbHelper.updateWord('item_id', nameEn: 'New Name');

// Tìm kiếm
List<GameItem> results = await dbHelper.searchWords('apple');
```

#### VocabRepository (`lib/core/data/vocab_repository.dart`)
- Repository pattern để tách biệt logic database
- API đơn giản, dễ sử dụng
- Tự động xử lý async operations

### 2. **Image Picker Service**

#### ImageService (`lib/core/services/image_service.dart`)
- ✅ Chọn hình ảnh từ thư viện
- ✅ Chụp ảnh bằng camera
- ✅ Tự động lưu vào thư mục app
- ✅ Hỗ trợ xóa hình ảnh

**Sử dụng:**
```dart
final imageService = ImageService();

// Chọn từ thư viện
String? path = await imageService.pickImageFromGallery();

// Chụp ảnh
String? path = await imageService.pickImageFromCamera();

// Xóa ảnh
await imageService.deleteImage(path);
```

### 3. **Vocabulary Feature - Cải tiến**

#### ✅ Đã fix:
- **Lưu thật sự vào SQLite** (không còn dùng GetStorage cho từ vựng mới)
- **Thêm được hình ảnh** khi tạo từ vựng mới
- **Dữ liệu không bị mất** sau khi tắt app
- **Tự động migrate** dữ liệu cũ từ GetStorage sang SQLite

#### VocabNotifier Updates:
```dart
// Thêm từ vựng với hình ảnh
await notifier.addNewWord(
  en: 'Apple',
  vi: 'Quả táo',
  ja: 'リンゴ',
  category: 'Fruits',
  imagePath: '/path/to/image', // Optional
);

// Xóa từ vựng
await notifier.deleteWord('item_id');

// Tìm kiếm
await notifier.searchWords('apple');
```

#### UI Updates (`vocab_list_screen.dart`):
- ✅ Dialog thêm từ vựng với image picker
- ✅ Chọn hình từ thư viện hoặc camera
- ✅ Preview hình ảnh trước khi lưu
- ✅ Nhập tiếng Nhật (optional)

#### VocabCard Updates:
- ✅ Hiển thị hình ảnh từ assets hoặc file local
- ✅ Error handling cho hình ảnh bị mất

### 4. **Các Features khác**

#### Spelling Game
- ✅ Đọc dữ liệu từ SQLite thay vì GlobalDataSource
- ✅ Auto-load animals từ database

#### Feeding Game
- ✅ Đọc dữ liệu từ SQLite
- ✅ Kết hợp Animals và Fruits từ database

### 5. **Dependencies mới**

```yaml
dependencies:
  sqflite: ^2.3.0
  path: ^1.9.0
  image_picker: ^1.0.7
  path_provider: ^2.1.2
```

## 🚀 Cách sử dụng

### Chạy app lần đầu
```bash
flutter pub get
flutter run
```

App sẽ tự động:
1. Tạo database
2. Seed dữ liệu mặc định
3. Migrate dữ liệu cũ từ GetStorage (nếu có)

### Thêm từ vựng mới
1. Vào màn hình Vocabulary
2. Nhấn nút ➕ (góc dưới phải)
3. Chọn hình ảnh (từ thư viện hoặc camera)
4. Nhập thông tin:
   - Chọn nhóm (Animals/Fruits/Colors)
   - Tiếng Anh
   - Tiếng Việt
   - Tiếng Nhật (tùy chọn)
5. Nhấn "Lưu vĩnh viễn"

### Xem dữ liệu trong database

**Sử dụng công cụ:**
- [DB Browser for SQLite](https://sqlitebrowser.org/)
- Android: `/data/data/com.example.flutter_kids_matching_game/databases/kids_vocab.db`
- iOS: `Library/Application Support/kids_vocab.db`

**Hoặc trong code:**
```dart
final dbHelper = DBHelper();
final allWords = await dbHelper.getWords('All');
print('Total words: ${allWords.length}');
```

## 🔧 Cấu trúc Database

### Table: `vocab`
| Column | Type | Description |
|--------|------|-------------|
| id | TEXT | Primary key |
| image | TEXT | Asset path hoặc file path |
| nameEn | TEXT | Tên tiếng Anh |
| nameJa | TEXT | Tên tiếng Nhật |
| nameVi | TEXT | Tên tiếng Việt |
| audioPath | TEXT | Đường dẫn audio (chưa dùng) |
| category | TEXT | Animals/Fruits/Colors |
| isUserAdded | INTEGER | 0=default, 1=user added |
| createdAt | INTEGER | Timestamp (milliseconds) |

## 📱 Permissions cần thiết

### Android (`android/app/src/main/AndroidManifest.xml`)
```xml
<uses-permission android:name="android.permission.CAMERA" />
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" 
    android:maxSdkVersion="32" />
```

### iOS (`ios/Runner/Info.plist`)
```xml
<key>NSCameraUsageDescription</key>
<string>Cần quyền camera để chụp ảnh cho từ vựng</string>
<key>NSPhotoLibraryUsageDescription</key>
<string>Cần quyền thư viện ảnh để chọn hình cho từ vựng</string>
```

## ⚠️ Lưu ý

1. **Dữ liệu cũ**: Tự động migrate từ GetStorage sang SQLite khi chạy lần đầu
2. **Hình ảnh**: Được lưu trong thư mục app (`vocab_images/`)
3. **Xóa app**: Sẽ mất toàn bộ database và hình ảnh
4. **Performance**: SQLite nhanh hơn GetStorage cho dữ liệu phức tạp

## 🎯 Tính năng tương lai có thể thêm

- [ ] Export/Import database (backup)
- [ ] Đồng bộ cloud (Firebase)
- [ ] Thêm audio recording cho từ vựng
- [ ] Category tùy chỉnh
- [ ] Thống kê học tập
- [ ] Flashcard mode
- [ ] Quiz mode với SQLite

## 🐛 Troubleshooting

### Lỗi "Table not found"
```dart
// Reset database
final dbHelper = DBHelper();
await dbHelper.close();
// Xóa file database và chạy lại app
```

### Hình ảnh không hiển thị
- Kiểm tra quyền camera/storage
- Kiểm tra đường dẫn file có tồn tại

### Database bị lỗi
```bash
# Xóa database và rebuild
flutter clean
flutter pub get
flutter run
```

## 📚 Tài liệu tham khảo

- [SQLite in Flutter](https://docs.flutter.dev/cookbook/persistence/sqlite)
- [Image Picker](https://pub.dev/packages/image_picker)
- [Path Provider](https://pub.dev/packages/path_provider)
