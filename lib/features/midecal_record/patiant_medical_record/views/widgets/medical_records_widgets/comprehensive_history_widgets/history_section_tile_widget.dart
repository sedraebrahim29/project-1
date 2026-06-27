import 'package:flutter/material.dart';
import '../../../../../../../core/theme/app_colors.dart';
import '../../../../models/medical_record_models/comprehensive_history_models.dart';
import 'condition_entry_widget.dart';

// =============================================
// Widget - قسم قابل للطي
// أيقونة مربعة + عنوان + سهم + محتوى عند الفتح
// =============================================
class HistorySectionTile extends StatelessWidget {
  final HistorySection section;
  final VoidCallback onToggle;

  const HistorySectionTile({
    super.key,
    required this.section,
    required this.onToggle,
  });

  // =============================================
  // أيقونة كل قسم — مربعة مع زوايا مدورة مع دعم الـ Dark Mode
  // =============================================
  Widget _buildSectionIcon(bool isDarkMode) {
    final IconData icon;

    switch (section.iconType) {
      case 'chronic':
        icon = Icons.monitor_heart_outlined; // نبضات قلب
        break;
      case 'surgery':
        icon = Icons.content_cut;            // مقص/جراحة
        break;
      case 'allergy':
        icon = Icons.masks_outlined;         // كمامة للحساسية
        break;
      case 'family':
        icon = Icons.people_outline;         // عائلة
        break;
      case 'other':
        icon = Icons.assignment_outlined;    // ملف/قائمة
        break;
      default:
        icon = Icons.medical_services_outlined;
    }

    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: isDarkMode ? AppColors.darkBackground : AppColors.borderGrey, // الخلفية الرمادية المناسبة لملف ألوانكِ
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Icon(
            icon,
            size: 20,
            color: isDarkMode ? AppColors.darkText : AppColors.textDark
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        // --- Header القسم ---
        InkWell(
          onTap: onToggle,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                // أيقونة مربعة تدعم الألوان الحالية بالكامل
                _buildSectionIcon(isDarkMode),
                const SizedBox(width: 14),
                // عنوان القسم
                Expanded(
                  child: Text(
                    section.title,
                    style: TextStyle(
                      color: isDarkMode ? AppColors.darkText : AppColors.textDark,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                // سهم فوق/تحت
                Icon(
                  section.isExpanded
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  color: isDarkMode ? AppColors.darkText.withOpacity(0.5) : AppColors.textLightGrey,
                  size: 22,
                ),
              ],
            ),
          ),
        ),

        // --- المحتوى عند الفتح ---
        if (section.isExpanded && section.entries.isNotEmpty)
          Column(
            children: List.generate(section.entries.length, (index) {
              return ConditionEntryWidget(
                entry: section.entries[index],
                showDivider: index != section.entries.length - 1,
              );
            }),
          ),

        // divider بين الأقسام دائماً يعتمد على حالة الثيم لتفادي المشاكل البصرية بالـ Dark mode
        Divider(
            height: 1,
            color: isDarkMode ? AppColors.darkBackground : AppColors.borderGrey
        ),
      ],
    );
  }
}
