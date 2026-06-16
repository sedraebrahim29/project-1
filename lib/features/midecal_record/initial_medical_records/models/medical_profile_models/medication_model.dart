// =============================================
// Model - بيانات الدواء فقط، لا يوجد UI هنا
// =============================================
class Medication {
  final String name;       // اسم الدواء: "Metformin"
  final String dosage;     // الجرعة: "500a g"
  final String frequency;  // التكرار: "Once daily"
  final String status;     // الحالة: "Active" / "Inactive"

  const Medication({
    required this.name,
    required this.dosage,
    required this.frequency,
    this.status = 'Active',
  });
}