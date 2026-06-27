import 'package:flutter/material.dart'; // المسار الصحيح لملف ألوانكِ
import '../../../../../../../core/constants/app_strings.dart';
import '../../../../../../../core/theme/app_colors.dart';
import '../../../../models/medical_record_models/dashboard_overview_models.dart';

// =============================================
// Widget - كارد Recent Activity
// عنوان + VIEW ALL + قائمة أنشطة
// =============================================
class RecentActivityCard extends StatelessWidget {
  final List<ActivityItem> activities;
  final VoidCallback onViewAll;

  const RecentActivityCard({
    super.key,
    required this.activities,
    required this.onViewAll,
  });

  @override
  Widget build(BuildContext context) {
    // التحقق من حالة الـ Dark Mode الحالية للثيم
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDarkMode ? AppColors.darkCard : AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDarkMode ? Colors.transparent : AppColors.borderGrey,
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            // --- Header: عنوان + VIEW ALL ---
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                        Icons.history,
                        size: 18,
                        color: isDarkMode ? AppColors.darkText : AppColors.textDark
                    ),
                    const SizedBox(width: 8),
                    Text(
                      AppStrings.recentActivity(context), // استخدام ملف الترجمة الأساسي الخاص بكِ
                      style: TextStyle(
                        color: isDarkMode ? AppColors.darkText : AppColors.textDark,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: onViewAll,
                  child: Text(
                    AppStrings.viewAll(context), // استخدام ملف الترجمة الأساسي الخاص بكِ
                    style: TextStyle(
                      color: isDarkMode ? AppColors.darkPrimaryGreen : AppColors.primaryGreen,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // --- قائمة الأنشطة ---
            ...List.generate(activities.length, (index) {
              return _ActivityItem(
                item: activities[index],
                showDivider: index != activities.length - 1,
              );
            }),
          ],
        ),
      ),
    );
  }
}

// =============================================
// Sub-widget - عنصر النشاط الواحد
// أيقونة مربعة + عنوان + وصف + وقت
// =============================================
class _ActivityItem extends StatelessWidget {
  final ActivityItem item;
  final bool showDivider;

  const _ActivityItem({required this.item, required this.showDivider});

  IconData get _icon {
    switch (item.iconType) {
      case 'lab':
        return Icons.science_outlined;
      case 'prescription':
        return Icons.description_outlined;
      default:
        return Icons.medical_services_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // أيقونة مربعة بخلفية رمادية/داكنة متناسقة تماماً مع ألوان الثيم الجديدة
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: isDarkMode ? AppColors.darkBackground : AppColors.borderGrey,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Icon(
                      _icon,
                      size: 18,
                      color: isDarkMode ? AppColors.darkText : AppColors.textDark
                  ),
                ),
              ),

              const SizedBox(width: 12),

              // النصوص مع مراعاة درجات رمادي الخطوط الفاتحة والداكنة من ملف ألوانكِ
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: TextStyle(
                        color: isDarkMode ? AppColors.darkText : AppColors.textDark,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      item.subtitle,
                      style: TextStyle(
                        color: isDarkMode ? AppColors.darkText.withOpacity(0.7) : AppColors.textLightGrey,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      item.timestamp,
                      style: TextStyle(
                        color: isDarkMode ? AppColors.darkText.withOpacity(0.5) : AppColors.textLightGrey,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        if (showDivider)
          Divider(
              height: 1,
              color: isDarkMode ? AppColors.darkBackground : AppColors.borderGrey
          ),
      ],
    );
  }
}
