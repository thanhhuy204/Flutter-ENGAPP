import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:audioplayers/audioplayers.dart';
import '../notifiers/space_notifier.dart';
import '../../domain/entities/planet_challenge.dart';
import 'planet_challenge_screen.dart';

class SpaceMapScreen extends ConsumerStatefulWidget {
  const SpaceMapScreen({super.key});

  @override
  ConsumerState<SpaceMapScreen> createState() => _SpaceMapScreenState();
}

class _SpaceMapScreenState extends ConsumerState<SpaceMapScreen> {
  final AudioPlayer bgmPlayer = AudioPlayer();

  // Tọa độ % chuẩn xác dựa trên ảnh space_map_full.jpg mới nhất
  static const List<Offset> stationOffsets = [
    Offset(0.28, 0.84), // Level 1: Mercury
    Offset(0.72, 0.68), // Level 2: Venus
    Offset(0.28, 0.53), // Level 3: Earth
    Offset(0.71, 0.37), // Level 4: Mars
    Offset(0.28, 0.23), // Level 5: Jupiter
    Offset(0.72, 0.06), // Final: Sun
  ];

  @override
  void initState() {
    super.initState();
    _playBGM();
  }

  void _playBGM() async {
    await bgmPlayer.setReleaseMode(ReleaseMode.loop);
    await bgmPlayer.play(AssetSource('audio/space_music.mp3'), volume: 0.15);
  }

  @override
  void dispose() {
    bgmPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(spaceProvider);

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Khu vực bản đồ đảm bảo không bị giãn
          Center(
            child: AspectRatio(
              aspectRatio: 0.65, // Tỉ lệ khung hình dọc của map
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final w = constraints.maxWidth;
                  final h = constraints.maxHeight;

                  return Stack(
                    children: [
                      // Ảnh nền bao phủ toàn bộ vùng chứa
                      Positioned.fill(
                        child: Image.asset(
                          'assets/images/spaces/space_map_full.png',
                          fit: BoxFit.contain, // Đảm bảo thấy toàn bộ ảnh
                        ),
                      ),

                      // Trạm & Hành tinh
                      ...List.generate(SpaceData.planets.length, (index) {
                        final planet = SpaceData.planets[index];
                        final isLocked = planet.level > state.unlockedLevel;
                        final pos = stationOffsets[index];

                        return Positioned(
                          left: w * pos.dx - 35,
                          top: h * pos.dy - 35,
                          child: _buildPlanetNode(context, ref, planet, isLocked, index),
                        );
                      }),

                      // Phi hành gia (Di chuyển mượt mà)
                      AnimatedPositioned(
                        duration: const Duration(seconds: 2),
                        curve: Curves.easeInOutCubic,
                        left: w * stationOffsets[state.currentPlanetIndex].dx - 30,
                        top: h * stationOffsets[state.currentPlanetIndex].dy - 80,
                        child: Image.asset('assets/images/spaces/chicken_astronaut.png', width: 60),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),

          // Nút Back trên cùng
          Positioned(
            top: 40, left: 20,
            child: CircleAvatar(
              backgroundColor: Colors.white24,
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlanetNode(BuildContext context, WidgetRef ref, SpacePlanet planet, bool isLocked, int index) {
    return GestureDetector(
      onTap: isLocked ? null : () {
        ref.read(spaceProvider.notifier).updatePosition(index);
        Navigator.push(context, MaterialPageRoute(builder: (_) => PlanetChallengeScreen(planet: planet)));
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Opacity(
                opacity: isLocked ? 0.3 : 1.0,
                child: Image.asset('assets/images/spaces/${planet.id}.png', width: 70),
              ),
              if (isLocked) const Icon(Icons.lock, color: Colors.white, size: 26),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
            decoration: BoxDecoration(color: Colors.black45, borderRadius: BorderRadius.circular(4)),
            child: Text(
              planet.name.toUpperCase(),
              style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}