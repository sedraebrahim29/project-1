import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/medical_record_repository.dart';
import '../../../../core/network/api_exception.dart';
import '../models/medical_history_models.dart';
part 'medical_history_state.dart';
class MedicalHistoryCubit extends Cubit<MedicalHistoryState> {
  final MedicalRecordRepository _repository;

  MedicalHistoryCubit({MedicalRecordRepository? repository})
      : _repository = repository ?? MedicalRecordRepository(),
        super(const MedicalHistoryState());

  // =============================================
  // تحميل الأقسام الأربعة مع بعض عند فتح الشاشة
  // =============================================
  Future<void> loadAll() async {
    emit(state.copyWith(status: MedicalHistoryStatus.loading, errorMessage: null));
    try {
      // بنجيبهم بالتوازي (مو متسلسل) لتسريع التحميل - كل قسم مستقل عن التاني
      final chronicConditions = _repository.getChronicConditions();
      final surgeries = _repository.getSurgeries();
      final allergies = _repository.getAllergies();
      final familyHistory = _repository.getFamilyHistory();

      emit(state.copyWith(
        status: MedicalHistoryStatus.loaded,
        chronicConditions: await chronicConditions,
        surgeries: await surgeries,
        allergies: await allergies,
        familyHistory: await familyHistory,
      ));
    } on ApiException catch (e) {
      emit(state.copyWith(status: MedicalHistoryStatus.failure, errorMessage: e.message));
    }
  }

  void toggleSection(int index) {
    final updated = List<bool>.from(state.expandedSections);
    updated[index] = !updated[index];
    emit(state.copyWith(expandedSections: updated));
  }

  // =============================================
  // Chronic Conditions
  // =============================================
  Future<void> addChronicCondition({
    required String conditionName,
    required String diagnosedAt,
    String? notes,
  }) async {
    try {
      final created = await _repository.addChronicCondition(
        conditionName: conditionName,
        diagnosedAt: diagnosedAt,
        notes: notes,
      );
      emit(state.copyWith(chronicConditions: [...state.chronicConditions, created]));
    } on ApiException catch (e) {
      emit(state.copyWith(status: MedicalHistoryStatus.failure, errorMessage: e.message));
    }
  }

  Future<void> updateChronicCondition(
      int id, {
        String? conditionName,
        String? diagnosedAt,
        String? notes,
      }) async {
    try {
      final updated = await _repository.updateChronicCondition(id, {
        if (conditionName != null) 'condition_name': conditionName,
        if (diagnosedAt != null) 'diagnosed_at': diagnosedAt,
        if (notes != null) 'notes': notes,
      });
      emit(state.copyWith(
        chronicConditions:
        state.chronicConditions.map((c) => c.id == id ? updated : c).toList(),
      ));
    } on ApiException catch (e) {
      emit(state.copyWith(status: MedicalHistoryStatus.failure, errorMessage: e.message));
    }
  }

  Future<void> deleteChronicCondition(int id) async {
    try {
      await _repository.deleteChronicCondition(id);
      emit(state.copyWith(
        chronicConditions: state.chronicConditions.where((c) => c.id != id).toList(),
      ));
    } on ApiException catch (e) {
      emit(state.copyWith(status: MedicalHistoryStatus.failure, errorMessage: e.message));
    }
  }

  // =============================================
  // Surgeries
  // =============================================
  Future<void> addSurgery({
    required String surgeryName,
    required String surgeryDate,
    String? notes,
  }) async {
    try {
      final created = await _repository.addSurgery(
        surgeryName: surgeryName,
        surgeryDate: surgeryDate,
        notes: notes,
      );
      emit(state.copyWith(surgeries: [...state.surgeries, created]));
    } on ApiException catch (e) {
      emit(state.copyWith(status: MedicalHistoryStatus.failure, errorMessage: e.message));
    }
  }

  Future<void> updateSurgery(
      int id, {
        String? surgeryName,
        String? surgeryDate,
        String? notes,
      }) async {
    try {
      final updated = await _repository.updateSurgery(id, {
        if (surgeryName != null) 'surgery_name': surgeryName,
        if (surgeryDate != null) 'surgery_date': surgeryDate,
        if (notes != null) 'notes': notes,
      });
      emit(state.copyWith(
        surgeries: state.surgeries.map((s) => s.id == id ? updated : s).toList(),
      ));
    } on ApiException catch (e) {
      emit(state.copyWith(status: MedicalHistoryStatus.failure, errorMessage: e.message));
    }
  }

  Future<void> deleteSurgery(int id) async {
    try {
      await _repository.deleteSurgery(id);
      emit(state.copyWith(surgeries: state.surgeries.where((s) => s.id != id).toList()));
    } on ApiException catch (e) {
      emit(state.copyWith(status: MedicalHistoryStatus.failure, errorMessage: e.message));
    }
  }

  // =============================================
  // Allergies
  // =============================================
  Future<void> addAllergy({
    required String allergenType,
    required String allergen,
    required String reaction,
    required String severity,
  }) async {
    try {
      final created = await _repository.addAllergy(
        allergenType: allergenType,
        allergen: allergen,
        reaction: reaction,
        severity: severity,
      );
      emit(state.copyWith(allergies: [...state.allergies, created]));
    } on ApiException catch (e) {
      emit(state.copyWith(status: MedicalHistoryStatus.failure, errorMessage: e.message));
    }
  }

  Future<void> updateAllergy(
      int id, {
        String? allergenType,
        String? allergen,
        String? reaction,
        String? severity,
      }) async {
    try {
      final updated = await _repository.updateAllergy(id, {
        if (allergenType != null) 'allergen_type': allergenType,
        if (allergen != null) 'allergen': allergen,
        if (reaction != null) 'reaction': reaction,
        if (severity != null) 'severity': severity,
      });
      emit(state.copyWith(
        allergies: state.allergies.map((a) => a.id == id ? updated : a).toList(),
      ));
    } on ApiException catch (e) {
      emit(state.copyWith(status: MedicalHistoryStatus.failure, errorMessage: e.message));
    }
  }

  Future<void> deleteAllergy(int id) async {
    try {
      await _repository.deleteAllergy(id);
      emit(state.copyWith(allergies: state.allergies.where((a) => a.id != id).toList()));
    } on ApiException catch (e) {
      emit(state.copyWith(status: MedicalHistoryStatus.failure, errorMessage: e.message));
    }
  }

  // =============================================
  // Family History
  // =============================================
  Future<void> addFamilyHistory({
    required String condition,
    required String relation,
    String? notes,
  }) async {
    try {
      final created = await _repository.addFamilyHistory(
        condition: condition,
        relation: relation,
        notes: notes,
      );
      emit(state.copyWith(familyHistory: [...state.familyHistory, created]));
    } on ApiException catch (e) {
      emit(state.copyWith(status: MedicalHistoryStatus.failure, errorMessage: e.message));
    }
  }

  Future<void> updateFamilyHistory(
      int id, {
        String? condition,
        String? relation,
        String? notes,
      }) async {
    try {
      final updated = await _repository.updateFamilyHistory(id, {
        if (condition != null) 'condition': condition,
        if (relation != null) 'relation': relation,
        if (notes != null) 'notes': notes,
      });
      emit(state.copyWith(
        familyHistory: state.familyHistory.map((f) => f.id == id ? updated : f).toList(),
      ));
    } on ApiException catch (e) {
      emit(state.copyWith(status: MedicalHistoryStatus.failure, errorMessage: e.message));
    }
  }

  Future<void> deleteFamilyHistory(int id) async {
    try {
      await _repository.deleteFamilyHistory(id);
      emit(state.copyWith(
        familyHistory: state.familyHistory.where((f) => f.id != id).toList(),
      ));
    } on ApiException catch (e) {
      emit(state.copyWith(status: MedicalHistoryStatus.failure, errorMessage: e.message));
    }
  }
}
