import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum FontScale { normal, medium, large }

class SettingsState {
  final Locale locale;
  final ThemeMode themeMode;
  final FontScale fontScale;
  final bool notificationsEnabled;

  SettingsState({
    required this.locale,
    required this.themeMode,
    required this.fontScale,
    this.notificationsEnabled = true,
  });

  double get scaleFactor {
    switch (fontScale) {
      case FontScale.normal: return 0.6;
      case FontScale.medium: return 0.9;
      case FontScale.large: return 1.2;
    }
  }

  SettingsState copyWith({
    Locale? locale,
    ThemeMode? themeMode,
    FontScale? fontScale,
    bool? notificationsEnabled,
  }) {
    return SettingsState(
      locale: locale ?? this.locale,
      themeMode: themeMode ?? this.themeMode,
      fontScale: fontScale ?? this.fontScale,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
    );
  }
}

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit() : super(SettingsState(
    locale: const Locale('en'),
    themeMode: ThemeMode.light,
    fontScale: FontScale.normal,
  ));

  void toggleLanguage() {
    emit(state.copyWith(
      locale: state.locale.languageCode == 'en' ? const Locale('ar') : const Locale('en'),
    ));
  }

  void toggleTheme() {
    emit(state.copyWith(
      themeMode: state.themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light,
    ));
  }

  void cycleFontScale() {
    FontScale nextScale;
    switch (state.fontScale) {
      case FontScale.normal: nextScale = FontScale.medium; break;
      case FontScale.medium: nextScale = FontScale.large; break;
      case FontScale.large: nextScale = FontScale.normal; break;
    }
    emit(state.copyWith(fontScale: nextScale));
  }

  /// App-wide notifications toggle. Lives here (not in a per-screen cubit)
  /// so the Settings drawer and the Profile screen always show the same
  /// value — two separate local toggles would drift out of sync the moment
  /// either one changed.
  void toggleNotifications(bool value) {
    emit(state.copyWith(notificationsEnabled: value));
  }
}
