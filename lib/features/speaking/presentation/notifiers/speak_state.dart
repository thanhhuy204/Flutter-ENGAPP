import '../../domain/speaking_level.dart';

class SpeakState {
  final List<SpeakingLevel> shuffledLevels; // Danh sách đã xáo trộn
  final int currentIndex;
  final String recognizedText;
  final bool isListening;
  final double score;
  final bool showSubtitle;

  SpeakState({
    required this.shuffledLevels,
    this.currentIndex = 0,
    this.recognizedText = "",
    this.isListening = false,
    this.score = 0.0,
    this.showSubtitle = false,
  });

  // Lấy câu hiện tại từ danh sách đã xáo trộn
  SpeakingLevel get currentLevel => shuffledLevels[currentIndex];

  SpeakState copyWith({
    List<SpeakingLevel>? shuffledLevels,
    int? currentIndex,
    String? recognizedText,
    bool? isListening,
    double? score,
    bool? showSubtitle,
  }) {
    return SpeakState(
      shuffledLevels: shuffledLevels ?? this.shuffledLevels,
      currentIndex: currentIndex ?? this.currentIndex,
      recognizedText: recognizedText ?? this.recognizedText,
      isListening: isListening ?? this.isListening,
      score: score ?? this.score,
      showSubtitle: showSubtitle ?? this.showSubtitle,
    );
  }
}