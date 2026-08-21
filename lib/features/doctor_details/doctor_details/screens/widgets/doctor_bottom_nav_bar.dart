import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled3/core/constants/setting.dart';
import '../../../../../core/Theme/app_colors.dart';
import '../../../../../core/constants/app_strings.dart';
import '../../../../../core/constants/app_strings_doctor.dart';


/// نفس هيكلية CustomBottomNavBar تبع المريض (patient_details) بالضبط،
/// بس بأربع تابات فقط للطبيب: الرئيسية / المواعيد / جدول العمل / شات
/// (شات فارغة حالياً - راجع DoctorChatPlaceholderScreen).
class DoctorBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const DoctorBottomNavBar({super.key, required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final settingsState = context.watch<SettingsCubit>().state;
    final double fontScale = settingsState.scaleFactor;
    final isDark = settingsState.themeMode == ThemeMode.dark;

    final double adjustedFontSize = 20.0 * fontScale;

    final navBarBg = isDark ? AppColors.darkCard : AppColors.white;
    final selectedItemColor = isDark ? AppColors.darkPrimaryGreen : AppColors.primaryGreen;
    final unselectedItemColor = isDark ? AppColors.darkText.withOpacity(0.4) : AppColors.textLightGrey;
    final shadowColor = isDark ? Colors.black.withOpacity(0.2) : Colors.black.withOpacity(0.04);

    return Container(
      decoration: BoxDecoration(
        color: navBarBg,
        boxShadow: [BoxShadow(color: shadowColor, blurRadius: 10, offset: const Offset(0, -2))],
      ),
      child: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: onTap,
        type: BottomNavigationBarType.fixed,
        backgroundColor: navBarBg,
        selectedItemColor: selectedItemColor,
        unselectedItemColor: unselectedItemColor,
        selectedFontSize: adjustedFontSize,
        unselectedFontSize: adjustedFontSize,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w700, height: 1.4),
        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500, height: 1.4),
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.home_outlined, size: 22),
            activeIcon: const Icon(Icons.home_rounded, size: 22),
            label: DoctorStrings.doctorHome(context),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.calendar_month_outlined, size: 22),
            activeIcon: const Icon(Icons.calendar_month_rounded, size: 22),
            label: AppStrings.appointments(context),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.schedule_outlined, size: 22),
            activeIcon: const Icon(Icons.schedule_rounded, size: 22),
            label: DoctorStrings.workScheduleManagement(context).split(' ').first,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.chat_bubble_outline_rounded, size: 21),
            activeIcon: const Icon(Icons.chat_bubble_rounded, size: 21),
            label: AppStrings.chats(context),
          ),
        ],
      ),
    );
  }
}
