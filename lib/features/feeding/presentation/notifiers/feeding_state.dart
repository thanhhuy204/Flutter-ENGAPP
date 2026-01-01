import 'package:flutter_kids_matching_game/core/domain/entities/game_item.dart';

class FeedingState {
  final GameItem targetItem;
  final List<GameItem> options;
  final bool isSuccess;
  final bool isError;
  final bool showKeyword;

  FeedingState({
    required this.targetItem,
    required this.options,
    required this.isSuccess,
    required this.isError,
    required this.showKeyword,
  });

  FeedingState copyWith({
    GameItem? targetItem,
    List<GameItem>? options,
    bool? isSuccess,
    bool? isError,
    bool? showKeyword,
  }) {
    return FeedingState(
      targetItem: targetItem ?? this.targetItem,
      options: options ?? this.options,
      isSuccess: isSuccess ?? this.isSuccess,
      isError: isError ?? this.isError,
      showKeyword: showKeyword ?? this.showKeyword,
    );
  }
}
