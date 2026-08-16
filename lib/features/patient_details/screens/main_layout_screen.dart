import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:untitled3/core/constants/setting.dart';
import 'package:untitled3/features/patient_details/views/widgets/settings_drawer_widget.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../midecal_record/patiant_medical_record/views/screens/medical_records_screens/medical_overview_screen.dart';
import '../models/doctor_dummy_data.dart';
import '../view_models/doctor_listing_cubit.dart';
import '../view_models/doctor_listing_state.dart';
import 'widgets/custom_bottom_nav_bar.dart';
import 'doctor_listing_screen.dart';
import 'patient_home_screen.dart';

class MainLayoutScreen extends StatelessWidget {
  const MainLayoutScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final settingsState = context.watch<SettingsCubit>().state;
    final isEn = settingsState.locale.languageCode == 'en';
    final currentScale = settingsState.fontScale;
    final isDark = settingsState.themeMode == ThemeMode.dark;


    double titleFontSize = 16.sp;
    if (currentScale == FontScale.medium) titleFontSize = 19.sp;
    if (currentScale == FontScale.large) titleFontSize = 22.sp;


    final scaffoldBg = isDark ? AppColors.darkBackground : AppColors.backgroundBeige;
    final appBarBg = isDark ? AppColors.darkCard : AppColors.white;
    final textColor = isDark ? AppColors.darkText : AppColors.textDark;
    final primaryGreenColor = isDark ? AppColors.darkPrimaryGreen : AppColors.primaryGreen;
    final bottomLineColor = isDark ? Colors.white10 : AppColors.backgroundBeige;

    return Directionality(
      textDirection: isEn ? TextDirection.ltr : TextDirection.rtl,
      child: BlocProvider(
        create: (context) => DoctorListingCubit(dummyDoctors),
        child: BlocBuilder<DoctorListingCubit, DoctorListingState>(
          builder: (context, state) {
            final cubit = context.read<DoctorListingCubit>();

            return Scaffold(
              backgroundColor: scaffoldBg,

              appBar: AppBar(
                backgroundColor: appBarBg,
                elevation: 0,
                scrolledUnderElevation: 0,
                automaticallyImplyLeading: false,
                titleSpacing: 16.w,
                title: Row(
                  children: [
                    CircleAvatar(
                      radius: 18.r,
                      backgroundColor: primaryGreenColor.withOpacity(0.15),
                      child: Icon(Icons.person_outline, color: primaryGreenColor, size: 20.sp),
                    ),
                    SizedBox(width: 10.w),
                    Text(
                      AppStrings.appName,
                      style: TextStyle(
                        fontSize: titleFontSize,
                        fontWeight: FontWeight.w700,
                        color: textColor,
                      ),
                    ),
                    const Spacer(),

                    if (state.currentIndex == 1) ...[
                      GestureDetector(
                        onTap: () => cubit.toggleShowingAll(),
                        child: Icon(
                          !state.showingAll || state.favCount > 0
                              ? Icons.favorite_rounded
                              : Icons.favorite_border_rounded,
                          color: !state.showingAll || state.favCount > 0
                              ? const Color(0xFFD85A30)
                              : AppColors.textLightGrey,
                          size: 22.sp,
                        ),
                      ),
                      SizedBox(width: 14.w),
                    ],
                    Icon(Icons.notifications_none_rounded, color: textColor, size: 24.sp),
                    SizedBox(width: 14.w),
                    GestureDetector(
                      onTap: () {
                        showSettingsDrawer(context);
                      },
                      child: Icon(Icons.more_vert, color: textColor, size: 24.sp),
                    ),
                  ],
                ),
                bottom: PreferredSize(
                  preferredSize: Size.fromHeight(1.0.h),
                  child: Container(color: bottomLineColor, height: 1.0.h),
                ),
              ),

              bottomNavigationBar: CustomBottomNavBar(
                currentIndex: state.currentIndex,
                onTap: (index) => cubit.changeTab(index),
              ),

              body: IndexedStack(
                index: state.currentIndex,
                children: [
                  const PatientHomeScreen(),
                  const DoctorListingScreen(),
                  Center(child: Text('Bookings Screen', style: TextStyle(color: textColor))),
                  Center(child: Text('Chat Screen', style: TextStyle(color: textColor))),
                  const MedicalOverviewScreen(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
