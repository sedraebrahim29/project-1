import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:untitled3/core/theme/app_colors.dart';
import 'package:untitled3/core/constants/app_strings.dart';

import '../../../doctor_auth/view_models/register_cubit.dart';
import '../../../doctor_auth/views/doctor_register_screen.dart';
import '../../view_models/login_cubit.dart';
import '../../view_models/login_state.dart';
import '../register_basic_info_screen.dart';


class LoginCardWidgets extends StatelessWidget {
  final Color themeColor;
  final bool isEn;

  const LoginCardWidgets({
    super.key,
    required this.themeColor,
    required this.isEn,
  });

  @override
  Widget build(BuildContext context) {
    // جلب نمط الألوان المفعل حالياً في التطبيق (Dark / Light)
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return BlocListener<LoginCubit, LoginState>(
      listener: (context, state) {
        // 1. التقاط حالة الحساب المعلق (Pending) وإظهار الـ SnackBar التنبيهي للمريض
        if (state.status == LoginStatus.pending && state.pendingMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.pendingMessage!),
              backgroundColor: const Color(0xFFD97706),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
            ),
          );
        }

        // 2. التقاط حالة النجاح (Success) والدخول إلى الـ Home Page
        if (state.status == LoginStatus.success) {
          Navigator.pushReplacementNamed(context, '/patient_home');
        }
      },
      child: BlocBuilder<LoginCubit, LoginState>(
        builder: (context, state) {
          return Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
            color: theme.cardColor,
            child: Padding(
              padding: EdgeInsets.all(20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // أزرار التبديل الذكية بين Login و Register (Tabs)
                  Row(
                    children: [
                      _buildTabButton(
                        title: AppStrings.login(context),
                        isActive: state.activeTab == LoginTab.login,
                        activeColor: themeColor,
                        textColor: isDarkMode ? Colors.white : AppColors.textLightGrey,
                        onTap: () => context.read<LoginCubit>().switchTab(LoginTab.login),
                      ),
                      _buildTabButton(
                        title: AppStrings.createAccount(context),
                        isActive: state.activeTab == LoginTab.register,
                        activeColor: themeColor,
                        textColor: isDarkMode ? Colors.white : AppColors.textLightGrey,
                        onTap: () => context.read<LoginCubit>().switchTab(LoginTab.register),
                      ),
                    ],
                  ),
                  Divider(height: 1.h, thickness: 1, color: theme.dividerColor),
                  SizedBox(height: 20.h),

                  // عرض الحقول بناءً على الـ Tab الفعّالة
                  if (state.activeTab == LoginTab.login) ...[
                    Text(
                      AppStrings.emailAddress(context),
                      style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500, color: theme.textTheme.bodyLarge?.color),
                    ),
                    SizedBox(height: 8.h),
                    TextFormField(
                      style: TextStyle(fontSize: 14.sp, color: theme.textTheme.bodyLarge?.color),
                      decoration: InputDecoration(
                        hintText: AppStrings.emailHint(context),
                        prefixIcon: Icon(Icons.email_outlined, color: theme.iconTheme.color),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r)),
                      ),
                    ),
                    SizedBox(height: 15.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          AppStrings.password(context),
                          style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500, color: theme.textTheme.bodyLarge?.color),
                        ),
                        TextButton(
                          onPressed: () {},
                          child: Text(
                            AppStrings.forgotPassword(context),
                            style: TextStyle(fontSize: 13.sp, color: themeColor, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    TextFormField(
                      obscureText: state.obscurePassword,
                      style: TextStyle(fontSize: 14.sp, color: theme.textTheme.bodyLarge?.color),
                      decoration: InputDecoration(
                        hintText: AppStrings.passwordHint(context),
                        prefixIcon: Icon(Icons.lock_outline, color: theme.iconTheme.color),
                        suffixIcon: IconButton(
                          icon: Icon(
                            state.obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                            color: theme.iconTheme.color,
                          ),
                          onPressed: () => context.read<LoginCubit>().togglePasswordVisibility(),
                        ),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r)),
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Row(
                      children: [
                        Checkbox(
                          value: state.rememberMe,
                          activeColor: themeColor,
                          checkColor: Colors.white,
                          onChanged: (val) => context.read<LoginCubit>().toggleRememberMe(val),
                        ),
                        Text(
                          AppStrings.rememberDevice(context),
                          style: TextStyle(fontSize: 14.sp, color: isDarkMode ? Colors.grey[400] : AppColors.textLightGrey),
                        ),
                      ],
                    ),
                    SizedBox(height: 15.h),
                    SizedBox(
                      width: double.infinity,
                      height: 50.h,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: themeColor,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
                        ),
                        onPressed: (state.isLoading || state.status == LoginStatus.loading)
                            ? null
                            : () => context.read<LoginCubit>().login('test', 'test'),
                        child: (state.isLoading || state.status == LoginStatus.loading)
                            ? const CircularProgressIndicator(color: Colors.white)
                            : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(AppStrings.signIn(context), style: TextStyle(fontSize: 16.sp, color: Colors.white, fontWeight: FontWeight.bold)),
                            SizedBox(width: 8.w),
                            Icon(isEn ? Icons.arrow_forward : Icons.arrow_back, color: Colors.white),
                          ],
                        ),
                      ),
                    ),
                  ] else ...[
                    // واجهة اختيار نوع الحساب للتسجيل
                    Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 10.h),
                        child: Text(
                          AppStrings.signUpAs(context),
                          style: TextStyle(fontSize: 16.sp, color: isDarkMode ? Colors.grey[400] : AppColors.textLightGrey, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                    SizedBox(height: 15.h),

                    _buildRegisterOptionButton(
                      label: AppStrings.doctor(context),
                      activeColor: themeColor.withOpacity(0.75),
                      isEn: isEn,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            // نقوم بحقن الـ Cubit المنفصل هنا ليصبح متاحاً للشاشة الفرعية وجميع الستيبات التابعة لها
                            builder: (context) => BlocProvider(
                              create: (context) => DoctorRegisterCubit(),
                              child: DoctorRegisterMainScreen(
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 20.h),

                    // خيار المريض الفعّال
                    _buildRegisterOptionButton(
                      label: AppStrings.patient(context),
                      activeColor: themeColor,
                      isEn: isEn,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RegisterMainLayout(),
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 10.h),
                  ],

                  SizedBox(height: 5.h),
                  Row(
                    children: [
                      Expanded(child: Divider(color: theme.dividerColor)),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: Text(
                          AppStrings.orContinue(context),
                          style: TextStyle(fontSize: 10.sp, color: isDarkMode ? Colors.grey[400] : AppColors.textLightGrey, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Expanded(child: Divider(color: theme.dividerColor)),
                    ],
                  ),
                  SizedBox(height: 7.h),
                  Row(
                    children: [
                      Expanded(
                        child: _buildSocialButton(
                          context: context,
                          icon: Icons.g_mobiledata,
                          label: AppStrings.google(context),
                          onTap: () {},
                        ),
                      ),
                      SizedBox(width: 7.w),
                      Expanded(
                        child: _buildSocialButton(
                          context: context,
                          icon: Icons.apple,
                          label: AppStrings.apple(context),
                          onTap: () {},
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTabButton({
    required String title,
    required bool isActive,
    required Color activeColor,
    required Color textColor,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 12.h),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: isActive ? activeColor : Colors.transparent, width: 2.h)),
          ),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              color: isActive ? activeColor : textColor,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRegisterOptionButton({
    required String label,
    required Color activeColor,
    required bool isEn,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 50.h,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: activeColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
        ),
        onPressed: onTap,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(label, style: TextStyle(fontSize: 16.sp, color: Colors.white, fontWeight: FontWeight.bold)),
            SizedBox(width: 8.w),
            Icon(isEn ? Icons.arrow_forward : Icons.arrow_back, color: Colors.white),
          ],
        ),
      ),
    );
  }

  Widget _buildSocialButton({
    required BuildContext context,
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8.r),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.h),
        decoration: BoxDecoration(
          border: Border.all(color: isDarkMode ? Colors.grey[700]! : AppColors.borderGrey),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 24.sp, color: Theme.of(context).iconTheme.color),
            SizedBox(width: 8.w),
            Text(
              label,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).textTheme.bodyLarge?.color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
