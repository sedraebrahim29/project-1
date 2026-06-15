import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';


// =============================================
// Widget - كارد القسم القابل للتكرار
// يعرض: أيقونة + عنوان يسار + زر Edit يمين
//        + محتوى مرن (children)
//
// الاستخدام:
//   ReviewSectionCard(
//     icon: Icons.person_outline,
//     title: 'Basic Info',
//     onEdit: () {},
//     children: [...],
//   )
// =============================================
class ReviewSectionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onEdit;
  final List<Widget> children; // محتوى الكارد مرن لكل قسم

  const ReviewSectionCard({
    super.key,
    required this.icon,
    required this.title,
    required this.onEdit,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
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
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Header: أيقونة + عنوان + زر Edit ---
            Row(
              children: [
                // أيقونة القسم
                Icon(icon, size: 20, color: AppColors.textDark),
                const SizedBox(width: 8),
                // عنوان القسم
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      color: AppColors.textDark,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                // زر Edit: أيقونة قلم + نص
                GestureDetector(
                  onTap: onEdit,
                  child: Row(
                    children: [
                      Icon(
                        Icons.edit_outlined,
                        size: 14,
                        color: AppColors.textGrey,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Edit',
                        style: TextStyle(
                          color: AppColors.textGrey,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 14),
            const Divider(height: 1, color: AppColors.dividerColor),
            const SizedBox(height: 14),

            // --- المحتوى الداخلي (مختلف لكل قسم) ---
            ...children,
          ],
        ),
      ),
    );
  }
}

// =============================================
// Sub-widget - حقل معلومة واحدة
// label رمادي فوق + قيمة داكنة تحت
//
// الاستخدام:
//   ReviewInfoField(label: 'Full Legal Name', value: 'Jonathan Edward Doe')
// =============================================
class ReviewInfoField extends StatelessWidget {
  final String label;
  final String value;

  const ReviewInfoField({
    super.key,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Label رمادي صغير
          Text(
            label,
            style: const TextStyle(
              color: AppColors.textGrey,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 3),
          // القيمة داكنة
          Text(
            value,
            style: const TextStyle(
              color: AppColors.textDark,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

// =============================================
// Sub-widget - chip الحساسية
// شكل pill أحمر فاتح مع أيقونة تحذير
//
// الاستخدام:
//   AllergyTag(name: 'Amoyicillin')
// =============================================
class AllergyTag extends StatelessWidget {
  final String name;

  const AllergyTag({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 6, bottom: 6),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.lightRed,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // أيقونة تحذير مثلث
          Icon(
            Icons.warning_amber_rounded,
            size: 13,
            color: AppColors.cancelRed,
          ),
          const SizedBox(width: 4),
          Text(
            name,
            style: TextStyle(
              color: AppColors.cancelRed,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

// =============================================
// Sub-widget - كارد الدواء الداخلي بقسم Meds
// أيقونة دائرية + اسم + تفاصيل
// =============================================
class ReviewMedCard extends StatelessWidget {
  final String name;
  final String details;

  const ReviewMedCard({
    super.key,
    required this.name,
    required this.details,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          // دائرة الأيقونة
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.completedGrey,
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Icon(
                Icons.medication_outlined,
                size: 18,
                color: AppColors.textDark,
              ),
            ),
          ),
          const SizedBox(width: 10),
          // اسم الدواء والتفاصيل
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(
                  color: AppColors.textDark,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                details,
                style: const TextStyle(
                  color: AppColors.textGrey,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// =============================================
// Sub-widget - كارد الملف الداخلي بقسم Attachments
// أيقونة نوع + اسم + تفاصيل
// =============================================
class ReviewAttachmentCard extends StatelessWidget {
  final String name;
  final String details;
  final bool isPdf;

  const ReviewAttachmentCard({
    super.key,
    required this.name,
    required this.details,
    required this.isPdf,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          // أيقونة نوع الملف
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: isPdf
                  ? const Color(0xFFF0F0F0) // أحمر فاتح للـ PDF
                  : const Color(0xFFF0F0F0), // أخضر فاتح للصورة
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Icon(
                isPdf ? Icons.shield_outlined : Icons.badge_outlined,
                size: 18,
                color: isPdf
                    ? const Color(0xFF1C1C1C)
                    : const Color(0xFF1C1C1C), // رمادي فاتح للبطاقة
              ),
            ),
          ),
          const SizedBox(width: 10),
          // اسم الملف والتفاصيل
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    color: AppColors.textDark,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  details,
                  style: const TextStyle(
                    color: AppColors.textGrey,
                    fontSize: 12,
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