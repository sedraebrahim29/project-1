/// اختصاص طبي (Department) - مطابق تماماً لشكل الرد الحقيقي لـ
/// GET /departments (Postman collection: Departments / all departments).
class DepartmentModel {
  final int id;
  final String name;
  final String? description;

  const DepartmentModel({required this.id, required this.name, this.description});

  factory DepartmentModel.fromJson(Map<String, dynamic> json) => DepartmentModel(
        id: json['id'] is int ? json['id'] as int : int.tryParse('${json['id']}') ?? 0,
        name: json['name']?.toString() ?? '',
        description: json['description']?.toString(),
      );
}
