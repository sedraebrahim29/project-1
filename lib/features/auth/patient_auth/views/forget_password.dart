import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/constants/app_strings.dart';
import '../view_models/forget_password_cubit.dart';
import '../view_models/forget_password_state.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ForgotPasswordCubit(),
      child: const _ForgotPasswordView(),
    );
  }
}

class _ForgotPasswordView extends StatefulWidget {
  const _ForgotPasswordView();

  @override
  State<_ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<_ForgotPasswordView> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _codeController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  InputDecoration _inputDecoration({
    required String hintText,
    Widget? prefixIcon,
    Widget? suffixIcon,
    TextAlign textAlign = TextAlign.start,
    required bool isDarkMode,
  }) {
    return InputDecoration(
      hintText: hintText,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      alignLabelWithHint: true,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.r),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.r),
        borderSide: BorderSide(color: AppColors.textLightGrey.withOpacity(0.4)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.r),
        borderSide: BorderSide(
          color: isDarkMode ? AppColors.darkPrimaryGreen : AppColors.primaryGreen,
          width: 2.0,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final themeColor = theme.primaryColor;
    final isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(),
      ),
      body: BlocConsumer<ForgotPasswordCubit, ForgotPasswordState>(
        listener: (context, state) {
          if (state.status == ForgotPasswordStatus.failure && state.errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errorMessage!), backgroundColor: Colors.red),
            );
          }
          if (state.status == ForgotPasswordStatus.success) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('تم تغيير كلمة المرور بنجاح، يمكنك تسجيل الدخول الآن'), backgroundColor: Colors.green),
            );
            Navigator.of(context).pop();
          }
        },
        builder: (context, state) {
          final cubit = context.read<ForgotPasswordCubit>();
          final isLoading = state.status == ForgotPasswordStatus.loading;

          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 15.h),
                Text(
                  state.step == ForgotPasswordStep.email ? 'Forgot Password' : 'Reset Password',
                  style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.bold, color: themeColor),
                ),
                SizedBox(height: 8.h),
                Text(
                  state.step == ForgotPasswordStep.email
                      ? 'Enter your email and we will send you a reset code.'
                      : 'Enter the code sent to ${state.email} and choose a new password.',
                  style: TextStyle(fontSize: 13.sp, color: AppColors.textLightGrey, height: 1.5),
                ),
                SizedBox(height: 30.h),

                if (state.step == ForgotPasswordStep.email) ...[
                  Text(AppStrings.emailAddress(context), style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w500)),
                  SizedBox(height: 6.h),
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: _inputDecoration(
                      hintText: AppStrings.emailHint(context),
                      prefixIcon: const Icon(Icons.email_outlined),
                      isDarkMode: isDarkMode,
                    ),
                  ),
                  SizedBox(height: 25.h),
                  SizedBox(
                    width: double.infinity,
                    height: 50.h,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: themeColor,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
                      ),
                      onPressed: isLoading ? null : () => cubit.sendCode(_emailController.text),
                      child: isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text('Send Code', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ] else ...[
                  Text('Reset Code', style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w500)),
                  SizedBox(height: 6.h),
                  TextFormField(
                    controller: _codeController,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold, letterSpacing: 8),
                    decoration: _inputDecoration(
                      hintText: '------',
                      isDarkMode: isDarkMode,
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Text(AppStrings.password(context), style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w500)),
                  SizedBox(height: 6.h),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: state.obscurePassword,
                    decoration: _inputDecoration(
                      hintText: AppStrings.passwordHint(context),
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        icon: Icon(state.obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined),
                        onPressed: () => cubit.toggleObscurePassword(),
                      ),
                      isDarkMode: isDarkMode,
                    ),
                  ),
                  SizedBox(height: 15.h),
                  Text(AppStrings.confirmPassword(context), style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w500)),
                  SizedBox(height: 6.h),
                  TextFormField(
                    controller: _confirmPasswordController,
                    obscureText: state.obscureConfirmPassword,
                    decoration: _inputDecoration(
                      hintText: AppStrings.passwordHint(context),
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        icon: Icon(state.obscureConfirmPassword ? Icons.visibility_off_outlined : Icons.visibility_outlined),
                        onPressed: () => cubit.toggleObscureConfirmPassword(),
                      ),
                      isDarkMode: isDarkMode,
                    ),
                  ),
                  SizedBox(height: 25.h),
                  SizedBox(
                    width: double.infinity,
                    height: 50.h,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: themeColor,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
                      ),
                      onPressed: isLoading
                          ? null
                          : () => cubit.resetPassword(
                        code: _codeController.text,
                        password: _passwordController.text,
                        confirmPassword: _confirmPasswordController.text,
                      ),
                      child: isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text('Reset Password', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Center(
                    child: TextButton(
                      onPressed: isLoading ? null : () => cubit.backToEmailStep(),
                      child: Text('Wrong email? Go back', style: TextStyle(fontSize: 13.sp, color: AppColors.textLightGrey)),
                    ),
                  ),
                ],
                SizedBox(height: 20.h),
              ],
            ),
          );
        },
      ),
    );
  }
}
