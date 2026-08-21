import 'package:dio/dio.dart';


import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_constants.dart';
import '../models/clinic_model.dart';

/// ✅ نداء حقيقي وعام لـ GET /clinics - بيرجع بس العيادات الفعّالة
/// (status: active)، يعني العيادة الجديدة يلي أنشأها الطبيب ما رح
/// تظهر هون إلا بعد ما يوافق عليها الأدمن (Admin/Clinics/approve).
class ClinicsRepository {
  final Dio _dio = ApiClient.instance.dio;

  Future<List<ClinicModel>> getClinics() async {
    try {
      final response = await _dio.get(ApiConstants.clinics);
      final data = response.data is Map ? response.data['data'] : response.data;
      if (data is List) {
        return data.whereType<Map<String, dynamic>>().map(ClinicModel.fromJson).toList();
      }
      return const [];
    } catch (_) {
      return const [];
    }
  }

  /// GET /clinics/{id} - يُستخدم بشاشة "إضافة عيادة" لما الطبيب يدخل
  /// رقم عيادة (Clinic ID) بالضبط، نفس أسلوب خطوة التسجيل (join_clinic
  /// mode). بيرجع null إذا الرقم غلط أو العيادة مش موجودة/مش فعّالة.
  Future<ClinicModel?> getClinicById(int id) async {
    try {
      final response = await _dio.get('${ApiConstants.clinics}/$id');
      final data = response.data is Map ? response.data['data'] : null;
      if (data is Map<String, dynamic>) return ClinicModel.fromJson(data);
      return null;
    } catch (_) {
      return null;
    }
  }
}
