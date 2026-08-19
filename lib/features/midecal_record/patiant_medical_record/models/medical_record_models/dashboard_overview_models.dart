// =============================================
// Models - بيانات شاشة Overview + الكارد العلوي (Patient Info)
// PatientInfo أصبح مبني من بيانات المستخدم الحقيقية (user object اللي
// يرجع مع تسجيل الدخول/إكمال الملف الشخصي) بدل البيانات الوهمية القديمة.
// حذفنا height/weight لأنه الباك لا يرجعهم إطلاقاً حالياً - عرض حقل
// غير موجود بالباك أسوأ من عدم عرضه.
// =============================================

// --- موديل معلومات المريض (الكارد العلوي الثابت) ---
class PatientInfo {
  final String name;        // "fakher ahmad" -> full_name
  final String? dob;        // "2025-01-07" (yyyy-MM-dd) من الباك، أو null لو غير معروف
  final String? gender;     // "male" / "female"
  final String? bloodType;  // "O+" -> user.profile.blood_type
  final String? phone;
  final String avatarAsset; // مسار صورة (فاضي حالياً - لا يوجد افاتار بالباك)

  const PatientInfo({
    required this.name,
    this.dob,
    this.gender,
    this.bloodType,
    this.phone,
    this.avatarAsset = '',
  });

  bool get isComplete => name.isNotEmpty && dob != null && bloodType != null;

  // --- عمر تقريبي محسوب من dob (yyyy-MM-dd) ---
  int? get ageInYears {
    if (dob == null) return null;
    final parsed = DateTime.tryParse(dob!);
    if (parsed == null) return null;
    final now = DateTime.now();
    int age = now.year - parsed.year;
    if (now.month < parsed.month ||
        (now.month == parsed.month && now.day < parsed.day)) {
      age--;
    }
    return age < 0 ? null : age;
  }

  // --- يبني PatientInfo مباشرة من user object القادم من
  // /auth/login أو /auth/complete-profile (data.user) ---
  factory PatientInfo.fromUserJson(Map<String, dynamic> json) {
    final profile = json['profile'] as Map<String, dynamic>?;
    return PatientInfo(
      name: json['full_name']?.toString() ??
          '${json['first_name'] ?? ''} ${json['last_name'] ?? ''}'.trim(),
      dob: json['dob']?.toString(),
      gender: json['gender']?.toString(),
      bloodType: profile?['blood_type']?.toString(),
      phone: json['phone']?.toString(),
    );
  }

  static const empty = PatientInfo(name: '');
}

// --- موديل عنصر النشاط الأخير ---
class ActivityItem {
  final String title;      // "Complete Blood Count (CBC)"
  final String subtitle;   // "Results uploaded by Dr. Sarah Jenkins."
  final String timestamp;  // "Today, 09:30 AM"
  final String iconType;   // "lab" / "prescription" / "allergy" / "condition" / "surgery" / "family" / "attachment"

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

// --- موديل ملخص السجل الطبي (يحل محل LatestVitalsData القديمة) ---
// LatestVitalsData (BP/HR) اتشالت لأنه لا يوجد أي endpoint حالياً يرجع
// علامات حيوية - عرضها كانت بيانات وهمية بالكامل. بدلاً منها كارد
// إحصائي مبني بالكامل من العناصر الحقيقية المحمّلة فعلياً بالسجل.
class RecordSummaryData {
  final int conditionsCount;   // chronic conditions
  final int allergiesCount;
  final int medicationsCount;  // active only
  final int attachmentsCount;

  const RecordSummaryData({
    required this.conditionsCount,
    required this.allergiesCount,
    required this.medicationsCount,
    required this.attachmentsCount,
  });
}
