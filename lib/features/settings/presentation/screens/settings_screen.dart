import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_kids_matching_game/core/theme/app_theme.dart';
import 'package:flutter_kids_matching_game/features/settings/presentation/screens/level_selector.dart';
import 'package:flutter_kids_matching_game/features/settings/presentation/screens/language_selector.dart';
import 'package:flutter_kids_matching_game/features/settings/presentation/screens/theme_color_selector.dart';

class SettingScreen extends ConsumerWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text('settings', style: AppTheme.textTheme.displayLarge).tr(),
        centerTitle: true,
        backgroundColor: AppTheme.primaryColor,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.white, AppTheme.primaryColor],
          ),
        ),
        // SỬA LỖI: Sử dụng SingleChildScrollView thay vì Column trực tiếp
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSection(
                  context,
                  icon: Icons.language,
                  title: 'lesson_language'.tr(),
                  child: const LanguageSelector(),
                ),
                const SizedBox(height: 20),
                _buildSection(
                  context,
                  icon: Icons.school,
                  title: 'game_level'.tr(),
                  child: const LevelSelector(),
                ),
                const SizedBox(height: 20),
                _buildSection(
                  context,
                  icon: Icons.palette,
                  title: 'theme_color'.tr(),
                  child: const ThemeColorSelector(),
                ),

                // SỬA LỖI: Thay Spacer() bằng SizedBox vì bên trong ScrollView không dùng được Spacer
                const SizedBox(height: 40),
                _buildFooter(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSection(
      BuildContext context, {
        required IconData icon,
        required String title,
        required Widget child,
      }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.primaryColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1), // Sửa lại cách dùng opacity
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: AppTheme.primaryColor),
              ),
              const SizedBox(width: 10),
              Text(
                title,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: Colors.white, // Đảm bảo text hiển thị rõ trên nền màu primary
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  Column _buildFooter(BuildContext context) {
    return Column(
      children: [
        const Divider(thickness: 5, color: Colors.black, height: 20),
        const SizedBox(height: 10),
        InkWell(
          onTap: () => _copyEmailToClipboard(context),
          child: Center( // Căn giữa footer
            child: Text.rich(
              textAlign: TextAlign.center,
              TextSpan(
                style: const TextStyle(color: Colors.black, fontSize: 18),
                children: [
                  TextSpan(text: 'developed_by'.tr(), style: const TextStyle(fontSize: 20)),
                  const TextSpan(text: " "),
                  TextSpan(
                    text: 'ibs'.tr(),
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 5),
        Text('${'version'.tr()} 1.5.0', style: const TextStyle(fontWeight: FontWeight.w500)),
        const Divider(thickness: 5, color: Colors.black, height: 20),
      ],
    );
  }

  void _copyEmailToClipboard(BuildContext context) {
    const email = 'contact@ibrahimselman.com';
    Clipboard.setData(const ClipboardData(text: email)).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('email_copied'.tr())),
      );
    });
  }
}