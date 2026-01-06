import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import '../notifiers/speak_notifier.dart';
import '../../data/speaking_data.dart';

class SpeakChallengeScreen extends ConsumerWidget {
  const SpeakChallengeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(speakProvider);
    final notifier = ref.read(speakProvider.notifier);
    final currentLevel = state.currentLevel; // Lấy dữ liệu bài hiện tại

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("listen_speak".tr()),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 10),
            // 1. Thanh tiến trình (Level Progress)
            _buildProgressBar(state.currentIndex),

            const SizedBox(height: 30),

            // 2. Hình ảnh minh họa cho câu nói
            Expanded(
              flex: 3,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  color: Colors.grey[100],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: Image.asset(
                    currentLevel.image,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.image, size: 100, color: Colors.grey),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),

            // 3. Phụ đề (Hiện tiếng Anh + Tiếng Việt khi bật mắt)
            _buildSubtitleSection(state, currentLevel, notifier),

            const SizedBox(height: 20),

            // 4. Kết quả nhận diện giọng nói
            if (state.recognizedText.isNotEmpty)
              _buildRecognitionResult(state),

            const Spacer(),

            // 5. Các nút chức năng (Nghe mẫu)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _ActionButton(
                  icon: Icons.volume_up_rounded,
                  label: "listen".tr(),
                  color: Colors.blue,
                  onTap: () => notifier.playTarget(0.6),
                ),
                _ActionButton(
                  icon: Icons.slow_motion_video_rounded,
                  label: "slow".tr(),
                  color: Colors.orange,
                  onTap: () => notifier.playTarget(0.3),
                ),
              ],
            ),

            const SizedBox(height: 40),

            // 6. Khu vực điều khiển: Back - Mic - Next
            _buildControlBar(state, notifier),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // Widget Thanh tiến trình
  Widget _buildProgressBar(int currentIndex) {
    double progress = (currentIndex + 1) / SpeakingData.levels.length;
    return Column(
      children: [
        LinearProgressIndicator(
          value: progress,
          backgroundColor: Colors.grey[200],
          color: Colors.green,
          minHeight: 8,
          borderRadius: BorderRadius.circular(10),
        ),
        const SizedBox(height: 8),
        Text(
          "Level ${currentIndex + 1} / ${SpeakingData.levels.length}",
          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
        ),
      ],
    );
  }

  // Widget hiển thị câu mẫu
  Widget _buildSubtitleSection(state, currentLevel, notifier) {
    return Column(
      children: [
        Text(
          state.showSubtitle ? currentLevel.sentence : "**** ****",
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.indigo),
        ),
        if (state.showSubtitle)
          Text(
            currentLevel.translation,
            style: const TextStyle(fontSize: 18, color: Colors.blueGrey, fontStyle: FontStyle.italic),
          ),
        IconButton(
          icon: Icon(state.showSubtitle ? Icons.visibility : Icons.visibility_off, color: Colors.grey),
          onPressed: () => notifier.toggleSubtitle(),
        ),
      ],
    );
  }

  // Widget hiển thị điểm và text bé nói
  Widget _buildRecognitionResult(state) {
    return Column(
      children: [
        Text("${'you_said'.tr()}: ${state.recognizedText}",
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.grey, fontSize: 16)),
        const SizedBox(height: 5),
        Text("${state.score.toInt()}%",
            style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: state.score > 70 ? Colors.green : Colors.orange
            )),
      ],
    );
  }

  // Widget điều khiển chính
  Widget _buildControlBar(state, notifier) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Nút bài trước
        IconButton(
          onPressed: state.currentIndex > 0 ? () => notifier.prevLevel() : null,
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
        ),

        // Nút Mic trung tâm
        GestureDetector(
          onLongPressStart: (_) => notifier.startListening(),
          onLongPressEnd: (_) => notifier.stopListening(),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: EdgeInsets.all(state.isListening ? 25 : 20),
            decoration: BoxDecoration(
              color: state.isListening ? Colors.red : Colors.blue,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: (state.isListening ? Colors.red : Colors.blue).withOpacity(0.4),
                  blurRadius: 20,
                  spreadRadius: 5,
                )
              ],
            ),
            child: Icon(
                state.isListening ? Icons.mic : Icons.mic_none,
                color: Colors.white,
                size: 40
            ),
          ),
        ),

        // Nút bài tiếp theo (Chỉ cho bấm nếu đã đạt điểm nhất định hoặc hết danh sách)
        IconButton(
          onPressed: state.currentIndex < SpeakingData.levels.length - 1 ? () => notifier.nextLevel() : null,
          icon: const Icon(Icons.arrow_forward_ios_rounded),
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  const _ActionButton({required this.icon, required this.label, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(15),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 30),
          ),
          const SizedBox(height: 4),
          Text(label, style: TextStyle(color: color, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}