import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:untitled3/core/constants/setting.dart';
import '../../../../core/theme/app_colors.dart';

/// A single filter chip: [label] is what the user sees (translated), while
/// [value] is the locale-independent value used for matching/selection so
/// that switching languages never breaks which chip is "selected" or how
/// doctors get filtered. See DoctorListingCubit for why this split exists.
class SpecialtyFilterOption {
  final String label;
  final String value;

  const SpecialtyFilterOption({required this.label, required this.value});
}

class SpecialtiesListWidget extends StatelessWidget {
  final List<SpecialtyFilterOption> filters;
  final String selectedValue;
  final ValueChanged<String> onFilterSelected;

  const SpecialtiesListWidget({
    super.key,
    required this.filters,
    required this.selectedValue,
    required this.onFilterSelected,
  });

  @override
  Widget build(BuildContext context) {
    final settingsState = context.watch<SettingsCubit>().state;
    final currentScale = settingsState.fontScale;
    final isDark = settingsState.themeMode == ThemeMode.dark;

    double filterTextSize = 13.sp;
    if (currentScale == FontScale.medium) filterTextSize = 15.sp;
    if (currentScale == FontScale.large) filterTextSize = 17.sp;

    // إعدادات الألوان التفاعلية بناءً على الدارك واللايت مود
    final unselectedBgColor = isDark ? AppColors.darkCard : AppColors.white;
    final selectedBgColor = isDark ? AppColors.darkPrimaryGreen : AppColors.primaryGreen;
    final unselectedTextColor = isDark ? AppColors.darkText : AppColors.textDark;
    final selectedTextColor = isDark ? AppColors.darkBackground : AppColors.white;
    final borderColor = isDark ? Colors.transparent : AppColors.borderGrey;

    return SizedBox(
      height: 48.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
        itemCount: filters.length,
        itemBuilder: (context, index) {
          final filter = filters[index];
          final isSelected = filter.value.toLowerCase() == selectedValue.toLowerCase();

          return GestureDetector(
            onTap: () => onFilterSelected(filter.value),
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 4.w),
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              decoration: BoxDecoration(
                color: isSelected ? selectedBgColor : unselectedBgColor,
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(
                  color: isSelected ? Colors.transparent : borderColor,
                  width: 1.w,
                ),
                boxShadow: isDark && !isSelected
                    ? [BoxShadow(color: Colors.black12, blurRadius: 2, offset: const Offset(0, 1))]
                    : [],
              ),
              alignment: Alignment.center,
              child: Text(
                filter.label,
                style: TextStyle(
                  color: isSelected ? selectedTextColor : unselectedTextColor,
                  fontSize: filterTextSize,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
