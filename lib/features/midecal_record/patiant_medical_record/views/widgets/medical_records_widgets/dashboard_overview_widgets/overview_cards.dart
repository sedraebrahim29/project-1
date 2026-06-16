import 'package:flutter/material.dart';
import '../../../../../../../core/theme/app_colors.dart';
import '../../../../models/medical_record_models/dashboard_overview_models.dart';

// =============================================
// Widget - كارد Active Medications
// خلفية أخضر فاتح mint + أيقونة + كبيرة يمين
// عنوان + وصف + زر Manage →
// =============================================
class ActiveMedicationsCard extends StatelessWidget {
  final ActiveMedicationsData data;
  final VoidCallback onManage;

  const ActiveMedicationsCard({
    super.key,
    required this.data,
    required this.onManage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 400,
      decoration: BoxDecoration(
        color: const Color(0xFFD0EDD9), // أخضر فاتح mint
        borderRadius: BorderRadius.circular(12),
      ),
      child: Stack(
        children: [
          // --- أيقونة + كبيرة شفافة يمين الخلفية ---
          Positioned(
            right: 16,
            top: 12,
            child: Icon(
              Icons.add_box_outlined,
              size: 52,
              color: AppColors.primaryGreen.withOpacity(0.15),
            ),
          ),

          // --- المحتوى ---
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // أيقونة الدواء المربعة
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.medication_outlined,
                      size: 22,
                      color: AppColors.primaryGreen,
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // العنوان
                const Text(
                  'Active Medications',
                  style: TextStyle(
                    color: AppColors.textDark,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),

                // العدد + الوصف
                Text(
                  '${data.count} ${data.label}',
                  style: const TextStyle(
                    color: AppColors.textGrey,
                    fontSize: 13,
                  ),
                ),

                const SizedBox(height: 14),

                // زر Manage →
                GestureDetector(
                  onTap: onManage,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: AppColors.borderGrey,
                        width: 1,
                      ),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Manage',
                          style: TextStyle(
                            color: AppColors.textDark,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(width: 4),
                        Icon(Icons.arrow_forward,
                            size: 14, color: AppColors.textDark),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// =============================================
// Widget - كارد Latest Vitals
// خلفية بيج فاتح + أيقونة نبضات + BP + HR
// + زر View Trends ↗
// =============================================
class LatestVitalsCard extends StatelessWidget {
  final LatestVitalsData data;
  final VoidCallback onViewTrends;

  const LatestVitalsCard({
    super.key,
    required this.data,
    required this.onViewTrends,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 400,
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
      child: Stack(
        children: [
          // --- أيقونة نبضات كبيرة شفافة يمين ---
          Positioned(
            right: 16,
            top: 12,
            child: Icon(
              Icons.monitor_heart_outlined,
              size: 52,
              color: AppColors.textGrey.withOpacity(0.15),
            ),
          ),

          // --- المحتوى ---
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // أيقونة النبضات المربعة
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.iconBgGrey,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.monitor_heart_outlined,
                      size: 22,
                      color: AppColors.textDark,
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // عنوان Latest Vitals
                const Text(
                  'Latest Vitals',
                  style: TextStyle(
                    color: AppColors.textDark,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),

                // BP + HR
                Text(
                  'BP: ${data.bp}, HR: ${data.hr}',
                  style: const TextStyle(
                    color: AppColors.textGrey,
                    fontSize: 13,
                  ),
                ),

                const SizedBox(height: 14),

                // زر View Trends ↗
                GestureDetector(
                  onTap: onViewTrends,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: AppColors.borderGrey,
                        width: 1,
                      ),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'View Trends',
                          style: TextStyle(
                            color: AppColors.textDark,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(width: 4),
                        Icon(Icons.open_in_new,
                            size: 14, color: AppColors.textDark),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}