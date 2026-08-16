part of 'medical_history_cubit.dart';

@immutable

enum MedicalHistoryStatus { initial, loading, loaded, failure }

class MedicalHistoryState {
  final MedicalHistoryStatus status;
  final List<ChronicCondition> chronicConditions;
  final List<Surgery> surgeries;
  final List<Allergy> allergies;
  final List<FamilyHistoryEntry> familyHistory;

  // ترتيب ثابت يطابق ترتيب الأقسام بالشاشة الأصلية:
  // 0: Chronic Diseases, 1: Surgeries, 2: Allergies, 3: Family History
  final List<bool> expandedSections;

  final String? errorMessage;

  const MedicalHistoryState({
    this.status = MedicalHistoryStatus.initial,
    this.chronicConditions = const [],
    this.surgeries = const [],
    this.allergies = const [],
    this.familyHistory = const [],
    this.expandedSections = const [true, true, false, false],
    this.errorMessage,
  });

  MedicalHistoryState copyWith({
    MedicalHistoryStatus? status,
    List<ChronicCondition>? chronicConditions,
    List<Surgery>? surgeries,
    List<Allergy>? allergies,
    List<FamilyHistoryEntry>? familyHistory,
    List<bool>? expandedSections,
    String? errorMessage,
  }) {
    return MedicalHistoryState(
      status: status ?? this.status,
      chronicConditions: chronicConditions ?? this.chronicConditions,
      surgeries: surgeries ?? this.surgeries,
      allergies: allergies ?? this.allergies,
      familyHistory: familyHistory ?? this.familyHistory,
      expandedSections: expandedSections ?? this.expandedSections,
      errorMessage: errorMessage,
    );
  }
}
