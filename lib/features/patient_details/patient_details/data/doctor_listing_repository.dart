import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_constants.dart';
import '../models/doctor_dummy_data.dart';

/// ✅ GET /doctors صار endpoint حقيقي وموجود بالباك (تأكدنا من الرد
/// الفعلي بالـ Postman collection) - رجعنا نرجع بيانات حقيقية بس، بلا
/// أي fallback لبيانات وهمية متل قبل (كان مؤقت لحد ما يجهز الـ endpoint،
/// وهلق جاهز).
class DoctorListingRepository {
  final Dio _dio = ApiClient.instance.dio;

  Future<List<DoctorListingModel>> getDoctors() async {
    try {
      final response = await _dio.get(ApiConstants.doctorsPublicList);
      final data = response.data is Map ? response.data['data'] : response.data;
      if (data is List) {
        return data.whereType<Map<String, dynamic>>().map(DoctorListingModel.fromApiJson).toList();
      }
      return const [];
    } catch (_) {
      // خطأ اتصال أو رد غير متوقع - منرجع لائحة فاضية بهدوء بدل ما نكسر
      // الشاشة، مع الحفاظ على حالة "لا يوجد أطباء" الحقيقية (مو بيانات
      // وهمية بعد اليوم).
      return const [];
    }
  }
}
