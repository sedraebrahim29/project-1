import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../../core/theme/app_colors.dart';
import '../../../../../../../core/constants/app_strings.dart';
import '../../../../models/medical_record_models/dashboard_overview_models.dart';

// =============================================
// Widget - كارد Active Medications
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
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFD0EDD9), // Light mint green as per Figma
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
              color: AppColors.primaryGreen.withOpacity(0.15),
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
                    color: AppColors.white.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.medication_outlined,
                      size: 22.sp,
                      color: AppColors.primaryGreen,
                    ),
                  ),
                ),
                SizedBox(height: 12.h),
                Text(
                  AppStrings.activeMedications(context),
                  style: TextStyle(
                    color: AppColors.textDark,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  '${data.count} ${AppStrings.currentPrescriptions(context)}',
                  style: TextStyle(
                    color: AppColors.textLightGrey,
                    fontSize: 13.sp,
                  ),
                ),
                SizedBox(height: 14.h),
                GestureDetector(
                  onTap: onManage,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(8.r),
                      border: Border.all(
                        color: AppColors.borderGrey,
                        width: 1.w,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          AppStrings.manage(context),
                          style: TextStyle(
                            color: AppColors.textDark,
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(width: 4.w),
                        Icon(Icons.arrow_forward, size: 14.sp, color: AppColors.textDark),
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
// Widget - كارد Latest Vitals
// =============================================
class LatestVitalsCard extends StatelessWidget {
  final LatestVitalsData data;
  final VoidCallback onViewTrends;

  const LatestVitalsCard({
    super.key,
    required this.data,
    required this.onViewTrends,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: 16.w,
            top: 12.h,
            child: Icon(
              Icons.monitor_heart_outlined,
              size: 52.sp,
              color: AppColors.textLightGrey.withOpacity(0.1),
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
                    color: AppColors.backgroundBeige,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.monitor_heart_outlined,
                      size: 22.sp,
                      color: AppColors.textDark,
                    ),
                  ),
                ),
                SizedBox(height: 12.h),
                Text(
                  AppStrings.latestVitals(context),
                  style: TextStyle(
                    color: AppColors.textDark,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  'BP: ${data.bp}, HR: ${data.hr}',
                  style: TextStyle(
                    color: AppColors.textLightGrey,
                    fontSize: 13.sp,
                  ),
                ),
                SizedBox(height: 14.h),
                GestureDetector(
                  onTap: onViewTrends,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(8.r),
                      border: Border.all(
                        color: AppColors.borderGrey,
                        width: 1.w,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          AppStrings.viewTrends(context),
                          style: TextStyle(
                            color: AppColors.textDark,
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(width: 4.w),
                        Icon(Icons.open_in_new, size: 14.sp, color: AppColors.textDark),
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
