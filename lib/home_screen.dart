import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_kids_matching_game/core/theme/app_theme.dart';

// Import các màn hình game
import 'package:flutter_kids_matching_game/features/vocabulary/presentation/screens/vocab_list_screen.dart';
import 'package:flutter_kids_matching_game/features/spelling/presentation/screens/spelling_screen.dart';
import 'package:flutter_kids_matching_game/features/feeding/presentation/screens/feeding_screen.dart'; // MÀN HÌNH MỚI
import 'features/treasure_hunt/presentation/screens/treasure_hunt_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('master_games').tr(),
        centerTitle: true,
        backgroundColor: AppTheme.primaryColor,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white, size: 28),
            onPressed: () => Navigator.pushNamed(context, '/setting'),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppTheme.primaryColor.withOpacity(0.8), Colors.white],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildMainGameCard(
                context,
                title: 'treasure_hunt'.tr(),
                icon: Icons.map_outlined,
                color: Colors.orange,
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const TreasureHuntScreen())),
              ),

              const SizedBox(height: 20),

              _buildMainGameCard(
                context,
                title: 'space_adventure'.tr(), // Cần thêm key này vào file JSON
                icon: Icons.rocket_launch_rounded,
                color: Colors.indigo, // Màu xanh tím vũ trụ
                onTap: () => Navigator.pushNamed(context, '/space'),
              ),

              const SizedBox(height: 20),
              Text('learning_zone'.tr(), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black54)),
              const SizedBox(height: 10),

              Row(
                children: [
                  Expanded(
                    child: _buildMiniGameCard(
                      context,
                      title: 'Greedy Boy (feeding)'.tr(), // Cập nhật key dịch: Bạn nhỏ tham ăn
                      icon: Icons.fastfood_rounded,
                      color: Colors.green,
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const FeedingScreen())),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: _buildMiniGameCard(
                      context,
                      title: 'spelling'.tr(),
                      icon: Icons.abc_rounded,
                      color: Colors.blue,
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SpellingScreen())),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              _buildMiniGameCard(
                context,
                title: 'vocabulary'.tr(),
                icon: Icons.menu_book_rounded,
                color: Colors.purple,
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const VocabListScreen())),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMainGameCard(BuildContext context, {required String title, required IconData icon, required Color color, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 160,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [BoxShadow(color: color.withOpacity(0.4), blurRadius: 10, offset: const Offset(0, 5))],
        ),
        child: Stack(
          children: [
            Positioned(right: -20, bottom: -20, child: Icon(icon, size: 150, color: Colors.white.withOpacity(0.2))),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(color: Colors.white.withOpacity(0.3), borderRadius: BorderRadius.circular(20)),
                    child: Text("featured".tr(), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 10)),
                  ),
                  const SizedBox(height: 10),
                  Text(title, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMiniGameCard(BuildContext context, {required String title, required IconData icon, required Color color, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 120,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 5))],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(radius: 25, backgroundColor: color.withOpacity(0.1), child: Icon(icon, color: color, size: 30)),
            const SizedBox(height: 10),
            Text(title, textAlign: TextAlign.center, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}