import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../view_models/register_cubit.dart';
import '../../view_models/register_state.dart';

class StepVerifyEmailWidgets extends StatefulWidget {
  const StepVerifyEmailWidgets({super.key});

  @override
  State<StepVerifyEmailWidgets> createState() => _StepVerifyEmailWidgetsState();
}

class _StepVerifyEmailWidgetsState extends State<StepVerifyEmailWidgets> {
  late final TextEditingController _codeController;
  Timer? _cooldownTimer;
  int _secondsRemaining = 0;
  bool _isResending = false;

  @override
  void initState() {
    super.initState();
    final model = context.read<DoctorRegisterCubit>().state.model;
    _codeController = TextEditingController(text: model.verificationCode);
    _startCooldown();
  }

  @override
  void dispose() {
    _codeController.dispose();
    _cooldownTimer?.cancel();
    super.dispose();
  }

  void _startCooldown() {
    _cooldownTimer?.cancel();
    setState(() => _secondsRemaining = 60);
    _cooldownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      if (_secondsRemaining <= 1) {
        timer.cancel();
        setState(() => _secondsRemaining = 0);
      } else {
        setState(() => _secondsRemaining--);
      }
    });
  }

  Future<void> _handleResend() async {
    if (_secondsRemaining > 0 || _isResending) return;
    setState(() => _isResending = true);

    final success = await context.read<DoctorRegisterCubit>().resendVerificationCode();

    if (!mounted) return;
    setState(() => _isResending = false);

    if (success) {
      _startCooldown();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تم إرسال كود جديد إلى بريدك الإلكتروني')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = Theme.of(context).primaryColor;
    final textColor = Theme.of(context).textTheme.bodyLarge?.color;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final cubit = context.read<DoctorRegisterCubit>();

    return BlocBuilder<DoctorRegisterCubit, DoctorRegisterState>(
      builder: (context, state) {
        return SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 25.h),
              Center(
                child: Container(
                  padding: EdgeInsets.all(18.w),
                  decoration: BoxDecoration(color: themeColor.withOpacity(0.08), shape: BoxShape.circle),
                  child: Icon(Icons.mark_email_read_outlined, color: themeColor, size: 40.sp),
                ),
              ),
              SizedBox(height: 20.h),
              Text(
                'Verify Your Email',
                style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.bold, color: themeColor),
              ),
              SizedBox(height: 8.h),
              Text.rich(
                TextSpan(
                  style: TextStyle(fontSize: 13.sp, color: AppColors.textLightGrey, height: 1.5),
                  children: [
                    const TextSpan(text: 'We sent a verification code to '),
                    TextSpan(text: state.model.email ?? '', style: TextStyle(fontWeight: FontWeight.bold, color: textColor)),
                    const TextSpan(text: '. Enter it below to confirm your email.'),
                  ],
                ),
              ),
              SizedBox(height: 30.h),
              TextFormField(
                controller: _codeController,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                maxLength: 6,
                autofocus: true,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.bold, letterSpacing: 10),
                decoration: InputDecoration(
                  counterText: '',
                  hintText: '------',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r)),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                    borderSide: BorderSide(color: isDarkMode ? AppColors.darkPrimaryGreen : AppColors.primaryGreen, width: 2.0),
                  ),
                ),
                onChanged: (value) => cubit.updateRegisterModel(state.model.copyWith(verificationCode: value)),
              ),
              SizedBox(height: 20.h),
              Center(
                child: TextButton(
                  onPressed: (_secondsRemaining > 0 || _isResending) ? null : _handleResend,
                  child: _isResending
                      ? SizedBox(width: 16.w, height: 16.w, child: const CircularProgressIndicator(strokeWidth: 2))
                      : Text(
                    _secondsRemaining > 0 ? 'Resend code in ${_secondsRemaining}s' : "Didn't get the code? Resend",
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.bold,
                      color: _secondsRemaining > 0 ? AppColors.textLightGrey : themeColor,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10.h),
            ],
          ),
        );
      },
    );
  }
}
