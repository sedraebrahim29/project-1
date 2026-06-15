import 'package:flutter/material.dart';

// =============================================
// كل ألوان التطبيق بمكان واحد
// لو بدك تغير لون، بتغيره هون بس
// =============================================
class AppColors {
  AppColors._(); // منع إنشاء instance من الكلاس

  static const Color background    = Color(0xFFF2F2EF); // خلفية الشاشة بيج فاتح
  static const Color primaryGreen  = Color(0xFF2D6A4F); // الأخضر الداكن الرئيسي
  static const Color lightGreen    = Color(0xFFD8F0E5); // خلفية badge Upcoming
  static const Color cancelRed     = Color(0xFFE53935); // أحمر Cancelled
  static const Color lightRed      = Color(0xFFFFE5E5); // خلفية badge Cancelled
  static const Color completedGrey = Color(0xFFE8E8E8); // خلفية badge Completed
  static const Color textDark      = Color(0xFF1C1C1C); // النص الداكن الرئيسي
  static const Color textGrey      = Color(0xFF7A7A7A); // النص الرمادي الثانوي
  static const Color textMedium    = Color(0xFF4A4A4A); // نص التاريخ والوقت
  static const Color textCompleted = Color(0xFF555555); // نص badge Completed
  static const Color borderGrey    = Color(0xFFB0B0B0); // حد الأزرار الرمادي
  static const Color dividerColor  = Color(0xFFEEEEEE); // الخط الفاصل داخل الكارد
  static const Color avatarBg      = Color(0xFFD9D9D9); // خلفية صورة الدكتور
  static const Color cardShadow    = Color(0x0D000000); // ظل الكارد خفيف
  static const Color navBarShadow  = Color(0x1A000000);// ظل الـ BottomNav
// =============== Medical Profile ===============
  static const Color progressBg        = Color(0xFFE0E0E0); // خلفية شريط التقدم
  static const Color backButtonBorder  = Color(0xFFD0D0D0); // حد زر Back
  static const Color editIconColor     = Color(0xFF9E9E9E); // أيقونة التعديل
  static const Color deleteIconColor   = Color(0xFF9E9E9E); // أيقونة الحذف
  static const Color iconBgPink        = Color(0xFFFCE8E8); // Chronic & Allergies
  static const Color iconBgGrey        = Color(0xFFF0F0F0); // Surgeries
  static const Color iconBgDark        = Color(0xFFE8E8E8); // Family History
  static const Color progressFill = Color(0xFF2D6A4F); // نفس primaryGreen
  static const Color cardBg = Colors.white;
}