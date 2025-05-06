// settings_view.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:deepseek_app/presentation/providers/providers.dart';

class SettingsView extends ConsumerWidget {
  const SettingsView({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(themeNotifierProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajustes'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // Navegar hacia atrás
            context.go('/chats'); // Vuelve a la pantalla anterior
          },
        ),  
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SwitchListTile(
            title: const Text('Modo Oscuro'),
            value: theme.isDarkmode,
            onChanged: (v) => ref.read(themeNotifierProvider.notifier).toggleDarkMode(),
          ),
          // aquí podrías agregar selector de color, configuraciones de API, etc.
        ],
      ),
    );
  }
}
