import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../../core/theme/app_colors.dart';
import '../../../../models/medical_record_models/medical_attachment_models.dart';

class LabResultItem extends StatelessWidget {
  final LabResult result;
  final bool showDivider;
  final VoidCallback onDownload;

  const LabResultItem({
    super.key,
    required this.result,
    required this.showDivider,
    required this.onDownload,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          child: Row(
            children: [
              Container(
                width: 40.w,
                height: 40.h,
                decoration: const BoxDecoration(
                  color: AppColors.backgroundBeige,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Icon(
                    result.iconType == 'flask'
                        ? Icons.science_outlined
                        : Icons.biotech_outlined,
                    size: 20.sp,
                    color: AppColors.primaryGreen,
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      result.title,
                      style: TextStyle(
                        color: AppColors.textDark,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 3.h),
                    Text(
                      '${result.date}  •  ${result.fileType} (${result.fileSize})',
                      style: TextStyle(
                        color: AppColors.textLightGrey,
                        fontSize: 12.sp,
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: onDownload,
                child: Container(
                  width: 34.w,
                  height: 34.h,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.borderGrey,
                      width: 1.5,
                    ),
                  ),
                  child: Icon(
                    Icons.download_outlined,
                    size: 18.sp,
                    color: AppColors.textLightGrey,
                  ),
                ),
              ),
            ],
          ),
        ),
        if (showDivider)
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: const Divider(
              height: 1,
              thickness: 1,
              color: AppColors.borderGrey,
            ),
          ),
      ],
    );
  }
}
