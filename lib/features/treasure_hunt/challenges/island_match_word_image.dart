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

class _IslandMatchWordImageState extends State<IslandMatchWordImage> with TickerProviderStateMixin {
  final AudioPlayer bgmPlayer = AudioPlayer();
  final AudioPlayer sfxPlayer = AudioPlayer();
  late AnimationController _shakeController;
  late AnimationController _rainController;

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
  late List<IslandQuizQuestion> roundQuestions;

  final List<RainDrop> rainDrops = [];

  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    
    _rainController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 50),
    )..repeat();
    
    _rainController.addListener(() {
      setState(() {
        for (var drop in rainDrops) {
          drop.y += drop.speed;
          if (drop.y > 1.0) {
            drop.y = -0.1;
            drop.x = _random.nextDouble();
          }
        }
      });
    });
    
    for (int i = 0; i < 100; i++) {
      rainDrops.add(RainDrop(
        x: _random.nextDouble(),
        y: _random.nextDouble(),
        speed: 0.01 + _random.nextDouble() * 0.02,
        length: 10 + _random.nextDouble() * 20,
      ));
    }
    
    _playBossBGM();
    _startRound(1);
  }

  void _playSFX(bool isWin) async {
    await sfxPlayer.stop();
    await sfxPlayer.setVolume(1.0);
    await sfxPlayer.play(AssetSource(isWin ? 'audio/win.mp3' : 'audio/lose.mp3'));
  }

  @override
  void dispose() {
    _shakeController.dispose();
    _rainController.dispose();
    bgmPlayer.dispose();
    sfxPlayer.dispose();
    super.dispose();
  }

  void _startRound(int round) {
    setState(() {
      currentRound = round;
      maxHP = 30 + (round * 10);
      currentHP = maxHP;
      bossImage = 'assets/images/treasures/treasure_pirateking$round.png';
      isRoundVictory = false;
      usedQuestionIndices.clear();
      roundQuestions = IslandQuizData.getQuestionsForRound(round);
    });
    _pickUniqueRandomQuestion();
  }
  
  void _playBossBGM() async {
    await bgmPlayer.stop();
    await bgmPlayer.setReleaseMode(ReleaseMode.loop);
    await bgmPlayer.setVolume(0.5);
    await bgmPlayer.play(AssetSource('audio/onepiece.mp3'));
  }

  void _pickUniqueRandomQuestion() {
    if (usedQuestionIndices.length >= roundQuestions.length) {
      usedQuestionIndices.clear();
    }

    int randomIndex;
    do {
      randomIndex = _random.nextInt(roundQuestions.length);
    } while (usedQuestionIndices.contains(randomIndex));

    usedQuestionIndices.add(randomIndex);
    
    setState(() {
      currentQuestion = roundQuestions[randomIndex];
    });
  }

  void _handleAnswer(String answer) {
    if (answer == currentQuestion.answer) {
      _playSFX(true);
      setState(() {
        currentHP -= 20;
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
        if (mounted) {
          setState(() => isGameCompleted = true);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isGameCompleted) {
      return _buildFinalVictory();
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final screenHeight = constraints.maxHeight;
        final isSmallScreen = screenHeight < 700;
        
        return Stack(
          children: [
            // Background image
            Positioned.fill(
              child: Image.asset(
                'assets/images/treasures/treasure_bg.png',
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.indigo.shade900,
                        Colors.blue.shade900,
                      ],
                    ),
                  ),
                ),
              ),
            ),
            
            // Main content
            Container(
              height: screenHeight,
              padding: EdgeInsets.symmetric(
                horizontal: 10.0,
                vertical: isSmallScreen ? 6 : 8,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Round $currentRound / $maxRounds',
                    style: TextStyle(
                      fontSize: isSmallScreen ? 14 : 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          color: Colors.black87,
                          offset: Offset(1, 1),
                          blurRadius: 3,
                        ),
                      ],
                    ),
                  ),
                  
                  SizedBox(height: isSmallScreen ? 2 : 3),
                  _buildHPBar(isSmallScreen),
                  SizedBox(height: 2),
                  _buildBossImage(isSmallScreen),
                  
                  if (isHealingAnim || isWrongAnim) 
                    _buildFeedback(isSmallScreen)
                  else
                    SizedBox(height: isSmallScreen ? 4 : 5),
                  
                  Expanded(
                    child: !isRoundVictory 
                        ? _buildQuestionPanel(isSmallScreen)
                        : _buildNextRoundButton(isSmallScreen),
                  ),
                ],
              ),
            ),
            
            // Rain effect ON TOP
            ...rainDrops.map((drop) {
              return Positioned(
                left: drop.x * constraints.maxWidth,
                top: drop.y * constraints.maxHeight,
                child: Container(
                  width: 1.5,
                  height: drop.length,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.white.withOpacity(0.7),
                        Colors.white.withOpacity(0.1),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ],
        );
      },
    );
  }

  Widget _buildHPBar(bool isSmall) {
    return Column(
      children: [
        Stack(
          children: [
            Container(
              height: isSmall ? 14 : 16,
              decoration: BoxDecoration(
                color: Colors.grey.shade300.withOpacity(0.8),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.black54, width: 1),
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              height: isSmall ? 14 : 16,
              width: MediaQuery.of(context).size.width * 0.92 * (currentHP / maxHP),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: currentHP > maxHP * 0.5
                      ? [Colors.green, Colors.lightGreen]
                      : currentHP > maxHP * 0.2
                          ? [Colors.orange, Colors.yellow]
                          : [Colors.red, Colors.deepOrange],
                ),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ],
        ),
        SizedBox(height: 3),
        Text(
          'HP: $currentHP / $maxHP',
          style: TextStyle(
            fontSize: isSmall ? 11 : 12,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            shadows: [
              Shadow(
                color: Colors.black87,
                offset: Offset(1, 1),
                blurRadius: 2,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBossImage(bool isSmall) {
    final size = isSmall ? 220.0 : 240.0; // BIGGER BOSS
    return AnimatedBuilder(
      animation: _shakeController,
      builder: (context, child) {
        final offset = sin(_shakeController.value * pi * 4) * 6;
        return Transform.translate(
          offset: Offset(offset, 0),
          child: child,
        );
      },
      child: Image.asset(
        bossImage,
        width: size,
        height: size,
        fit: BoxFit.contain,
        errorBuilder: (_, __, ___) => Icon(
          Icons.shield,
          size: size,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildFeedback(bool isSmall) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: isSmall ? 3 : 4),
      child: Text(
        isHealingAnim ? '💥 -20 HP!' : '❌ Wrong!',
        style: TextStyle(
          fontSize: isSmall ? 14 : 16,
          fontWeight: FontWeight.bold,
          color: isHealingAnim ? Colors.red : Colors.orange,
          shadows: [
            Shadow(
              color: Colors.black87,
              offset: Offset(1, 1),
              blurRadius: 3,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuestionPanel(bool isSmall) {
    final languageCode = context.locale.languageCode;
    
    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.zero,
        padding: EdgeInsets.all(isSmall ? 4 : 5),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.75),
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black38,
              offset: Offset(0, 2),
              blurRadius: 5,
            )
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              currentQuestion.getQuestion(languageCode),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: isSmall ? 12 : 14,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
                height: 1.2,
              ),
            ),
            
            SizedBox(height: 3),

            // Grid 2x2 - SMALLER IMAGES
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: isSmall ? 2 : 3,
                mainAxisSpacing: isSmall ? 2 : 3,
                childAspectRatio: isSmall ? 1.35 : 1.3,
              ),
              itemCount: currentQuestion.options.length,
              itemBuilder: (context, index) {
                final opt = currentQuestion.options[index];
                return _buildOptionCard(opt, isSmall);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionCard(IslandQuizOption option, bool isSmall) {
    return InkWell(
      onTap: () => _handleAnswer(option.text),
      borderRadius: BorderRadius.circular(6),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: Colors.deepPurple.withOpacity(0.4),
            width: 0.8,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              offset: const Offset(0, 1),
              blurRadius: 2,
            ),
          ],
        ),
        child: Column(
          children: [
            // SMALLER IMAGE - fills all available space
            Expanded(
              flex: 4,
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  isSmall ? 2 : 3,
                  isSmall ? 2 : 3,
                  isSmall ? 2 : 3,
                  0,
                ),
                child: Image.asset(
                  option.imagePath,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Icon(
                    Icons.image_not_supported,
                    size: isSmall ? 12 : 16,
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                vertical: isSmall ? 3 : 3.5,
                horizontal: 2,
              ),
              decoration: BoxDecoration(
                color: Colors.deepPurple.withOpacity(0.12),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(5),
                  bottomRight: Radius.circular(5),
                ),
              ),
              child: Text(
                option.text,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 10,
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

  Widget _buildNextRoundButton(bool isSmall) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.check_circle,
            color: Colors.green,
            size: isSmall ? 50 : 60,
          ),
          SizedBox(height: isSmall ? 8 : 12),
          Text(
            'Boss $currentRound Defeated!',
            style: TextStyle(
              fontSize: isSmall ? 20 : 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: [
                Shadow(
                  color: Colors.black87,
                  offset: Offset(2, 2),
                  blurRadius: 4,
                ),
              ],
            ),
          ),
          SizedBox(height: isSmall ? 14 : 18),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple,
              padding: EdgeInsets.symmetric(
                horizontal: isSmall ? 28 : 36,
                vertical: isSmall ? 12 : 14,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(22),
              ),
              elevation: 6,
            ),
            onPressed: () {
              if (currentRound < maxRounds) {
                _startRound(currentRound + 1);
              }
            },
            icon: Icon(
              Icons.arrow_forward_rounded,
              color: Colors.white,
              size: isSmall ? 20 : 24,
            ),
            label: Text(
              'Next Boss',
              style: TextStyle(
                fontSize: isSmall ? 16 : 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFinalVictory() {
    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset(
            'assets/images/treasures/treasure_bg.png',
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              color: Colors.indigo.shade900,
            ),
          ),
        ),
        Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.emoji_events, color: Colors.amber, size: 80),
                const SizedBox(height: 14),
                Text(
                  '🎉 ALL BOSSES DEFEATED! 🎉',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        color: Colors.black87,
                        offset: Offset(2, 2),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'congratulations'.tr(),
                  style: const TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        color: Colors.black87,
                        offset: Offset(1, 1),
                        blurRadius: 3,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 14,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    elevation: 8,
                  ),
                  onPressed: widget.onCompleted,
                  icon: const Icon(
                    Icons.arrow_forward_rounded,
                    color: Colors.white,
                    size: 26,
                  ),
                  label: Text(
                    'Complete',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// Rain drop model
class RainDrop {
  double x;
  double y;
  double speed;
  double length;

  RainDrop({
    required this.x,
    required this.y,
    required this.speed,
    required this.length,
  });
}
