import 'package:flutter/material.dart';
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
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            // --- Header: عنوان + VIEW ALL ---
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(
                  children: [
                    Icon(Icons.history, size: 18, color: AppColors.textDark),
                    SizedBox(width: 8),
                    Text(
                      'Recent Activity',
                      style: TextStyle(
                        color: AppColors.textDark,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: onViewAll,
                  child: const Text(
                    'VIEW ALL',
                    style: TextStyle(
                      color: AppColors.primaryGreen,
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

  // أيقونة بناءً على نوع النشاط
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
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // أيقونة مربعة رمادية
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: AppColors.iconBgGrey,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Icon(_icon, size: 18, color: AppColors.textDark),
                ),
              ),

              const SizedBox(width: 12),

              // النص
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: const TextStyle(
                        color: AppColors.textDark,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      item.subtitle,
                      style: const TextStyle(
                        color: AppColors.textGrey,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      item.timestamp,
                      style: const TextStyle(
                        color: AppColors.textGrey,
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
          const Divider(height: 1, color: AppColors.dividerColor),
      ],
    );
  }
}