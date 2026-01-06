import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:flutter_kids_matching_game/core/data/global_data_source.dart';
import 'package:flutter_kids_matching_game/core/domain/entities/game_item.dart';
import 'package:flutter_kids_matching_game/features/settings/presentation/notifiers/settings_notifier.dart';
import 'vocab_state.dart';
import 'package:flutter_kids_matching_game/core/constants/setting_choices.dart';
import 'package:get_storage/get_storage.dart';

class VocabNotifier extends AutoDisposeNotifier<VocabState> {
  final FlutterTts _tts = FlutterTts();
  late String _currentLangCode;
  final _storage = GetStorage();
  final String _storageKey = 'user_added_words';

  @override
  VocabState build() {
    final settings = ref.watch(settingsNotifierProvider);
    _currentLangCode = settings.selectedLanguage.languageCode;
    _initTts();

    // Tự động nạp dữ liệu gộp khi khởi tạo
    return VocabState(vocabList: _loadCombinedData('All'));
  }

  // --- LOGIC GỘP DỮ LIỆU TĨNH VÀ DỮ LIỆU ĐÃ LƯU ---
  List<GameItem> _loadCombinedData(String category) {
    // 1. Lấy dữ liệu từ file GlobalDataSource
    List<GameItem> baseList;
    if (category == 'Animals') baseList = List.from(GlobalDataSource.animals);
    else if (category == 'Fruits') baseList = List.from(GlobalDataSource.fruits);
    else if (category == 'Colors') baseList = List.from(GlobalDataSource.colors);
    else baseList = List.from(GlobalDataSource.getAll());

    // 2. Lấy dữ liệu từ bộ nhớ máy (GetStorage)
    final List<dynamic>? storedWords = _storage.read(_storageKey);
    if (storedWords != null) {
      final userWords = storedWords
          .map((e) => GameItem.fromJson(Map<String, dynamic>.from(e)))
          .where((item) => category == 'All' || item.id.contains(category.toLowerCase())) // Lọc theo category lưu trong ID
          .toList();

      return [...userWords.reversed, ...baseList]; // Ưu tiên từ mới lên đầu
    }

    return baseList;
  }

  void setCategory(String category) {
    state = state.copyWith(
        vocabList: _loadCombinedData(category),
        selectedCategory: category,
        selectedVocab: null
    );
  }

  // --- LOGIC LƯU VĨNH VIỄN ---
  void addNewWord({
    required String en,
    required String vi,
    required String ja,
    required String category
  }) {
    // Tạo item mới (ID chứa category để dễ lọc)
    final newItem = GameItem(
      id: '${category.toLowerCase()}_${DateTime.now().millisecondsSinceEpoch}',
      image: 'assets/images/logos/logo1.png',
      nameEn: en,
      nameVi: vi,
      nameJa: ja,
    );

    // 1. Ghi vào GetStorage (Lưu vào file dữ liệu của máy)
    final List<dynamic> currentList = _storage.read(_storageKey) ?? [];
    currentList.add(newItem.toJson());
    _storage.write(_storageKey, currentList);

    // 2. Đồng thời cập nhật vào mảng tĩnh trong GlobalDataSource để nhất quán trong phiên chạy này
    if (category == 'Animals') GlobalDataSource.animals.add(newItem);
    else if (category == 'Fruits') GlobalDataSource.fruits.add(newItem);
    else if (category == 'Colors') GlobalDataSource.colors.add(newItem);

    // 3. Cập nhật giao diện
    setCategory(state.selectedCategory);
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