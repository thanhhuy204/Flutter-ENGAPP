import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:string_similarity/string_similarity.dart';
import 'speak_state.dart';
import '../../data/speaking_data.dart';
import '../../domain/speaking_level.dart'; // Đảm bảo đã import model

class SpeakNotifier extends AutoDisposeNotifier<SpeakState> {
  final SpeechToText _speechToText = SpeechToText();
  final FlutterTts _tts = FlutterTts();

  @override
  SpeakState build() {
    _initSpeech();

    // 1. Lấy danh sách gốc và xáo trộn (Random) ngay khi khởi tạo
    final List<SpeakingLevel> randomList = List.from(SpeakingData.levels)..shuffle();

    // 2. Trả về state với danh sách đã được xáo trộn
    return SpeakState(shuffledLevels: randomList);
  }

  void _initSpeech() async {
    await _speechToText.initialize();
    await _tts.setLanguage("en-US");
  }

  void playTarget(double rate) async {
    await _tts.setSpeechRate(rate);
    // Luôn đọc câu mẫu từ danh sách đã xáo trộn (state.currentLevel)
    await _tts.speak(state.currentLevel.sentence);
  }

  // --- LOGIC ĐIỀU HƯỚNG BÀI HỌC ---
  void nextLevel() {
    // Kiểm tra dựa trên độ dài của danh sách shuffledLevels
    if (state.currentIndex < state.shuffledLevels.length - 1) {
      state = state.copyWith(
        currentIndex: state.currentIndex + 1,
        recognizedText: "",
        score: 0.0,
      );
    } else {
      // Nếu đã hết 15 câu, tiến hành xáo trộn lại một bộ mới (Vòng lặp vô tận)
      final List<SpeakingLevel> reShuffled = List.from(SpeakingData.levels)..shuffle();
      state = state.copyWith(
        shuffledLevels: reShuffled,
        currentIndex: 0,
        recognizedText: "",
        score: 0.0,
      );
    }
  }

  void prevLevel() {
    if (state.currentIndex > 0) {
      state = state.copyWith(
        currentIndex: state.currentIndex - 1,
        recognizedText: "",
        score: 0.0,
      );
    }
  }

  // --- LOGIC CHẤM ĐIỂM ---
  void _calculateScore() {
    // So sánh với câu mẫu của LEVEL HIỆN TẠI trong danh sách xáo trộn
    double similarity = state.currentLevel.sentence
        .toLowerCase()
        .similarityTo(state.recognizedText.toLowerCase());

    state = state.copyWith(score: similarity * 100);
  }

  // --- GHI ÂM ---
  void startListening() async {
    bool available = await _speechToText.initialize();
    if (available) {
      // Ngắt âm thanh đang đọc (nếu có) trước khi ghi âm
      await _tts.stop();

      state = state.copyWith(isListening: true, recognizedText: "...");
      _speechToText.listen(
        onResult: (result) {
          state = state.copyWith(recognizedText: result.recognizedWords);
          if (result.finalResult) stopListening();
        },
        localeId: "en-US", // Ép nhận diện tiếng Anh
      );
    }
  }

  void stopListening() async {
    await _speechToText.stop();
    state = state.copyWith(isListening: false);
    _calculateScore();
  }

  void toggleSubtitle() => state = state.copyWith(showSubtitle: !state.showSubtitle);
}

final speakProvider = AutoDisposeNotifierProvider<SpeakNotifier, SpeakState>(() => SpeakNotifier());