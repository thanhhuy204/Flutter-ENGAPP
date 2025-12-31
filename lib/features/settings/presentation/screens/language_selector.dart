import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_kids_matching_game/core/constants/setting_choices.dart';
import 'package:flutter_kids_matching_game/features/settings/presentation/screens/build_dropdown.dart';
import 'package:flutter_kids_matching_game/features/settings/presentation/notifiers/settings_notifier.dart';

class LanguageSelector extends ConsumerWidget {
  const LanguageSelector({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsNotifierProvider);

    return buildDropdown<AppLanguage>(
      context: context,
      label: 'lesson_language'.tr(),
      value: settings.selectedLanguage,
      items: AppLanguage.values.map((lang) {
        return DropdownMenuItem<AppLanguage>(
          value: lang,
          child: Text(
            lang.translatedName,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.bold // Làm đậm chữ cho dễ đọc
            ),
          ),
        );
      }).toList(),
      onChanged: (appLanguage) async { // 1. Thêm async
        if (appLanguage != null) {
          // 2. Thêm await để chờ nạp file ngôn ngữ xong
          await context.setLocale(appLanguage.locale);

          // 3. Sau đó mới cập nhật Riverpod để vẽ lại màn hình
          ref.read(settingsNotifierProvider.notifier).setLanguage(appLanguage);
        }
      },
    );
  }
}