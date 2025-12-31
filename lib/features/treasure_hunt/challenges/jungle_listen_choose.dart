import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_kids_matching_game/features/settings/presentation/notifiers/settings_notifier.dart';
import 'package:flutter_kids_matching_game/core/constants/setting_choices.dart'; // Import quan trọng
import 'package:flutter_kids_matching_game/features/treasure_hunt/domain/challenge_models.dart';

class JungleListenChoose extends ConsumerStatefulWidget {
  final ListenChooseData data; // Đã đổi sang dùng data
  final VoidCallback onCompleted;

  // Constructor mới khớp với ChallengeScreen
  const JungleListenChoose({Key? key, required this.data, required this.onCompleted}) : super(key: key);

  @override
  ConsumerState<JungleListenChoose> createState() => _JungleListenChooseState();
}

class _JungleListenChooseState extends ConsumerState<JungleListenChoose> {
  final FlutterTts flutterTts = FlutterTts();
  final AudioPlayer sfxPlayer = AudioPlayer();
  bool completed = false;
  int selectedIndex = -1;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 500), _playQuestion);
  }

  void _playQuestion() async {
    String lang = ref.read(settingsNotifierProvider).selectedLanguage.languageCode;
    await flutterTts.setLanguage(lang == 'ja' ? "ja-JP" : "en-US");
    await flutterTts.speak(widget.data.correctItem.name(lang));
  }

  void _playSFX(bool win) async {
    sfxPlayer.stop();
    sfxPlayer.play(AssetSource(win ? 'audio/win.mp3' : 'audio/lose.mp3'));
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(widget.langCode == 'ja' ? '聞いて選ぼう' : 'Listen & Find', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.green)),
            const SizedBox(height: 10),
            Text(widget.langCode == 'ja' ? 'スピーカーをタップして、正しい動物を選んでね！' : 'Tap the speaker, then pick the animal!', style: const TextStyle(fontSize: 16, color: Colors.black54)),
            const SizedBox(height: 30),
            GestureDetector(
              onTap: playSound,
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [BoxShadow(color: Colors.green.withOpacity(0.3), blurRadius: 15, spreadRadius: 5)]),
                child: const Icon(Icons.volume_up_rounded, size: 60, color: Colors.green),
              ),
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: 320,
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 20, mainAxisSpacing: 20),
                itemCount: (q['options'] as List).length,
                itemBuilder: (context, i) {
                  final img = q['options'][i];
                  final isCorrect = img == q['image'];
                  final isSelected = selected == i;
                  return GestureDetector(
                    onTap: completed ? null : () {
                      setState(() => selected = i);
                      if (isCorrect) {
                        _playSFX(true);
                        setState(() => completed = true);
                      } else {
                        _playSFX(false);
                        Future.delayed(const Duration(milliseconds: 700), () {
                          if (mounted) setState(() => selected = -1);
                        });
                      }
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected ? (isCorrect ? Colors.green : Colors.red) : Colors.transparent,
                          width: 4,
                        ),
                        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)],
                      ),
                      padding: const EdgeInsets.all(10),
                      child: Image.asset(img, fit: BoxFit.contain),
                    ),
                  );
                },
              ),
            ),
            if (completed)
              Padding(
                padding: const EdgeInsets.only(top: 40),
                child: ElevatedButton.icon(
                  onPressed: widget.onCompleted,
                  icon: const Icon(Icons.arrow_forward), label: Text(widget.langCode == 'ja' ? '次へ' : 'Next'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green, padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15)),
                ),
              ),
          ],
        ),
      ),
    );