import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:easy_localization/easy_localization.dart';
import '../data/ocean_choose_image_data.dart';
import '../domain/entities/challenge_question.dart';

class OceanChooseImage extends StatefulWidget {
  final int questionIndex;
  final VoidCallback onCompleted;
  const OceanChooseImage({Key? key, required this.questionIndex, required this.onCompleted}) : super(key: key);

  @override
  State<OceanChooseImage> createState() => _OceanChooseImageState();
}

class _OceanChooseImageState extends State<OceanChooseImage> {
  final AudioPlayer sfxPlayer = AudioPlayer();
  late List<OceanChooseImageQuestion> questions;
  late OceanChooseImageQuestion currentQuestion;

  int? selectedIndex;
  bool isCompleted = false;
  bool isWrong = false;

  @override
  void initState() {
    super.initState();
    questions = OceanChooseImageData.getQuestions();
    currentQuestion = questions[widget.questionIndex % questions.length];
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    currentQuestion = questions[widget.questionIndex % questions.length];
  }

  @override
  void dispose() {
    sfxPlayer.dispose();
    super.dispose();
  }

  void _playSFX(bool isWin) async {
    await sfxPlayer.stop();
    await sfxPlayer.setVolume(1.0);
    await sfxPlayer.play(AssetSource(isWin ? 'audio/win.mp3' : 'audio/lose.mp3'));
  }

  @override
  Widget build(BuildContext context) {
    final languageCode = context.locale.languageCode;

    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'ocean_challenge'.tr(),
                style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.blueAccent),
              ),
              const SizedBox(height: 20),

              Container(
                padding: const EdgeInsets.all(20),
                margin: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.blue.shade300, width: 2),
                  boxShadow: [
                    BoxShadow(color: Colors.black12, offset: Offset(0, 4), blurRadius: 8)
                  ],
                ),
                child: Text(
                  currentQuestion.getRiddle(languageCode),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                    height: 1.5,
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // Grid 2x2 with smaller images
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.0, // Square cards
                ),
                itemCount: currentQuestion.options.length,
                itemBuilder: (context, i) {
                  bool isCorrect = (i == currentQuestion.answerIndex);
                  bool isThisSelected = (selectedIndex == i);
                  Color borderColor = Colors.transparent;

                  if (isThisSelected) {
                    if (isCompleted && isCorrect) {
                      borderColor = Colors.green;
                    } else if (isWrong) {
                      borderColor = Colors.red;
                    }
                  }

                  return GestureDetector(
                    onTap: (isCompleted || isWrong) ? null : () {
                      setState(() {
                        selectedIndex = i;
                      });

                      if (isCorrect) {
                        _playSFX(true);
                        setState(() {
                          isCompleted = true;
                        });
                      } else {
                        _playSFX(false);
                        setState(() {
                          isWrong = true;
                        });
                        Future.delayed(const Duration(milliseconds: 1200), () {
                          if (mounted) {
                            setState(() {
                              selectedIndex = null;
                              isWrong = false;
                            });
                          }
                        });
                      }
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: borderColor.withOpacity(borderColor == Colors.transparent ? 0 : 1),
                          width: 3,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            offset: Offset(0, 3),
                            blurRadius: 5,
                          )
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.asset(
                                currentQuestion.options[i].imagePath,
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stackTrace) {
                                  return Icon(Icons.water_drop, size: 40, color: Colors.blue.shade300);
                                },
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            currentQuestion.options[i].getLabel(languageCode),
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.blueGrey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),

              if (isCompleted)
                Padding(
                  padding: const EdgeInsets.only(top: 30.0, bottom: 15),
                  child: Column(
                    children: [
                      const Text(
                        "🎉 Correct! 🎉",
                        style: TextStyle(
                          fontSize: 24,
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent,
                          padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                          elevation: 8,
                        ),
                        onPressed: widget.onCompleted,
                        icon: const Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 26),
                        label: Text(
                          'next'.tr(),
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
