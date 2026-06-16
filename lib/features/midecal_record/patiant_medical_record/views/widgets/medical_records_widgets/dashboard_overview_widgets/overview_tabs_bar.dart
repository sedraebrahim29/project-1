import 'package:flutter/material.dart';

import '../../../../../../../core/theme/app_colors.dart';


// =============================================
// Widget - شريط الـ Tabs
// Overview (محدد) | History | Medications | ...
// الـ Tab المحدد: نص داكن + خط أخضر تحته
// =============================================
class OverviewTabsBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTabSelected;

  static const List<String> tabs = [
    'Overview',
    'History',
    'Medications',
  ];

  const OverviewTabsBar({
    super.key,
    required this.selectedIndex,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 18,right: 18),
      child: Container(
        color: Colors.white,
        child: Row(
          children: [
            // الـ Tabs القابلة للتمرير
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(tabs.length, (index) {
                    final bool isSelected = index == selectedIndex;
                    return GestureDetector(
                      onTap: () => onTabSelected(index),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 14),
                        decoration: BoxDecoration(
                          // خط أخضر تحت الـ Tab المحدد فقط
                          border: Border(
                            bottom: BorderSide(
                              color: isSelected
                                  ? AppColors.primaryGreen
                                  : Colors.transparent,
                              width: 2.5,
                            ),
                          ),
                        ),
                        child: Text(
                          tabs[index],
                          style: TextStyle(
                            color: isSelected
                                ? AppColors.textDark
                                : AppColors.textGrey,
                            fontSize: 14,
                            fontWeight: isSelected
                                ? FontWeight.w700
                                : FontWeight.w400,
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ),

            // | أيقونة المزيد يمين
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Icon(
                Icons.more_horiz,
                color: AppColors.textGrey,
                size: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}