import 'package:flutter/material.dart';
import '../../models/medical_record_models/encounter_model.dart';
import '../../theme/app_colors.dart';

// =============================================
// Widget - عنصر الـ Timeline الواحد
// يعرض: دائرة timeline + تاريخ + نوع الزيارة
//        + كارد الدكتور مع التشخيص والملاحظات
//
// الاستخدام:
//   TimelineEncounterCard(
//     encounter: encounter,
//     isLast: false,
//     onViewDetails: () {},
//   )
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
      // IntrinsicHeight عشان الخط الرأسي يمتد بطول الكارد
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
// دائرة خضراء صغيرة + خط رمادي رأسي
// =============================================
class _TimelineIndicator extends StatelessWidget {
  final bool isLast;

  const _TimelineIndicator({required this.isLast});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // دائرة خضراء صغيرة فارغة من الداخل
        Container(
          width: 12,
          height: 12,
          margin: const EdgeInsets.only(top: 3),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: AppColors.primaryGreen,
              width: 2,
            ),
            color: Colors.white,
          ),
        ),
        // الخط الرأسي الرمادي — لا يظهر بعد آخر عنصر
        if (!isLast)
          Expanded(
            child: Container(
              width: 1.5,
              color: const Color(0xFFDDDDDD),
            ),
          ),
      ],
    );
  }
}

// =============================================
// Sub-widget - صف التاريخ ونوع الزيارة
// "OCT 24, 2023  •  FOLLOW-UP"
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
    return Row(
      children: [
        // التاريخ
        Text(
          date,
          style: const TextStyle(
            color: AppColors.textGrey,
            fontSize: 11,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
        // فاصل نقطة
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 6),
          child: Text(
            '•',
            style: TextStyle(color: AppColors.textGrey, fontSize: 11),
          ),
        ),
        // نوع الزيارة
        Text(
          visitType,
          style: const TextStyle(
            color: AppColors.textGrey,
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
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 6,
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
            _DoctorInfoRow(encounter: encounter),

            const SizedBox(height: 12),
            const Divider(height: 1, color: AppColors.dividerColor),
            const SizedBox(height: 12),

            // --- Diagnosis Summary ---
            _DiagnosisSummarySection(text: encounter.diagnosisSummary),

            const SizedBox(height: 10),

            // --- ملاحظات الدكتور (اقتباس) ---
            _DoctorNotesSection(notes: encounter.doctorNotes),

            const SizedBox(height: 12),

            // --- رابط View Full Details ---
            Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: onViewDetails,
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'View Full Details',
                      style: TextStyle(
                        color: AppColors.primaryGreen,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(width: 2),
                    Icon(
                      Icons.chevron_right,
                      color: AppColors.primaryGreen,
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
// صورة دائرية + اسم + تخصص
// =============================================
class _DoctorInfoRow extends StatelessWidget {
  final Encounter encounter;

  const _DoctorInfoRow({required this.encounter});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // صورة الدكتور الدائرية
        CircleAvatar(
          radius: 22,
          backgroundColor: AppColors.avatarBg,
          // استبدل بـ AssetImage عند وجود الصور
          child: const Icon(Icons.person, color: Colors.grey, size: 24),
        ),
        const SizedBox(width: 10),
        // الاسم والتخصص
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              encounter.doctorName,
              style: const TextStyle(
                color: AppColors.textDark,
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              encounter.specialty,
              style: const TextStyle(
                color: AppColors.textGrey,
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
// أيقونة طبية + عنوان + نص التشخيص
// =============================================
class _DiagnosisSummarySection extends StatelessWidget {
  final String text;

  const _DiagnosisSummarySection({required this.text});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // صف الأيقونة والعنوان
        const Row(
          children: [
            Icon(
              Icons.medical_information_outlined,
              size: 15,
              color: AppColors.textGrey,
            ),
            SizedBox(width: 6),
            Text(
              'Diagnosis Summary',
              style: TextStyle(
                color: AppColors.textGrey,
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
          style: const TextStyle(
            color: AppColors.textDark,
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
// أيقونة اقتباس + النص بين علامتي تنصيص
// =============================================
class _DoctorNotesSection extends StatelessWidget {
  final String notes;

  const _DoctorNotesSection({required this.notes});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // أيقونة الاقتباس
        const Icon(
          Icons.format_quote,
          size: 18,
          color: AppColors.textGrey,
        ),
        const SizedBox(width: 6),
        // النص بين علامتي تنصيص
        Expanded(
          child: Text(
            '"${notes}"',
            style: const TextStyle(
              color: AppColors.textMedium,
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