import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:untitled3/core/constants/setting.dart';
import '../../../../core/theme/app_colors.dart';
import '../../view_models/account_cubit.dart';
import '../../view_models/account_state.dart';

/// Shows the destructive-action confirmation sheet from the Figma design
/// (used for both "Delete account" and "Log out"). Returns `true` if the
/// user confirmed and the action completed, `false`/`null` otherwise.
Future<bool?> showConfirmActionDialog(
  BuildContext context, {
  required String title,
  required String description,
  required String confirmLabel,
  required String cancelLabel,
  required Future<void> Function(AccountCubit cubit) onConfirm,
}) {
  return showDialog<bool>(
    context: context,
    barrierDismissible: true,
    builder: (dialogContext) => BlocProvider(
      create: (_) => AccountCubit(),
      child: _ConfirmActionContent(
        title: title,
        description: description,
        confirmLabel: confirmLabel,
        cancelLabel: cancelLabel,
        onConfirm: onConfirm,
      ),
    ),
  );
}

class _ConfirmActionContent extends StatelessWidget {
  final String title;
  final String description;
  final String confirmLabel;
  final String cancelLabel;
  final Future<void> Function(AccountCubit cubit) onConfirm;

  const _ConfirmActionContent({
    required this.title,
    required this.description,
    required this.confirmLabel,
    required this.cancelLabel,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    final settingsState = context.watch<SettingsCubit>().state;
    final isDark = settingsState.themeMode == ThemeMode.dark;
    final cubit = context.watch<AccountCubit>();
    final isProcessing = cubit.state.status == AccountActionStatus.processing;

    final cardBg = isDark ? AppColors.darkCard : AppColors.white;
    final textColor = isDark ? AppColors.darkText : AppColors.textDark;
    const dangerColor = Color(0xFFC0392B);

    return Dialog(
      backgroundColor: cardBg,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.r)),
      insetPadding: EdgeInsets.symmetric(horizontal: 28.w),
      child: Padding(
        padding: EdgeInsets.fromLTRB(24.w, 32.h, 24.w, 24.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64.r,
              height: 64.r,
              decoration: BoxDecoration(color: dangerColor.withOpacity(0.12), shape: BoxShape.circle),
              child: Icon(Icons.warning_rounded, color: dangerColor, size: 30.sp),
            ),
            SizedBox(height: 20.h),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w800, color: textColor),
            ),
            SizedBox(height: 12.h),
            Text(
              description,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14.sp, color: AppColors.textLightGrey, height: 1.5),
            ),
            SizedBox(height: 28.h),
            SizedBox(
              width: double.infinity,
              height: 50.h,
              child: ElevatedButton(
                onPressed: isProcessing
                    ? null
                    : () async {
                        await onConfirm(cubit);
                        if (context.mounted) Navigator.pop(context, true);
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: dangerColor,
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.r)),
                ),
                child: isProcessing
                    ? SizedBox(
                        width: 20.r,
                        height: 20.r,
                        child: const CircularProgressIndicator(strokeWidth: 2.4, color: Colors.white),
                      )
                    : Text(confirmLabel, style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 15.sp)),
              ),
            ),
            SizedBox(height: 12.h),
            SizedBox(
              width: double.infinity,
              height: 50.h,
              child: OutlinedButton(
                onPressed: isProcessing ? null : () => Navigator.pop(context, false),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: AppColors.borderGrey, width: 1.w),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.r)),
                ),
                child: Text(cancelLabel, style: TextStyle(color: textColor, fontWeight: FontWeight.w600, fontSize: 15.sp)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
