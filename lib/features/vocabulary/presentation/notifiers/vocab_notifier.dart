import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tts/flutter_tts.dart'; // Sử dụng flutter_tts
import 'package:flutter_kids_matching_game/features/vocabulary/data/vocab_data.dart';
import 'package:flutter_kids_matching_game/features/vocabulary/presentation/notifiers/vocab_state.dart';
import 'package:flutter_kids_matching_game/features/vocabulary/domain/vocab_item.dart';

class VocabNotifier extends AutoDisposeNotifier<VocabState> {
  final FlutterTts _tts = FlutterTts();

  @override
  VocabState build() {
    _initTts();
    return VocabState(vocabList: VocabData.animals);
  }

  // Khởi tạo cấu hình giọng đọc
  Future<void> _initTts() async {
    await _tts.setLanguage("en-US"); // Ngôn ngữ tiếng Anh
    await _tts.setPitch(1.0);        // Độ cao giọng nói
    await _tts.setSpeechRate(0.5);   // Tốc độ đọc (0.5 cho bé dễ nghe)
  }

  // Hàm thực hiện việc đọc chữ
  Future<void> speakWord(String text) async {
    try {
      await _tts.stop(); // Dừng nếu đang đọc từ trước đó
      await _tts.speak(text);
    } catch (e) {
      print("Lỗi TTS: $e");
    }
  }

  void onWordTap(VocabItem item, WidgetRef ref) {
    state = state.copyWith(selectedVocab: item);
    // Máy sẽ tự động đọc từ vựng vừa nhấn
    speakWord(item.word);
  }
}

final vocabNotifierProvider = AutoDisposeNotifierProvider<VocabNotifier, VocabState>(() {
  return VocabNotifier();
});