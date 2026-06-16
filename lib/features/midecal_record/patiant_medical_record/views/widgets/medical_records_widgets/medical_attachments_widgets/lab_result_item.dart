import 'package:flutter/material.dart';
import '../../../../../../../core/theme/app_colors.dart';
import '../../../../models/medical_record_models/medical_attachment_models.dart';

// =============================================
// Widget - عنصر نتيجة مختبر واحد
// يُستخدم داخل كارد أبيض موحد مع divider بينهم
//
// الاستخدام:
//   LabResultItem(
//     result: result,
//     showDivider: true,
//     onDownload: () {},
//   )
// =============================================
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
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            children: [
              // --- أيقونة دائرية رمادية ---
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.iconBgGrey,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Icon(
                    // flask للـ Lipid Panel، microscope للـ Comprehensive
                    result.iconType == 'flask'
                        ? Icons.science_outlined
                        : Icons.biotech_outlined,
                    size: 20,
                    color: AppColors.textDark,
                  ),
                ),
              ),

              const SizedBox(width: 12),

              // --- اسم + تاريخ + نوع + حجم ---
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      result.title,
                      style: const TextStyle(
                        color: AppColors.textDark,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      '${result.date}  •  ${result.fileType} (${result.fileSize})',
                      style: const TextStyle(
                        color: AppColors.textGrey,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),

              // --- أيقونة Download دائرية رمادية ---
              GestureDetector(
                onTap: onDownload,
                child: Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.borderGrey,
                      width: 1.5,
                    ),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.download_outlined,
                      size: 18,
                      color: AppColors.textGrey,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        // Divider بين العناصر فقط — لا يظهر بعد الأخير
        if (showDivider)
          const Divider(
            height: 1,
            thickness: 1,
            color: AppColors.dividerColor,
            indent: 14,
            endIndent: 14,
          ),
      ],
    );
  }
}