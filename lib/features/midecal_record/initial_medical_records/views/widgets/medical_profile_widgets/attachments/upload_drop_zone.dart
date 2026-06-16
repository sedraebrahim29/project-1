import 'package:flutter/material.dart';

import '../../../../../../../core/theme/app_colors.dart';


// =============================================
// Widget - منطقة رفع الملفات
// تعرض: border مقطع dashed، أيقونة خضراء،
//        نص "Tap to upload"، و3 chips تصنيف
//
// الاستخدام:
//   UploadDropZone(onTap: () {})
// =============================================
class UploadDropZone extends StatelessWidget {
  final VoidCallback onTap;

  const UploadDropZone({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 16),
        decoration: BoxDecoration(
          color: const Color(0xFFF5F5F2), // بيج فاتح جداً داخل المنطقة
          borderRadius: BorderRadius.circular(12),
          // border مقطع dashed — بنعمله بـ CustomPainter
          border: Border.all(
            color: AppColors.borderGrey,
            width: 1.5,
            strokeAlign: BorderSide.strokeAlignInside,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // --- دائرة الأيقونة الخضراء ---
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.lightGreen,
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Icon(
                  Icons.upload_file,
                  color: AppColors.primaryGreen,
                  size: 24,
                ),
              ),
            ),

            const SizedBox(height: 12),

            // --- نص Tap to upload ---
            const Text(
              'Tap to upload file',
              style: TextStyle(
                color: AppColors.textDark,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 4),

            // --- نص or drag and drop ---
            const Text(
              'or drag and drop here',
              style: TextStyle(
                color: AppColors.textGrey,
                fontSize: 12,
              ),
            ),

            const SizedBox(height: 16),

            // --- الـ chips: Lab Results, Prescriptions, Medical Images ---
            const _FileTypeChips(),
          ],
        ),
      ),
    );
  }
}

// =============================================
// Sub-widget - chips تصنيف أنواع الملفات
// =============================================
class _FileTypeChips extends StatelessWidget {
  const _FileTypeChips();

  // أنواع الملفات المقبولة
  static const List<String> _types = [
    'Lab Results',
    'Prescriptions',
    'Medical Images',
  ];

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,   // مسافة أفقية بين الـ chips
      runSpacing: 8, // مسافة عمودية لو انتقلوا لسطر ثاني
      alignment: WrapAlignment.center,
      children: _types.map((type) => _Chip(label: type)).toList(),
    );
  }
}

// =============================================
// Sub-widget - chip تصنيف واحد
// شكل pill رمادي فاتح مع نص رمادي
// =============================================
class _Chip extends StatelessWidget {
  final String label;

  const _Chip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.borderGrey, width: 1),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: AppColors.textMedium,
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}