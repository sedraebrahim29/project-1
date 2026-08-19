part of 'medical_record_gate_cubit.dart';

@immutable
enum MedicalRecordGateStatus { initial, loading, loaded, failure }

class MedicalRecordGateState {
  final MedicalRecordGateStatus status;
  final bool hasRecord; // false = المريض لسا ما عندو أي بيانات بسجله
  final String? errorMessage;

  const MedicalRecordGateState({
    this.status = MedicalRecordGateStatus.initial,
    this.hasRecord = false,
    this.errorMessage,
  });

  MedicalRecordGateState copyWith({
    MedicalRecordGateStatus? status,
    bool? hasRecord,
    String? errorMessage,
  }) {
    return MedicalRecordGateState(
      status: status ?? this.status,
      hasRecord: hasRecord ?? this.hasRecord,
      errorMessage: errorMessage,
    );
  }
}
