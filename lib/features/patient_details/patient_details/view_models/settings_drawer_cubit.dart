import 'package:flutter_bloc/flutter_bloc.dart';
import 'settings_drawer_state.dart';

/// Purely ephemeral UI state for the settings drawer — which accordion
/// section is expanded right now. The notifications toggle is a real app
/// setting and lives in [SettingsCubit] instead, so it stays in sync with
/// the Profile screen's copy of the same switch.
class SettingsDrawerUiCubit extends Cubit<SettingsDrawerUiState> {
  SettingsDrawerUiCubit() : super(const SettingsDrawerUiState());

  void toggleThemeExpanded() => emit(state.copyWith(isThemeExpanded: !state.isThemeExpanded));

  void toggleLangExpanded() => emit(state.copyWith(isLangExpanded: !state.isLangExpanded));
}
