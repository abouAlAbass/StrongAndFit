import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

/// Cubit managing theme mode state (dark, light, system).
class ThemeCubit extends Cubit<ThemeMode> {
  ThemeCubit() : super(ThemeMode.dark);

  bool get isDarkMode => state == ThemeMode.dark;

  void setThemeMode(ThemeMode mode) {
    emit(mode);
  }

  void toggleTheme() {
    emit(state == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark);
  }
}

