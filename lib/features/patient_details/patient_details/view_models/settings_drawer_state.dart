class SettingsDrawerUiState {
  final bool isThemeExpanded;
  final bool isLangExpanded;

  const SettingsDrawerUiState({
    this.isThemeExpanded = false,
    this.isLangExpanded = false,
  });

  SettingsDrawerUiState copyWith({
    bool? isThemeExpanded,
    bool? isLangExpanded,
  }) {
    return SettingsDrawerUiState(
      isThemeExpanded: isThemeExpanded ?? this.isThemeExpanded,
      isLangExpanded: isLangExpanded ?? this.isLangExpanded,
    );
  }
}
