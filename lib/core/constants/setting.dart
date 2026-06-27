import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum FontScale { normal, medium, large }

class SettingsState {
  final Locale locale;
  final ThemeMode themeMode;
  final FontScale fontScale;

  SettingsState({
    required this.locale,
    required this.themeMode,
    required this.fontScale,
  });

  // حساب معامل الضرب بناءً على الحجم المختار
  double get scaleFactor {
    switch (fontScale) {
      case FontScale.normal: return 0.6;
      case FontScale.medium: return 0.9;
      case FontScale.large: return 1.2;
    }
  }
}

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit() : super(SettingsState(
    locale: const Locale('en'),
    themeMode: ThemeMode.light,
    fontScale: FontScale.normal,
  ));

  void toggleLanguage() {
    emit(SettingsState(
      locale: state.locale.languageCode == 'en' ? const Locale('ar') : const Locale('en'),
      themeMode: state.themeMode,
      fontScale: state.fontScale,
    ));
  }

  void toggleTheme() {
    final nextTheme = state.themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    emit(SettingsState(locale: state.locale, themeMode: nextTheme, fontScale: state.fontScale));
  }

  // التبديل بين الأحجام الثلاثة بالتناوب (Normal -> Medium -> Large -> Normal)
  void cycleFontScale() {
    FontScale nextScale;
    switch (state.fontScale) {
      case FontScale.normal: nextScale = FontScale.medium; break;
      case FontScale.medium: nextScale = FontScale.large; break;
      case FontScale.large: nextScale = FontScale.normal; break;
    }
    emit(SettingsState(locale: state.locale, themeMode: state.themeMode, fontScale: nextScale));
  }
}
