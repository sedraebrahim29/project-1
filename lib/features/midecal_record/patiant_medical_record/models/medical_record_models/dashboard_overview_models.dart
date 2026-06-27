// =============================================
// Models - بيانات شاشة Overview فقط
// =============================================

// --- موديل معلومات المريض ---
class PatientInfo {
  final String name;        // "Alexander Vance"
  final String age;         // "35 yrs"
  final String dob;         // "12/04/1988"
  final String bloodType;   // "A+"
  final String height;      // "180 cm"
  final String weight;      // "78 kg"
  final String avatarAsset; // مسار الصورة

  const PatientInfo({
    required this.name,
    required this.age,
    required this.dob,
    required this.bloodType,
    required this.height,
    required this.weight,
    required this.avatarAsset,
  });
}

// --- موديل عنصر النشاط الأخير ---
class ActivityItem {
  final String title;      // "Complete Blood Count (CBC)"
  final String subtitle;   // "Results uploaded by Dr. Sarah Jenkins."
  final String timestamp;  // "Today, 09:30 AM"
  final String iconType;   // "lab" / "prescription"

  const ActivityItem({
    required this.title,
    required this.subtitle,
    required this.timestamp,
    required this.iconType,
  });
}

// --- موديل بيانات Active Medications ---
class ActiveMedicationsData {
  final int count;       // 2
  final String label;    // "current prescriptions"

  const ActiveMedicationsData({
    required this.count,
    required this.label,
  });
}

// --- موديل بيانات Latest Vitals ---
class LatestVitalsData {
  final String bp;  // "120/80"
  final String hr;  // "72 bpm"

  const LatestVitalsData({required this.bp, required this.hr});
}