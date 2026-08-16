import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../../core/theme/app_colors.dart';
import '../../../../../../../core/constants/app_strings.dart';
import '../../../../../initial_medical_records/models/attached_model.dart';
import '../../../../view_models/medical_overview_cubit.dart';
import 'attachment_record_card.dart';

// =============================================
// محتوى تاب "Attachments" - قائمة واحدة بكل الملفات الحقيقية المرفوعة
// (getFullMedicalRecord يرجعها ضمن نفس نداء الشاشة، فما في نداء شبكة
// إضافي هون). التنزيل يعرض Snackbar بحجم الملف حالياً؛ لازم تضيفوا
// path_provider + open_file (أو share_plus) عشان يحفظ/يفتح الملف
// فعلياً على الجهاز - راجعوا ملاحظة ذلك بالملخص المرفق.
// =============================================
class AttachmentsTabView extends StatefulWidget {
  final MedicalOverviewState state;

  const AttachmentsTabView({super.key, required this.state});

  @override
  State<AttachmentsTabView> createState() => _AttachmentsTabViewState();
}

class _AttachmentsTabViewState extends State<AttachmentsTabView> {
  int? _downloadingId;

  Future<void> _handleDownload(BuildContext context, AttachedFile file) async {
    setState(() => _downloadingId = file.id);
    final cubit = context.read<MedicalOverviewCubit>();
    final bytes = await cubit.downloadAttachment(file.id);
    if (!mounted) return;
    setState(() => _downloadingId = null);
    if (!context.mounted) return;
    final messenger = ScaffoldMessenger.of(context);
    if (bytes != null) {
      messenger.showSnackBar(SnackBar(content: Text('${file.type} • ${bytes.length} bytes')));
    } else {
      messenger.showSnackBar(
        SnackBar(content: Text(AppStrings.downloadFailed(context)), backgroundColor: Colors.red),
      );
    }
  }

  Future<void> _confirmDelete(BuildContext context, AttachedFile file) async {
    final cubit = context.read<MedicalOverviewCubit>();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(AppStrings.deleteAttachmentConfirmTitle(dialogContext)),
        content: Text(AppStrings.deleteAttachmentConfirmDesc(dialogContext)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(AppStrings.cancel(dialogContext)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text(AppStrings.delete(dialogContext)),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await cubit.deleteAttachment(file.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final files = widget.state.attachments;

    if (files.isEmpty) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 40.h),
        child: Center(
          child: Text(
            AppStrings.noAttachmentsYet(context),
            style: TextStyle(color: AppColors.textLightGrey, fontSize: 13.sp),
          ),
        ),
      );
    }

    return Column(
      children: files
          .map((f) => AttachmentRecordCard(
                file: f,
                isDownloading: _downloadingId == f.id,
                onDownload: () => _handleDownload(context, f),
                onDelete: () => _confirmDelete(context, f),
              ))
          .toList(),
    );
  }
}
