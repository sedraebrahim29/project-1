class ApiConstants {
  ApiConstants._();

  static const String baseUrl = 'http://localhost:8000/api/v1';

  // --- Auth ---
  static const String register = '/auth/register';
  static const String verifyEmailCode = '/auth/email/verify-code';
  static const String resendCode = '/auth/email/resend-code';
  static const String completeProfile = '/auth/complete-profile';
  static const String login = '/auth/login';
  static const String forgotPassword = '/auth/forgot-password';
  static const String resetPassword = '/auth/reset-password';
  static const String changePassword = '/auth/change-password';
  static const String logout = '/auth/logout';
  static const String passwordConfirmationKey = 'password confirmation';

  // --- Patient / Medical Record ---
  // مضافة: كل نقاط النهاية الخاصة بالسجل الطبي للمريض (شوهدت بالـ Postman
  // collection تحت Patient/Medical Record).
  static const String medicalRecordBase = '/patient/medical-record';
  static const String medicalRecordAllergies = '$medicalRecordBase/allergies';
  static const String medicalRecordChronicConditions = '$medicalRecordBase/chronic-conditions';
  static const String medicalRecordSurgeries = '$medicalRecordBase/surgeries';
  static const String medicalRecordFamilyHistory = '$medicalRecordBase/family-history';
  static const String medicalRecordMedications = '$medicalRecordBase/medications';
  static const String medicalRecordAttachments = '$medicalRecordBase/attachments';
<<<<<<< HEAD

  // --- Doctor ---
  static const String doctorProfile = '/doctor/profile';
  static const String doctorProfilePhoto = '/doctor/profile/photo';
  // ✅ تصحيح 16/8 حسب الكولكشن الأحدث: "الانضمام لعيادة" ما عاد يحتاج
  // قسم (department_id) - صار clinic_id + consultation_fee بس (التخصص
  // صار مستقل عن العيادة، بينحدد مرة وحدة بالريجستر). "مغادرة قسم" لسا
  // تحت المسار القديم /departments/leave (ما تغيّر بالكولكشن).
  static const String doctorJoinClinic = '/doctor/profile/clinics/join';
  static const String doctorCreateClinic = '/doctor/profile/clinics/create';
  static String doctorUpdateClinicFee(int clinicId) => '/doctor/profile/clinics/$clinicId/fee';
  static const String doctorLeaveDepartment = '/doctor/profile/departments/leave';

  // --- Doctor / Schedule (✅ حقيقية بالكامل - راجع Postman collection
  // المحدّث: مجلد "Schedule"). كل هالنقاط تحت /doctor/schedule تخص
  // الطبيب المسجّل دخوله حالياً (self) لعيادة محددة بالـ clinicId.
  static const String doctorScheduleBase = '/doctor/schedule';
  static String doctorAllSchedules() => doctorScheduleBase;
  static String doctorSchedule(int clinicId) => '$doctorScheduleBase/$clinicId';
  static String doctorGenerateSlots(int clinicId) => '$doctorScheduleBase/$clinicId/generate-slots';
  static String doctorVacation(int clinicId) => '$doctorScheduleBase/$clinicId/vacation';
  static String doctorBlockedTimes(int clinicId) => '$doctorScheduleBase/$clinicId/blocked-times';
  static String doctorDeleteBlockedTime(int blockedTimeId) => '$doctorScheduleBase/blocked-times/$blockedTimeId';
  // عام (مو تحت /doctor) - بيرجع الأوقات المتاحة الفعلية (Slots المولّدة)
  // لأي طبيب بأي مجال تواريخ وعيادة، مستخدم من جهة المريض للحجز، وهون
  // منستخدمه كمان من جهة الطبيب نفسه ليعرض له أوقاته المتاحة يوم بيوم.
  static String doctorAvailability(int doctorId) => '/doctors/$doctorId/availability';

  // ✅ صار موجود فعلياً بالباك (Doctor / list + filter) - لائحة عامة
  // بكل الأطباء، بترجع كل طبيب مع أقسامه (departments، مستقلة عن
  // العيادة هلق) وعياداته (كل عيادة مع رسمها/سعرها الخاص consultation_fee).
  static const String doctorsPublicList = '/doctors';

  // --- Clinics / Departments (public) ---
  static const String clinics = '/clinics';
  static const String departments = '/departments';
=======
>>>>>>> 6f2cf5c88c0f04be6d75e9a7241f4aeaf98d82f7
}
