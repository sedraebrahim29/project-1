import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../../core/theme/app_colors.dart';
import '../../../../../../../core/constants/app_strings.dart';
import '../../../../../initial_medical_records/models/attached_model.dart';

// =============================================
// Widget - صف الملف المرفق الواحد بتاب "Attachments" (بيانات حقيقية)
// الباك لا يرجع اسم ملف أصلي ولا "دكتور واصف" ولا حالة Active/Expired -
// بس type (الفئة اللي اختارها المريض وقت الرفع، مثلاً "X-ray photo") +
// mime_type + file_size + is_encrypted + download_url. فبنينا الكارد
// حول هاي الحقول فعلياً بدل تصميم يفترض حقول غير موجودة بالباك.
// =============================================
class AttachmentRecordCard extends StatelessWidget {
  final AttachedFile file;
  final bool isDownloading;
  final VoidCallback onDownload;
  final VoidCallback onDelete;

  const AttachmentRecordCard({
    super.key,
    required this.file,
    required this.onDownload,
    required this.onDelete,
    this.isDownloading = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? AppColors.darkCard : AppColors.white;
    final textColor = isDark ? AppColors.darkText : AppColors.textDark;
    final subTextColor = isDark ? AppColors.darkText.withOpacity(0.6) : AppColors.textLightGrey;

    return Container(
      margin: EdgeInsets.only(bottom: 10.h),
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.transparent : Colors.black.withOpacity(0.04),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          _FileTypeIcon(fileType: file.fileType),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        file.type,
                        style: TextStyle(color: textColor, fontSize: 14.sp, fontWeight: FontWeight.w600),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (file.isEncrypted) ...[
                      SizedBox(width: 6.w),
                      Icon(Icons.lock_outline, size: 13.sp, color: AppColors.primaryGreen),
                    ],
                  ],
                ),
                SizedBox(height: 3.h),
                Text(
                  file.uploadedAt != null
                      ? '${file.size} • ${AppStrings.uploadedOn(context)} ${_formatDate(file.uploadedAt!)}'
                      : file.size,
                  style: TextStyle(color: subTextColor, fontSize: 12.sp),
                ),
              ],
            ),
          ),
          if (isDownloading)
            SizedBox(
              width: 20.w,
              height: 20.w,
              child: const CircularProgressIndicator(strokeWidth: 2),
            )
          else
            GestureDetector(
              onTap: onDownload,
              child: Padding(
                padding: EdgeInsets.all(4.w),
                child: Icon(Icons.download_outlined, color: AppColors.primaryGreen, size: 20.sp),
              ),
            ),
          SizedBox(width: 8.w),
          GestureDetector(
            onTap: onDelete,
            child: Padding(
              padding: EdgeInsets.all(4.w),
              child: Icon(Icons.delete_outline, color: const Color(0xFFD32F2F), size: 20.sp),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime dt) =>
      '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}';
}

class _FileTypeIcon extends StatelessWidget {
  final AttachmentType fileType;

  const _FileTypeIcon({required this.fileType});

  Color _bgColor(bool isDark) {
    switch (fileType) {
      case AttachmentType.pdf:
        return const Color(0xFFFFEBEE).withOpacity(isDark ? 0.15 : 1.0);
      case AttachmentType.image:
        return const Color(0xFFE8F5E9).withOpacity(isDark ? 0.15 : 1.0);
      case AttachmentType.other:
        return isDark ? Colors.grey[800]! : const Color(0xFFF3F4F6);
    }
  }

  Color _iconColor(bool isDark) {
    switch (fileType) {
      case AttachmentType.pdf:
        return const Color(0xFFE53935);
      case AttachmentType.image:
        return const Color(0xFF43A047);
      case AttachmentType.other:
        return isDark ? Colors.grey[400]! : Colors.grey[600]!;
    }
  }

  IconData get _icon {
    switch (fileType) {
      case AttachmentType.pdf:
        return Icons.picture_as_pdf;
      case AttachmentType.image:
        return Icons.image_outlined;
      case AttachmentType.other:
        return Icons.insert_drive_file_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: 44.w,
      height: 44.h,
      decoration: BoxDecoration(color: _bgColor(isDark), borderRadius: BorderRadius.circular(8.r)),
      child: Center(child: Icon(_icon, color: _iconColor(isDark), size: 22.sp)),
    );
  }
}
