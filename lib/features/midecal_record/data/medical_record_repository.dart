import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import '../../../core/network/api_client.dart';
import '../../../core/network/api_constants.dart';
import '../../../core/network/api_exception.dart';
import '../initial_medical_records/models/attached_model.dart';
import '../initial_medical_records/models/medical_history_models.dart';
import '../initial_medical_records/models/medication_model.dart';


class MedicalRecordRepository {
  final Dio _dio = ApiClient.instance.dio;

  // =============================================
  // السجل الكامل - يستخدم لشاشة Review، ولمعرفة هل عند
  // المريض سجل أصلاً (شاشة الدخول/Empty State)
  // =============================================
  Future<Map<String, dynamic>> getFullMedicalRecord() async {
    final response = await _get(ApiConstants.medicalRecordBase);
    return response['data'] as Map<String, dynamic>;
  }

  // =============================================
  // Allergies
  // =============================================
  Future<List<Allergy>> getAllergies() async {
    final response = await _get(ApiConstants.medicalRecordAllergies);
    return (response['data'] as List)
        .map((e) => Allergy.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<Allergy> addAllergy({
    required String allergenType,
    required String allergen,
    required String reaction,
    required String severity,
  }) async {
    final response = await _post(ApiConstants.medicalRecordAllergies, {
      'allergen_type': allergenType,
      'allergen': allergen,
      'reaction': reaction,
      'severity': severity,
    });
    return Allergy.fromJson(response['data'] as Map<String, dynamic>);
  }

  Future<Allergy> updateAllergy(int id, Map<String, dynamic> fields) async {
    final response = await _put('${ApiConstants.medicalRecordAllergies}/$id', fields);
    return Allergy.fromJson(response['data'] as Map<String, dynamic>);
  }

  Future<void> deleteAllergy(int id) => _delete('${ApiConstants.medicalRecordAllergies}/$id');

  // =============================================
  // Chronic Conditions
  // =============================================
  Future<List<ChronicCondition>> getChronicConditions() async {
    final response = await _get(ApiConstants.medicalRecordChronicConditions);
    return (response['data'] as List)
        .map((e) => ChronicCondition.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<ChronicCondition> addChronicCondition({
    required String conditionName,
    required String diagnosedAt,
    String? notes,
  }) async {
    final response = await _post(ApiConstants.medicalRecordChronicConditions, {
      'condition_name': conditionName,
      'diagnosed_at': diagnosedAt,
      'notes': notes,
    });
    return ChronicCondition.fromJson(response['data'] as Map<String, dynamic>);
  }

  Future<ChronicCondition> updateChronicCondition(int id, Map<String, dynamic> fields) async {
    final response = await _put('${ApiConstants.medicalRecordChronicConditions}/$id', fields);
    return ChronicCondition.fromJson(response['data'] as Map<String, dynamic>);
  }

  Future<void> deleteChronicCondition(int id) =>
      _delete('${ApiConstants.medicalRecordChronicConditions}/$id');

  // =============================================
  // Surgeries
  // =============================================
  Future<List<Surgery>> getSurgeries() async {
    final response = await _get(ApiConstants.medicalRecordSurgeries);
    return (response['data'] as List)
        .map((e) => Surgery.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<Surgery> addSurgery({
    required String surgeryName,
    required String surgeryDate,
    String? notes,
  }) async {
    final response = await _post(ApiConstants.medicalRecordSurgeries, {
      'surgery_name': surgeryName,
      'surgery_date': surgeryDate,
      'notes': notes,
    });
    return Surgery.fromJson(response['data'] as Map<String, dynamic>);
  }

  Future<Surgery> updateSurgery(int id, Map<String, dynamic> fields) async {
    final response = await _put('${ApiConstants.medicalRecordSurgeries}/$id', fields);
    return Surgery.fromJson(response['data'] as Map<String, dynamic>);
  }

  Future<void> deleteSurgery(int id) => _delete('${ApiConstants.medicalRecordSurgeries}/$id');

  // =============================================
  // Family History
  // =============================================
  Future<List<FamilyHistoryEntry>> getFamilyHistory() async {
    final response = await _get(ApiConstants.medicalRecordFamilyHistory);
    return (response['data'] as List)
        .map((e) => FamilyHistoryEntry.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<FamilyHistoryEntry> addFamilyHistory({
    required String condition,
    required String relation,
    String? notes,
  }) async {
    final response = await _post(ApiConstants.medicalRecordFamilyHistory, {
      'condition': condition,
      'relation': relation,
      'notes': notes,
    });
    return FamilyHistoryEntry.fromJson(response['data'] as Map<String, dynamic>);
  }

  Future<FamilyHistoryEntry> updateFamilyHistory(int id, Map<String, dynamic> fields) async {
    final response = await _put('${ApiConstants.medicalRecordFamilyHistory}/$id', fields);
    return FamilyHistoryEntry.fromJson(response['data'] as Map<String, dynamic>);
  }

  Future<void> deleteFamilyHistory(int id) =>
      _delete('${ApiConstants.medicalRecordFamilyHistory}/$id');

  // =============================================
  // Medications
  // =============================================
  Future<List<Medication>> getMedications() async {
    final response = await _get(ApiConstants.medicalRecordMedications);
    return (response['data'] as List)
        .map((e) => Medication.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<Medication> addMedication({
    required String drugName,
    required String form,
    required String strength,
    required String dosage,
    required String frequency,
    required String route,
    required String startDate,
    String? notes,
  }) async {
    final response = await _post(ApiConstants.medicalRecordMedications, {
      'drug_name': drugName,
      'form': form,
      'strength': strength,
      'dosage': dosage,
      'frequency': frequency,
      'route': route,
      'start_date': startDate,
      'notes': notes,
    });
    return Medication.fromJson(response['data'] as Map<String, dynamic>);
  }

  Future<Medication> updateMedication(int id, Map<String, dynamic> fields) async {
    final response = await _put('${ApiConstants.medicalRecordMedications}/$id', fields);
    return Medication.fromJson(response['data'] as Map<String, dynamic>);
  }

  Future<Medication> stopMedication(int id, {String? reason}) async {
    final response = await _post(
      '${ApiConstants.medicalRecordMedications}/$id/stop',
      {'reason': reason},
    );
    return Medication.fromJson(response['data'] as Map<String, dynamic>);
  }

  Future<void> deleteMedication(int id) => _delete('${ApiConstants.medicalRecordMedications}/$id');

  // =============================================
  // Attachments
  // =============================================
  Future<List<AttachedFile>> getAttachments() async {
    final response = await _get(ApiConstants.medicalRecordAttachments);
    return (response['data'] as List)
        .map((e) => AttachedFile.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<AttachedFile> uploadAttachment({
    required List<int> bytes,
    required String filename,
    required String type,
    String? mimeSubtype, // مثلاً 'jpeg', 'png', 'pdf' - افتراضي octet-stream لو ما تحدد
  }) async {
    try {
      final formData = FormData.fromMap({
        'type': type,
        'file': MultipartFile.fromBytes(
          bytes,
          filename: filename,
          contentType: mimeSubtype != null
              ? MediaType('application', mimeSubtype == 'pdf' ? 'pdf' : mimeSubtype)
              : null,
        ),
      });
      final response = await _dio.post(ApiConstants.medicalRecordAttachments, data: formData);
      return AttachedFile.fromJson(response.data['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _mapError(e);
    }
  }

  Future<void> deleteAttachment(int id) => _delete('${ApiConstants.medicalRecordAttachments}/$id');

  // =============================================
  // تنزيل ملف مرفق (bytes) - endpoint التنزيل محمي بنفس Bearer token
  // متل باقي الطلبات (مو رابط عام قابل للفتح مباشرة بالمتصفح)، فلازم
  // يمر عبر نفس Dio instance المصادق عليه بدل url_launcher.
  // =============================================
  Future<List<int>> downloadAttachmentBytes(int id) async {
    try {
      final response = await _dio.get<List<int>>(
        '${ApiConstants.medicalRecordAttachments}/$id/download',
        options: Options(responseType: ResponseType.bytes),
      );
      return response.data ?? <int>[];
    } on DioException catch (e) {
      throw _mapError(e);
    }
  }

  // =============================================
  // Helpers مشتركة (GET/POST/PUT/DELETE + معالجة الأخطاء)
  // نفس نمط AuthRepository._mapError تماماً حتى تضل رسائل الخطأ متسقة
  // بكل التطبيق.
  // =============================================
  Future<Map<String, dynamic>> _get(String path) async {
    try {
      final response = await _dio.get(path);
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw _mapError(e);
    }
  }

  // POST (store/stop): بالـ Postman كلها formdata - حتى الحقول النصية
  // البسيطة (مو بس الملفات). بنشيل أي قيمة null قبل الإرسال لأنه
  // FormData.fromMap برمي استثناء لو انبعتلها null مباشرة.
  Future<Map<String, dynamic>> _post(String path, Map<String, dynamic> fields) async {
    try {
      final cleanFields = <String, dynamic>{}..addEntries(
        fields.entries.where((e) => e.value != null),
      );
      final formData = FormData.fromMap(cleanFields, ListFormat.multiCompatible);
      final response = await _dio.post(path, data: formData);
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw _mapError(e);
    }
  }

  // PUT (update): بالـ Postman raw JSON مش form-data (تأكدنا من كل
  // endpoints الـ update: allergies/chronic-conditions/surgeries/
  // family-history/medications). لازم نلتزم بنفس الصيغة وإلا الباك
  // (PHP) ما رح يقرأ جسم الطلب أصلاً على PUT multipart.
  Future<Map<String, dynamic>> _put(String path, Map<String, dynamic> fields) async {
    try {
      final cleanFields = <String, dynamic>{}..addEntries(
        fields.entries.where((e) => e.value != null),
      );
      final response = await _dio.put(
        path,
        data: cleanFields,
        options: Options(contentType: Headers.jsonContentType),
      );
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw _mapError(e);
    }
  }

  Future<void> _delete(String path) async {
    try {
      await _dio.delete(path);
    } on DioException catch (e) {
      throw _mapError(e);
    }
  }

  ApiException _mapError(DioException e) {
    final response = e.response;
    if (response == null) {
      return ApiException('تعذّر الاتصال بالسيرفر، تأكد من الإنترنت وحاول مجدداً');
    }

    final data = response.data;
    String message = 'حدث خطأ غير متوقع';
    Map<String, dynamic>? errors;

    if (data is Map) {
      message = data['message']?.toString() ?? message;
      if (data['errors'] is Map) {
        errors = Map<String, dynamic>.from(data['errors']);
        if (data['message'] == null && errors.isNotEmpty) {
          final firstKey = errors.keys.first;
          final firstVal = errors[firstKey];
          if (firstVal is List && firstVal.isNotEmpty) {
            message = firstVal.first.toString();
          }
        }
      }
    }

    return ApiException(message, statusCode: response.statusCode, errors: errors);
  }
}
