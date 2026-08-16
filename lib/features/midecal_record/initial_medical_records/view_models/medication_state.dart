part of 'medication_cubit.dart';

@immutable
enum MedicationsStatus { initial, loading, loaded, failure }

class MedicationsState {
  final MedicationsStatus status;
  final List<Medication> medications;
  final String? errorMessage;

  const MedicationsState({
    this.status = MedicationsStatus.initial,
    this.medications = const [],
    this.errorMessage,
  });

  MedicationsState copyWith({
    MedicationsStatus? status,
    List<Medication>? medications,
    String? errorMessage,
  }) {
    return MedicationsState(
      status: status ?? this.status,
      medications: medications ?? this.medications,
      errorMessage: errorMessage,
    );
  }
}
