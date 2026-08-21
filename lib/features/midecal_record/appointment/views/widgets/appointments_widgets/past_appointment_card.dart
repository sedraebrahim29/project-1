/*import 'package:flutter/material.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../view_models/appointment_model.dart';
import 'status_badge.dart';

// =============================================
// Widget - كارد الموعد السابق (Past History)
// يحتوي على: معلومات الدكتور، التاريخ فقط،
//            وزر "Book Again" للمكتمل فقط
//
// الاستخدام:
//   PastAppointmentCard(appointment: appointment)
// =============================================
class PastAppointmentCard extends StatelessWidget {
  final Appointment appointment;

  const PastAppointmentCard({
    super.key,
    required this.appointment,
  });

  // لون الحد الأيسر يتغير بناءً على الحالة
  Color get _borderColor {
    return appointment.status == 'Cancelled'
        ? AppColors.cancelRed   // أحمر للملغي
        : AppColors.primaryGreen; // أخضر للمكتمل
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        // الحد الأيسر يتغير لونه بناءً على الحالة
        border: Border(
          left: BorderSide(color: _borderColor, width: 4),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- صف معلومات الدكتور ---
            _DoctorInfoRow(appointment: appointment),

            const SizedBox(height: 12),
            const Divider(height: 1, color: AppColors.dividerColor),
            const SizedBox(height: 10),

            // --- التاريخ فقط (بدون وقت في Past) ---
            Row(
              children: [
                const Icon(Icons.calendar_month_outlined,
                    size: 15, color: AppColors.textGrey),
                const SizedBox(width: 4),
                Text(
                  appointment.date,
                  style: const TextStyle(
                    color: AppColors.textMedium,
                    fontSize: 12,
                  ),
                ),
              ],
            ),

            // زر "Book Again" يظهر فقط للمواعيد المكتملة
            if (appointment.status == 'Completed') ...[
              const SizedBox(height: 12),
              _BookAgainButton(),
            ],
          ],
        ),
      ),
    );
  }
}

// =============================================
// Sub-widget - صف معلومات الدكتور
// =============================================
class _DoctorInfoRow extends StatelessWidget {
  final Appointment appointment;

  const _DoctorInfoRow({required this.appointment});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CircleAvatar(
          radius: 24,
          backgroundColor: AppColors.avatarBg,
          child: const Icon(Icons.person, color: Colors.grey, size: 26),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                appointment.doctorName,
                style: const TextStyle(
                  color: AppColors.textDark,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                appointment.specialty,
                style: const TextStyle(
                  color: AppColors.textGrey,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
        StatusBadge(status: appointment.status),
      ],
    );
  }
}

// =============================================
// Sub-widget - زر Book Again
// يظهر فقط للمكتمل، بهيكل OutlinedButton
// =============================================
class _BookAgainButton extends StatelessWidget {
  const _BookAgainButton();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: () {},
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: AppColors.borderGrey, width: 1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(vertical: 10),
          backgroundColor: Colors.white,
        ),
        child: const Text(
          'Book Again',
          style: TextStyle(
            color: AppColors.textDark,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}*/
