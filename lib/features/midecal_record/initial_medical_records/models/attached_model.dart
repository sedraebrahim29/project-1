import 'package:equatable/equatable.dart';

// =============================================
// Model - بيانات الملف المرفق (Attachment)
// أعيد بناؤه ليطابق شكل الباك (/patient/medical-record/attachments)
// ملاحظة مهمة: الباك ما بيرجع اسم الملف الأصلي - بس "type" (فئة اختارها
// المستخدم، مثلاً "X-ray photo") + mime_type + file_size بالبايت.
// لهيك حطيت getters (name/size/status) حتى AttachedFileItem widget
// القديم يضل يشتغل بدون أي تعديل عليه.
// =============================================
enum AttachmentType { pdf, image, other }

class AttachedFile extends Equatable {
  final int id;
  final String type; // الفئة اللي اختارها المستخدم وقت الرفع
  final String mimeType;
  final int fileSizeBytes;
  final bool isEncrypted;
  final String downloadUrl;
  final DateTime? uploadedAt;

  const AttachedFile({
    required this.id,
    required this.type,
    required this.mimeType,
    required this.fileSizeBytes,
    required this.isEncrypted,
    required this.downloadUrl,
    this.uploadedAt,
  });

  // --- توافق مع AttachedFileItem widget القديم بدون تعديله ---
  String get name => type;
  String get size => '${(fileSizeBytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  String get status => 'Complete'; // الباك ما بيرجع حالة؛ الرفع الناجح = مكتمل دايماً

  AttachmentType get fileType {
    if (mimeType.contains('pdf')) return AttachmentType.pdf;
    if (mimeType.startsWith('image/')) return AttachmentType.image;
    return AttachmentType.other;
  }

  @override
  List<Object?> get props =>
      [id, type, mimeType, fileSizeBytes, isEncrypted, downloadUrl, uploadedAt];

  factory AttachedFile.fromJson(Map<String, dynamic> json) => AttachedFile(
    id: json['id'] as int,
    type: json['type']?.toString() ?? '',
    mimeType: json['mime_type']?.toString() ?? '',
    fileSizeBytes: json['file_size'] as int? ?? 0,
    isEncrypted: json['is_encrypted'] as bool? ?? false,
    downloadUrl: json['download_url']?.toString() ?? '',
    uploadedAt: json['uploaded_at'] != null
        ? DateTime.tryParse(json['uploaded_at'].toString())
        : null,
  );
}
