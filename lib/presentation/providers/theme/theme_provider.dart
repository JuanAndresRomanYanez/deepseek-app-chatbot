import 'package:deepseek_app/config/config.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Un simple boolean
final isDarkModeProvider = StateProvider((ref) => false);

// Listado de colores inmutable
final colorListProvider = Provider((ref) => colorList );

// Un simple int
final selectedColorProvider = StateProvider((ref) => 0);

// Un objeto de tipo AppTheme (custom)
final themeNotifierProvider = StateNotifierProvider<ThemeNotifier, AppTheme>(
  (ref) => ThemeNotifier(),
);

// Controller o Notifier
class ThemeNotifier extends StateNotifier<AppTheme>{
  // STATE = Estado = new AppTheme();
  ThemeNotifier(): super( AppTheme() );

  void toggleDarkMode(){
    state = state.copyWith(null, !state.isDarkmode);
  }

  void changeColorIndex( int colorIndex ){
    state = state.copyWith(colorIndex, null);
  }


}