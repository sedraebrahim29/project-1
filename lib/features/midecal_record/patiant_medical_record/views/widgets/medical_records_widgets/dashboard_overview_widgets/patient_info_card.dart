import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../../core/theme/app_colors.dart';
import '../../../../../../../core/constants/app_strings.dart';
import '../../../../models/medical_record_models/dashboard_overview_models.dart';

// =============================================
// Widget - الكارد العلوي الثابت لمعلومات المريض
// يقرأ الآن من PatientInfo الحقيقي (مبني من user object بعد تسجيل
// الدخول) بدل بيانات وهمية. يدعم 3 حالات: تحميل / ناقص / مكتمل.
// =============================================
class PatientInfoCard extends StatelessWidget {
  final PatientInfo? patient;
  final bool isLoading;
  final VoidCallback? onEditProfile;

  const PatientInfoCard({
    super.key,
    required this.patient,
    this.isLoading = false,
    this.onEditProfile,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    final cardBg = isDarkMode ? AppColors.darkCard : AppColors.white;
    final textColor = isDarkMode ? AppColors.darkText : AppColors.textDark;
    final primaryGreen = isDarkMode ? AppColors.darkPrimaryGreen : AppColors.primaryGreen;
    final avatarBg = isDarkMode ? AppColors.darkBackground : AppColors.backgroundBeige;

    final decoration = BoxDecoration(
      color: cardBg,
      borderRadius: BorderRadius.circular(12.r),
      border: Border(left: BorderSide(color: primaryGreen, width: 4.w)),
      boxShadow: [
        BoxShadow(
          color: isDarkMode ? Colors.black.withOpacity(0.2) : Colors.black.withOpacity(0.05),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
    );

    if (isLoading) {
      return Container(
        decoration: decoration,
        padding: EdgeInsets.all(16.w),
        child: Row(
          children: [
            CircleAvatar(radius: 32.r, backgroundColor: avatarBg),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _skeletonLine(avatarBg, 120.w),
                  SizedBox(height: 8.h),
                  _skeletonLine(avatarBg, 180.w),
                ],
              ),
            ),
          ],
        ),
      );
    }

    final info = patient;
    if (info == null || !info.isComplete) {
      return Container(
        decoration: decoration,
        padding: EdgeInsets.all(16.w),
        child: Row(
          children: [
            CircleAvatar(
              radius: 28.r,
              backgroundColor: avatarBg,
              child: Icon(Icons.person_outline, color: AppColors.textLightGrey, size: 28.sp),
            ),
            SizedBox(width: 14.w),
            Expanded(
              child: Text(
                AppStrings.completeProfilePrompt(context),
                style: TextStyle(color: AppColors.textLightGrey, fontSize: 13.sp, height: 1.4),
              ),
            ),
            if (onEditProfile != null)
              TextButton(
                onPressed: onEditProfile,
                child: Text(
                  AppStrings.editProfile(context),
                  style: TextStyle(color: primaryGreen, fontSize: 13.sp, fontWeight: FontWeight.bold),
                ),
              ),
          ],
        ),
      );
    }

    final age = info.ageInYears;

    return Container(
      decoration: decoration,
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 32.r,
              backgroundColor: avatarBg,
              child: info.avatarAsset.isNotEmpty
                  ? null
                  : Icon(Icons.person, color: AppColors.textLightGrey, size: 32.sp),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          info.name,
                          style: TextStyle(color: textColor, fontSize: 18.sp, fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (onEditProfile != null)
                        InkWell(
                          onTap: onEditProfile,
                          borderRadius: BorderRadius.circular(20.r),
                          child: Padding(
                            padding: EdgeInsets.all(4.w),
                            child: Icon(Icons.edit_outlined, size: 18.sp, color: AppColors.textLightGrey),
                          ),
                        ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  Wrap(
                    spacing: 8.w,
                    runSpacing: 6.h,
                    children: [
                      if (age != null)
                        _InfoChip(
                          icon: Icons.calendar_today_outlined,
                          text: info.dob != null
                              ? '$age ${_yrsLabel(context)} • ${info.dob}'
                              : '$age ${_yrsLabel(context)}',
                        ),
                      if (info.gender != null && info.gender!.isNotEmpty)
                        _InfoChip(icon: Icons.wc_outlined, text: _capitalize(info.gender!)),
                      if (info.bloodType != null && info.bloodType!.isNotEmpty)
                        _InfoChip(icon: Icons.water_drop_outlined, text: info.bloodType!),
                    ],
                  ),
                  if (info.phone != null && info.phone!.isNotEmpty) ...[
                    SizedBox(height: 6.h),
                    _InfoChip(icon: Icons.phone_outlined, text: info.phone!),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _yrsLabel(BuildContext context) =>
      Localizations.localeOf(context).languageCode == 'ar' ? 'سنة' : 'yrs';

  String _capitalize(String s) => s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);

  Widget _skeletonLine(Color color, double width) {
    return Container(
      width: width,
      height: 12.h,
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(4.r)),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String text;

  const _InfoChip({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14.sp, color: AppColors.textLightGrey),
        SizedBox(width: 4.w),
        Text(text, style: TextStyle(color: AppColors.textLightGrey, fontSize: 12.sp)),
      ],
    );
  }
}
