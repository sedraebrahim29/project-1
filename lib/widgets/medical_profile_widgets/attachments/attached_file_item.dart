import 'package:flutter/material.dart';
import '../../../models/medical_profile_models/attached_model.dart';
import '../../../theme/app_colors.dart';

// =============================================
// Widget - صف الملف المرفق الواحد
// يعرض: أيقونة نوع الملف + اسم + حجم وحالة
//        + أيقونة حذف يمين
//
// الاستخدام:
//   AttachedFileItem(
//     file: file,
//     onDelete: () {},
//   )
// =============================================
class AttachedFileItem extends StatelessWidget {
  final AttachedFile file;
  final VoidCallback onDelete;

  const AttachedFileItem({
    super.key,
    required this.file,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
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
      child: Row(
        children: [
          // --- أيقونة نوع الملف ---
          _FileTypeIcon(fileType: file.fileType),

          const SizedBox(width: 12),

          // --- اسم الملف + حجمه وحالته ---
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  file.name,
                  style: const TextStyle(
                    color: AppColors.textDark,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis, // لو الاسم طويل
                ),
                const SizedBox(height: 3),
                // الحجم والحالة مفصولين بـ •
                Text(
                  '${file.size} • ${file.status}',
                  style: const TextStyle(
                    color: AppColors.textGrey,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),

          // --- أيقونة الحذف ---
          GestureDetector(
            onTap: onDelete,
            child: const Icon(
              Icons.delete_outline,
              color: AppColors.textGrey,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }
}

// =============================================
// Sub-widget - أيقونة نوع الملف
// PDF = أحمر | Image = أخضر | Other = رمادي
// =============================================
class _FileTypeIcon extends StatelessWidget {
  final AttachmentType  fileType;

  const _FileTypeIcon({required this.fileType});

  // لون خلفية الأيقونة بناءً على النوع
  Color get _bgColor {
    switch (fileType) {
      case AttachmentType .pdf:   return const Color(0xFFFFEBEE); // أحمر فاتح
      case AttachmentType .image: return const Color(0xFFE8F5E9); // أخضر فاتح
      case AttachmentType .other: return AppColors.completedGrey;
    }
  }

  // لون الأيقونة نفسها
  Color get _iconColor {
    switch (fileType) {
      case AttachmentType .pdf:   return const Color(0xFFD32F2F); // أحمر
      case AttachmentType .image: return const Color(0xFF388E3C); // أخضر
      case AttachmentType .other: return AppColors.textGrey;
    }
  }

  // نوع الأيقونة
  IconData get _icon {
    switch (fileType) {
      case AttachmentType .pdf:   return Icons.picture_as_pdf;
      case AttachmentType .image: return Icons.image_outlined;
      case AttachmentType .other: return Icons.insert_drive_file_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: _bgColor,
        borderRadius: BorderRadius.circular(8), // مربع بزوايا مدورة مش دائرة
      ),
      child: Center(
        child: Icon(_icon, color: _iconColor, size: 22),
      ),
    );
  }
}