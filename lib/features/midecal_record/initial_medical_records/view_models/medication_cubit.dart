import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../models/medication_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/medical_record_repository.dart';
import '../../../../core/network/api_exception.dart';

part 'medication_state.dart';


class MedicationsCubit extends Cubit<MedicationsState> {
  final MedicalRecordRepository _repository;

  MedicationsCubit({MedicalRecordRepository? repository})
      : _repository = repository ?? MedicalRecordRepository(),
        super(const MedicationsState());

  Future<void> loadMedications() async {
    emit(state.copyWith(status: MedicationsStatus.loading, errorMessage: null));
    try {
      final medications = await _repository.getMedications();
      emit(state.copyWith(status: MedicationsStatus.loaded, medications: medications));
    } on ApiException catch (e) {
      emit(state.copyWith(status: MedicationsStatus.failure, errorMessage: e.message));
    }
  }

  Future<void> addMedication({
    required String drugName,
    required String form,
    required String strength,
    required String dosage,
    required String frequency,
    required String route,
    required String startDate,
    String? notes,
  }) async {
    try {
      final created = await _repository.addMedication(
        drugName: drugName,
        form: form,
        strength: strength,
        dosage: dosage,
        frequency: frequency,
        route: route,
        startDate: startDate,
        notes: notes,
      );
      emit(state.copyWith(medications: [...state.medications, created]));
    } on ApiException catch (e) {
      emit(state.copyWith(status: MedicationsStatus.failure, errorMessage: e.message));
    }
  }

  Future<void> updateMedication(
      int id, {
        String? dosage,
        String? frequency,
        String? route,
        String? notes,
      }) async {
    try {
      final updated = await _repository.updateMedication(id, {
        if (dosage != null) 'dosage': dosage,
        if (frequency != null) 'frequency': frequency,
        if (route != null) 'route': route,
        if (notes != null) 'notes': notes,
      });
      emit(state.copyWith(
        medications: state.medications.map((m) => m.id == id ? updated : m).toList(),
      ));
    } on ApiException catch (e) {
      emit(state.copyWith(status: MedicationsStatus.failure, errorMessage: e.message));
    }
  }

  /// إيقاف دواء (مو حذف) - الباك بيحتفظ فيه بالسجل مع status = stopped
  Future<void> stopMedication(int id, {String? reason}) async {
    try {
      final updated = await _repository.stopMedication(id, reason: reason);
      emit(state.copyWith(
        medications: state.medications.map((m) => m.id == id ? updated : m).toList(),
      ));
    } on ApiException catch (e) {
      emit(state.copyWith(status: MedicationsStatus.failure, errorMessage: e.message));
    }
  }

  Future<void> deleteMedication(int id) async {
    try {
      await _repository.deleteMedication(id);
      emit(state.copyWith(medications: state.medications.where((m) => m.id != id).toList()));
    } on ApiException catch (e) {
      emit(state.copyWith(status: MedicationsStatus.failure, errorMessage: e.message));
    }
  }
}
