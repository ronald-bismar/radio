import 'package:flutter/material.dart';
import 'package:radio/resources/colores.dart';

class ThemeProvider extends ChangeNotifier {
  bool _isDarkMode;

  ThemeProvider(BuildContext context)
      : _isDarkMode =
            MediaQuery.of(context).platformBrightness == Brightness.dark;

  bool get isDarkMode => _isDarkMode;

  ThemeData get themeData => _isDarkMode
      ? ThemeData.dark().copyWith(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        )
      : ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        );

  // Propiedades calculadas dinámicamente según el modo oscuro/claro
  Color get baseColor => _isDarkMode ? colorExtra : baseColorPrimary;
  Color get secondColor => _isDarkMode ? secondary : baseColorPrimary;
  Color get shadowLight => _isDarkMode ? colorExtra : shadowLightPrimary;
  Color get shadowDark => _isDarkMode ? Colors.black : shadowDarkPrimary;
  Color get colorReproductor => _isDarkMode ? reproductorColor : primary;

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }
}
