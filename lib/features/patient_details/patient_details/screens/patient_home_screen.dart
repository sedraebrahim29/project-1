import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:untitled3/core/constants/setting.dart';
import '../../../../core/Theme/app_colors.dart';
import '../../../../core/constants/app_strings.dart';

import '../models/patient_profile_dummy_data.dart';
import '../view_models/doctor_listing_cubit.dart';
import '../view_models/doctor_listing_state.dart';
import 'patient_profile_screen.dart';
import 'widgets/home_doctor_tile.dart';
import 'widgets/home_specialty_chip.dart';

class PatientHomeScreen extends StatelessWidget {
  /// user object الحقيقي من data.user برد /auth/login - لو انمرر،
  /// الترحيب وصورة البروفايل بيعرضوا اسم المريض الحقيقي والنقر عليها
  /// بيوديه لبروفايله الحقيقي بدل dummyPatientProfile.
  final Map<String, dynamic>? currentUserJson;

  const PatientHomeScreen({super.key, this.currentUserJson});

  @override
  Widget build(BuildContext context) {
    final settingsState = context.watch<SettingsCubit>().state;
    final currentScale = settingsState.fontScale;
    final isDark = settingsState.themeMode == ThemeMode.dark;

    double greetingSize = 12.sp;
    double nameSize = 18.sp;
    double sectionSize = 16.sp;
    if (currentScale == FontScale.medium) { greetingSize = 14.sp; nameSize = 20.sp; sectionSize = 18.sp; }
    if (currentScale == FontScale.large) { greetingSize = 16.sp; nameSize = 22.sp; sectionSize = 20.sp; }

    final textColor = isDark ? AppColors.darkText : AppColors.textDark;
    final primaryGreen = isDark ? AppColors.darkPrimaryGreen : AppColors.primaryGreen;
    final cardBg = isDark ? AppColors.darkCard : AppColors.white;

    final profile = currentUserJson != null
        ? PatientProfileModel.fromUserJson(currentUserJson!)
        : dummyPatientProfile;

    final hour = TimeOfDay.now().hour;
    final greeting = hour < 12
        ? AppStrings.goodMorning(context)
        : hour < 18
            ? AppStrings.goodAfternoon(context)
            : AppStrings.goodEvening(context);

    return BlocBuilder<DoctorListingCubit, DoctorListingState>(
      builder: (context, state) {
        final cubit = context.read<DoctorListingCubit>();
        final nearby = state.allDoctors.take(3).toList();

        return ListView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 24.h),
          children: [
            // --- الترحيب ---
            Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => PatientProfileScreen(profile: profile)),
                  ),
                  child: CircleAvatar(
                    radius: 20.r,
                    backgroundColor: primaryGreen.withOpacity(0.15),
                    backgroundImage:
                        (profile.avatarUrl?.isNotEmpty ?? false) ? NetworkImage(profile.avatarUrl!) : null,
                    child: (profile.avatarUrl?.isNotEmpty ?? false)
                        ? null
                        : Icon(Icons.person_outline, color: primaryGreen, size: 22.sp),
                  ),
                ),
                SizedBox(width: 10.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(greeting, style: TextStyle(fontSize: greetingSize, color: AppColors.textLightGrey, fontWeight: FontWeight.w500)),
                    Text(profile.firstName, style: TextStyle(fontSize: nameSize, fontWeight: FontWeight.w800, color: primaryGreen)),
                  ],
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () {},
                  child: Icon(Icons.notifications_none_rounded, color: textColor, size: 24.sp),
                ),
              ],
            ),
            SizedBox(height: 18.h),

            // --- شريط البحث (يفتح تبويب الأطباء) ---
            GestureDetector(
              onTap: () => cubit.changeTab(1),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 13.h),
                decoration: BoxDecoration(color: cardBg, borderRadius: BorderRadius.circular(12.r)),
                child: Row(
                  children: [
                    Icon(Icons.search_rounded, color: AppColors.textLightGrey, size: 20.sp),
                    SizedBox(width: 10.w),
                    Text(AppStrings.searchDoctorHint(context), style: TextStyle(color: AppColors.textLightGrey, fontSize: 14.sp)),
                    const Spacer(),
                    Icon(Icons.tune_rounded, color: AppColors.textLightGrey, size: 20.sp),
                  ],
                ),
              ),
            ),
            SizedBox(height: 18.h),

            // --- بانر البحث عن طبيب ---
            Container(
              padding: EdgeInsets.all(20.r),
              decoration: BoxDecoration(
                color: primaryGreen,
                borderRadius: BorderRadius.circular(20.r),
                image: const DecorationImage(
                  image: NetworkImage('https://images.unsplash.com/photo-1622253692010-333f2da6031d?w=600&q=60'),
                  fit: BoxFit.cover,
                  opacity: 0.28,
                  alignment: Alignment.centerRight,
                ),
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 190.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppStrings.findDoctorEasilyTitle(context),
                      style: TextStyle(color: Colors.white, fontSize: sectionSize + 3.sp, fontWeight: FontWeight.w800, height: 1.25),
                    ),
                    SizedBox(height: 14.h),
                    GestureDetector(
                      onTap: () => cubit.changeTab(1),
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 10.h),
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24.r)),
                        child: Text(AppStrings.searchNow(context), style: TextStyle(color: primaryGreen, fontWeight: FontWeight.w700, fontSize: 13.sp)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 24.h),

            // --- تخصصات الأطباء ---
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(AppStrings.doctorSpecialties(context), style: TextStyle(fontSize: sectionSize, fontWeight: FontWeight.w700, color: textColor)),
                GestureDetector(
                  onTap: () => cubit.changeTab(1),
                  child: Text(AppStrings.seeAll(context), style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600, color: primaryGreen)),
                ),
              ],
            ),
            SizedBox(height: 14.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                HomeSpecialtyChip(
                  icon: Icons.favorite_border_rounded,
                  label: AppStrings.subSpecialties(context, 'Medicine')[0],
                  onTap: () {
                    cubit.updateFilter(AppStrings.subSpecialtiesCanonical('Medicine')[0]);
                    cubit.changeTab(1);
                  },
                ),
                HomeSpecialtyChip(
                  icon: Icons.psychology_outlined,
                  label: AppStrings.subSpecialties(context, 'Medicine')[2],
                  onTap: () {
                    cubit.updateFilter(AppStrings.subSpecialtiesCanonical('Medicine')[2]);
                    cubit.changeTab(1);
                  },
                ),
                HomeSpecialtyChip(
                  icon: Icons.child_care_rounded,
                  label: AppStrings.subSpecialties(context, 'Medicine')[3],
                  onTap: () {
                    cubit.updateFilter(AppStrings.subSpecialtiesCanonical('Medicine')[3]);
                    cubit.changeTab(1);
                  },
                ),
                HomeSpecialtyChip(
                  icon: Icons.accessibility_new_rounded,
                  label: AppStrings.subSpecialties(context, 'Medicine')[5],
                  onTap: () {
                    cubit.updateFilter(AppStrings.subSpecialtiesCanonical('Medicine')[5]);
                    cubit.changeTab(1);
                  },
                ),
              ],
            ),
            SizedBox(height: 24.h),

            // --- أطباء بالقرب منك ---
            Text(AppStrings.doctorsNearYou(context), style: TextStyle(fontSize: sectionSize, fontWeight: FontWeight.w700, color: textColor)),
            SizedBox(height: 12.h),
            if (nearby.isEmpty)
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(20.w),
                decoration: BoxDecoration(color: cardBg, borderRadius: BorderRadius.circular(14.r)),
                child: Center(
                  child: Text(AppStrings.noDoctorsFound(context),
                      style: TextStyle(color: AppColors.textLightGrey, fontSize: 13.sp)),
                ),
              )
            else
              ...nearby.map((doc) => HomeDoctorTile(
                    doc: doc,
                    onToggleFav: () => cubit.toggleFavourite(doc.id),
                    onBook: () => cubit.changeTab(2),
                  )),
          ],
        );
      },
    );
  }
}
