import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/constants/app_strings.dart';
import '../view_models/register_cubit.dart';
import '../view_models/register_state.dart';
import '../../../../core/constants/setting.dart';
import 'package:untitled3/features/auth/patient_auth/views/widgets/step_four_widget.dart';
import 'package:untitled3/features/auth/patient_auth/views/widgets/step_one_widget.dart';
import 'package:untitled3/features/auth/patient_auth/views/widgets/step_two_widget.dart';
import 'package:untitled3/features/auth/patient_auth/views/widgets/step_verify_email_widget.dart';
import 'package:untitled3/features/auth/patient_auth/views/account_under_review_screen.dart';

class RegisterMainLayout extends StatelessWidget {
  RegisterMainLayout({super.key});

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final themeColor = Theme.of(context).primaryColor;
    final isEn = context.read<SettingsCubit>().state.locale.languageCode == 'en';
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDarkMode ? const Color(0xFF121212) : const Color(0xFFF7F5F0);
    final cardColor = isDarkMode ? const Color(0xFF1E1E1E) : Colors.white;
    final borderColor = isDarkMode ? Colors.white10 : const Color(0xFFE0E0E0);

    return BlocProvider(
      create: (context) => RegisterCubit(),
      child: BlocBuilder<SettingsCubit, SettingsState>(
        builder: (context, settingsState) {
          return Directionality(
            textDirection: isEn ? TextDirection.ltr : TextDirection.rtl,
            child: Scaffold(
              backgroundColor: backgroundColor,
              appBar: AppBar(
                elevation: 0,
                backgroundColor: backgroundColor,
                leading: IconButton(
                  icon: Icon(isEn ? Icons.arrow_back : Icons.arrow_forward, color: themeColor, size: 24.sp),
                  onPressed: () => context.read<RegisterCubit>().previousStep(context),
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
                  child: BlocConsumer<RegisterCubit, RegisterState>(
                    listener: (context, state) {

                      if (state is RegisterSubmitFailure) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(state.errorMessage),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }

                      if (state is RegisterSubmitSuccess) {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => const AccountUnderReviewScreen()),
                              (route) => false,
                        );
                      }
                    },
                    builder: (context, registerState) {
                      final cubit = context.read<RegisterCubit>();
                      final double progressValue = registerState.currentStep / cubit.totalSteps;
                      final isSubmitting = registerState is RegisterStepSubmitting;

                      return Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                            child: SizedBox(
                              height: 6.h,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(4.r),
                                child: LinearProgressIndicator(
                                  value: progressValue,
                                  backgroundColor: isDarkMode ? Colors.white10 : borderColor,
                                  valueColor: AlwaysStoppedAnimation<Color>(themeColor),
                                ),
                              ),
                            ),
                          ),

                          Expanded(
                            child: PageView(
                              controller: cubit.pageController,
                              physics: const NeverScrollableScrollPhysics(),
                              children: [
                                const StepOneWidgets(),
                                const StepVerifyEmailWidgets(),
                                const StepTwoWidgets(),
                                const StepFourWidgets(),
                              ],
                            ),
                          ),

                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
                            decoration: BoxDecoration(
                              color: cardColor,
                              border: Border(top: BorderSide(color: borderColor, width: 1.2)),
                            ),
                            child: registerState.currentStep == cubit.totalSteps
                                ? Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: themeColor,
                                      padding: EdgeInsets.symmetric(vertical: 14.h),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
                                    ),
                                    onPressed: isSubmitting ? null : () => cubit.submitRegistration(),
                                    child: isSubmitting
                                        ? SizedBox(
                                      width: 22.w,
                                      height: 22.w,
                                      child: const CircularProgressIndicator(
                                        strokeWidth: 2.5,
                                        color: Colors.white,
                                      ),
                                    )
                                        : Row(
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
                                : SizedBox(
                              width: double.infinity,
                              height: 50.h,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: themeColor,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
                                ),
                                onPressed: isSubmitting ? null : () => cubit.nextStep(_formKey),
                                child: isSubmitting
                                    ? SizedBox(
                                  width: 22.w,
                                  height: 22.w,
                                  child: const CircularProgressIndicator(
                                    strokeWidth: 2.5,
                                    color: Colors.white,
                                  ),
                                )
                                    : Row(
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
