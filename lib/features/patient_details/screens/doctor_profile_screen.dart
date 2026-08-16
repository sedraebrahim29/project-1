import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:untitled3/core/constants/setting.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../models/doctor_dummy_data.dart';

class DoctorProfileScreen extends StatelessWidget {
  final DoctorListingModel doctor;

  const DoctorProfileScreen({super.key, required this.doctor});

  @override
  Widget build(BuildContext context) {
    final settingsState = context.watch<SettingsCubit>().state;
    final currentScale = settingsState.fontScale;
    final isDark = settingsState.themeMode == ThemeMode.dark;


    double nameSize = 20.sp;
    double specialtySize = 14.sp;
    double sectionTitleSize = 16.sp;
    double bodyTextSize = 13.sp;
    double feeSize = 18.sp;

    if (currentScale == FontScale.medium) {
      nameSize = 23.sp; specialtySize = 16.sp; sectionTitleSize = 18.sp; bodyTextSize = 15.sp; feeSize = 21.sp;
    } else if (currentScale == FontScale.large) {
      nameSize = 26.sp; specialtySize = 18.sp; sectionTitleSize = 20.sp; bodyTextSize = 17.sp; feeSize = 24.sp;
    }


    final scaffoldBg = isDark ? AppColors.darkBackground : AppColors.backgroundBeige;
    final cardBgColor = isDark ? AppColors.darkCard : AppColors.white;
    final doctorCardBg = isDark ? const Color(0xFF23392E) : const Color(0xFFC4D7C5); // درجة داكنة متناسقة للكرت العلوي في الدارك
    final textColor = isDark ? AppColors.darkText : AppColors.textDark;
    final primaryGreenColor = isDark ? AppColors.darkPrimaryGreen : AppColors.primaryGreen;
    final borderColor = isDark ? Colors.white10 : AppColors.borderGrey;

    return Scaffold(
      backgroundColor: scaffoldBg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: textColor, size: 24.sp),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(
              doctor.isFavourite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
              color: doctor.isFavourite ? const Color(0xFFD85A30) : textColor,
              size: 24.sp,
            ),
            onPressed: () {
            },
          ),
          SizedBox(width: 8.w),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(16.r),
                      decoration: BoxDecoration(
                        color: doctorCardBg,
                        borderRadius: BorderRadius.circular(24.r),
                      ),
                      child: Stack(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                                decoration: BoxDecoration(
                                  color: (isDark ? AppColors.darkCard : AppColors.white).withOpacity(0.9),
                                  borderRadius: BorderRadius.circular(20.r),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.star_rounded, color: const Color(0xFFFBBF24), size: 16.sp),
                                    SizedBox(width: 2.w),
                                    Text(
                                      '${doctor.rating}',
                                      style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold, color: textColor),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 16.h),
                              Text(
                                doctor.fullName,
                                style: TextStyle(fontSize: nameSize, fontWeight: FontWeight.w700, color: isDark ? AppColors.darkText : AppColors.primaryGreen),
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                doctor.subSpecialty,
                                style: TextStyle(fontSize: specialtySize, color: textColor.withOpacity(0.8), fontWeight: FontWeight.w500),
                              ),
                              SizedBox(height: 24.h),
                              Row(
                                children: [
                                  _buildQuickActionIcon(Icons.phone, cardBgColor, primaryGreenColor),
                                  SizedBox(width: 12.w),
                                  _buildQuickActionIcon(Icons.videocam_rounded, cardBgColor, primaryGreenColor),
                                  SizedBox(width: 12.w),
                                  _buildQuickActionIcon(Icons.location_on_rounded, cardBgColor, primaryGreenColor),
                                ],
                              ),
                            ],
                          ),
                          Align(
                            alignment: Alignment.topRight,
                            child: Container(
                              width: 85.w,
                              height: 95.h,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16.r),
                                color: cardBgColor,
                                image: const DecorationImage(
                                  image: AssetImage('assets/images/doctor_placeholder.png'),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 24.h),

                    Text(
                      AppStrings.about(context),
                      style: TextStyle(fontSize: sectionTitleSize, fontWeight: FontWeight.w700, color: primaryGreenColor),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'Dr. ${doctor.lastName} is a dedicated professional with years of experience in providing complete medical care. Accurate profiles ensure better patient care and treatment outcomes.',
                      style: TextStyle(fontSize: bodyTextSize, color: isDark ? AppColors.darkText.withOpacity(0.7) : AppColors.textLightGrey, height: 1.5),
                    ),
                    SizedBox(height: 24.h),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          AppStrings.availableSchedule(context),
                          style: TextStyle(fontSize: sectionTitleSize, fontWeight: FontWeight.w700, color: primaryGreenColor),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                          decoration: BoxDecoration(
                            color: cardBgColor,
                            borderRadius: BorderRadius.circular(12.r),
                            border: Border.all(color: borderColor),
                          ),
                          child: Row(
                            children: [
                              Text('October', style: TextStyle(fontSize: 11.sp, color: textColor, fontWeight: FontWeight.w600)),
                              Icon(Icons.keyboard_arrow_down_rounded, size: 14.sp, color: AppColors.textLightGrey),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12.h),

                    SizedBox(
                      height: 65.h,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        children: [
                          _buildDayCard('Mon', '12', primaryGreenColor, isDark ? const Color(0xFF2C3E35) : const Color(0xFFD2DDD5), textColor, isSelected: true),
                          _buildDayCard('Tue', '13', primaryGreenColor, isDark ? const Color(0xFF2C3E35) : const Color(0xFFD2DDD5), textColor),
                          _buildDayCard('Wed', '14', primaryGreenColor, isDark ? const Color(0xFF2C3E35) : const Color(0xFFD2DDD5), textColor),
                          _buildDayCard('Thu', '15', primaryGreenColor, isDark ? const Color(0xFF2C3E35) : const Color(0xFFD2DDD5), textColor),
                          _buildDayCard('Fri', '16', primaryGreenColor, isDark ? const Color(0xFF2C3E35) : const Color(0xFFD2DDD5), textColor),
                        ],
                      ),
                    ),
                    SizedBox(height: 16.h),

                    Text(
                      AppStrings.morning(context),
                      style: TextStyle(fontSize: bodyTextSize, fontWeight: FontWeight.w600, color: isDark ? AppColors.darkText.withOpacity(0.6) : AppColors.textLightGrey),
                    ),
                    SizedBox(height: 8.h),
                    Wrap(
                      spacing: 10.w,
                      runSpacing: 10.h,
                      children: [
                        _buildTimeSlot('09:00 AM', cardBgColor, borderColor, textColor, primaryGreenColor, doctorCardBg),
                        _buildTimeSlot('09:30 AM', cardBgColor, borderColor, textColor, primaryGreenColor, doctorCardBg, isSelected: true),
                        _buildTimeSlot('10:00 AM', cardBgColor, borderColor, textColor, primaryGreenColor, doctorCardBg),
                        _buildTimeSlot('11:30 AM', cardBgColor, borderColor, textColor, primaryGreenColor, doctorCardBg),
                      ],
                    ),
                    SizedBox(height: 16.h),

                    Text(
                      AppStrings.afternoon(context),
                      style: TextStyle(fontSize: bodyTextSize, fontWeight: FontWeight.w600, color: isDark ? AppColors.darkText.withOpacity(0.6) : AppColors.textLightGrey),
                    ),
                    SizedBox(height: 8.h),
                    Wrap(
                      spacing: 10.w,
                      runSpacing: 10.h,
                      children: [
                        _buildTimeSlot('01:00 PM', cardBgColor, borderColor, textColor, primaryGreenColor, doctorCardBg),
                        _buildTimeSlot('02:30 PM', cardBgColor, borderColor, textColor, primaryGreenColor, doctorCardBg, isDisabled: true),
                        _buildTimeSlot('04:00 PM', cardBgColor, borderColor, textColor, primaryGreenColor, doctorCardBg),
                      ],
                    ),
                    SizedBox(height: 20.h),
                  ],
                ),
              ),
            ),

            Container(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 14.h),
              decoration: BoxDecoration(
                color: cardBgColor,
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(isDark ? 0.3 : 0.03), spreadRadius: 1, blurRadius: 10, offset: const Offset(0, -2)),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        AppStrings.consultationFeeLabel(context),
                        style: TextStyle(fontSize: 12.sp, color: AppColors.textLightGrey, fontWeight: FontWeight.w500),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        '\$${doctor.consultationFee.toStringAsFixed(2)}',
                        style: TextStyle(fontSize: feeSize, fontWeight: FontWeight.w700, color: textColor),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 200.w,
                    height: 46.h,
                    child: ElevatedButton(
                      onPressed: () {
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryGreenColor,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.r)),
                        elevation: 0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            AppStrings.bookAppointment(context),
                            style: TextStyle(color: isDark ? AppColors.darkBackground : AppColors.white, fontSize: 14.sp, fontWeight: FontWeight.w700),
                          ),
                          SizedBox(width: 6.w),
                          Icon(Icons.arrow_forward, color: isDark ? AppColors.darkBackground : AppColors.white, size: 16.sp),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionIcon(IconData icon, Color bg, Color iconColor) {
    return Container(
      width: 44.r,
      height: 44.r,
      decoration: BoxDecoration(
        color: bg,
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: iconColor, size: 20.sp),
    );
  }

  Widget _buildDayCard(String day, String date, Color selectedColor, Color unselectedColor, Color textColor, {bool isSelected = false}) {
    return Container(
      width: 52.w,
      margin: EdgeInsets.only(right: 10.w),
      decoration: BoxDecoration(
        color: isSelected ? selectedColor : unselectedColor,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(day, style: TextStyle(fontSize: 11.sp, color: isSelected ? Colors.white : AppColors.textLightGrey, fontWeight: FontWeight.w500)),
          SizedBox(height: 4.h),
          Text(date, style: TextStyle(fontSize: 15.sp, color: isSelected ? Colors.white : textColor, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildTimeSlot(String time, Color cardBg, Color border, Color text, Color primary, Color selectedBg, {bool isSelected = false, bool isDisabled = false}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: isSelected
            ? selectedBg
            : isDisabled
            ? Colors.black.withOpacity(0.05)
            : cardBg,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(
          color: isSelected
              ? primary
              : isDisabled
              ? Colors.transparent
              : border,
          width: 1.w,
        ),
      ),
      child: Text(
        time,
        style: TextStyle(
          fontSize: 12.sp,
          fontWeight: FontWeight.w600,
          color: isDisabled
              ? AppColors.textLightGrey.withOpacity(0.4)
              : text,
        ),
      ),
    );
  }
}
