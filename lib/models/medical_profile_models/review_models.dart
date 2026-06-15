// =============================================
// Models - بيانات شاشة المراجعة فقط، لا UI هنا
// =============================================

// --- موديل حقل المعلومات الأساسية ---
class InfoField {
  final String label; // "Full Legal Name"
  final String value; // "Jonathan Edward Doe"

  const InfoField({required this.label, required this.value});
}

// --- موديل الدواء بشاشة المراجعة ---
class ReviewMedication {
  final String name;    // "Metformin"
  final String details; // "500mg • Twice daily with meals"

  const ReviewMedication({required this.name, required this.details});
}

// --- موديل الملف المرفق بشاشة المراجعة ---
class ReviewAttachment {
  final String name;    // "Drivers_License_Front.jpg"
  final String details; // "2.1 MB • Uploaded Today"
  final bool isPdf;     // لتحديد الأيقونة

  const ReviewAttachment({
    required this.name,
    required this.details,
    required this.isPdf,
  });
}

// --- موديل الحساسية ---
class AllergyChip {
  final String name; // "Amoyicillin"

  const AllergyChip({required this.name});
}