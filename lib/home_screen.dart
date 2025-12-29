import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_kids_matching_game/features/spelling/presentation/screens/spelling_screen.dart';
import 'features/treasure_hunt/treasure_hunt_screen.dart';
import 'package:flutter_kids_matching_game/core/theme/app_theme.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('master_games').tr(),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, size: 36),
            onPressed: () => Navigator.pushNamed(context, '/setting'),
          ),
        ],
      ),
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.white, AppTheme.primaryColor],
            ),
          ),
          // SỬA LỖI OVERFLOW: Bọc SingleChildScrollView để có thể cuộn
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'lets_play'.tr(),
                    style: Theme.of(context).textTheme.displayMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),

                  // Mascot Image
                  const Center(
                    child: Material(
                      elevation: 8.0,
                      shape: CircleBorder(),
                      child: CircleAvatar(
                        backgroundImage: AssetImage('assets/images/kid_mascot.png'),
                        radius: 80, // Giảm nhẹ radius để tiết kiệm không gian
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Game Buttons - Danh sách các nút bấm
                  GameButton(
                    label: 'color_game'.tr(),
                    color: Colors.orange,
                    icon: Icons.color_lens,
                    onTap: () => Navigator.pushNamed(context, '/colorGame'),
                  ),

                  const SizedBox(height: 20),

                  GameButton(
                    label: 'animal_game'.tr(),
                    color: Colors.green,
                    icon: Icons.pets,
                    onTap: () => Navigator.pushNamed(context, '/animalGame'),
                  ),

                  const SizedBox(height: 20),

                  GameButton(
                    label: 'fruit_game'.tr(),
                    color: Colors.red,
                    icon: Icons.local_dining,
                    onTap: () => Navigator.pushNamed(context, '/fruitGame'),
                  ),

                  const SizedBox(height: 20),

                  // NÚT MỚI: Vocabulary
                  GameButton(
                    label: 'vocabulary_learning'.tr(),
                    color: Colors.purple,
                    icon: Icons.menu_book_rounded,
                    onTap: () => Navigator.pushNamed(context, '/vocabulary'),
                  ),

                  // Tìm đến chỗ các GameButton cũ và thêm vào phía dưới
                  const SizedBox(height: 20),

                  GameButton(
                    label: 'spelling_game'.tr(), // Bạn nhớ thêm key này vào file JSON nhé
                    color: Colors.blueAccent,    // Màu xanh dương cho khác biệt
                    icon: Icons.abc_rounded,     // Icon chữ ABC rất hợp với đánh vần
                    onTap: () {
                      Navigator.pushNamed(context, '/spelling');
                    },
                  ),
                  // Khoảng trống dưới cùng để cuộn mượt hơn
                  const SizedBox(height: 40),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orangeAccent,
                        minimumSize: const Size(double.infinity, 56),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                      ),
                      icon: const Icon(Icons.map, color: Colors.white, size: 32),
                      label: const Text(
                        'Treasure Hunt Game',
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const TreasureHuntScreen()),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class GameButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const GameButton({
    Key? key,
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      // Sử dụng màu sắc truyền vào cho nút bấm
      style: AppTheme.elevatedButtonStyle().copyWith(
        backgroundColor: WidgetStateProperty.all(color),
      ),
      onPressed: onTap,
      icon: Container(
        padding: const EdgeInsets.all(4),
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 30, color: color),
      ),
      label: Text(
        label,
        style: const TextStyle(fontSize: 20, color: Colors.white),
      ),
    );
  }
}