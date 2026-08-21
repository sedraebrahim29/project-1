import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled3/core/constants/setting.dart';
import '../../../../../core/Theme/app_colors.dart';
import '../../../../../core/constants/app_strings.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // مراقبة حالة الـ SettingsCubit بالكامل لقراءة الخط والثيم
    final settingsState = context.watch<SettingsCubit>().state;
    final double fontScale = settingsState.scaleFactor;
    final isDark = settingsState.themeMode == ThemeMode.dark;

    // معادلة موازنة: نضمن ألا يقل حجم الخط عن 11، ويكبر تدريجياً بشكل مريح مع المستخدم
    final double adjustedFontSize = 20.0 * fontScale;

    // تجهيز الألوان التفاعلية بناءً على وضع الثيم
    final navBarBg = isDark ? AppColors.darkCard : AppColors.white;
    final selectedItemColor = isDark ? AppColors.darkPrimaryGreen : AppColors.primaryGreen;
    final unselectedItemColor = isDark ? AppColors.darkText.withOpacity(0.4) : AppColors.textLightGrey;
    final shadowColor = isDark ? Colors.black.withOpacity(0.2) : Colors.black.withOpacity(0.04);

    return Container(
      decoration: BoxDecoration(
        color: navBarBg,
        boxShadow: [
          BoxShadow(
            color: shadowColor,
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: onTap,
        type: BottomNavigationBarType.fixed,
        backgroundColor: navBarBg,
        selectedItemColor: selectedItemColor,
        unselectedItemColor: unselectedItemColor,

        // تطبيق الحجم المتوازن الجديد لمنع الخط الصغير المشوه
        selectedFontSize: adjustedFontSize,
        unselectedFontSize: adjustedFontSize,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w700, height: 1.4),
        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500, height: 1.4),

        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.home_outlined, size: 22),
            activeIcon: const Icon(Icons.home_rounded, size: 22),
            label: AppStrings.home(context),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.person_search_outlined, size: 22),
            activeIcon: const Icon(Icons.person_search_rounded, size: 22),
            label: AppStrings.doctors(context),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.calendar_month_outlined, size: 22),
            activeIcon: const Icon(Icons.calendar_month_rounded, size: 22),
            label: AppStrings.appointments(context),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.chat_bubble_outline_rounded, size: 21),
            activeIcon: const Icon(Icons.chat_bubble_rounded, size: 21),
            label: AppStrings.chats(context),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.assignment_outlined, size: 22),
            activeIcon: const Icon(Icons.assignment_rounded, size: 22),
            label: AppStrings.medicalRecords(context),
          ),
        ],
      ),
    );
  }
}
