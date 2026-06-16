import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart' as fp; // alias عشان ما يتعارض مع FileType عندنا

// --- Models ---
import '../../../../../../core/theme/app_colors.dart';
import '../../../models/medical_profile_models/attached_model.dart';

// --- Widgets ---
import '../../widgets/medical_profile_widgets/attachments/attached_file_item.dart';
import '../../widgets/medical_profile_widgets/attachments/upload_drop_zone.dart';
import '../../widgets/medical_profile_widgets/medical_history_widgets/bottom_action_buttons.dart';
import '../../widgets/medical_profile_widgets/medical_history_widgets/step_progress_bar.dart';

// =============================================
// الشاشة الرئيسية - Medical Profile / Step 3
// Upload Files
// =============================================
class AttachmentScreen extends StatefulWidget {
  const AttachmentScreen({super.key});

  @override
  State<AttachmentScreen> createState() => _UploadFilesScreenState();
}

class _UploadFilesScreenState extends State<AttachmentScreen> {

  // =============================================
  // بيانات الملفات المرفقة — قابلة للحذف
  // =============================================
  late List<AttachedFile> _attachedFiles;

  @override
  void initState() {
    super.initState();
    _attachedFiles = [
      const AttachedFile(
        name: 'Blood_Work_Q3.pdf',
        size: '2.4 MB',
        status: 'Complete',
        fileType: AttachmentType.pdf, // FileType هو enum عندنا من attached_model.dart
      ),
      const AttachedFile(
        name: 'Chest_X-Ray.jpg',
        size: '5.1 MB',
        status: 'Complete',
        fileType: AttachmentType.image,
      ),
    ];
  }

  // =============================================
  // فتح الـ file picker من الجهاز
  // استخدمنا fp.FileType عشان نفرق بين
  // FileType عندنا وFileType تبع الباكج
  // =============================================
  Future<void> _pickFile() async {
    final result = await fp.FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: fp.FileType.any, // fp. هون تبع الباكج مش enum عندنا
    );

    if (result != null) {
      setState(() {
        for (final file in result.files) {
          final ext = file.extension?.toLowerCase() ?? '';

          // تحديد FileType عندنا بناءً على امتداد الملف
          final fileType = ext == 'pdf'
              ? AttachmentType.pdf
              : ['jpg', 'jpeg', 'png', 'gif'].contains(ext)
              ? AttachmentType.image
              : AttachmentType.other;

          _attachedFiles.add(AttachedFile(
            name: file.name,
            size: '${(file.size / (1024 * 1024)).toStringAsFixed(1)} MB',
            status: 'Complete',
            fileType: fileType,
          ));
        }
      });
    }
  }

  // حذف ملف من القائمة
  void _deleteFile(AttachedFile file) {
    setState(() => _attachedFiles.remove(file));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(),
      bottomNavigationBar: BottomActionButtons(
        onBack: () => Navigator.pop(context),
        onNextStep: () {
          // Navigator.push للشاشة التالية Step 4
        },
      ),
      body: _buildBody(),
    );
  }

  // =============================================
  // AppBar
  // =============================================
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.background,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: AppColors.textDark, size: 22),
        onPressed: () => Navigator.pop(context),
      ),
      title: const Text(
        'Medical Profile',
        style: TextStyle(
          color: AppColors.textDark,
          fontSize: 17,
          fontWeight: FontWeight.w700,
        ),
      ),
      centerTitle: false,
    );
  }

  // =============================================
  // Body Builder
  // =============================================
  Widget _buildBody() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Attachments",
            style: TextStyle(
              color: AppColors.textDark,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 20),

          // --- شريط التقدم: Step 3 of 4 مع label "Attachments" ---
          const StepProgressBar(
            currentStep: 3,
            totalSteps: 4,
          ),

           SizedBox(height: 24),

          // --- عنوان الصفحة والوصف ---
           Text(
            'Upload Files',
            style: TextStyle(
              color: AppColors.textDark,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
           SizedBox(height: 6),
           Text(
            'Please provide any relevant documents to complete\nyour profile. This helps us tailor your care.',
            style: TextStyle(
              color: AppColors.textGrey,
              fontSize: 13,
              height: 1.5,
            ),
          ),

           SizedBox(height: 20),

          // --- منطقة رفع الملفات ---
          UploadDropZone(onTap: _pickFile),

           SizedBox(height: 24),

          // --- قسم Attached Files (يظهر فقط لو في ملفات) ---
          if (_attachedFiles.isNotEmpty) ...[
             Text(
              'Attached Files',
              style: TextStyle(
                color: AppColors.textDark,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
             SizedBox(height: 12),

            ..._attachedFiles.map(
                  (file) => AttachedFileItem(
                file: file,
                onDelete: () => _deleteFile(file),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

