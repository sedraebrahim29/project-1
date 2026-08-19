import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../../core/theme/app_colors.dart';
import '../../../../../../../core/constants/app_strings.dart';
import '../../../../models/medical_record_models/dashboard_overview_models.dart';

// =============================================
// Widget - كارد Active Medications (يدعم الثيمين)
// =============================================
class ActiveMedicationsCard extends StatelessWidget {
  final ActiveMedicationsData data;
  final VoidCallback onManage;

  const ActiveMedicationsCard({
    super.key,
    required this.data,
    required this.onManage,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    final cardBgColor = isDarkMode ? const Color(0xFF1B3D2B) : const Color(0xFFD0EDD9);
    final primaryGreen = isDarkMode ? AppColors.darkPrimaryGreen : AppColors.primaryGreen;
    final textColor = isDarkMode ? AppColors.darkText : AppColors.textDark;
    final subTextColor = isDarkMode ? AppColors.darkText.withOpacity(0.6) : AppColors.textLightGrey;
    final buttonBg = isDarkMode ? AppColors.darkCard : AppColors.white;
    final buttonBorder = isDarkMode ? Colors.white10 : AppColors.borderGrey;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: cardBgColor,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Stack(
        children: [
          Positioned(
            right: 16.w,
            top: 12.h,
            child: Icon(
              Icons.add_box_outlined,
              size: 52.sp,
              color: primaryGreen.withOpacity(0.12),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 40.w,
                  height: 40.h,
                  decoration: BoxDecoration(
                    color: isDarkMode ? Colors.black : AppColors.white.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.medication_outlined,
                      size: 22.sp,
                      color: primaryGreen,
                    ),
                  ),
                ),
                SizedBox(height: 12.h),
                Text(
                  AppStrings.activeMedications(context),
                  style: TextStyle(
                    color: textColor,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  '${data.count} ${AppStrings.currentPrescriptions(context)}',
                  style: TextStyle(
                    color: subTextColor,
                    fontSize: 13.sp,
                  ),
                ),
                SizedBox(height: 14.h),
                GestureDetector(
                  onTap: onManage,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                    decoration: BoxDecoration(
                      color: buttonBg,
                      borderRadius: BorderRadius.circular(8.r),
                      border: Border.all(color: buttonBorder, width: 1.w),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          AppStrings.manage(context),
                          style: TextStyle(color: textColor, fontSize: 13.sp, fontWeight: FontWeight.w500),
                        ),
                        SizedBox(width: 4.w),
                        Icon(Icons.arrow_forward, size: 14.sp, color: textColor),
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

// =============================================
// Widget - كارد ملخص السجل (يحل محل Latest Vitals القديم)
// مبني بالكامل من عدّادات حقيقية (allergies/conditions/medications/
// attachments) بدل علامات حيوية وهمية لا يوجد لها endpoint حالياً.
// =============================================
class RecordSummaryCard extends StatelessWidget {
  final RecordSummaryData data;

  const RecordSummaryCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    final cardBgColor = isDarkMode ? AppColors.darkCard : AppColors.white;
    final textColor = isDarkMode ? AppColors.darkText : AppColors.textDark;
    final subTextColor = isDarkMode ? AppColors.darkText.withOpacity(0.6) : AppColors.textLightGrey;
    final iconContainerBg = isDarkMode ? AppColors.darkBackground : AppColors.backgroundBeige;

    final stats = <_Stat>[
      _Stat(Icons.monitor_heart_outlined, data.conditionsCount, AppStrings.chronicDiseases(context)),
      _Stat(Icons.masks_outlined, data.allergiesCount, AppStrings.allergies(context)),
      _Stat(Icons.medication_outlined, data.medicationsCount, AppStrings.medications(context)),
      _Stat(Icons.attach_file, data.attachmentsCount, AppStrings.attachments(context)),
    ];

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: cardBgColor,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: isDarkMode ? Colors.black.withOpacity(0.2) : Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppStrings.recordSummary(context),
            style: TextStyle(color: textColor, fontSize: 16.sp, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 14.h),
          Row(
            children: stats
                .map((s) => Expanded(
                      child: Column(
                        children: [
                          Container(
                            width: 40.w,
                            height: 40.h,
                            decoration: BoxDecoration(
                              color: iconContainerBg,
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: Center(child: Icon(s.icon, size: 20.sp, color: textColor)),
                          ),
                          SizedBox(height: 6.h),
                          Text(
                            '${s.count}',
                            style: TextStyle(color: textColor, fontSize: 16.sp, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            s.label,
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(color: subTextColor, fontSize: 10.sp),
                          ),
                        ],
                      ),
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }
}

class _Stat {
  final IconData icon;
  final int count;
  final String label;
  const _Stat(this.icon, this.count, this.label);
}
