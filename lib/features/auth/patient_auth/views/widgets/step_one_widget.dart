import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/constants/app_strings.dart';
import '../../view_models/register_cubit.dart';
import '../../view_models/register_state.dart';
class StepOneWidgets extends StatelessWidget {
  const StepOneWidgets({super.key});

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
              SizedBox(height: 15.h),
              Text(
                AppStrings.tellUsAboutYourself(context),
                style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.bold, color: themeColor),
              ),
              SizedBox(height: 5.h),
              Text(
                AppStrings.provideBasicInfo(context),
                style: TextStyle(fontSize: 13.sp, color: AppColors.textLightGrey),
              ),
              SizedBox(height: 25.h),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(AppStrings.firstName(context), style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w500)),
                        SizedBox(height: 6.h),
                        TextFormField(
                          initialValue: state.model.firstName,
                          validator: (val) => (val == null || val.isEmpty) ? AppStrings.requiredField(context) : null,
                          decoration: InputDecoration(
                            hintText: AppStrings.firstNameHint(context),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r)),
                            contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
                          ),
                          onChanged: (value) {
                            cubit.updateRegisterModel(state.model.copyWith(firstName: value));
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(AppStrings.lastName(context), style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w500)),
                        SizedBox(height: 6.h),
                        TextFormField(
                          initialValue: state.model.lastName,
                          validator: (val) => (val == null || val.isEmpty) ? AppStrings.requiredField(context) : null,
                          decoration: InputDecoration(
                            hintText: AppStrings.lastNameHint(context),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r)),
                            contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
                          ),
                          onChanged: (value) {
                            cubit.updateRegisterModel(state.model.copyWith(lastName: value));
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15.h),
              Text(AppStrings.emailAddress(context), style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w500)),
              SizedBox(height: 6.h),
              TextFormField(
                initialValue: state.model.email,
                keyboardType: TextInputType.emailAddress,
                validator: (val) => (val == null || val.isEmpty || !val.contains('@')) ? AppStrings.invalidEmail(context) : null,
                decoration: InputDecoration(
                  hintText: AppStrings.emailHint(context),
                  prefixIcon: const Icon(Icons.email_outlined),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r)),
                ),
                onChanged: (value) {
                  cubit.updateRegisterModel(state.model.copyWith(email: value));
                },
              ),
              SizedBox(height: 15.h),
              Text(AppStrings.phoneNumber(context), style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w500)),
              SizedBox(height: 6.h),
              TextFormField(
                initialValue: state.model.phoneNumber,
                keyboardType: TextInputType.phone,
                validator: (val) => (val == null || val.isEmpty) ? AppStrings.requiredField(context) : null,
                decoration: InputDecoration(
                  hintText: AppStrings.phoneHint(context),
                  prefixIcon: const Icon(Icons.phone_outlined),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r)),
                ),
                onChanged: (value) {
                  cubit.updateRegisterModel(state.model.copyWith(phoneNumber: value));
                },
              ),
              SizedBox(height: 15.h),
              Text(AppStrings.password(context), style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w500)),
              SizedBox(height: 6.h),
              TextFormField(
                initialValue: state.model.password,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: AppStrings.passwordHint(context),
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: const Icon(Icons.visibility_off_outlined),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r)),
                ),
                onChanged: (value) {
                  cubit.updateRegisterModel(state.model.copyWith(password: value));
                },
              ),
              SizedBox(height: 4.h),
              Text(
                AppStrings.passwordLengthWarning(context),
                style: TextStyle(fontSize: 11.sp, color: AppColors.textLightGrey),
              ),
              SizedBox(height: 15.h),
              Text(AppStrings.confirmPassword(context), style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w500)),
              SizedBox(height: 6.h),
              TextFormField(
                initialValue: state.model.confirmPassword,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: AppStrings.passwordHint(context),
                  prefixIcon: const Icon(Icons.lock_outline),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r)),
                ),
                onChanged: (value) {
                  cubit.updateRegisterModel(state.model.copyWith(confirmPassword: value));
                },
              ),
              SizedBox(height: 20.h),
            ],
          ),
        );
      },
    );
  }
}
