import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:flutter_kids_matching_game/core/data/vocab_repository.dart';
import 'package:flutter_kids_matching_game/core/domain/entities/game_item.dart';
import 'package:flutter_kids_matching_game/features/settings/presentation/notifiers/settings_notifier.dart';
import 'vocab_state.dart';
import 'package:flutter_kids_matching_game/core/constants/setting_choices.dart';
import 'package:get_storage/get_storage.dart';

class VocabNotifier extends AutoDisposeNotifier<VocabState> {
  final FlutterTts _tts = FlutterTts();
  late String _currentLangCode;
  final _repository = VocabRepository();
  final _storage = GetStorage();
  final String _storageKey = 'user_added_words';

  @override
  VocabState build() {
    final settings = ref.watch(settingsNotifierProvider);
    _currentLangCode = settings.selectedLanguage.languageCode;
    _initTts();

    // Load data từ SQLite và migrate data cũ từ GetStorage (nếu có)
    _initializeData();
    return VocabState(vocabList: const []);
  }

  // Khởi tạo và migrate dữ liệu
  Future<void> _initializeData() async {
    // Migrate data từ GetStorage sang SQLite (chỉ chạy 1 lần)
    await _migrateFromGetStorage();
    
    // Load data từ SQLite
    await setCategory('All');
  }

  // Migrate dữ liệu cũ từ GetStorage sang SQLite
  Future<void> _migrateFromGetStorage() async {
    final migrationKey = 'vocab_migrated_to_sqlite';
    final isMigrated = _storage.read(migrationKey) ?? false;

    if (!isMigrated) {
      final List<dynamic>? storedWords = _storage.read(_storageKey);
      if (storedWords != null && storedWords.isNotEmpty) {
        for (var wordData in storedWords) {
          try {
            final item = GameItem.fromJson(Map<String, dynamic>.from(wordData));
            // Xác định category từ ID cũ
            String category = 'Animals';
            if (item.id.contains('fruits')) category = 'Fruits';
            else if (item.id.contains('colors')) category = 'Colors';

            await _repository.addVocab(
              id: item.id,
              nameEn: item.nameEn,
              nameVi: item.nameVi,
              nameJa: item.nameJa,
              category: category,
              imagePath: item.image,
            );
          } catch (e) {
            print('Error migrating word: $e');
          }
        }
      }
      // Đánh dấu đã migrate
      _storage.write(migrationKey, true);
    }
  }

  // Load data từ SQLite
  Future<void> setCategory(String category) async {
    final vocabList = await _repository.getVocabByCategory(category);
    state = state.copyWith(
      vocabList: vocabList,
      selectedCategory: category,
      selectedVocab: null,
    );
  }

  // Thêm từ vựng mới vào SQLite
  Future<void> addNewWord({
    required String en,
    required String vi,
    required String ja,
    required String category,
    String? imagePath,
  }) async {
    if (!_repository.isSQLiteSupported) {
      // Web không hỗ trợ thêm từ vựng
      return;
    }

    // Tạo ID unique
    final id = '${category.toLowerCase()}_${DateTime.now().millisecondsSinceEpoch}';

    // Lưu vào SQLite
    await _repository.addVocab(
      id: id,
      nameEn: en,
      nameVi: vi,
      nameJa: ja,
      category: category,
      imagePath: imagePath,
    );

    // Refresh UI
    await setCategory(state.selectedCategory);
  }

  // Xóa từ vựng
  Future<void> deleteWord(String id) async {
    await _repository.deleteVocab(id);
    await setCategory(state.selectedCategory);
  }

  // Tìm kiếm từ vựng
  Future<void> searchWords(String keyword) async {
    if (keyword.isEmpty) {
      await setCategory(state.selectedCategory);
      return;
    }
    final results = await _repository.searchVocab(keyword);
    state = state.copyWith(vocabList: results, selectedVocab: null);
  }

  // --- TTS LOGIC ---
  Future<void> _initTts() async {
    if (_currentLangCode == 'ja') await _tts.setLanguage("ja-JP");
    else if (_currentLangCode == 'vi') await _tts.setLanguage("vi-VN");
    else await _tts.setLanguage("en-US");

    await _tts.setPitch(1.0);
    await _tts.setSpeechRate(0.8); // Đọc chậm cho bé dễ nghe
  }

  Future<void> speakWord(String text) async {
    try {
      await _tts.stop();
      await _tts.speak(text);
    } catch (e) {
      print("TTS Error: $e");
    }
  }

  void onWordTap(GameItem item, WidgetRef ref) {
    state = state.copyWith(selectedVocab: item);
    speakWord(item.name(_currentLangCode));
  }
}

final vocabNotifierProvider = AutoDisposeNotifierProvider<VocabNotifier, VocabState>(() {
  return VocabNotifier();
});