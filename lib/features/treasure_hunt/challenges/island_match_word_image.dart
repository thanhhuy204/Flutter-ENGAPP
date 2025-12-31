import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:easy_localization/easy_localization.dart';
import 'dart:math';
import '../data/island_quiz_data.dart';
import '../domain/entities/challenge_question.dart';

class IslandMatchWordImage extends StatefulWidget {
  final int questionIndex;
  final VoidCallback onCompleted;
  const IslandMatchWordImage({Key? key, required this.questionIndex, required this.onCompleted}) : super(key: key);

  @override
  State<IslandMatchWordImage> createState() => _IslandMatchWordImageState();
}

class _IslandMatchWordImageState extends State<IslandMatchWordImage> with SingleTickerProviderStateMixin {
  final AudioPlayer bgmPlayer = AudioPlayer();
  final AudioPlayer sfxPlayer = AudioPlayer();
  late AnimationController _shakeController;

  // Game state
  int currentRound = 1;
  int maxRounds = 5;
  late int maxHP;
  late int currentHP;
  late String bossImage;

  bool isWrongAnim = false;
  bool isHealingAnim = false;
  bool isRoundVictory = false;
  bool isGameCompleted = false;

  late IslandQuizQuestion currentQuestion;
  final Random _random = Random();
  List<int> usedQuestionIndices = [];
  late List<IslandQuizQuestion> questionPool;

  @override
  void initState() {
    super.initState();
    questionPool = IslandQuizData.getQuestions();
    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _playBossBGM(); // Play One Piece music right away
    _startRound(1);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    questionPool = IslandQuizData.getQuestions();
  }

  void _playBGM() async {
    await bgmPlayer.setReleaseMode(ReleaseMode.loop);
    await bgmPlayer.setVolume(0.3);
    await bgmPlayer.play(AssetSource('audio/bgm.mp3'));
  }

  void _playSFX(bool isWin) async {
    await sfxPlayer.stop();
    await sfxPlayer.setVolume(1.0);
    await sfxPlayer.play(AssetSource(isWin ? 'audio/win.mp3' : 'audio/lose.mp3'));
  }

  @override
  void dispose() {
    _shakeController.dispose();
    bgmPlayer.dispose();
    sfxPlayer.dispose();
    super.dispose();
  }

  void _startRound(int round) {
    currentRound = round;
    maxHP = 30 + (round * 10);
    currentHP = maxHP;
    bossImage = 'assets/images/treasures/treasure_pirateking$round.png';
    isRoundVictory = false;
    usedQuestionIndices.clear(); // Clear for each new round
    _pickUniqueRandomQuestion();
    setState(() {});
  }
  
  void _playBossBGM() async {
    await bgmPlayer.stop();
    await bgmPlayer.setReleaseMode(ReleaseMode.loop);
    await bgmPlayer.setVolume(0.5); // Slightly louder for epic battle
    await bgmPlayer.play(AssetSource('audio/onepiece.mp3'));
  }

  void _pickUniqueRandomQuestion() {
    // Get questions for current round
    final roundQuestions = IslandQuizData.getQuestionsForRound(currentRound);
    
    if (usedQuestionIndices.length >= roundQuestions.length) {
      usedQuestionIndices.clear();
    }

    int randomIndex;
    do {
      randomIndex = _random.nextInt(roundQuestions.length);
    } while (usedQuestionIndices.contains(randomIndex));

    usedQuestionIndices.add(randomIndex);
    currentQuestion = roundQuestions[randomIndex];
    
    setState(() {}); // Update UI with new question
  }

  void _handleAnswer(String answer) {
    if (answer == currentQuestion.answer) {
      _playSFX(true);
      setState(() {
        currentHP -= 15;
        isHealingAnim = true;
      });
      Future.delayed(const Duration(milliseconds: 800), () {
        if (mounted) setState(() => isHealingAnim = false);
      });

      if (currentHP <= 0) {
        _handleBossDefeated();
      } else {
        Future.delayed(const Duration(milliseconds: 1000), _pickUniqueRandomQuestion);
      }
    } else {
      _playSFX(false);
      setState(() => isWrongAnim = true);
      _shakeController.forward(from: 0.0).then((_) {
        if (mounted) setState(() => isWrongAnim = false);
      });
    }
  }

  void _handleBossDefeated() {
    setState(() {
      currentHP = 0;
      isRoundVictory = true;
    });

    if (currentRound >= maxRounds) {
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) setState(() => isGameCompleted = true);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isGameCompleted) {
      return _buildFinalVictory();
    }

    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'island_challenge'.tr(),
                style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.deepPurple),
              ),
              const SizedBox(height: 10),
              Text(
                'Round $currentRound / $maxRounds',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.purple),
              ),

              const SizedBox(height: 20),

              // Boss HP Bar
              Stack(
                children: [
                  Container(
                    height: 25,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.black54, width: 2),
                    ),
                  ),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 500),
                    height: 25,
                    width: MediaQuery.of(context).size.width * 0.85 * (currentHP / maxHP),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: currentHP > maxHP * 0.5
                            ? [Colors.green, Colors.lightGreen]
                            : currentHP > maxHP * 0.2
                                ? [Colors.orange, Colors.yellow]
                                : [Colors.red, Colors.deepOrange],
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                'HP: $currentHP / $maxHP',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
              ),

              const SizedBox(height: 20),

              // Boss Image - Bigger size
              AnimatedBuilder(
                animation: _shakeController,
                builder: (context, child) {
                  final offset = sin(_shakeController.value * pi * 4) * 10;
                  return Transform.translate(
                    offset: Offset(offset, 0),
                    child: child,
                  );
                },
                child: Image.asset(
                  bossImage,
                  width: 250,
                  height: 250,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => const Icon(Icons.shield, size: 150, color: Colors.deepPurple),
                ),
              ),

              if (isHealingAnim)
                const Padding(
                  padding: EdgeInsets.only(top: 10.0),
                  child: Text(
                    '💥 Hit! -15 HP',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.red),
                  ),
                ),

              if (isWrongAnim)
                const Padding(
                  padding: EdgeInsets.only(top: 10.0),
                  child: Text(
                    '❌ Wrong!',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.orange),
                  ),
                ),

              const SizedBox(height: 30),

              if (!isRoundVictory) _buildQuestionPanel(),

              if (isRoundVictory) _buildNextRoundButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuestionPanel() {
    final languageCode = context.locale.languageCode;
    
    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black12, offset: Offset(0, 4), blurRadius: 8)],
      ),
      child: Column(
        children: [
          // Question with optional image
          if (currentQuestion.questionImagePath != null) ...[
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.asset(
                currentQuestion.questionImagePath!,
                width: 120,
                height: 120,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Icon(Icons.image_not_supported, size: 80, color: Colors.grey),
              ),
            ),
            const SizedBox(height: 15),
          ],
          
          Text(
            currentQuestion.getQuestion(languageCode),
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87, height: 1.4),
          ),

          const SizedBox(height: 25),

          // Options with images in a grid - smaller size
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.0,
            ),
            itemCount: currentQuestion.options.length,
            itemBuilder: (context, index) {
              final opt = currentQuestion.options[index];
              return _buildOptionCard(opt);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildOptionCard(IslandQuizOption option) {
    return InkWell(
      onTap: () => _handleAnswer(option.text),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.deepPurple.withOpacity(0.3), width: 2),
          boxShadow: [
            BoxShadow(
              color: Colors.deepPurple.withOpacity(0.15),
              offset: const Offset(0, 3),
              blurRadius: 6,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(6.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    option.imagePath,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) => Icon(
                      Icons.image_not_supported,
                      size: 40,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 6),
              decoration: BoxDecoration(
                color: Colors.deepPurple.withOpacity(0.08),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
              ),
              child: Text(
                option.text,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNextRoundButton() {
    return Column(
      children: [
        const Icon(Icons.check_circle, color: Colors.green, size: 80),
        const SizedBox(height: 15),
        Text(
          'congratulations'.tr(),
          style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.green),
        ),
        const SizedBox(height: 25),

        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepPurple,
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            elevation: 8,
          ),
          onPressed: () {
            _startRound(currentRound + 1);
          },
          icon: const Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 28),
          label: Text(
            'Round ${currentRound + 1}',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
      ],
    );
  }

  Widget _buildFinalVictory() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.emoji_events, color: Colors.amber, size: 100),
            const SizedBox(height: 20),
            Text(
              'you_win'.tr(),
              style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.orange),
            ),
            const SizedBox(height: 15),
            Text(
              'congratulations'.tr(),
              style: const TextStyle(fontSize: 24, color: Colors.green),
            ),

            const SizedBox(height: 40),

            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 18),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                elevation: 10,
              ),
              onPressed: widget.onCompleted,
              icon: const Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 30),
              label: Text(
                'next'.tr(),
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
