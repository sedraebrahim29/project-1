import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/constants/app_strings.dart';
import '../../view_models/register_cubit.dart';
import '../../view_models/register_state.dart';

class StepOneWidgets extends StatefulWidget {
  final GlobalKey<FormState> formKey;

  const StepOneWidgets({super.key, required this.formKey});

  @override
  State<StepOneWidgets> createState() => _StepOneWidgetsState();
}

class _StepOneWidgetsState extends State<StepOneWidgets> {
  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;
  late final TextEditingController _emailController;
  late final TextEditingController _idCardNumberController;
  late final TextEditingController _passwordController;
  late final TextEditingController _confirmPasswordController;

  @override
  void initState() {
    super.initState();
    final model = context.read<DoctorRegisterCubit>().state.model;
    _firstNameController = TextEditingController(text: model.firstName);
    _lastNameController = TextEditingController(text: model.lastName);
    _emailController = TextEditingController(text: model.email);
    _idCardNumberController = TextEditingController(text: model.idCardNumber);
    _passwordController = TextEditingController(text: model.password);
    _confirmPasswordController = TextEditingController(text: model.confirmPassword);
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _idCardNumberController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cubit = context.read<DoctorRegisterCubit>();

    return BlocListener<DoctorRegisterCubit, DoctorRegisterState>(
      listenWhen: (previous, current) => previous.currentStep != current.currentStep,
      listener: (context, state) {},
      child: Form(
        key: widget.formKey,
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 15.h),
              Text(
                AppStrings.tellUsAboutYourself(context),
                style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.bold, color: theme.primaryColor),
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
                          controller: _firstNameController,
                          validator: (val) => (val == null || val.isEmpty) ? AppStrings.requiredField(context) : null,
                          decoration: InputDecoration(
                            hintText: AppStrings.firstNameHint(context),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r)),
                            contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
                          ),
                          onChanged: (value) => cubit.updateRegisterModel(cubit.state.model.copyWith(firstName: value)),
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
                          controller: _lastNameController,
                          validator: (val) => (val == null || val.isEmpty) ? AppStrings.requiredField(context) : null,
                          decoration: InputDecoration(
                            hintText: AppStrings.lastNameHint(context),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r)),
                            contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
                          ),
                          onChanged: (value) => cubit.updateRegisterModel(cubit.state.model.copyWith(lastName: value)),
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
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                validator: (val) => (val == null || val.isEmpty || !val.contains('@')) ? AppStrings.invalidEmail(context) : null,
                decoration: InputDecoration(
                  hintText: AppStrings.emailHint(context),
                  prefixIcon: const Icon(Icons.email_outlined),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r)),
                ),
                onChanged: (value) => cubit.updateRegisterModel(cubit.state.model.copyWith(email: value)),
              ),
              SizedBox(height: 15.h),
              Text('ID Card Number', style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w500)),
              SizedBox(height: 6.h),
              TextFormField(
                controller: _idCardNumberController,
                keyboardType: TextInputType.number,
                validator: (val) => (val == null || val.isEmpty) ? AppStrings.requiredField(context) : null,
                decoration: InputDecoration(
                  hintText: 'Enter your ID card number',
                  prefixIcon: const Icon(Icons.badge_outlined),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r)),
                ),
                onChanged: (value) => cubit.updateRegisterModel(cubit.state.model.copyWith(idCardNumber: value)),
              ),
              SizedBox(height: 15.h),
              Text(AppStrings.password(context), style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w500)),
              SizedBox(height: 6.h),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                validator: (val) => (val == null || val.length < 8) ? AppStrings.passwordLengthWarning(context) : null,
                decoration: InputDecoration(
                  hintText: AppStrings.passwordHint(context),
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: const Icon(Icons.visibility_off_outlined),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r)),
                ),
                onChanged: (value) => cubit.updateRegisterModel(cubit.state.model.copyWith(password: value)),
              ),
              SizedBox(height: 15.h),
              Text(AppStrings.confirmPassword(context), style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w500)),
              SizedBox(height: 6.h),
              TextFormField(
                controller: _confirmPasswordController,
                obscureText: true,
                validator: (val) {
                  if (val == null || val.isEmpty) return AppStrings.requiredField(context);
                  if (val != _passwordController.text) return AppStrings.passwordsDoNotMatch(context);
                  return null;
                },
                decoration: InputDecoration(
                  hintText: AppStrings.passwordHint(context),
                  prefixIcon: const Icon(Icons.lock_outline),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r)),
                ),
                onChanged: (value) => cubit.updateRegisterModel(cubit.state.model.copyWith(confirmPassword: value)),
              ),
              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }
}
