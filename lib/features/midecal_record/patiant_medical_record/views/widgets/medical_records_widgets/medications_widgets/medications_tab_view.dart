import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../../core/theme/app_colors.dart';
import '../../../../../../../core/constants/app_strings.dart';
import '../../../../../initial_medical_records/models/medication_model.dart';
import '../../../../view_models/medical_overview_cubit.dart';
import 'medication_record_card.dart';

// =============================================
// محتوى تاب "Medications" - يحل محل شاشة Active/Past القديمة اللي
// كانت Scaffold منفصلة (بار علوي + bottom nav خاص فيها). هلق مجرد
// محتوى يترسم مكانه جوا الـ IndexedStack بشاشة MedicalOverviewScreen.
// =============================================
class MedicationsTabView extends StatelessWidget {
  final MedicalOverviewState state;

  const MedicationsTabView({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<MedicalOverviewCubit>();
    final meds = state.medicationsFilter == MedicationsFilter.active
        ? state.activeMedications
        : state.pastMedications;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _FilterToggle(
          filter: state.medicationsFilter,
          activeCount: state.activeMedications.length,
          pastCount: state.pastMedications.length,
          onChanged: cubit.setMedicationsFilter,
        ),
        SizedBox(height: 16.h),
        if (meds.isEmpty)
          _EmptyState(text: AppStrings.noMedicationsYet(context))
        else
          ...meds.map(
            (m) => MedicationRecordCard(
              medication: m,
              onStop: (m.editable && !m.isStopped) ? () => _confirmStop(context, cubit, m) : null,
              onDelete: () => _confirmDelete(context, cubit, m),
            ),
          ),
      ],
    );
  }

  Future<void> _confirmStop(BuildContext context, MedicalOverviewCubit cubit, Medication m) async {
    final reasonController = TextEditingController();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(AppStrings.stopMedicationConfirmTitle(dialogContext)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(AppStrings.stopMedicationConfirmDesc(dialogContext)),
            SizedBox(height: 12.h),
            TextField(
              controller: reasonController,
              decoration: InputDecoration(hintText: AppStrings.stopReasonHint(dialogContext)),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(AppStrings.cancel(dialogContext)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text(AppStrings.confirm(dialogContext)),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await cubit.stopMedication(m.id, reason: reasonController.text.trim().isEmpty ? null : reasonController.text.trim());
    }
  }

  Future<void> _confirmDelete(BuildContext context, MedicalOverviewCubit cubit, Medication m) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(AppStrings.deleteConfirmTitle(dialogContext)),
        content: Text(AppStrings.deleteConfirmDesc(dialogContext)),
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
      await cubit.deleteMedication(m.id);
    }
  }
}

class _FilterToggle extends StatelessWidget {
  final MedicationsFilter filter;
  final int activeCount;
  final int pastCount;
  final ValueChanged<MedicationsFilter> onChanged;

  const _FilterToggle({
    required this.filter,
    required this.activeCount,
    required this.pastCount,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.darkBackground : AppColors.borderGrey.withOpacity(0.5);
    final selectedBg = isDark ? AppColors.darkCard : AppColors.white;
    final selectedText = isDark ? AppColors.darkText : AppColors.textDark;
    final unselectedText = AppColors.textLightGrey;

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(10.r)),
      child: Row(
        children: [
          Expanded(
            child: _ToggleButton(
              label: '${AppStrings.active(context)} ($activeCount)',
              selected: filter == MedicationsFilter.active,
              selectedBg: selectedBg,
              selectedText: selectedText,
              unselectedText: unselectedText,
              onTap: () => onChanged(MedicationsFilter.active),
            ),
          ),
          Expanded(
            child: _ToggleButton(
              label: '${AppStrings.past(context)} ($pastCount)',
              selected: filter == MedicationsFilter.past,
              selectedBg: selectedBg,
              selectedText: selectedText,
              unselectedText: unselectedText,
              onTap: () => onChanged(MedicationsFilter.past),
            ),
          ),
        ],
      ),
    );
  }
}

class _ToggleButton extends StatelessWidget {
  final String label;
  final bool selected;
  final Color selectedBg;
  final Color selectedText;
  final Color unselectedText;
  final VoidCallback onTap;

  const _ToggleButton({
    required this.label,
    required this.selected,
    required this.selectedBg,
    required this.selectedText,
    required this.unselectedText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: EdgeInsets.symmetric(vertical: 8.h),
        decoration: BoxDecoration(
          color: selected ? selectedBg : Colors.transparent,
          borderRadius: BorderRadius.circular(8.r),
          boxShadow: selected
              ? [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 4, offset: const Offset(0, 1))]
              : null,
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            color: selected ? selectedText : unselectedText,
            fontSize: 13.sp,
            fontWeight: selected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final String text;
  const _EmptyState({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 40.h),
      child: Center(
        child: Text(text, style: TextStyle(color: AppColors.textLightGrey, fontSize: 13.sp)),
      ),
    );
  }
}
