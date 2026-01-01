class SpaceState {
  final int unlockedLevel;      // Level cao nhất đã mở
  final int currentPlanetIndex; // Vị trí phi hành gia đang đứng (0-5)

  SpaceState({this.unlockedLevel = 1, this.currentPlanetIndex = 0});

  SpaceState copyWith({int? unlockedLevel, int? currentPlanetIndex}) {
    return SpaceState(
      unlockedLevel: unlockedLevel ?? this.unlockedLevel,
      currentPlanetIndex: currentPlanetIndex ?? this.currentPlanetIndex,
    );
  }
}