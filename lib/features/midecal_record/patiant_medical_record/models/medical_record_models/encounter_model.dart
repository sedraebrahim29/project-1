// =============================================
// Model - بيانات الزيارة الطبية فقط، لا UI هنا
// =============================================
class Encounter {
  final String date;             // "OCT 24, 2023"
  final String visitType;        // "FOLLOW-UP" / "CONSULTATION"
  final String doctorName;       // "Dr. Sarah Jenkins"
  final String specialty;        // "Cardiology"
  final String avatarAsset;      // مسار صورة الدكتور
  final String diagnosisSummary; // نص ملخص التشخيص
  final String doctorNotes;      // نص ملاحظات الدكتور (الاقتباس)

  const Encounter({
    required this.date,
    required this.visitType,
    required this.doctorName,
    required this.specialty,
    required this.avatarAsset,
    required this.diagnosisSummary,
    required this.doctorNotes,
  });
}