
part of 'review_submit_cubit.dart';

@immutable

enum ReviewSubmitStatus { initial, loading, loaded, failure }

class ReviewSubmitState {
  final ReviewSubmitStatus status;
  final List<Allergy> allergies;
  final List<ChronicCondition> chronicConditions;
  final List<Surgery> surgeries;
  final List<FamilyHistoryEntry> familyHistory;
  final List<Medication> medications;
  final List<AttachedFile> attachments;
  final String? errorMessage;

  const ReviewSubmitState({
    this.status = ReviewSubmitStatus.initial,
    this.allergies = const [],
    this.chronicConditions = const [],
    this.surgeries = const [],
    this.familyHistory = const [],
    this.medications = const [],
    this.attachments = const [],
    this.errorMessage,
  });

  ReviewSubmitState copyWith({
    ReviewSubmitStatus? status,
    List<Allergy>? allergies,
    List<ChronicCondition>? chronicConditions,
    List<Surgery>? surgeries,
    List<FamilyHistoryEntry>? familyHistory,
    List<Medication>? medications,
    List<AttachedFile>? attachments,
    String? errorMessage,
  }) {
    return ReviewSubmitState(
      status: status ?? this.status,
      allergies: allergies ?? this.allergies,
      chronicConditions: chronicConditions ?? this.chronicConditions,
      surgeries: surgeries ?? this.surgeries,
      familyHistory: familyHistory ?? this.familyHistory,
      medications: medications ?? this.medications,
      attachments: attachments ?? this.attachments,
      errorMessage: errorMessage,
    );
  }
}
