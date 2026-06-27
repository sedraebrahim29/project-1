// =============================================
// Model - بيانات الملف المرفق فقط، لا UI هنا
// =============================================
enum AttachmentType  { pdf, image, other }

class AttachedFile {
  final String name;       // اسم الملف: "Blood_Work_Q3.pdf"
  final String size;       // الحجم: "2.4 MB"
  final String status;     // الحالة: "Complete"
  final AttachmentType  fileType; // نوع الملف لتحديد الأيقونة واللون

  const AttachedFile({
    required this.name,
    required this.size,
    required this.status,
    required this.fileType,
  });
}