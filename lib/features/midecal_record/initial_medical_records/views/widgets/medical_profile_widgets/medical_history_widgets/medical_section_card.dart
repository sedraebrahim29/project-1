import 'package:flutter/material.dart';
import '../../../../../../../core/theme/app_colors.dart';
import '../../../../models/medical_profile_models/medical_history_models.dart';
import 'medical_entry_item.dart';

// =============================================
// Widget - كارد القسم القابل للطي والفتح
// يعرض: أيقونة + عنوان + زر Add New + سهم
//        وعند الفتح: يعرض قائمة العناصر
//
// الاستخدام:
//   MedicalSectionCard(
//     section: section,
//     iconWidget: Icon(...),
//     iconBgColor: AppColors.iconBgPink,
//     onToggle: () {},
//     onAddNew: () {},
//     onEdit: (entry) {},
//     onDelete: (entry) {},
//   )
// =============================================
class MedicalSectionCard extends StatelessWidget {
  final MedicalSection section;
  final Widget iconWidget;       // أيقونة القسم (مختلفة لكل قسم)
  final Color iconBgColor;       // لون خلفية دائرة الأيقونة
  final VoidCallback onToggle;   // فتح/غلق القسم
  final VoidCallback onAddNew;   // زر + Add New
  final Function(MedicalEntry) onEdit;
  final Function(MedicalEntry) onDelete;

  const MedicalSectionCard({
    super.key,
    required this.section,
    required this.iconWidget,
    required this.iconBgColor,
    required this.onToggle,
    required this.onAddNew,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // =============================================
          // Header: أيقونة + عنوان + زر Add New + سهم
          // =============================================
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // --- صف العنوان والسهم ---
                Row(
                  children: [
                    // دائرة الأيقونة
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: iconBgColor,
                        shape: BoxShape.circle,
                      ),
                      child: Center(child: iconWidget),
                    ),
                    const SizedBox(width: 12),

                    // عنوان القسم
                    Expanded(
                      child: Text(
                        section.title,
                        style: const TextStyle(
                          color: AppColors.textDark,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),

                    // سهم الفتح/الغلق
                    GestureDetector(
                      onTap: onToggle,
                      child: Icon(
                        section.isExpanded
                            ? Icons.keyboard_arrow_up
                            : Icons.keyboard_arrow_down,
                        color: AppColors.textGrey,
                        size: 22,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                // --- زر + Add New ---
                _AddNewButton(onTap: onAddNew),
              ],
            ),
          ),

          // =============================================
          // القائمة المنسدلة - تظهر فقط إذا isExpanded
          // =============================================
          if (section.isExpanded && section.entries.isNotEmpty) ...[
            const Divider(height: 1, color: AppColors.dividerColor),
            // عرض كل عنصر بالقائمة
            ...section.entries.asMap().entries.map((mapEntry) {
              final index = mapEntry.key;
              final entry = mapEntry.value;
              // الخط الفاصل لا يظهر تحت آخر عنصر
              final isLast = index == section.entries.length - 1;
              return MedicalEntryItem(
                entry: entry,
                onEdit: () => onEdit(entry),
                onDelete: () => onDelete(entry),
                showDivider: !isLast,
              );
            }),
          ],
        ],
      ),
    );
  }
}

// =============================================
// Sub-widget - زر + Add New
// الشكل: pill أخضر فاتح مع نص أخضر داكن
// =============================================
class _AddNewButton extends StatelessWidget {
  final VoidCallback onTap;

  const _AddNewButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.lightGreen,
          borderRadius: BorderRadius.circular(20), // شكل pill
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min, // بس بقدر النص
          children: [
            Icon(
              Icons.add,
              size: 14,
              color: AppColors.primaryGreen,
            ),
            SizedBox(width: 4),
            Text(
              'Add New',
              style: TextStyle(
                color: AppColors.primaryGreen,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}