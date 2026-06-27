import 'package:flutter/material.dart';
import '../../../../../../core/constants/app_strings.dart'; // مسار ملف نصوصكِ المعتمد
import '../../../../../../core/theme/app_colors.dart';    // مسار ملف ألوانكِ المعتمد
import '../../../models/medical_record_models/encounter_model.dart';

// =============================================
// Widget - عنصر الـ Timeline الواحد
// يعرض: دائرة timeline + تاريخ + نوع الزيارة
//        + كارد الدكتور مع التشخيص والملاحظات
// =============================================
class TimelineEncounterCard extends StatelessWidget {
  final Encounter encounter;
  final bool isLast;              // لإخفاء الخط تحت آخر عنصر
  final VoidCallback onViewDetails;

  const TimelineEncounterCard({
    super.key,
    required this.encounter,
    required this.isLast,
    required this.onViewDetails,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // =============================================
          // عمود الـ Timeline: دائرة + خط رأسي
          // =============================================
          _TimelineIndicator(isLast: isLast),

          const SizedBox(width: 12),

          // =============================================
          // المحتوى: تاريخ + نوع + كارد
          // =============================================
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- صف التاريخ ونوع الزيارة ---
                  _DateVisitTypeRow(
                    date: encounter.date,
                    visitType: encounter.visitType,
                  ),

                  const SizedBox(height: 10),

                  // --- كارد الزيارة ---
                  _EncounterCard(
                    encounter: encounter,
                    onViewDetails: onViewDetails,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// =============================================
// Sub-widget - مؤشر الـ Timeline
// =============================================
class _TimelineIndicator extends StatelessWidget {
  final bool isLast;

  const _TimelineIndicator({required this.isLast});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        // دائرة صغيرة فارغة تتغير حسب الثيم الحالي للـ App
        Container(
          width: 12,
          height: 12,
          margin: const EdgeInsets.only(top: 3),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: isDarkMode ? AppColors.darkPrimaryGreen : AppColors.primaryGreen,
              width: 2,
            ),
            color: isDarkMode ? AppColors.darkBackground : AppColors.white,
          ),
        ),
        // الخط الرأسي الرمادي المتناسق مع ألوان البوردر
        if (!isLast)
          Expanded(
            child: Container(
              width: 1.5,
              color: isDarkMode ? AppColors.darkBackground : AppColors.borderGrey,
            ),
          ),
      ],
    );
  }
}

// =============================================
// Sub-widget - صف التاريخ ونوع الزيارة
// =============================================
class _DateVisitTypeRow extends StatelessWidget {
  final String date;
  final String visitType;

  const _DateVisitTypeRow({
    required this.date,
    required this.visitType,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDarkMode ? AppColors.darkText.withOpacity(0.6) : AppColors.textLightGrey;

    return Row(
      children: [
        // التاريخ
        Text(
          date,
          style: TextStyle(
            color: textColor,
            fontSize: 11,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
        // فاصل نقطة
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6),
          child: Text(
            '•',
            style: TextStyle(color: textColor, fontSize: 11),
          ),
        ),
        // نوع الزيارة
        Text(
          visitType,
          style: TextStyle(
            color: textColor,
            fontSize: 11,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }
}

// =============================================
// Sub-widget - كارد الزيارة الكامل
// =============================================
class _EncounterCard extends StatelessWidget {
  final Encounter encounter;
  final VoidCallback onViewDetails;

  const _EncounterCard({
    required this.encounter,
    required this.onViewDetails,
  });

  @override
  Widget build(BuildContext context) {
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- صف معلومات الدكتور ---
            _DoctorInfoRow(encounter: encounter),

            const SizedBox(height: 12),
            Divider(
                height: 1,
                color: isDarkMode ? AppColors.darkBackground : AppColors.borderGrey
            ),
            const SizedBox(height: 12),

            // --- Diagnosis Summary ---
            _DiagnosisSummarySection(text: encounter.diagnosisSummary),

            const SizedBox(height: 10),

            // --- ملاحظات الدكتور (اقتباس) ---
            _DoctorNotesSection(notes: encounter.doctorNotes),

            const SizedBox(height: 12),

            // --- رابط View Full Details مع اتجاه الأيقونة تلقائياً حسب اللغة ---
            Align(
              alignment: Directionality.of(context) == TextDirection.rtl
                  ? Alignment.centerLeft
                  : Alignment.centerRight,
              child: GestureDetector(
                onTap: onViewDetails,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      AppStrings.viewFullDetails(context), // ترجمة النص ديناميكياً
                      style: TextStyle(
                        color: isDarkMode ? AppColors.darkPrimaryGreen : AppColors.primaryGreen,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 2),
                    Icon(
                      Directionality.of(context) == TextDirection.rtl
                          ? Icons.chevron_left
                          : Icons.chevron_right,
                      color: isDarkMode ? AppColors.darkPrimaryGreen : AppColors.primaryGreen,
                      size: 16,
                    ),
                  ],
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
// Sub-widget - صف معلومات الدكتور
// =============================================
class _DoctorInfoRow extends StatelessWidget {
  final Encounter encounter;

  const _DoctorInfoRow({required this.encounter});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Row(
      children: [
        // صورة الدكتور الدائرية مع معالجة خلفية السيركل متوافقة مع ألوانكِ
        CircleAvatar(
          radius: 22,
          backgroundColor: isDarkMode ? AppColors.darkBackground : AppColors.borderGrey,
          child: Icon(
              Icons.person,
              color: isDarkMode ? AppColors.darkText.withOpacity(0.5) : AppColors.textLightGrey,
              size: 24
          ),
        ),
        const SizedBox(width: 10),
        // الاسم والتخصص
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              encounter.doctorName,
              style: TextStyle(
                color: isDarkMode ? AppColors.darkText : AppColors.textDark,
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              encounter.specialty,
              style: TextStyle(
                color: isDarkMode ? AppColors.darkText.withOpacity(0.6) : AppColors.textLightGrey,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// =============================================
// Sub-widget - قسم Diagnosis Summary
// =============================================
class _DiagnosisSummarySection extends StatelessWidget {
  final String text;

  const _DiagnosisSummarySection({required this.text});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final greyColor = isDarkMode ? AppColors.darkText.withOpacity(0.6) : AppColors.textLightGrey;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // صف الأيقونة والعنوان المترجم
        Row(
          children: [
            Icon(
              Icons.medical_information_outlined,
              size: 15,
              color: greyColor,
            ),
            const SizedBox(width: 6),
            Text(
              AppStrings.diagnosisSummary(context), // ترجمة العنوان
              style: TextStyle(
                color: greyColor,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        // نص التشخيص
        Text(
          text,
          style: TextStyle(
            color: isDarkMode ? AppColors.darkText : AppColors.textDark,
            fontSize: 13,
            height: 1.5,
          ),
        ),
      ],
    );
  }
}

// =============================================
// Sub-widget - قسم ملاحظات الدكتور
// =============================================
class _DoctorNotesSection extends StatelessWidget {
  final String notes;

  const _DoctorNotesSection({required this.notes});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textMediumColor = isDarkMode ? AppColors.darkText.withOpacity(0.8) : AppColors.textLightGrey;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          Icons.format_quote,
          size: 18,
          color: isDarkMode ? AppColors.darkText.withOpacity(0.5) : AppColors.textLightGrey,
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            '"$notes"',
            style: TextStyle(
              color: textMediumColor,
              fontSize: 13,
              height: 1.5,
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
      ],
    );
  }
}
