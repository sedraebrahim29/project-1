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
}
