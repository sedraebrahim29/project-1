import 'package:flutter/material.dart';
import '../../../models/medical_profile_models/medication_model.dart';
import '../../../theme/app_colors.dart';

// =============================================
// Widget - كارد الدواء الواحد
// يعرض: أيقونة حبة دواء + اسم + badge Active
//        + 3 نقاط + Dosage + Frequency
//
// الاستخدام:
//   MedicationCard(
//     medication: medication,
//     onMenuTap: () {},
//   )
// =============================================
class MedicationCard extends StatelessWidget {
  final Medication medication;
  final VoidCallback onMenuTap; // الضغط على الـ 3 نقاط

  const MedicationCard({
    super.key,
    required this.medication,
    required this.onMenuTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- أيقونة حبة الدواء ---
            _MedicationIcon(),

            const SizedBox(width: 12),

            // --- المحتوى: اسم + dosage + frequency ---
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // صف الاسم + badge Active
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Text(
                          medication.name,
                          style: const TextStyle(
                            color: AppColors.textDark,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      // Badge الحالة
                      _StatusBadge(status: medication.status),
                    ],
                  ),

                  const SizedBox(height: 6),

                  // صف Dosage مع أيقونة
                  _InfoRow(
                    icon: Icons.medication_outlined,
                    label: 'Dosage:',
                    value: medication.dosage,
                  ),

                  const SizedBox(height: 4),

                  // صف Frequency مع أيقونة ساعة
                  _InfoRow(
                    icon: Icons.access_time,
                    label: 'Frequency:',
                    value: medication.frequency,
                  ),
                ],
              ),
            ),

            // --- أيقونة الـ 3 نقاط (القائمة) ---
            GestureDetector(
              onTap: onMenuTap,
              child: const Padding(
                padding: EdgeInsets.only(left: 4),
                child: Icon(
                  Icons.more_vert,
                  color: AppColors.textGrey,
                  size: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =============================================
// Sub-widget - دائرة أيقونة الحبة الدواء
// خلفية رمادية فاتحة مع أيقونة حبة داكنة
// =============================================
class _MedicationIcon extends StatelessWidget {
  const _MedicationIcon();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: AppColors.iconBgGrey, // رمادي فاتح
        shape: BoxShape.circle,
      ),
      child: const Center(
        child: Icon(
          Icons.medication,
          size: 22,
          color: AppColors.textDark, // حبة داكنة
        ),
      ),
    );
  }
}

// =============================================
// Sub-widget - Badge الحالة (Active / Inactive)
// =============================================
class _StatusBadge extends StatelessWidget {
  final String status;

  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    // Active = أخضر فاتح | Inactive = رمادي
    final bool isActive = status == 'Active';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: isActive ? AppColors.lightGreen : AppColors.completedGrey,
        borderRadius: BorderRadius.circular(20), // pill shape
      ),
      child: Text(
        status,
        style: TextStyle(
          color: isActive ? AppColors.primaryGreen : AppColors.textGrey,
          fontSize: 11,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

// =============================================
// Sub-widget - صف المعلومات (Dosage / Frequency)
// أيقونة + label بولد خفيف + قيمة
// =============================================
class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // الأيقونة
        Icon(icon, size: 13, color: AppColors.textGrey),
        const SizedBox(width: 4),
        // Label
        Text(
          '$label ',
          style: const TextStyle(
            color: AppColors.textGrey,
            fontSize: 12,
          ),
        ),
        // القيمة - قابلة للالتفاف لو كانت طويلة
        Flexible(
          child: Text(
            value,
            style: const TextStyle(
              color: AppColors.textMedium,
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }
}