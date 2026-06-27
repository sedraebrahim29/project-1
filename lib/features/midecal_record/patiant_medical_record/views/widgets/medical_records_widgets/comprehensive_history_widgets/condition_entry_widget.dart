import 'package:flutter/material.dart';
import '../../../../../../../core/constants/app_strings.dart';
import '../../../../../../../core/theme/app_colors.dart';
import '../../../../models/medical_record_models/comprehensive_history_models.dart';

// =============================================
// Widget - عنصر الحالة المرضية الواحدة
// اسم + badge Active + DIAGNOSED: XXXX + وصف
// =============================================
class ConditionEntryWidget extends StatelessWidget {
  final ConditionEntry entry;
  final bool showDivider; // خط فاصل بين الحالات

  const ConditionEntryWidget({
    super.key,
    required this.entry,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- صف الاسم + badge ---
              Row(
                children: [
                  Text(
                    entry.name,
                    style: TextStyle(
                      color: isDarkMode ? AppColors.darkText : AppColors.textDark,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 8),

                  // badge "Active" أو حالة المرض — متناسقة تماماً مع الثيم الجديد
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: isDarkMode ? AppColors.darkBackground : AppColors.borderGrey,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      entry.status,
                      style: TextStyle(
                        color: isDarkMode ? AppColors.darkText.withOpacity(0.8) : AppColors.textLightGrey,
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 4),

              // --- DIAGNOSED: XXXX — أحرف مأخوذة ديناميكياً من ملف الترجمة الخاص بكِ ---
              Text(
                '${AppStrings.diagnosed(context)}: ${entry.diagnosedYear}',
                style: TextStyle(
                  color: isDarkMode ? AppColors.darkText.withOpacity(0.5) : AppColors.textLightGrey,
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),

              const SizedBox(height: 6),

              // --- نص الوصف التفصيلي ---
              Text(
                entry.description,
                style: TextStyle(
                  color: isDarkMode ? AppColors.darkText.withOpacity(0.7) : AppColors.textLightGrey,
                  fontSize: 13,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),

        // خط فاصل بين الحالات — لا يظهر بعد الأخيرة ويتغير لونه حسب وضع الثيم
        if (showDivider)
          Divider(
              height: 1,
              color: isDarkMode ? AppColors.darkBackground : AppColors.borderGrey
          ),
      ],
    );
  }
}
