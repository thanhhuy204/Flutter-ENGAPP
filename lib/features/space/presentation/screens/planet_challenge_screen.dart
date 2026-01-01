import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:audioplayers/audioplayers.dart';

import '../notifiers/space_notifier.dart';
import '../../domain/entities/planet_challenge.dart';

class PlanetChallengeScreen extends ConsumerStatefulWidget {
  final SpacePlanet planet;

  const PlanetChallengeScreen({
    super.key,
    required this.planet,
  });

  @override
  ConsumerState<PlanetChallengeScreen> createState() =>
      _PlanetChallengeScreenState();
}

class _PlanetChallengeScreenState
    extends ConsumerState<PlanetChallengeScreen> {
  final AudioPlayer sfxPlayer = AudioPlayer();

  int currentQuestionIndex = 0;
  bool isCorrect = false;
  bool showTargetWord = false;
  String? selectedAnswer;

  String displayWord = '';
  String scrambledWord = '';

  @override
  void initState() {
    super.initState();
    _setupQuestion();
  }

  void _setupQuestion() {
    final q = widget.planet.questions[currentQuestionIndex];

    isCorrect = false;
    showTargetWord = false;
    selectedAnswer = null;

    if (widget.planet.skill == SpaceSkill.missingLetter) {
      final hideChar = q.answer ?? q.targetWord[1];
      displayWord = q.targetWord.replaceFirst(hideChar, '_');
    } else if (widget.planet.skill == SpaceSkill.scramble) {
      final chars = q.targetWord.split('')..shuffle();
      scrambledWord = chars.join();
    } else {
      displayWord = q.targetWord;
    }

    if (widget.planet.skill == SpaceSkill.listening) {
      Future.microtask(() {
        ref.read(spaceProvider.notifier).speak(q.targetWord, 'en');
      });
    }

    setState(() {});
  }

  Future<void> _handleCorrect() async {
    if (isCorrect) return;
    isCorrect = true;
    showTargetWord = true;

    await sfxPlayer.play(AssetSource('audio/win.mp3'), volume: 0.3);
    setState(() {});

    Future.delayed(const Duration(milliseconds: 1500), _nextQuestion);
  }

  void _handleWrong() {
    sfxPlayer.play(AssetSource('audio/lose.mp3'), volume: 0.3);
  }

  void _nextQuestion() {
    if (currentQuestionIndex < widget.planet.questions.length - 1) {
      currentQuestionIndex++;
      _setupQuestion();
    } else {
      ref.read(spaceProvider.notifier).completeLevel(widget.planet.level);
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    sfxPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final q = widget.planet.questions[currentQuestionIndex];

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/spaces/space_single.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              _buildProgressBar(),
              const SizedBox(height: 8),
              _buildRevealWord(q.targetWord),
              const SizedBox(height: 8),
              Expanded(child: _buildSkillContent(q)),
            ],
          ),
        ),
      ),
    );
  }

  // ================= UI =================

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios,
                color: Colors.white, size: 18),
            onPressed: () => Navigator.pop(context),
          ),
          Text(
            "${widget.planet.name} "
                "(${currentQuestionIndex + 1}/${widget.planet.questions.length})",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: LinearProgressIndicator(
        value:
        (currentQuestionIndex + 1) / widget.planet.questions.length,
        backgroundColor: Colors.white24,
        valueColor:
        const AlwaysStoppedAnimation(Colors.cyanAccent),
      ),
    );
  }

  /// 🔹 TARGET WORD (ẨN → HIỆN)
  Widget _buildRevealWord(String word) {
    return AnimatedOpacity(
      opacity: showTargetWord ? 1 : 0,
      duration: const Duration(milliseconds: 300),
      child: AnimatedScale(
        scale: showTargetWord ? 1 : 0.85,
        duration: const Duration(milliseconds: 300),
        child: Container(
          padding:
          const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.black54,
            borderRadius: BorderRadius.circular(16),
          ),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              word.toUpperCase(),
              style: const TextStyle(
                fontSize: 26,
                color: Colors.white,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ================= SKILL SWITCH =================

  Widget _buildSkillContent(SpaceQuestion q) {
    switch (widget.planet.skill) {
      case SpaceSkill.listening:
        return _buildListening(q);
      case SpaceSkill.missingLetter:
        return _tapToConfirm(displayWord);
      case SpaceSkill.scramble:
        return _tapToConfirm(scrambledWord);
      case SpaceSkill.reading:
      case SpaceSkill.matching:
        return _tapToConfirm(q.targetWord);
    }
  }

  // ================= LISTENING =================

  Widget _buildListening(SpaceQuestion q) {
    return Column(
      children: [
        const SizedBox(height: 8),
        IconButton(
          icon: const Icon(Icons.volume_up,
              size: 56, color: Colors.cyanAccent),
          onPressed: () =>
              ref.read(spaceProvider.notifier).speak(q.targetWord, 'en'),
        ),
        const SizedBox(height: 8),
        if (q.imageOptions != null)
          Expanded(child: _buildImageChoices(q)),
      ],
    );
  }

  Widget _buildImageChoices(SpaceQuestion q) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 360, // 👈 cố định chiều rộng như điện thoại
        ),
        child: GridView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: q.imageOptions!.length,
          gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // 2 trên – 2 dưới
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1,
          ),
          itemBuilder: (_, i) {
            final img = q.imageOptions![i];
            final isSelected = selectedAnswer == img;

            Color borderColor = Colors.cyanAccent;
            if (isSelected) {
              borderColor =
              img == q.correctImage ? Colors.green : Colors.red;
            }

            return GestureDetector(
              onTap: isCorrect
                  ? null
                  : () {
                selectedAnswer = img;
                if (img == q.correctImage) {
                  _handleCorrect();
                } else {
                  _handleWrong();
                  setState(() {});
                }
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: borderColor, width: 3),
                ),
                child: Image.asset(
                  'assets/images/animals/$img.png',
                  fit: BoxFit.contain,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _tapToConfirm(String text) {
    return Center(
      child: GestureDetector(
        onTap: _handleCorrect,
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            text.toUpperCase(),
            style: const TextStyle(
              fontSize: 36,
              color: Colors.orangeAccent,
            ),
          ),
        ),
      ),
    );
  }
}
