import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

/// Service để xử lý việc chọn và lưu hình ảnh
class ImageService {
  final ImagePicker _picker = ImagePicker();

  /// Chọn hình ảnh từ thư viện
  Future<String?> pickImageFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );

      if (image != null) {
        return await _saveImageToAppDirectory(image);
      }
      return null;
    } catch (e) {
      print('Error picking image: $e');
      return null;
    }
  }

  /// Chọn hình ảnh từ camera
  Future<String?> pickImageFromCamera() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );

      if (image != null) {
        return await _saveImageToAppDirectory(image);
      }
      return null;
    } catch (e) {
      print('Error taking photo: $e');
      return null;
    }
  }

  /// Lưu hình ảnh vào thư mục ứng dụng
  Future<String> _saveImageToAppDirectory(XFile image) async {
    final appDir = await getApplicationDocumentsDirectory();
    final fileName = 'vocab_${DateTime.now().millisecondsSinceEpoch}${path.extension(image.path)}';
    final savedPath = path.join(appDir.path, 'vocab_images', fileName);

    // Tạo thư mục nếu chưa có
    final directory = Directory(path.dirname(savedPath));
    if (!await directory.exists()) {
      await directory.create(recursive: true);
    }

    // Copy file vào thư mục ứng dụng
    final File sourceFile = File(image.path);
    await sourceFile.copy(savedPath);

    return savedPath;
  }

  /// Xóa hình ảnh đã lưu
  Future<void> deleteImage(String imagePath) async {
    try {
      final file = File(imagePath);
      if (await file.exists()) {
        await file.delete();
      }
    } catch (e) {
      print('Error deleting image: $e');
    }
  }

  /// Kiểm tra xem đường dẫn có phải là file local không
  bool isLocalFile(String imagePath) {
    return !imagePath.startsWith('assets/') && File(imagePath).existsSync();
  }
}
