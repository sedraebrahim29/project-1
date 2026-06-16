import 'package:flutter/material.dart';

import '../../../../../../../core/theme/app_colors.dart';
import '../../../../models/medical_record_models/comprehensive_history_models.dart';


// =============================================
// Widget - عنصر الحالة المرضية الواحدة
// اسم + badge Active + DIAGNOSED: XXXX + وصف
//
// الاستخدام:
//   ConditionEntryWidget(entry: entry, showDivider: true)
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
                    style: const TextStyle(
                      color: AppColors.textDark,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 8),
                  // badge "Active" — رمادي فاتح مع نص رمادي
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.completedGrey,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      entry.status,
                      style: const TextStyle(
                        color: AppColors.textMedium,
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 4),

              // --- DIAGNOSED: XXXX — أحرف كبيرة رمادية صغيرة ---
              Text(
                'DIAGNOSED: ${entry.diagnosedYear}',
                style: const TextStyle(
                  color: AppColors.textGrey,
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),

              const SizedBox(height: 6),

              // --- نص الوصف التفصيلي ---
              Text(
                entry.description,
                style: const TextStyle(
                  color: AppColors.textGrey,
                  fontSize: 13,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),

        // خط فاصل بين الحالات — لا يظهر بعد الأخيرة
        if (showDivider)
          const Divider(height: 1, color: AppColors.dividerColor),
      ],
    );
  }
}