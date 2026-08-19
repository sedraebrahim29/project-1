import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../view_models/register_cubit.dart';
import '../../view_models/register_state.dart';

class StepThreeWidgets extends StatelessWidget {
  const StepThreeWidgets({super.key});

  @override
  Widget build(BuildContext context) {
    final themeColor = Theme.of(context).primaryColor;
    final cubit = context.read<RegisterCubit>();

    return BlocBuilder<RegisterCubit, RegisterState>(
      builder: (context, state) {
        return SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 25.h),

              Text(
                'Identity Verification',
                style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.bold, color: themeColor),
              ),
              SizedBox(height: 10.h),
              Text(
                'Please enter your national ID number to verify your account.',
                style: TextStyle(fontSize: 13.sp, color: AppColors.textLightGrey),
              ),
              SizedBox(height: 30.h),

              TextFormField(
                initialValue: state.model.idCardNumber,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'National ID Number',
                  prefixIcon: const Icon(Icons.badge_outlined),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r)),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                    borderSide: BorderSide(color: themeColor, width: 2.0),
                  ),
                ),
                onChanged: (value) {
                  cubit.updateRegisterModel(state.model.copyWith(idCardNumber: value));
                },
              ),

              SizedBox(height: 30.h),

              Container(
                padding: EdgeInsets.all(15.w),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(12.r),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10)],
                ),
                child: Row(
                  children: [
                    Icon(Icons.lock_outline, color: themeColor, size: 24.sp),
                    SizedBox(width: 15.w),
                    Expanded(
                      child: Text(
                        'Your national ID is encrypted and kept secure for verification purposes only.',
                        style: TextStyle(fontSize: 13.sp, color: AppColors.textLightGrey, height: 1.4),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
