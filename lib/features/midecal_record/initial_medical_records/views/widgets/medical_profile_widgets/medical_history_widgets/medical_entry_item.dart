import 'package:flutter/material.dart';
import '../../../../../../../core/theme/app_colors.dart';
import '../../../../models/medical_profile_models/medical_history_models.dart';

// =============================================
// Widget - صف العنصر الواحد داخل القسم
// يعرض: العنوان والتفاصيل يسار، أيقونة تعديل
//        وحذف يمين، وخط فاصل بين العناصر
//
// الاستخدام:
//   MedicalEntryItem(
//     entry: entry,
//     onEdit: () {},
//     onDelete: () {},
//   )
// =============================================
class MedicalEntryItem extends StatelessWidget {
  final MedicalEntry entry;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final bool showDivider; // هل يظهر الخط الفاصل تحت العنصر

  const MedicalEntryItem({
    super.key,
    required this.entry,
    required this.onEdit,
    required this.onDelete,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- النص: العنوان + التفاصيل ---
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      entry.title,
                      style: const TextStyle(
                        color: AppColors.textDark,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      entry.subtitle,
                      style: const TextStyle(
                        color: AppColors.textGrey,
                        fontSize: 12,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),

              // --- أيقونتا التعديل والحذف ---
              Row(
                children: [
                  // أيقونة التعديل (قلم رمادي)
                  GestureDetector(
                    onTap: onEdit,
                    child: const Icon(
                      Icons.edit_outlined,
                      size: 18,
                      color: AppColors.editIconColor,
                    ),
                  ),
                  const SizedBox(width: 12),
                  // أيقونة الحذف (سلة رمادية)
                  GestureDetector(
                    onTap: onDelete,
                    child: const Icon(
                      Icons.delete_outline,
                      size: 18,
                      color: AppColors.deleteIconColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        // خط فاصل بين العناصر (لا يظهر تحت آخر عنصر)
        if (showDivider)
          const Divider(
            height: 1,
            thickness: 1,
            color: AppColors.dividerColor,
            indent: 16,
            endIndent: 16,
          ),
      ],
    );
  }
}