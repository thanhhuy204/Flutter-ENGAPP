import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_kids_matching_game/features/settings/presentation/notifiers/settings_notifier.dart';
import 'package:flutter_kids_matching_game/core/constants/setting_choices.dart';
import 'package:flutter_kids_matching_game/features/treasure_hunt/data/challenge_generator.dart';
import 'package:flutter_kids_matching_game/features/treasure_hunt/domain/challenge_models.dart';

// Sửa đường dẫn import (lùi ra 2 cấp cha ../..)
import '../../challenges/jungle_listen_choose.dart';
import '../../challenges/mountain_word_puzzle.dart';
import '../../challenges/desert_fill_blank.dart';
import '../../challenges/ocean_choose_image.dart';
import '../../challenges/island_match_word_image.dart';

class ChallengeScreen extends ConsumerStatefulWidget {
  final int level;
  final int questionIndex;
  final VoidCallback onCompleted;
  final VoidCallback? onReset; // Đã thêm onReset để sửa lỗi bên Map

  const ChallengeScreen({
    Key? key,
    required this.level,
    required this.questionIndex,
    required this.onCompleted,
    this.onReset, // Thêm vào constructor
  }) : super(key: key);

  @override
  ConsumerState<ChallengeScreen> createState() => _ChallengeScreenState();
}

class _ChallengeScreenState extends ConsumerState<ChallengeScreen> {
  @override
  Widget build(BuildContext context) {
    final langCode = ref.read(settingsNotifierProvider).selectedLanguage.languageCode;

  @override
  Widget build(BuildContext context) {
    Widget challengeWidget;
    List<Color> bgColors = [Colors.white, Colors.white];

    switch (widget.level) {
      case 0: // Jungle
        challengeWidget = JungleListenChoose(
          questionIndex: widget.questionIndex,
          langCode: langCode,
          onCompleted: _finish,
        );
        bgColors = [Colors.green.shade50, Colors.green.shade100];
        break;
      case 1: // Mountain
        challengeWidget = MountainWordPuzzle(
          questionIndex: widget.questionIndex,
          langCode: langCode,
          onCompleted: _finish,
        );
        bgColors = [Colors.brown.shade50, Colors.orange.shade50];
        break;
      case 2: // Desert
        challengeWidget = DesertFillBlank(
          questionIndex: widget.questionIndex,
          langCode: langCode,
          onCompleted: _finish,
        );
        bgColors = [Colors.orange.shade50, Colors.yellow.shade50];
        break;
      case 3: // Ocean
        challengeWidget = OceanChooseImage(
          questionIndex: widget.questionIndex,
          langCode: langCode,
          onCompleted: _finish,
        );
        bgColors = [Colors.blue.shade50, Colors.blue.shade100];
        break;
      case 4: // Island
        challengeWidget = IslandMatchWordImage(
          questionIndex: widget.questionIndex,
          langCode: langCode,
          onCompleted: _finish,
        );
        bgColors = [Colors.purple.shade50, Colors.deepPurple.shade100];
        break;
      default:
        challengeWidget = const SizedBox();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Level ${widget.level + 1}'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black54,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          // Thêm nút Reset nếu có onReset
          if (widget.onReset != null)
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () {
                Navigator.pop(context);
                widget.onReset!();
              },
            )
        ],
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: bgColors)
        ),
        child: SafeArea(child: challengeWidget),
      ),
    );
  }

  void _finish() {
    widget.onCompleted();
    Navigator.pop(context);
  }
}