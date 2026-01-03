import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

class _PlanetChallengeScreenState extends ConsumerState<PlanetChallengeScreen> {
  final AudioPlayer sfxPlayer = AudioPlayer();

  int currentQuestionIndex = 0;
  bool isCorrect = false;
  bool showTargetWord = false;
  String? selectedAnswer;

  String displayWord = '';
  String scrambledWord = '';

  List<String> missingLetterOptions = [];
  List<String> userLetters = [];
  List<String> shuffledLetters = [];
  final FocusNode _focusNode = FocusNode();

  // Thêm getter để biết đang ở Round mấy
  bool get isSun => widget.planet.id == 'sun';
  int get currentRound => (currentQuestionIndex ~/ 5) + 1;

  @override
  void initState() {
    super.initState();
    _setupQuestion();
  }

  void _setupQuestion() {
    final q = widget.planet.questions[currentQuestionIndex];
    final isSun = widget.planet.id == 'sun';

    // Reset trạng thái
    isCorrect = false;
    showTargetWord = false;
    selectedAnswer = null;
    userLetters = [];

    // --- LOGIC TỰ ĐỘNG NÓI (SUN ROUND 1 HOẶC SKILL LISTENING) ---
    bool isListeningRound = (widget.planet.skill == SpaceSkill.listening) || (isSun && currentQuestionIndex < 5);

    if (isListeningRound) {
      Future.microtask(() {
        ref.read(spaceProvider.notifier).speak(q.targetWord, 'en');
      });
    }

    // --- LOGIC THIẾT LẬP DỮ LIỆU THEO SKILL ---
    // Round 2 của Sun hoặc Skill Missing Letter
    if (widget.planet.skill == SpaceSkill.missingLetter || (isSun && currentQuestionIndex >= 5 && currentQuestionIndex < 10)) {
      final hideChar = q.answer ?? q.targetWord[1];
      displayWord = q.targetWord.toUpperCase().replaceFirst(hideChar.toUpperCase(), '_');

      final correctChar = (q.answer ?? hideChar).toUpperCase();
      final options = <String>{correctChar};
      while (options.length < 4) {
        options.add(String.fromCharCode(65 + Random().nextInt(26)));
      }
      missingLetterOptions = options.toList()..shuffle();
    }
    // Round 4 của Sun hoặc Skill Scramble
    else if (widget.planet.skill == SpaceSkill.scramble || (isSun && currentQuestionIndex >= 15)) {
      shuffledLetters = q.targetWord.toUpperCase().split('')..shuffle();
      _focusNode.requestFocus();
    } else {
      displayWord = q.targetWord;
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

  // Trong class _PlanetChallengeScreenState

  void _nextQuestion() {
    // Kiểm tra xem có phải là câu cuối cùng của một Round ở Level Sun không (câu 5, 10, 15)
    bool isEndOfRound = isSun && (currentQuestionIndex + 1) % 5 == 0;
    bool isLastQuestion = currentQuestionIndex == widget.planet.questions.length - 1;

    if (isSun && isEndOfRound) {
      if (isLastQuestion) {
        _showFinalVictoryDialog();
      } else {
        _showNextRoundDialog();
      }
    } else if (currentQuestionIndex < widget.planet.questions.length - 1) {
      currentQuestionIndex++;
      _setupQuestion();
    } else {
      // Hoàn thành các level bình thường (1-5)
      ref.read(spaceProvider.notifier).completeLevel(widget.planet.level);
      Navigator.pop(context);
    }
  }

  void _showNextRoundDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.deepOrange.shade900,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("ROUND COMPLETE!",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        content: Text("You passed Round $currentRound! \nGet ready for the next challenge.",
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white70)),
        actions: [
          Center(
            child: ElevatedButton(
              // Đã sửa: ElevatedButton.styleFrom
              style: ElevatedButton.styleFrom(backgroundColor: Colors.orangeAccent),
              onPressed: () {
                Navigator.pop(context);
                setState(() {
                  currentQuestionIndex++;
                  _setupQuestion();
                });
              },
              child: Text("START ROUND ${currentRound + 1}"),
            ),
          )
        ],
      ),
    );
  }

  void _showFinalVictoryDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.orange.shade800,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("☀️ MISSION ACCOMPLISHED! ☀️",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
        content: const Text("You have conquered the Sun and completed the ultimate Battle Mode!",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white)),
        actions: [
          Center(
            child: ElevatedButton(
              // Đã sửa: ElevatedButton.styleFrom
              style: ElevatedButton.styleFrom(backgroundColor: Colors.yellowAccent),
              onPressed: () {
                ref.read(spaceProvider.notifier).completeLevel(widget.planet.level);
                Navigator.pop(context); // Đóng Dialog
                Navigator.pop(context, true); // Thoát khỏi màn hình thử thách và gửi tín hiệu 'true'
              },
              child: const Text("COLLECT VICTORY", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
            ),
          )
        ],
      ),
    );
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
    int round = (currentQuestionIndex ~/ 5) + 1;
    String title = isSun ? "🔥 ROUND $round - BOSS BATTLE 🔥" : "${widget.planet.name}";

    return Padding(
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 18),
            onPressed: () => Navigator.pop(context),
          ),
          Expanded(
            child: Text(
              "$title (${currentQuestionIndex + 1}/${widget.planet.questions.length})",
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 48),
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
    final isSun = widget.planet.id == 'sun';

    if (isSun) {
      if (currentQuestionIndex < 5) return _buildListening(q);      // Round 1
      if (currentQuestionIndex < 10) return _buildMissingLetter(q); // Round 2
      if (currentQuestionIndex < 15) return _buildReadingChallenge(q); // Round 3
      return _buildScrambleChallenge(q);                            // Round 4
    }
    switch (widget.planet.skill) {
      case SpaceSkill.listening:
        if (widget.planet.id == 'jupiter') {
          return _buildDictationChallenge(q);
        }
        return _buildListening(q);
      case SpaceSkill.missingLetter:
        return _buildMissingLetter(q);
      case SpaceSkill.reading:
        return _buildReadingChallenge(q);
      case SpaceSkill.scramble:
        return _buildScrambleChallenge(q);
      case SpaceSkill.matching:
        return _tapToConfirm(q.targetWord);
    }
  }

  Widget _buildReadingChallenge(SpaceQuestion q) {
    return Column(
      children: [
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.cyanAccent.withOpacity(0.5)),
          ),
          child: Text(
            q.targetWord.toUpperCase(),
            style: const TextStyle(
              fontSize: 42,
              fontWeight: FontWeight.bold,
              color: Colors.orangeAccent,
              letterSpacing: 3,
            ),
          ),
        ),
        const SizedBox(height: 30),
        if (q.imageOptions != null)
          Expanded(child: _buildImageChoices(q)), // Dùng lại hàm build image của bạn
      ],
    );
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
        constraints: const BoxConstraints(maxWidth: 360),
        child: GridView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: q.imageOptions!.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 15,
            mainAxisSpacing: 15,
          ),
          itemBuilder: (_, i) {
            final img = q.imageOptions![i];
            final isSelected = selectedAnswer == img;

            // 🆕 KHÔNG CẦN IF-ELSE NỮA, CHỈ CẦN GỌI HÀM NÀY:
            final String imagePath = SpaceData.getImagePath(img);

            Color borderColor = Colors.cyanAccent;
            if (isSelected) {
              borderColor = img == q.correctImage ? Colors.green : Colors.red;
            }

            return GestureDetector(
              onTap: isCorrect ? null : () {
                setState(() => selectedAnswer = img);
                if (img == q.correctImage) {
                  _handleCorrect();
                } else {
                  _handleWrong();
                }
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: borderColor, width: 4),
                  boxShadow: isSelected ? [BoxShadow(color: borderColor.withOpacity(0.5), blurRadius: 10)] : [],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.asset(
                    imagePath, // 👈 Sử dụng đường dẫn đã lấy được
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      // Nếu thiếu ảnh, nó sẽ hiện icon lỗi thay vì crash app
                      return const Icon(Icons.image_not_supported, color: Colors.white);
                    },
                  ),
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

  Widget _buildMissingLetter(SpaceQuestion q) {
    final correctChar = q.answer!.toUpperCase();

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          displayWord.toUpperCase(),
          style: const TextStyle(
            fontSize: 40,
            color: Colors.orangeAccent,
            letterSpacing: 2,
          ),
        ),
        const SizedBox(height: 24),
        Wrap(
          spacing: 16,
          runSpacing: 16,
          children: missingLetterOptions.map((char) {
            final isSelected = selectedAnswer == char;

            Color bg = Colors.black54;
            if (isSelected) {
              bg = char == correctChar ? Colors.green : Colors.red;
            }

            return GestureDetector(
              onTap: isCorrect
                  ? null
                  : () {
                if (char == correctChar) {
                  // ✅ ĐÚNG → GIỮ NGUYÊN THỨ TỰ
                  selectedAnswer = char;
                  displayWord = q.targetWord.toUpperCase();
                  _handleCorrect();
                } else {
                  selectedAnswer = char;
                  _handleWrong();
                  setState(() {});

                  // ⏳ delay rồi mới reset
                  Future.delayed(const Duration(milliseconds: 600), () {
                    if (!mounted) return;

                    setState(() {
                      selectedAnswer = null;
                      missingLetterOptions.shuffle();
                    });
                  });
                }
              },
              child: Container(
                width: 64,
                height: 64,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: bg,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.cyanAccent,
                    width: isSelected ? 2 : 0, // 👈 reset viền
                  ),
                ),
                child: Text(
                  char,
                  style: const TextStyle(
                    fontSize: 28,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildScrambleChallenge(SpaceQuestion q) {
    final String target = q.targetWord.toUpperCase();

    return KeyboardListener(
      focusNode: _focusNode,
      autofocus: true, // Tự động nhận diện bàn phím
      onKeyEvent: (event) {
        if (event is KeyDownEvent) {
          final key = event.logicalKey.keyLabel.toUpperCase();
          // Xử lý phím xóa (Backspace)
          if (event.logicalKey == LogicalKeyboardKey.backspace) {
            if (userLetters.isNotEmpty) {
              setState(() => userLetters.removeLast());
            }
            return;
          }
          // Xử lý phím chữ cái (chỉ nhận nếu từ mục tiêu chứa chữ đó)
          if (key.length == 1 && target.contains(key)) {
            _onLetterTap(key, target);
          }
        }
      },
      child: Column(
        children: [
          // 1. Ô câu đố (Hint Box)
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Text(
              q.hint,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18, color: Colors.black87),
            ),
          ),

          // 2. Các ô trống hiển thị chữ đã chọn
          const SizedBox(height: 20),
          Wrap(
            spacing: 8,
            children: List.generate(target.length, (index) {
              String char = index < userLetters.length ? userLetters[index] : "";
              return Container(
                width: 50,
                height: 60,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.orangeAccent, width: 2),
                  color: Colors.black45,
                ),
                child: Text(
                  char,
                  style: const TextStyle(fontSize: 26, color: Colors.white, fontWeight: FontWeight.bold),
                ),
              );
            }),
          ),

          // 3. Phần giữa linh hoạt
          const Expanded(child: SizedBox()),

          // 4. Nút CLEAR
          TextButton(
            onPressed: () => setState(() => userLetters = []),
            child: const Text("CLEAR", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          ),

          const SizedBox(height: 10),

          // 5. Dãy nút bấm (Đảm bảo Wrap không bị rỗng)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 30),
            child: Wrap(
              spacing: 10,
              runSpacing: 10,
              alignment: WrapAlignment.center,
              children: shuffledLetters.map((char) {
                return GestureDetector(
                  onTap: isCorrect ? null : () => _onLetterTap(char, target),
                  child: Container(
                    width: 55,
                    height: 55,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.orangeAccent,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: const [BoxShadow(color: Colors.black45, offset: Offset(0, 3))],
                    ),
                    child: Text(
                      char,
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDictationChallenge(SpaceQuestion q) {
    final String target = q.targetWord.toUpperCase();
    final String imagePath = SpaceData.getImagePath(q.correctImage ?? "");

    return KeyboardListener(
      focusNode: _focusNode,
      autofocus: true,
      onKeyEvent: (event) {
        if (event is KeyDownEvent) {
          final key = event.logicalKey.keyLabel.toUpperCase();
          if (event.logicalKey == LogicalKeyboardKey.backspace) {
            if (userLetters.isNotEmpty) setState(() => userLetters.removeLast());
            return;
          }
          if (key.length == 1 && target.contains(key)) _onLetterTap(key, target);
        }
      },
      child: Column(
        children: [
          const SizedBox(height: 10),
          // 1. Hình ảnh gợi ý (Bị làm mờ bằng hiệu ứng Blur)
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white24, width: 2),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: ImageFiltered(
                    imageFilter: isCorrect
                        ? ColorFilter.mode(Colors.transparent, BlendMode.multiply)
                        : ColorFilter.mode(Colors.black.withOpacity(0.5), BlendMode.darken),
                    child: Image.asset(imagePath, fit: BoxFit.contain),
                  ),
                ),
              ),
              // Nút loa đè lên hình ảnh
              IconButton(
                icon: const Icon(Icons.volume_up, size: 80, color: Colors.cyanAccent),
                onPressed: () => ref.read(spaceProvider.notifier).speak(q.targetWord, 'en'),
              ),
            ],
          ),

          const SizedBox(height: 30),

          // 2. Các ô trống hiển thị chữ
          Wrap(
            spacing: 8,
            children: List.generate(target.length, (index) {
              String char = index < userLetters.length ? userLetters[index] : "";
              return Container(
                width: 45,
                height: 55,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                      color: isCorrect ? Colors.greenAccent : Colors.cyanAccent,
                      width: 2
                  ),
                  color: Colors.black38,
                ),
                child: Text(
                  char,
                  style: const TextStyle(fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold),
                ),
              );
            }),
          ),

          const Expanded(child: SizedBox()),

          // 3. Dãy nút bấm chữ cái (Lấy từ shuffledLetters đã tạo ở _setupQuestion)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 30),
            child: Wrap(
              spacing: 10,
              runSpacing: 10,
              alignment: WrapAlignment.center,
              children: shuffledLetters.map((char) {
                return GestureDetector(
                  onTap: isCorrect ? null : () => _onLetterTap(char, target),
                  child: Container(
                    width: 50,
                    height: 50,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.deepPurpleAccent, // Jupiter thường có màu tím/nâu
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: const [BoxShadow(color: Colors.black45, offset: Offset(0, 3))],
                    ),
                    child: Text(
                      char,
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }


// Hàm xử lý khi chọn chữ (bấm nút hoặc gõ phím)
  void _onLetterTap(String char, String target) {
    if (userLetters.length < target.length) {
      setState(() {
        userLetters.add(char);
      });

      if (userLetters.length == target.length) {
        if (userLetters.join('') == target) {
          _handleCorrect();
        } else {
          _handleWrong();
          // Sai thì rung nhẹ và tự xóa sau 500ms
          Future.delayed(const Duration(milliseconds: 600), () {
            if (mounted) setState(() => userLetters = []);
          });
        }
      }
    }
  }

}


