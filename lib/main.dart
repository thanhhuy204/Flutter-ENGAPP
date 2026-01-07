import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';

// Import các màn hình
import 'package:flutter_kids_matching_game/features/spelling/presentation/screens/spelling_screen.dart';
import 'package:flutter_kids_matching_game/features/vocabulary/presentation/screens/vocab_list_screen.dart';
import 'package:flutter_kids_matching_game/home_screen.dart';
import 'package:flutter_kids_matching_game/features/settings/presentation/screens/settings_screen.dart';
import 'package:flutter_kids_matching_game/features/settings/presentation/notifiers/settings_notifier.dart';
import 'package:flutter_kids_matching_game/features/feeding/presentation/screens/feeding_screen.dart';
import 'package:flutter_kids_matching_game/features/speaking/presentation/screens/speak_challenge_screen.dart';
// Import Core
import 'package:flutter_kids_matching_game/core/theme/app_theme.dart';
import 'package:flutter_kids_matching_game/core/services/storage_service.dart';
import 'package:flutter_kids_matching_game/core/data/db_helper.dart';

import 'features/space/presentation/screens/space_map_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await GetStorage.init();
  await StorageService().init();

  // Khởi tạo SQLite database với seed data
  final dbHelper = DBHelper();
  await dbHelper.db; // Trigger database initialization

  runApp(ProviderScope(
    child: EasyLocalization(
      supportedLocales: const [
        Locale('en', 'US'),
        Locale('ja', 'JP'),
      ],
      path: 'assets/translations',
      fallbackLocale: const Locale('en', 'US'),
      child: const MyApp(),
    ),
  ));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsNotifier = ref.watch(settingsNotifierProvider);
    final currentTheme = AppTheme.getThemeFor(settingsNotifier.selectedThemeColor);

    return MaterialApp(
        debugShowCheckedModeBanner: false,

        // --- QUAN TRỌNG: Thêm Key để ép App vẽ lại khi đổi ngôn ngữ/theme ---
        key: ValueKey("${settingsNotifier.selectedLocale.languageCode}-${settingsNotifier.selectedThemeColor}"),

        theme: currentTheme,
        initialRoute: '/',
        routes: {
          '/': (context) => const HomeScreen(),
          '/setting': (context) => const SettingScreen(),
          '/vocabulary': (context) => const VocabListScreen(),
          '/spelling': (context) => const SpellingScreen(),
          '/feeding': (context) => const FeedingScreen(),
          '/space': (context) => const SpaceMapScreen(),
          '/speak': (context) => const SpeakChallengeScreen(),

        },
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,

        // --- QUAN TRỌNG: Dùng locale từ Riverpod thay vì context ---
        locale: settingsNotifier.selectedLocale
    );
  }
}