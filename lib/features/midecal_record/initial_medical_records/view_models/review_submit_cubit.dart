import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../../core/network/api_exception.dart';
import '../../data/medical_record_repository.dart';
import '../models/attached_model.dart';
import '../models/medical_history_models.dart';
import '../models/medication_model.dart';

part 'review_submit_state.dart';

// =============================================
// ملاحظة معمارية مهمة: عكس شاشات Register، ما في هون endpoint
// "submit نهائي" - كل عنصر انحفظ فوراً وقت إضافته بالخطوات السابقة.
// هاد الـ Cubit بس بيجيب نسخة طازجة من كل شي محفوظ عرض للمراجعة،
// عبر نداء واحد GET /patient/medical-record (بدل 4-5 نداءات منفصلة).
// =============================================
class ReviewSubmitCubit extends Cubit<ReviewSubmitState> {
  final MedicalRecordRepository _repository;

  ReviewSubmitCubit({MedicalRecordRepository? repository})
      : _repository = repository ?? MedicalRecordRepository(),
        super(const ReviewSubmitState());

  Future<void> loadRecord() async {
    emit(state.copyWith(status: ReviewSubmitStatus.loading, errorMessage: null));
    try {
      final record = await _repository.getFullMedicalRecord();
      final medicalHistory = record['medical_history'] as Map<String, dynamic>? ?? {};

      List<T> parseList<T>(dynamic raw, T Function(Map<String, dynamic>) fromJson) {
        return ((raw as List?) ?? [])
            .map((e) => fromJson(e as Map<String, dynamic>))
            .toList();
      }

      emit(state.copyWith(
        status: ReviewSubmitStatus.loaded,
        allergies: parseList(medicalHistory['allergies'], Allergy.fromJson),
        chronicConditions:
        parseList(medicalHistory['chronic_conditions'], ChronicCondition.fromJson),
        surgeries: parseList(medicalHistory['surgeries'], Surgery.fromJson),
        familyHistory: parseList(medicalHistory['family_history'], FamilyHistoryEntry.fromJson),
        medications: parseList(record['medications'], Medication.fromJson),
        attachments: parseList(record['attachments'], AttachedFile.fromJson),
      ));
    } on ApiException catch (e) {
      emit(state.copyWith(status: ReviewSubmitStatus.failure, errorMessage: e.message));
    }
  }
}
