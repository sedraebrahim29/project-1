// النموذج (Model) لبيانات الموعد
// =============================================
class Appointment {
  final String doctorName;
  final String specialty;
  final String date;
  final String? time;       // null في حالة Past History بدون وقت
  final String status;      // "Upcoming" / "Completed" / "Cancelled"
  final String avatarAsset; // مسار صورة الدكتور

  const Appointment({
    required this.doctorName,
    required this.specialty,
    required this.date,
    this.time,
    required this.status,
    required this.avatarAsset,
  });
}