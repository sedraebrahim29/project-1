import 'package:flutter/material.dart';
import '../../../../../../../core/theme/app_colors.dart';
import '../../../../models/medical_record_models/comprehensive_history_models.dart';

// =============================================
// Widget - عنصر الحالة المرضية الواحدة
// اسم + badge اختياري + سطر meta (Diagnosed/Surgery date/Reaction/
// Relation حسب القسم) + وصف. الـ label بقى ديناميكي بدل "DIAGNOSED"
// ثابتة (كانت غلط لغوياً بقسم Surgeries/Allergies/Family History).
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
              // --- صف الاسم + badge (اختياري) ---
              Row(
                children: [
                  Expanded(
                    child: Text(
                      entry.name,
                      style: TextStyle(
                        color: isDarkMode ? AppColors.darkText : AppColors.textDark,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  if (entry.status != null && entry.status!.isNotEmpty) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: isDarkMode ? AppColors.darkBackground : AppColors.borderGrey,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        entry.status!,
                        style: TextStyle(
                          color: isDarkMode ? AppColors.darkText.withOpacity(0.8) : AppColors.textLightGrey,
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ],
              ),

              const SizedBox(height: 4),

              // --- سطر الـ meta: label ديناميكي حسب نوع القسم ---
              if (entry.metaValue.isNotEmpty)
                Text(
                  '${entry.metaLabel}: ${entry.metaValue}',
                  style: TextStyle(
                    color: isDarkMode ? AppColors.darkText.withOpacity(0.5) : AppColors.textLightGrey,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),

              if (entry.description.isNotEmpty) ...[
                const SizedBox(height: 6),
                Text(
                  entry.description,
                  style: TextStyle(
                    color: isDarkMode ? AppColors.darkText.withOpacity(0.7) : AppColors.textLightGrey,
                    fontSize: 13,
                    height: 1.5,
                  ),
                ),
              ],
            ],
          ),
        ),

        if (showDivider)
          Divider(height: 1, color: isDarkMode ? AppColors.darkBackground : AppColors.borderGrey),
      ],
    );
  }
}
