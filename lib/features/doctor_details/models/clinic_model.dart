import '../../auth/doctor_auth/models/department_model.dart';

/// عيادة عامة (من GET /clinics الحقيقي) - كل عيادة معها لائحة الأقسام
/// المتوفرة فيها فعلياً، مستخدمة لبناء شاشة "الانضمام لعيادة".
class ClinicModel {
  final int id;
  final String name;
  final String? phone;
  final String? email;
  final String? address;
  final String status; // active / pending / suspended
  final List<DepartmentModel> departments;

  const ClinicModel({
    required this.id,
    required this.name,
    this.phone,
    this.email,
    this.address,
    this.status = 'active',
    this.departments = const [],
  });

  factory ClinicModel.fromJson(Map<String, dynamic> json) => ClinicModel(
        id: json['id'] is int ? json['id'] as int : int.tryParse('${json['id']}') ?? 0,
        name: json['name']?.toString() ?? '',
        phone: json['phone']?.toString(),
        email: json['email']?.toString(),
        address: json['address']?.toString(),
        status: json['status']?.toString() ?? 'active',
        departments: json['departments'] is List
            ? (json['departments'] as List)
                .map((e) => DepartmentModel.fromJson(e as Map<String, dynamic>))
                .toList()
            : const [],
      );
}
