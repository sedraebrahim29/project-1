/*import 'package:flutter/material.dart';

import '../../../../../../core/theme/app_colors.dart';



// =============================================
// Widget - Badge الحالة (Upcoming/Completed/Cancelled)
// بيتكرر بكل كارد، لهيك هو widget مستقل
//
// الاستخدام:
//   StatusBadge(status: appointment.status)
// =============================================
class StatusBadge extends StatelessWidget {
  final String status;

  const StatusBadge({
    super.key,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    // تحديد لون الخلفية والنص بناءً على الحالة
    final Color bgColor;
    final Color textColor;

    switch (status) {
      case 'Upcoming':
        bgColor   = AppColors.lightGreen;
        textColor = AppColors.primaryGreen;
        break;
      case 'Completed':
        bgColor   = AppColors.completedGrey;
        textColor = AppColors.textCompleted;
        break;
      case 'Cancelled':
        bgColor   = AppColors.lightRed;
        textColor = AppColors.cancelRed;
        break;
      default:
        bgColor   = AppColors.completedGrey;
        textColor = AppColors.textCompleted;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20), // شكل pill مستدير
      ),
      child: Text(
        status,
        style: TextStyle(
          color: textColor,
          fontSize: 11,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}*/
