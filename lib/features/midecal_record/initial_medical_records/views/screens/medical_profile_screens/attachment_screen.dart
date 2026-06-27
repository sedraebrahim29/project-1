import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart' as fp;
import 'package:flutter_bloc/flutter_bloc.dart';
// --- Models ---
import '../../../../../../core/constants/app_strings.dart';
import '../../../../../../core/constants/setting.dart';
import '../../../models/medical_profile_models/attached_model.dart';

// --- Widgets ---
import '../../widgets/medical_profile_widgets/attachments/attached_file_item.dart';
import '../../widgets/medical_profile_widgets/attachments/upload_drop_zone.dart';
import '../../widgets/medical_profile_widgets/medical_history_widgets/bottom_action_buttons.dart';
import '../../widgets/medical_profile_widgets/medical_history_widgets/step_progress_bar.dart';

class AttachmentScreen extends StatefulWidget {
  const AttachmentScreen({super.key});

  @override
  State<AttachmentScreen> createState() => _UploadFilesScreenState();
}

class _UploadFilesScreenState extends State<AttachmentScreen> {
  late List<AttachedFile> _attachedFiles;

  @override
  void initState() {
    super.initState();
    _attachedFiles = [
      const AttachedFile(
        name: 'Blood_Work_Q3.pdf',
        size: '2.4 MB',
        status: 'Complete',
        fileType: AttachmentType.pdf,
      ),
      const AttachedFile(
        name: 'Chest_X-Ray.jpg',
        size: '5.1 MB',
        status: 'Complete',
        fileType: AttachmentType.image,
      ),
    ];
  }

  Future<void> _pickFile() async {
    final result = await fp.FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: fp.FileType.any,
    );

    if (result != null) {
      setState(() {
        for (final file in result.files) {
          final ext = file.extension?.toLowerCase() ?? '';

          final fileType = ext == 'pdf'
              ? AttachmentType.pdf
              : ['jpg', 'jpeg', 'png', 'gif'].contains(ext)
              ? AttachmentType.image
              : AttachmentType.other;

          _attachedFiles.add(
            AttachedFile(
              name: file.name,
              size: '${(file.size / (1024 * 1024)).toStringAsFixed(1)} MB',
              status: 'Complete',
              fileType: fileType,
            ),
          );
        }
      });
    }
  }

  void _deleteFile(AttachedFile file) {
    setState(() => _attachedFiles.remove(file));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: _buildAppBar(context),
      bottomNavigationBar: BottomActionButtons(
        onBack: () => Navigator.pop(context),
        onNextStep: () {
          // Navigator.push للشاشة التالية Step 4
        },
      ),
      body: _buildBody(context),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    final theme = Theme.of(context);
    final scaleFactor = BlocProvider.of<SettingsCubit>(
      context,
    ).state.scaleFactor;

    return AppBar(
      backgroundColor: theme.scaffoldBackgroundColor,
      elevation: 0,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back,
          color: theme.textTheme.bodyLarge?.color,
          size: 22,
        ),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text(
        AppStrings.medicalProfileTitle(context),
        style: TextStyle(
          color: theme.textTheme.bodyLarge?.color,
          fontSize: 17 * scaleFactor,
          fontWeight: FontWeight.w700,
        ),
      ),
      centerTitle: false,
    );
  }

  Widget _buildBody(BuildContext context) {
    final theme = Theme.of(context);
    final scaleFactor = BlocProvider.of<SettingsCubit>(
      context,
    ).state.scaleFactor;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppStrings.attachmentsSection(context),
            style: TextStyle(
              color: theme.textTheme.bodyLarge?.color,
              fontSize: 15 * scaleFactor,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),

          const StepProgressBar(currentStep: 3, totalSteps: 4),

          const SizedBox(height: 24),

          Text(
            AppStrings.uploadFilesTitle(context),
            style: TextStyle(
              color: theme.textTheme.bodyLarge?.color,
              fontSize: 24 * scaleFactor,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            AppStrings.uploadFilesDesc(context),
            style: TextStyle(
              color: theme.textTheme.bodyMedium?.color,
              fontSize: 13 * scaleFactor,
              height: 1.5,
            ),
          ),

          const SizedBox(height: 20),

          UploadDropZone(onTap: _pickFile),

          const SizedBox(height: 24),

          if (_attachedFiles.isNotEmpty) ...[
            Text(
              AppStrings.attachedFilesSection(context),
              style: TextStyle(
                color: theme.textTheme.bodyLarge?.color,
                fontSize: 16 * scaleFactor,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
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
