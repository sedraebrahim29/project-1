import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:untitled3/core/constants/setting.dart';
import 'package:untitled3/features/patient_details/views/widgets/settings_drawer_widget.dart';
import '../../../../core/Theme/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/cubits/medical_record_status_cubit.dart';
import '../../../midecal_record/patiant_medical_record/views/screens/medical_records_screens/medical_overview_screen.dart';
import 'widgets/custom_bottom_nav_bar.dart';
import 'doctor_listing_screen.dart';
import 'patient_home_screen.dart';
import 'patient_profile_screen.dart';
import '../models/patient_profile_dummy_data.dart';
import '../view_models/doctor_listing_cubit.dart';
import '../view_models/doctor_listing_state.dart';

class MainLayoutScreen extends StatelessWidget {
  /// user object الحقيقي القادم من data.user برد /auth/login الناجح -
  /// نفس الكائن يلي بينمرر لكل الشاشات التابعة (الرئيسية/السجل الطبي/
  /// البروفايل) حتى تعرض كلها بيانات المريض الحقيقية المدخلة بالريجستر
  /// بدل أي بيانات وهمية.
  final Map<String, dynamic>? currentUserJson;

  const MainLayoutScreen({super.key, this.currentUserJson});

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
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => DoctorListingCubit(const [])..loadDoctors()),
          // ✅ حالة أولية من currentUserJson (لحظة تسجيل الدخول)، وبعدين
          // بتتحدث حية بمنتصف الجلسة لما يخلّص المريض تعبئة سجله الطبي -
          // راجع تعليق medical_record_status_cubit.dart.
          BlocProvider(
            create: (context) => MedicalRecordStatusCubit(
              currentUserJson != null &&
                  (currentUserJson!['profile'] is Map) &&
                  (currentUserJson!['profile']['has_medical_data'] == true),
            ),
          ),
        ],
        child: BlocBuilder<DoctorListingCubit, DoctorListingState>(
          builder: (context, state) {
            final cubit = context.read<DoctorListingCubit>();
            final hasMedicalRecord = context.watch<MedicalRecordStatusCubit>().state;

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
                    GestureDetector(
                      onTap: () {
                        if (currentUserJson == null) return;
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => PatientProfileScreen(
                              profile: PatientProfileModel.fromUserJson(currentUserJson!),
                            ),
                          ),
                        );
                      },
                      child: CircleAvatar(
                        radius: 18.r,
                        backgroundColor: primaryGreenColor.withOpacity(0.15),
                        child: Icon(Icons.person_outline, color: primaryGreenColor, size: 20.sp),
                      ),
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
                  PatientHomeScreen(currentUserJson: currentUserJson),
                  const DoctorListingScreen(),
                  Center(child: Text('Bookings Screen', style: TextStyle(color: textColor))),
                  Center(child: Text('Chat Screen', style: TextStyle(color: textColor))),
                  MedicalOverviewScreen(
                    currentUserJson: currentUserJson,
                    // ✅ هلق بياخد القيمة الحية من MedicalRecordStatusCubit
                    // (مو حساب ثابت مرة وحدة من currentUserJson) - راجع
                    // تعليق الـ Cubit لتفاصيل المشكلة يلي انحلت.
                    hasMedicalRecord: hasMedicalRecord,
                    onEditProfile: currentUserJson == null
                        ? null
                        : () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => PatientProfileScreen(
                                  profile: PatientProfileModel.fromUserJson(currentUserJson!),
                                ),
                              ),
                            ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
