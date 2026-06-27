import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../../core/theme/app_colors.dart';
import '../../../../models/medical_record_models/medical_attachment_models.dart';

class MedicalImageCard extends StatelessWidget {
  final MedicalImage image;
  final VoidCallback onDownload;

  const MedicalImageCard({
    super.key,
    required this.image,
    required this.onDownload,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12.r),
      child: Stack(
        children: [
          Container(
            height: 150.h,
            width: double.infinity,
            color: AppColors.textDark, // Dark background as per Figma
            child: image.imageAsset.isNotEmpty
                ? Image.asset(image.imageAsset, fit: BoxFit.cover)
                : Center(
                    child: Icon(
                      Icons.image_outlined,
                      color: AppColors.white.withOpacity(0.3),
                      size: 40.sp,
                    ),
                  ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.fromLTRB(10.w, 24.h, 10.w, 10.h),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.8),
                  ],
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          image.title,
                          style: TextStyle(
                            color: AppColors.white,
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          '${image.date} • ${image.fileType}',
                          style: TextStyle(
                            color: AppColors.white.withOpacity(0.7),
                            fontSize: 10.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: onDownload,
                    child: Container(
                      width: 28.w,
                      height: 28.h,
                      decoration: BoxDecoration(
                        color: AppColors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.white.withOpacity(0.5),
                          width: 1,
                        ),
                      ),
                      child: Icon(
                        Icons.download_outlined,
                        color: AppColors.white,
                        size: 16.sp,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
