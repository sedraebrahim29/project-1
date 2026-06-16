import 'package:flutter/material.dart';
import '../../../../../../../core/theme/app_colors.dart';
import '../../../../models/medical_record_models/dashboard_overview_models.dart';


// =============================================
// Widget - كارد معلومات المريض
// حد أخضر يسار + صورة + اسم + تفاصيل صحية
// =============================================
class PatientInfoCard extends StatelessWidget {
  final PatientInfo patient;

  const PatientInfoCard({super.key, required this.patient});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: const Border(
          left: BorderSide(color: AppColors.primaryGreen, width: 4),
        ),
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
            // --- صورة المريض الدائرية ---
            CircleAvatar(
              radius: 32,
              backgroundColor: AppColors.avatarBg,
              child: patient.avatarAsset.isNotEmpty
                  ? null
                  : const Icon(Icons.person, color: Colors.grey, size: 32),
            ),

            const SizedBox(width: 14),

            // --- الاسم والتفاصيل الصحية ---
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // الاسم
                  Text(
                    patient.name,
                    style: const TextStyle(
                      color: AppColors.textDark,
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 6),

                  // العمر + DOB
                  _InfoRow(
                    icon: Icons.calendar_today_outlined,
                    text: '${patient.age} (DOB: ${patient.dob})',
                  ),
                  const SizedBox(height: 4),

                  // Blood Type + الطول في نفس الصف
                  Row(
                    children: [
                      _InfoRow(
                        icon: Icons.water_drop_outlined,
                        text: 'Blood Type: ${patient.bloodType}',
                      ),
                      const SizedBox(width: 12),
                      _InfoRow(
                        icon: Icons.straighten,
                        text: patient.height,
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),

                  // الوزن
                  _InfoRow(
                    icon: Icons.monitor_weight_outlined,
                    text: patient.weight,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Sub-widget: صف أيقونة + نص
class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _InfoRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 13, color: AppColors.textGrey),
        const SizedBox(width: 4),
        Text(
          text,
          style: const TextStyle(
            color: AppColors.textGrey,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}