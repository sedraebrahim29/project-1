import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import '../../data/medical_record_repository.dart';
import '../../../../core/network/api_exception.dart';

part 'medical_record_gate_state.dart';


class MedicalRecordGateCubit extends Cubit<MedicalRecordGateState> {
  final MedicalRecordRepository _repository;

  MedicalRecordGateCubit({MedicalRecordRepository? repository})
      : _repository = repository ?? MedicalRecordRepository(),
        super(const MedicalRecordGateState());

  Future<void> checkStatus() async {
    emit(state.copyWith(status: MedicalRecordGateStatus.loading, errorMessage: null));
    try {
      final record = await _repository.getFullMedicalRecord();

      final medicalHistory = record['medical_history'] as Map<String, dynamic>? ?? {};
      final allergies = (medicalHistory['allergies'] as List?) ?? [];
      final chronicConditions = (medicalHistory['chronic_conditions'] as List?) ?? [];
      final surgeries = (medicalHistory['surgeries'] as List?) ?? [];
      final familyHistory = (medicalHistory['family_history'] as List?) ?? [];
      final medications = (record['medications'] as List?) ?? [];
      final attachments = (record['attachments'] as List?) ?? [];

      final hasRecord = allergies.isNotEmpty ||
          chronicConditions.isNotEmpty ||
          surgeries.isNotEmpty ||
          familyHistory.isNotEmpty ||
          medications.isNotEmpty ||
          attachments.isNotEmpty;

      emit(state.copyWith(status: MedicalRecordGateStatus.loaded, hasRecord: hasRecord));
    } on ApiException catch (e) {
      emit(state.copyWith(status: MedicalRecordGateStatus.failure, errorMessage: e.message));
    }
  }
}
