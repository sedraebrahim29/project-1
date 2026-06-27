// lib/core/widgets/custom_bottom_nav_bar.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/setting.dart';
class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scale = context.read<SettingsCubit>().state.scaleFactor;

    // الأيقونات والنصوص حسب التصميم المرفق
    final List<Map<String, dynamic>> navItems = [
      {'icon': Icons.home_outlined, 'activeIcon': Icons.home, 'label': 'Home'},
      {'icon': Icons.person_search_outlined, 'activeIcon': Icons.person_search, 'label': 'Doctors'},
      {'icon': Icons.calendar_today_outlined, 'activeIcon': Icons.calendar_today, 'label': 'Bookings'},
      {'icon': Icons.chat_bubble_outline, 'activeIcon': Icons.chat_bubble, 'label': 'Chat'},
      {'icon': Icons.assignment_outlined, 'activeIcon': Icons.assignment, 'label': 'Records'},
    ];

    return Container(
      decoration: BoxDecoration(
        color: theme.cardColor,
        border: Border(top: BorderSide(color: theme.dividerColor, width: 1)),
      ),
      child: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: onTap,
        type: BottomNavigationBarType.fixed,
        backgroundColor: theme.cardColor,
        selectedItemColor: theme.primaryColor,
        unselectedItemColor: theme.brightness == Brightness.dark ? Colors.grey[500] : Colors.grey[600],
        selectedLabelStyle: TextStyle(fontSize: (11 * scale).sp, fontWeight: FontWeight.bold),
        unselectedLabelStyle: TextStyle(fontSize: (11 * scale).sp, fontWeight: FontWeight.normal),
        elevation: 0,
        items: navItems.map((item) {
          int index = navItems.indexOf(item);
          bool isSelected = index == currentIndex;
          return BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.only(bottom: 4.h),
              child: Icon(isSelected ? item['activeIcon'] : item['icon'], size: 22.sp),
            ),
            label: item['label'],
          );
        }).toList(),
      ),
    );
  }
}
