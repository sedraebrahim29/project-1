import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:untitled3/core/constants/setting.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';

class SearchBarWidget extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  /// Optional hint override. Defaults to [AppStrings.searchHint] so every
  /// caller stays translated even if it doesn't pass one explicitly.
  final String? hintText;

  /// Shows a filter icon at the trailing corner of the field (see the
  /// Figma "Filters" screen) when provided, and calls it on tap.
  final VoidCallback? onFilterTap;

  const SearchBarWidget({
    super.key,
    required this.controller,
    required this.onChanged,
    this.hintText,
    this.onFilterTap,
  });

  @override
  Widget build(BuildContext context) {
    final settingsState = context.watch<SettingsCubit>().state;
    final currentScale = settingsState.fontScale;
    final isDark = settingsState.themeMode == ThemeMode.dark;

    double inputSize = 14.sp;
    if (currentScale == FontScale.medium) inputSize = 16.sp;
    if (currentScale == FontScale.large) inputSize = 18.sp;

    // تحديد الألوان التفاعلية للـ Search Bar بناءً على نمط المظهر الحالي
    final inputBgColor = isDark ? AppColors.darkCard : AppColors.white;
    final inputTextColor = isDark ? AppColors.darkText : AppColors.textDark;
    final primaryGreenColor = isDark ? AppColors.darkPrimaryGreen : AppColors.primaryGreen;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              style: TextStyle(color: inputTextColor, fontSize: inputSize),
              decoration: InputDecoration(
                hintText: hintText ?? AppStrings.searchHint(context),
                hintStyle: TextStyle(color: AppColors.textLightGrey, fontSize: inputSize),
                prefixIcon: Icon(Icons.search_rounded, color: AppColors.textLightGrey, size: 22.sp),
                filled: true,
                fillColor: inputBgColor,
                contentPadding: EdgeInsets.symmetric(vertical: 12.h),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: isDark ? BorderSide(color: Colors.white10, width: 1.w) : BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: isDark ? BorderSide(color: Colors.white10, width: 1.w) : BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide(
                    color: isDark ? AppColors.darkPrimaryGreen : AppColors.primaryGreen,
                    width: 1.w,
                  ),
                ),
              ),
            ),
          ),
          if (onFilterTap != null) ...[
            SizedBox(width: 10.w),
            Material(
              color: inputBgColor,
              borderRadius: BorderRadius.circular(12.r),
              child: InkWell(
                borderRadius: BorderRadius.circular(12.r),
                onTap: onFilterTap,
                child: Container(
                  width: 46.h,
                  height: 46.h,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.r),
                    border: isDark ? Border.all(color: Colors.white10, width: 1.w) : null,
                  ),
                  child: Icon(Icons.tune_rounded, color: primaryGreenColor, size: 22.sp),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
