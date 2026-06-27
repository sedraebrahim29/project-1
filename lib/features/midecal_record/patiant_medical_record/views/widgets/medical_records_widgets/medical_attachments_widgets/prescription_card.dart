import 'package:flutter/material.dart'; // أو المسار الخاص بـ StringApp لديكِ
import 'package:untitled3/core/constants/app_strings.dart';
import '../../../../../../../core/theme/app_colors.dart';
import '../../../../models/medical_record_models/medical_attachment_models.dart';

// =============================================
// Widget - كارد الوصفة الطبية
// حد أخضر يسار + اسم + badge + دكتور + نوع
// + زرا View و Download
// =============================================
class PrescriptionCard extends StatelessWidget {
  final Prescription prescription;
  final VoidCallback onView;
  final VoidCallback onDownload;

  const PrescriptionCard({
    super.key,
    required this.prescription,
    required this.onView,
    required this.onDownload,
  });

  // لون الحد الأيسر بناءً على الحالة من ملف ألوانكِ
  Color get _borderColor =>
      prescription.status == 'ACTIVE'
          ? AppColors.primaryGreen
          : AppColors.textLightGrey;

  @override
  Widget build(BuildContext context) {

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(10),
        // الحد الأيسر الملوّن — أخضر للـ ACTIVE، رمادي للـ EXPIRED
        border: Border(
          left: BorderSide(color: _borderColor, width: 4),
        ),
        boxShadow: const [
          BoxShadow(
            color: AppColors.borderGrey,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- صف الأيقونة + الاسم + Badge ---
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // أيقونة الوصفة
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: AppColors.borderGrey,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.description_outlined,
                      size: 20,
                      color: AppColors.textDark,
                    ),
                  ),
                ),

                const SizedBox(width: 10),

                // اسم الدواء + دكتور + نوع الملف
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        prescription.medicationName,
                        style: const TextStyle(
                          color: AppColors.textDark,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        '${prescription.doctorName} • ${prescription.fileType}',
                        style: const TextStyle(
                          color: AppColors.textLightGrey,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),

                // Badge ACTIVE / EXPIRED
                _StatusBadge(status: prescription.status),
              ],
            ),

            const SizedBox(height: 10),

            // --- زرا View و Download ---
            Row(
              children: [
                // زر View مع أيقونة عين
                GestureDetector(
                  onTap: onView,
                  child: Row(
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(left: 45),
                        child: Icon(
                          Icons.visibility_outlined,
                          size: 15,
                          color: AppColors.textLightGrey,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        AppStrings.view(context) ,// ملف الترجمة string_app
                        style: const TextStyle(
                          color: AppColors.textLightGrey,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 16),

                // زر Download مع أيقونة تحميل
                GestureDetector(
                  onTap: onDownload,
                  child: Row(
                    children: [
                      const Icon(
                        Icons.download_outlined,
                        size: 15,
                        color: AppColors.textLightGrey,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        AppStrings.download(context), // ملف الترجمة string_app
                        style: const TextStyle(
                          color: AppColors.textLightGrey,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// =============================================
// Sub-widget - Badge الحالة ACTIVE / EXPIRED
// =============================================
class _StatusBadge extends StatelessWidget {
  final String status;

  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final bool isActive = status == 'ACTIVE';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: isActive ? AppColors.backgroundBeige : AppColors.borderGrey,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: isActive ? AppColors.primaryGreen : AppColors.textLightGrey,
          fontSize: 10,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
