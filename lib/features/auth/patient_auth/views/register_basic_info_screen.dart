import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:untitled3/features/auth/patient_auth/views/widgets/step_four_widget.dart';
import 'package:untitled3/features/auth/patient_auth/views/widgets/step_one_widget.dart';
import 'package:untitled3/features/auth/patient_auth/views/widgets/step_three_widget.dart';
import 'package:untitled3/features/auth/patient_auth/views/widgets/step_two_widget.dart';
import '../../../../core/constants/setting.dart';
import '../../../../../core/constants/app_strings.dart';
import '../../../patient_details/views/doctor_listing_screen.dart';
import '../../../patient_details/views/patient_home_screen.dart';
import '../view_models/register_cubit.dart';
import '../view_models/register_state.dart';

class RegisterMainLayout extends StatelessWidget {
  RegisterMainLayout({super.key});

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final themeColor = Theme.of(context).primaryColor;
    final isEn = context.read<SettingsCubit>().state.locale.languageCode == 'en';

    return BlocProvider(
      create: (context) => RegisterCubit(),
      child: BlocBuilder<SettingsCubit, SettingsState>(
        builder: (context, settingsState) {
          return Directionality(
            textDirection: isEn ? TextDirection.ltr : TextDirection.rtl,
            child: Scaffold(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              appBar: AppBar(
                elevation: 0,
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                leading: Builder(
                  builder: (context) => IconButton(
                    icon: Icon(isEn ? Icons.arrow_back : Icons.arrow_forward, color: themeColor, size: 24.sp),
                    onPressed: () => context.read<RegisterCubit>().previousStep(context),
                  ),
                ),
                title: Text(
                  AppStrings.createAccount(context),
                  style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold, color: themeColor),
                ),
                centerTitle: true,
              ),
              body: SafeArea(
                child: Form(
                  key: _formKey,
                  child: BlocBuilder<RegisterCubit, RegisterState>(
                    builder: (context, registerState) {
                      final cubit = context.read<RegisterCubit>();
                      final double progressValue = registerState.currentStep / cubit.totalSteps;

                      return Column(
                        children: [
                          // مؤشر التقدم العلوي الثابت
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(4.r),
                              child: LinearProgressIndicator(
                                value: progressValue,
                                backgroundColor: Colors.grey.withOpacity(0.2),
                                valueColor: AlwaysStoppedAnimation<Color>(themeColor),
                                minHeight: 6.h,
                              ),
                            ),
                          ),

                          // عرض الخطوات الأربعة داخل الـ PageView
                          Expanded(
                            child: PageView(
                              controller: cubit.pageController,
                              physics: const NeverScrollableScrollPhysics(),
                              children: [
                                const StepOneWidgets(),  // الخطوة 1: المعلومات الأساسية
                                const StepTwoWidgets(),  // الخطوة 2: التفاصيل الشخصية والعنوان
                                StepThreeWidgets(),// الخطوة 3: رفع وصورة الهوية الحية
                                const StepFourWidgets(), // الخطوة 4: مراجعة كافة البيانات والتعديل
                              ],
                            ),
                          ),

                          // منطقة الأزرار السفلية الديناميكية
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
                            decoration: BoxDecoration(
                              color: Theme.of(context).scaffoldBackgroundColor,
                              border: Border(top: BorderSide(color: Colors.grey.withOpacity(0.1), width: 1)),
                            ),
                            child: registerState.currentStep == cubit.totalSteps
                            // شكل الأزرار في الخطوة الرابعة والأخيرة (مراجعة وإرسال)
                                ? Row(
                              children: [
                                Expanded(
                                  child: OutlinedButton(
                                    style: OutlinedButton.styleFrom(
                                      padding: EdgeInsets.symmetric(vertical: 14.h),
                                      side: BorderSide(color: Colors.grey.withOpacity(0.3)),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
                                    ),
                                    onPressed: () {
                                      // منطق حفظ البيانات كمسودة مبدئية
                                    },
                                    child: Text(
                                      AppStrings.saveDraft(context),
                                      style: TextStyle(fontSize: 15.sp, color: Colors.black87, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 12.w),
                                Expanded(
                                  flex: 2,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: themeColor,
                                      padding: EdgeInsets.symmetric(vertical: 14.h),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
                                    ),
                                    onPressed: () => DoctorListingScreen(),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          AppStrings.confirmSubmit(context),
                                          style: TextStyle(fontSize: 15.sp, color: Colors.white, fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(width: 8.w),
                                        Icon(Icons.check_circle_outline, color: Colors.white, size: 18.sp),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            )
                            // شكل الزر العادي لباقي الخطوات (1 و 2 و 3)
                                : SizedBox(
                              width: double.infinity,
                              height: 50.h,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: themeColor,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
                                ),
                                onPressed: () => cubit.nextStep(_formKey),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      AppStrings.nextStep(context),
                                      style: TextStyle(fontSize: 16.sp, color: Colors.white, fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(width: 8.w),
                                    Icon(isEn ? Icons.arrow_forward : Icons.arrow_back, color: Colors.white, size: 18.sp),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
