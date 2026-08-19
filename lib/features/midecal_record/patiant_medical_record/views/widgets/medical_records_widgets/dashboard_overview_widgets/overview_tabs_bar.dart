import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../../core/theme/app_colors.dart';
import '../../../../../../../core/constants/app_strings.dart';

// =============================================
// شريط التابات الأفقي: Overview / History / Medications / Attachments
// هذا هو محرك التنقل الأساسي بالشاشة - الضغط على أي تاب يبدّل المحتوى
// تحته بدون أي Navigator.push، بدل ما كانت كل شاشة صفحة منفصلة.
// أضفنا تاب Attachments الرابع، وحوّلنا أيقونة "..." من ديكور إلى زر
// تحديث فعلي (إعادة جلب السجل من الباك).
// =============================================
class OverviewTabsBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTabSelected;
  final VoidCallback? onRefresh;

  const OverviewTabsBar({
    super.key,
    required this.selectedIndex,
    required this.onTabSelected,
    this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    final List<String> tabs = [
      AppStrings.overview(context),
      AppStrings.history(context),
      AppStrings.medications(context),
      AppStrings.attachments(context),
    ];

    return Container(
      color: isDarkMode ? AppColors.darkCard : AppColors.white,
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        children: [
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(tabs.length, (index) {
                  final bool isSelected = index == selectedIndex;
                  final primaryGreen = isDarkMode
                      ? AppColors.darkPrimaryGreen
                      : AppColors.primaryGreen;
                  final textColor = isSelected
                      ? (isDarkMode ? AppColors.darkText : AppColors.textDark)
                      : AppColors.textLightGrey;

                  return GestureDetector(
                    onTap: () => onTabSelected(index),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 14.h,
                      ),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: isSelected ? primaryGreen : Colors.transparent,
                            width: 2.5.w,
                          ),
                        ),
                      ),
                      child: Text(
                        tabs[index],
                        style: TextStyle(
                          color: textColor,
                          fontSize: 14.sp,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
          if (onRefresh != null)
            IconButton(
              onPressed: onRefresh,
              tooltip: AppStrings.refresh(context),
              icon: Icon(
                Icons.refresh,
                color: AppColors.textLightGrey,
                size: 20.sp,
              ),
            ),
        ],
      ),
    );
  }
}
