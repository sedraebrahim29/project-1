import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/Theme/app_colors.dart';
import '../../../../../core/constants/app_strings_doctor.dart';
import '../../models/doctor_profile_models.dart';
import '../../models/work_schedule_models.dart';

/// كارد أعلى شاشة Doctor Home: صورة + اسم الطبيب + تخصصه، بالنقر عليه
/// بينتقل لبروفايله الكامل (DoctorProfileScreen) - تماماً متل ما بيصير
/// بجهة المريض.
class DoctorProfileHeaderCard extends StatelessWidget {
  final DoctorProfileInfo profile;
  final bool isDark;
  final VoidCallback onTap;

  const DoctorProfileHeaderCard({
    super.key,
    required this.profile,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final primaryGreen = isDark ? AppColors.darkPrimaryGreen : AppColors.primaryGreen;
    final textColor = isDark ? AppColors.darkText : AppColors.textDark;
    final cardBg = isDark ? AppColors.darkCard : AppColors.white;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16.r),
      child: Container(
        padding: EdgeInsets.all(14.w),
        decoration: BoxDecoration(color: cardBg, borderRadius: BorderRadius.circular(16.r)),
        child: Row(
          children: [
            CircleAvatar(
              radius: 28.r,
              backgroundColor: primaryGreen.withOpacity(0.15),
              backgroundImage: profile.photoUrl != null && profile.photoUrl!.isNotEmpty
                  ? NetworkImage(profile.photoUrl!)
                  : null,
              child: profile.photoUrl == null || profile.photoUrl!.isEmpty
                  ? Text(profile.initials,
                      style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold, color: primaryGreen))
                  : null,
            ),
            SizedBox(width: 14.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Dr. ${profile.fullName}',
                    style: TextStyle(fontSize: 17.sp, fontWeight: FontWeight.w800, color: textColor),
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (profile.mainSpecialty.isNotEmpty) ...[
                    SizedBox(height: 3.h),
                    Text(profile.mainSpecialty,
                        style: TextStyle(fontSize: 13.sp, color: AppColors.textLightGrey)),
                  ],
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded, color: AppColors.textLightGrey, size: 22.sp),
          ],
        ),
      ),
    );
  }
}

/// شريحة إحصائية صغيرة (عدد المواعيد اليوم / قيد الانتظار / رسائل ...)
class DoctorStatChip extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final bool isDark;

  const DoctorStatChip({
    super.key,
    required this.icon,
    required this.value,
    required this.label,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final primaryGreen = isDark ? AppColors.darkPrimaryGreen : AppColors.primaryGreen;
    final textColor = isDark ? AppColors.darkText : AppColors.textDark;
    final cardBg = isDark ? AppColors.darkCard : AppColors.white;

    return Expanded(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 4.w),
        padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 8.w),
        decoration: BoxDecoration(color: cardBg, borderRadius: BorderRadius.circular(14.r)),
        child: Column(
          children: [
            Icon(icon, color: primaryGreen, size: 20.sp),
            SizedBox(height: 6.h),
            Text(value, style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w800, color: textColor)),
            SizedBox(height: 2.h),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 10.5.sp, color: AppColors.textLightGrey),
            ),
          ],
        ),
      ),
    );
  }
}

/// بانر "لازم تكون هون من.. لـ.." - بيبني الجملة تلقائياً حسب عدد
/// العيادات المفتوحة اليوم (عيادة وحدة أو أكتر) من جدول العمل الحقيقي
/// يلي حدده الطبيب.
class TodayClinicsBanner extends StatelessWidget {
  final List<TodayClinicSlot> slots;
  final bool isDark;

  const TodayClinicsBanner({super.key, required this.slots, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final primaryGreen = isDark ? AppColors.darkPrimaryGreen : AppColors.primaryGreen;
    final textColor = isDark ? AppColors.darkText : AppColors.textDark;
    final cardBg = isDark ? AppColors.darkCard : AppColors.white;

    if (slots.isEmpty) {
      return Container(
        width: double.infinity,
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(color: cardBg, borderRadius: BorderRadius.circular(14.r)),
        child: Row(
          children: [
            Icon(Icons.event_busy_rounded, color: AppColors.textLightGrey, size: 20.sp),
            SizedBox(width: 10.w),
            Expanded(
              child: Text(DoctorStrings.noAppointmentsToday(context),
                  style: TextStyle(color: AppColors.textLightGrey, fontSize: 13.sp)),
            ),
          ],
        ),
      );
    }

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(color: cardBg, borderRadius: BorderRadius.circular(14.r)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(DoctorStrings.todaysClinics(context),
              style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w700, color: textColor)),
          SizedBox(height: 10.h),
          for (final slot in slots)
            Padding(
              padding: EdgeInsets.only(bottom: 8.h),
              child: Row(
                children: [
                  Container(
                    width: 8.w,
                    height: 8.w,
                    decoration: BoxDecoration(color: primaryGreen, shape: BoxShape.circle),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: Text.rich(
                      TextSpan(
                        style: TextStyle(fontSize: 13.sp, color: textColor, height: 1.4),
                        children: [
                          TextSpan(
                              text: '${DoctorStrings.youShouldBeAt(context)} ',
                              style: TextStyle(color: AppColors.textLightGrey)),
                          TextSpan(text: slot.clinicName, style: TextStyle(fontWeight: FontWeight.w700)),
                          TextSpan(
                              text:
                                  ' ${DoctorStrings.from(context)} ${slot.start.format(context)} ${DoctorStrings.to(context)} ${slot.end.format(context)}',
                              style: TextStyle(color: AppColors.textLightGrey)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

/// بانر أول دخول: الطبيب لسا ما حدد جدول عمله بأي عيادة - يوجّهه لشاشة
/// Work Schedule Management بدل ما يعرضله خيارات فارغة بدون سياق.
class EmptyScheduleBanner extends StatelessWidget {
  final bool isDark;
  final VoidCallback onSetup;

  const EmptyScheduleBanner({super.key, required this.isDark, required this.onSetup});

  @override
  Widget build(BuildContext context) {
    final primaryGreen = isDark ? AppColors.darkPrimaryGreen : AppColors.primaryGreen;
    final textColor = isDark ? AppColors.darkText : AppColors.textDark;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        color: primaryGreen.withOpacity(0.10),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: primaryGreen.withOpacity(0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.event_available_rounded, color: primaryGreen, size: 22.sp),
              SizedBox(width: 10.w),
              Expanded(
                child: Text(
                  DoctorStrings.scheduleNotSetTitle(context),
                  style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w800, color: textColor),
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            DoctorStrings.scheduleNotSetDesc(context),
            style: TextStyle(fontSize: 12.5.sp, color: AppColors.textLightGrey, height: 1.5),
          ),
          SizedBox(height: 14.h),
          SizedBox(
            width: double.infinity,
            height: 44.h,
            child: ElevatedButton(
              onPressed: onSetup,
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryGreen,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
              ),
              child: Text(DoctorStrings.setUpSchedule(context),
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 14.sp)),
            ),
          ),
        ],
      ),
    );
  }
}
