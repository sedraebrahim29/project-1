// =============================================
// Models - بيانات شاشة المرفقات فقط، لا UI هنا
// =============================================

// --- موديل الصورة الطبية ---
class MedicalImage {
  final String title;      // "Chest X-Ray"
  final String date;       // "Oct 12, 2023"
  final String fileType;   // "JPG" / "DICOM"
  final String imageAsset; // مسار الصورة

  const MedicalImage({
    required this.title,
    required this.date,
    required this.fileType,
    required this.imageAsset,
  });
}

// --- موديل نتيجة المختبر ---
class LabResult {
  final String title;    // "Lipid Panel"
  final String date;     // "Oct 14, 2023"
  final String fileType; // "PDF"
  final String fileSize; // "1.2 MB"
  final String iconType; // "flask" / "microscope" لتحديد الأيقونة

  const LabResult({
    required this.title,
    required this.date,
    required this.fileType,
    required this.fileSize,
    required this.iconType,
  });
}

// --- موديل الوصفة الطبية ---
class Prescription {
  final String medicationName; // "Amoxicillin 500mg"
  final String doctorName;     // "Dr. Sarah Jenkins"
  final String fileType;       // "Digital Signature PDF"
  final String status;         // "ACTIVE" / "EXPIRED"

  const Prescription({
    required this.medicationName,
    required this.doctorName,
    required this.fileType,
    required this.status,
  });
}