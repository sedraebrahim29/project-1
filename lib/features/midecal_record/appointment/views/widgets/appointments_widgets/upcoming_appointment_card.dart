import 'package:flutter/material.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../models/appointment_model.dart';
import 'status_badge.dart';

// =============================================
// Widget - كارد الموعد القادم (Upcoming)
// يحتوي على: معلومات الدكتور، التاريخ والوقت،
//            زر Reschedule وزر View Details
//
// الاستخدام:
//   UpcomingAppointmentCard(appointment: appointment)
// =============================================
class UpcomingAppointmentCard extends StatelessWidget {
  final Appointment appointment;

  const UpcomingAppointmentCard({
    super.key,
    required this.appointment,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        // الحد الأخضر على يسار الكارد
        border: const Border(
          left: BorderSide(
            color: AppColors.primaryGreen,
            width: 4,
          ),
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
            // --- صف الدكتور + Badge ---
            _DoctorInfoRow(appointment: appointment),

            const SizedBox(height: 12),
            const Divider(height: 1, color: AppColors.dividerColor),
            const SizedBox(height: 10),

            // --- التاريخ والوقت ---
            _DateTimeRow(date: appointment.date, time: appointment.time),

            const SizedBox(height: 12),

            // --- زرا Reschedule و View Details ---
            _ActionButtonsRow(),
          ],
        ),
      ),
    );
  }
}

// =============================================
// Sub-widget خاص بهاد الكارد
// صف معلومات الدكتور: صورة + اسم + تخصص + badge
// =============================================
class _DoctorInfoRow extends StatelessWidget {
  final Appointment appointment;

  const _DoctorInfoRow({required this.appointment});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // صورة الدكتور الدائرية
        CircleAvatar(
          radius: 24,
          backgroundColor: AppColors.avatarBg,
          // بدّل الـ Icon بـ AssetImage أو NetworkImage لما تضيف الصور
          child: const Icon(Icons.person, color: Colors.grey, size: 26),
        ),
        const SizedBox(width: 10),
        // اسم الدكتور والتخصص
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
                  height: 1.3,
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
        // Badge الحالة
        StatusBadge(status: appointment.status),
      ],
    );
  }
}

// =============================================
// Sub-widget خاص بهاد الكارد
// صف التاريخ والوقت مع أيقوناتهم
// =============================================
class _DateTimeRow extends StatelessWidget {
  final String date;
  final String? time; // الوقت اختياري

  const _DateTimeRow({required this.date, this.time});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // التاريخ
        const Icon(Icons.calendar_month_outlined,
            size: 15, color: AppColors.textGrey),
        const SizedBox(width: 4),
        Text(
          date,
          style: const TextStyle(color: AppColors.textMedium, fontSize: 12),
        ),
        // الوقت — يظهر فقط إذا كان موجوداً
        if (time != null) ...[
          const SizedBox(width: 20),
          const Icon(Icons.access_time,
              size: 15, color: AppColors.textGrey),
          const SizedBox(width: 4),
          Text(
            time!,
            style: const TextStyle(color: AppColors.textMedium, fontSize: 12),
          ),
        ],
      ],
    );
  }
}

// =============================================
// Sub-widget خاص بهاد الكارد
// زرا Reschedule (border) و View Details (أخضر)
// =============================================
class _ActionButtonsRow extends StatelessWidget {
  const _ActionButtonsRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // زر Reschedule - border بدون fill
        Expanded(
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
              'Reschedule',
              style: TextStyle(
                color: AppColors.textDark,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        // زر View Details - أخضر داكن مع نص أبيض
        Expanded(
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryGreen,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(vertical: 10),
              elevation: 0,
            ),
            child: const Text(
              'View Details',
              style: TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ],
    );
  }
}