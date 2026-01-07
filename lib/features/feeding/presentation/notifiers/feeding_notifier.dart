import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:flutter_kids_matching_game/core/data/vocab_repository.dart';
import 'package:flutter_kids_matching_game/core/domain/entities/game_item.dart';
import 'package:flutter_kids_matching_game/features/settings/presentation/notifiers/settings_notifier.dart';
import '../../../../core/constants/setting_choices.dart';
import 'feeding_state.dart';

class FeedingNotifier extends AutoDisposeNotifier<FeedingState> {
  final FlutterTts _tts = FlutterTts();
  late String _langCode;
  final _repository = VocabRepository();
  List<GameItem> _allItems = [];

  @override
  FeedingState build() {
    ref.keepAlive();

    ref.onDispose(() {
      _tts.stop();
    });

    final settings = ref.watch(settingsNotifierProvider);
    _langCode = settings.selectedLanguage.languageCode;

    _initData();
    _initTts();
    return FeedingState(
      targetItem: null,
      options: [],
      isSuccess: false,
      isError: false,
      showKeyword: false,
    );
  }

  Future<void> _initData() async {
    final animals = await _repository.getVocabByCategory('Animals');
    final fruits = await _repository.getVocabByCategory('Fruits');
    _allItems = [...animals, ...fruits];
    if (_allItems.isNotEmpty) {
      state = _generateLevel();
      await playRequest();
    }
  }

  Future<void> _initTts() async {
    await _tts.setLanguage(_langCode == 'ja' ? 'ja-JP' : 'en-US');
    await _tts.setSpeechRate(0.4);
    await _tts.setPitch(1.0);
    await _tts.awaitSpeakCompletion(true);

    await playRequest();
  }

  FeedingState _generateLevel() {
    if (_allItems.isEmpty) return state;

    final shuffledItems = List<GameItem>.from(_allItems)..shuffle(Random());
    final target = shuffledItems.first;
    final options = shuffledItems.take(4).toList()..shuffle(Random());

    return FeedingState(
      targetItem: target,
      options: options,
      isSuccess: false,
      isError: false,
      showKeyword: false, // ⭐ ẨN keyword ban đầu
    );
  }

  /// 🔊 Chỉ nói, KHÔNG lộ keyword trên UI
  Future<void> playRequest() async {
    final text = _langCode == 'ja'
        ? "${state.targetItem.nameJa}をください"
        : "I'm hungry! I want ${state.targetItem.nameEn}!";

    await _tts.speak(text);
  }

  /// ✅ Cho ăn
  Future<void> checkAnswer(GameItem selectedItem) async {
    if (state.isSuccess) return;

    if (selectedItem.id == state.targetItem.id) {
      // ⭐ HIỆN KEYWORD
      state = state.copyWith(
        isSuccess: true,
        isError: false,
        showKeyword: true,
      );

      await _tts.speak(
        _langCode == 'ja'
            ? "美味しい！ありがとう！"
            : "Yummy! Thank you!",
      );

      // ⏳ Cho bé nhìn chữ
      await Future.delayed(const Duration(milliseconds: 1500));

      // 🔄 Level mới → ẩn keyword lại
      state = _generateLevel();
      await playRequest();
    } else {
      state = state.copyWith(isError: true);

      await _tts.speak(
        _langCode == 'ja' ? "違います" : "No, that's not it.",
      );

      await Future.delayed(const Duration(milliseconds: 600));
      state = state.copyWith(isError: false);
    }
  }
}

final feedingProvider =
AutoDisposeNotifierProvider<FeedingNotifier, FeedingState>(() {
  return FeedingNotifier();
});
