import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart'; // Thêm import này
import 'package:flutter_kids_matching_game/features/settings/presentation/notifiers/settings_notifier.dart'; // Thêm để lấy ngôn ngữ
import '../../../../core/constants/setting_choices.dart';
import '../notifiers/feeding_notifier.dart';
import 'package:flutter_kids_matching_game/core/domain/entities/game_item.dart';

class FeedingScreen extends ConsumerWidget {
  const FeedingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(feedingProvider);
    final notifier = ref.read(feedingProvider.notifier);

    final langCode = ref.watch(settingsNotifierProvider).selectedLanguage.languageCode;

    return Scaffold(
      appBar: AppBar(
        title: Text("hungry_boy_title".tr()),
        backgroundColor: Colors.orange,
      ),
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.orange.shade100, Colors.white],
            begin: Alignment.topCenter,
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: 30),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              margin: const EdgeInsets.symmetric(horizontal: 30),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
                boxShadow: const [
                  BoxShadow(color: Colors.black12, blurRadius: 10),
                ],
              ),
              child: Wrap(
                alignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 5,
                children: [
                  Text(
                    "im_hungry_prefix".tr(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepOrange,
                    ),
                  ),

                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 400),
                    transitionBuilder: (child, animation) {
                      return ScaleTransition(
                        scale: animation,
                        child: child,
                      );
                    },
                    child: Text(
                      state.showKeyword
                          ? state.targetItem.name(langCode)
                          : "...",
                      key: ValueKey(state.showKeyword),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepOrange,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            // 2️⃣ Cậu bé béo + nút nghe lại (ĐƯỢC BỌC TRONG EXPANDED)
            Expanded(
              child: DragTarget<GameItem>(
                onAccept: notifier.checkAnswer,
                builder: (context, candidateData, rejectedData) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center, // Căn giữa theo chiều dọc
                    children: [
                      // Hình ảnh cậu bé dùng Flexible để co giãn
                      Flexible(
                        child: AnimatedScale(
                          scale: state.isSuccess ? 1.15 : 1.0,
                          duration: const Duration(milliseconds: 300),
                          child: Image.asset(
                            'assets/images/feedings/ChubbyBoy.png',
                            fit: BoxFit.contain, // Giữ tỷ lệ ảnh không bị méo
                            errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.face, size: 100, color: Colors.orange),
                          ),
                        ),
                      ),

                      const SizedBox(height: 12),

                      // 🔊 NÚT LOA + LISTEN AGAIN
                      InkWell(
                        borderRadius: BorderRadius.circular(40),
                        onTap: notifier.playRequest,
                        splashColor: Colors.orange.withOpacity(0.3),
                        highlightColor: Colors.orange.withOpacity(0.15),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const CircleAvatar(
                              backgroundColor: Colors.orange,
                              radius: 28,
                              child: Icon(
                                Icons.volume_up,
                                color: Colors.white,
                                size: 30,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'listen_again'.tr(),
                              style: const TextStyle(
                                fontSize: 21,
                                fontWeight: FontWeight.w600,
                                color: Colors.deepOrange,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),

            //Khay thức ăn
            Container(
              padding: const EdgeInsets.all(25),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, -5),
                  ),
                ],
              ),
              child: Wrap(
                spacing: 20,
                runSpacing: 20,
                alignment: WrapAlignment.center,
                children: state.options.map((item) {
                  return Draggable<GameItem>(
                    data: item,
                    feedback: _buildFoodItem(item, size: 90, elevation: 15),
                    childWhenDragging: Opacity(
                      opacity: 0.2,
                      child: _buildFoodItem(item),
                    ),
                    child: _buildFoodItem(item),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFoodItem(
      GameItem item, {
        double size = 80,
        double elevation = 3,
      }) {
    return Material(
      color: Colors.transparent,
      child: Container(
        width: size,
        height: size,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: elevation,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(
            color: Colors.orange.shade50,
            width: 2,
          ),
        ),
        child: Image.asset(item.image, fit: BoxFit.contain),
      ),
    );
  }
}