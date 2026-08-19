import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_constants.dart';
import '../models/department_model.dart';

/// نداء حقيقي لـ GET /departments (عام، ما بيحتاج تسجيل دخول) - يستخدم
/// لتعبئة لائحة الاختصاصات يلي الطبيب بيختار منها وقت التسجيل، وممكن
/// يُعاد استخدامه لاحقاً بأي مكان تاني بحتاج لائحة الاختصاصات (مثلاً
/// فلاتر البحث عند المريض).
class DepartmentsRepository {
  final Dio _dio = ApiClient.instance.dio;

  Future<List<DepartmentModel>> getDepartments() async {
    try {
      final response = await _dio.get(ApiConstants.departments);
      final data = response.data is Map ? response.data['data'] : response.data;
      if (data is List) {
        return data.whereType<Map<String, dynamic>>().map(DepartmentModel.fromJson).toList()
          ..sort((a, b) => a.name.compareTo(b.name));
      }
      return const [];
    } catch (_) {
      return const [];
    }
  }
}
