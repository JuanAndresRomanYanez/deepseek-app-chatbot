import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:deepseek_app/infrastructure/services/services.dart';
import 'package:deepseek_app/presentation/providers/providers.dart';
import 'package:deepseek_app/config/config.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  await LocalSearchService.init();
  runApp(
    const ProviderScope(      
      child: MainApp(),
    ),
  );
}

class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final AppTheme appTheme = ref.watch(themeNotifierProvider);

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: appRouter,
      theme: appTheme.getTheme(),
    );
  }
}
