import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../../core/theme/app_colors.dart';
import '../../../../../../../core/constants/app_strings.dart';
import '../../../../../initial_medical_records/models/medication_model.dart';

// =============================================
// Widget - كارد الدواء الواحد بتاب "Medications" (السجل الطبي الفعلي)
// مبني على بيانات Medication الحقيقية (status/dosage/frequency/route/
// start_date/stopped_at). ما فيه زر "Request Refill" لأنه ما في
// endpoint لطلب تجديد وصفة حالياً بالباك - بدلاً منه زر "إيقاف الدواء"
// الحقيقي (POST .../stop) لما يكون الدواء فعّال وقابل للتعديل.
// =============================================
class MedicationRecordCard extends StatelessWidget {
  final Medication medication;
  final VoidCallback? onStop;
  final VoidCallback? onDelete;

  const MedicationRecordCard({
    super.key,
    required this.medication,
    this.onStop,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDarkMode ? AppColors.darkCard : AppColors.white;
    final textColor = isDarkMode ? AppColors.darkText : AppColors.textDark;
    final subTextColor = isDarkMode ? AppColors.darkText.withOpacity(0.6) : AppColors.textLightGrey;
    final isStopped = medication.isStopped;

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: isDarkMode ? Colors.black.withOpacity(0.2) : Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(14.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 44.w,
                  height: 44.h,
                  decoration: BoxDecoration(
                    color: isDarkMode ? AppColors.darkBackground : AppColors.backgroundBeige,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.medication, size: 22.sp, color: AppColors.primaryGreen),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        medication.strength.isNotEmpty
                            ? '${medication.drugName} ${medication.strength}'
                            : medication.drugName,
                        style: TextStyle(color: textColor, fontSize: 16.sp, fontWeight: FontWeight.w700),
                      ),
                      if (medication.form.isNotEmpty)
                        Text(
                          _capitalize(medication.form),
                          style: TextStyle(color: subTextColor, fontSize: 12.sp),
                        ),
                    ],
                  ),
                ),
                _StatusBadge(isStopped: isStopped),
                if (onStop != null || onDelete != null)
                  PopupMenuButton<String>(
                    icon: Icon(Icons.more_vert, size: 20.sp, color: subTextColor),
                    onSelected: (value) {
                      if (value == 'stop') onStop?.call();
                      if (value == 'delete') onDelete?.call();
                    },
                    itemBuilder: (context) => [
                      if (onStop != null && !isStopped)
                        PopupMenuItem(
                          value: 'stop',
                          child: Text(AppStrings.stopMedication(context)),
                        ),
                      if (onDelete != null)
                        PopupMenuItem(
                          value: 'delete',
                          child: Text(AppStrings.delete(context)),
                        ),
                    ],
                  ),
              ],
            ),
            SizedBox(height: 10.h),
            Wrap(
              spacing: 16.w,
              runSpacing: 6.h,
              children: [
                _InfoRow(icon: Icons.medication_outlined, label: AppStrings.dosageLabel(context), value: medication.dosage),
                _InfoRow(icon: Icons.access_time, label: AppStrings.frequencyLabel(context), value: medication.frequency),
                if (medication.route.isNotEmpty)
                  _InfoRow(icon: Icons.route_outlined, label: AppStrings.routeLabel(context), value: _capitalize(medication.route)),
              ],
            ),
            SizedBox(height: 6.h),
            Text(
              isStopped
                  ? '${AppStrings.startedOn(context)}: ${medication.startDate}  •  ${AppStrings.stoppedOn(context)}: ${medication.stoppedAt ?? '-'}'
                  : '${AppStrings.startedOn(context)}: ${medication.startDate}',
              style: TextStyle(color: subTextColor, fontSize: 11.sp),
            ),
            if (isStopped && (medication.stopReason?.isNotEmpty ?? false)) ...[
              SizedBox(height: 4.h),
              Text(
                '${AppStrings.notesLabel(context)}: ${medication.stopReason}',
                style: TextStyle(color: subTextColor, fontSize: 11.sp, fontStyle: FontStyle.italic),
              ),
            ],
            if (!isStopped && (medication.notes?.isNotEmpty ?? false)) ...[
              SizedBox(height: 4.h),
              Text(
                '${AppStrings.notesLabel(context)}: ${medication.notes}',
                style: TextStyle(color: subTextColor, fontSize: 11.sp),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _capitalize(String s) => s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);
}

class _StatusBadge extends StatelessWidget {
  final bool isStopped;
  const _StatusBadge({required this.isStopped});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final label = isStopped ? AppStrings.stopped(context) : AppStrings.active(context);
    final bg = isStopped
        ? (isDark ? Colors.grey.shade800 : Colors.grey.shade200)
        : (isDark ? AppColors.darkPrimaryGreen.withOpacity(0.2) : const Color(0xFFE8F5E9));
    final fg = isStopped
        ? (isDark ? Colors.grey.shade300 : Colors.grey.shade700)
        : (isDark ? AppColors.darkPrimaryGreen : const Color(0xFF388E3C));

    return Container(
      margin: EdgeInsets.only(left: 6.w, right: 2.w),
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 3.h),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(20.r)),
      child: Text(label, style: TextStyle(color: fg, fontSize: 11.sp, fontWeight: FontWeight.w600)),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final color = isDark ? AppColors.darkText.withOpacity(0.7) : AppColors.textLightGrey;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 13.sp, color: color),
        SizedBox(width: 4.w),
        Text('$label ', style: TextStyle(color: color, fontSize: 12.sp, fontWeight: FontWeight.w500)),
        Text(value, style: TextStyle(color: isDark ? AppColors.darkText : AppColors.textDark, fontSize: 12.sp)),
      ],
    );
  }
}
