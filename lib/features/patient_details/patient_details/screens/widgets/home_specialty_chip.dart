import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:untitled3/core/constants/setting.dart';
import '../../../../core/theme/app_colors.dart';

class HomeSpecialtyChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const HomeSpecialtyChip({super.key, required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final settingsState = context.watch<SettingsCubit>().state;
    final isDark = settingsState.themeMode == ThemeMode.dark;
    final currentScale = settingsState.fontScale;

    double labelSize = 12.sp;
    if (currentScale == FontScale.medium) labelSize = 14.sp;
    if (currentScale == FontScale.large) labelSize = 16.sp;

    final cardBg = isDark ? AppColors.darkCard : AppColors.white;
    final textColor = isDark ? AppColors.darkText : AppColors.textDark;
    final primaryGreen = isDark ? AppColors.darkPrimaryGreen : AppColors.primaryGreen;

    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 76.w,
        child: Column(
          children: [
            Container(
              width: 56.r,
              height: 56.r,
              decoration: BoxDecoration(color: cardBg, shape: BoxShape.circle),
              alignment: Alignment.center,
              child: Icon(icon, color: primaryGreen, size: 24.sp),
            ),
            SizedBox(height: 8.h),
            Text(
              label,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: labelSize, fontWeight: FontWeight.w600, color: textColor),
            ),
          ],
        ),
      ),
    );
  }
}
