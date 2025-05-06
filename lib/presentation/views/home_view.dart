import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:deepseek_app/presentation/providers/providers.dart';
import 'package:deepseek_app/presentation/widgets/widgets.dart';


class HomeView extends ConsumerWidget {
  static const name = 'home-screen';
  final StatefulNavigationShell currentChild;


  const HomeView({
    super.key,
    required this.currentChild,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final bool isDarkMode = ref.watch(themeNotifierProvider).isDarkmode;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Asistente Inteligente'),
        backgroundColor: Colors.green,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              context.go('/settings');
            },
          ),
          IconButton(
            icon: Icon( isDarkMode ? Icons.dark_mode_outlined : Icons.light_mode_outlined ),
            onPressed: (){
              ref.read(themeNotifierProvider.notifier)
                 .toggleDarkMode();           
            }, 
          )
        ],
      ),
      body: currentChild,
      bottomNavigationBar: CustomBottomNavigation(
        currentChild: currentChild
      ),
      
    );
  }
}