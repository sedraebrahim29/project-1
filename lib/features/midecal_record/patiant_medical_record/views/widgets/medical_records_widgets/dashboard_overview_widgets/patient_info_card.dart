import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../../core/theme/app_colors.dart';
import '../../../../models/medical_record_models/dashboard_overview_models.dart';

class PatientInfoCard extends StatelessWidget {
  final PatientInfo patient;

  const PatientInfoCard({super.key, required this.patient});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border(
          left: BorderSide(color: AppColors.primaryGreen, width: 4.w),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 32.r,
              backgroundColor: AppColors.backgroundBeige,
              child: patient.avatarAsset.isNotEmpty
                  ? null
                  : Icon(Icons.person, color: AppColors.textLightGrey, size: 32.sp),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    patient.name,
                    style: TextStyle(
                      color: AppColors.textDark,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 6.h),
                  _InfoRow(
                    icon: Icons.calendar_today_outlined,
                    text: '${patient.age} (DOB: ${patient.dob})',
                  ),
                  SizedBox(height: 4.h),
                  Row(
                    children: [
                      _InfoRow(
                        icon: Icons.water_drop_outlined,
                        text: 'Blood Type: ${patient.bloodType}',
                      ),
                      SizedBox(width: 12.w),
                      _InfoRow(
                        icon: Icons.straighten,
                        text: patient.height,
                      ),
                    ],
                  ),
                  SizedBox(height: 4.h),
                  _InfoRow(
                    icon: Icons.monitor_weight_outlined,
                    text: patient.weight,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _InfoRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14.sp, color: AppColors.textLightGrey),
        SizedBox(width: 6.w),
        Text(
          text,
          style: TextStyle(
            color: AppColors.textLightGrey,
            fontSize: 12.sp,
          ),
        ),
      ],
    );
  }
}
