import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/constants/app_strings.dart';
import '../../view_models/register_cubit.dart';
import '../../view_models/register_state.dart';
class StepFourWidgets extends StatelessWidget {
  const StepFourWidgets({super.key});

  @override
  Widget build(BuildContext context) {
    final themeColor = Theme.of(context).primaryColor;
    final cubit = context.read<RegisterCubit>();

    return BlocBuilder<RegisterCubit, RegisterState>(
      builder: (context, state) {
        final fullName = "${state.model.firstName ?? ''} ${state.model.lastName ?? ''}".trim();

        return SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 15.h),
              Text(
                AppStrings.reviewSubmit(context),
                style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.bold, color: themeColor),
              ),
              SizedBox(height: 5.h),
              Text(
                AppStrings.reviewInstructions(context),
                style: TextStyle(fontSize: 13.sp, color: AppColors.textLightGrey),
              ),
              SizedBox(height: 25.h),

              _buildReviewCard(
                context,
                title: AppStrings.basicInfo(context),
                onEdit: () => cubit.jumpToStep(1),
                items: {
                  AppStrings.fullName(context): fullName.isNotEmpty ? fullName : '—',
                  AppStrings.emailAddress(context): state.model.email ?? '—',
                  'ID Card Number': state.model.idCardNumber ?? '—',
                  AppStrings.password(context): state.model.password != null ? '••••••••••••' : '—',
                },
              ),

              _buildReviewCard(
                context,
                title: AppStrings.personalDetails(context),
                onEdit: () => cubit.jumpToStep(3),
                items: {
                  AppStrings.dateOfBirth(context): state.model.dateOfBirth ?? '—',
                  AppStrings.gender(context): state.model.gender ?? 'female',
                  'Home Address': state.model.homeAddress ?? '—',
                  'Phone': state.model.phone ?? '—',
                  'Blood Type': state.model.bloodType ?? '—',
                },
              ),

              Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.info_outline, color: AppColors.textLightGrey, size: 20.sp),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Text(
                        AppStrings.termsReviewNote(context),
                        style: TextStyle(fontSize: 12.sp, color: AppColors.textLightGrey, height: 1.5),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30.h),
            ],
          ),
        );
      },
    );
  }

  Widget _buildReviewCard(
      BuildContext context, {
        required String title,
        required VoidCallback onEdit,
        required Map<String, String> items,
      }) {
    return Container(
      margin: EdgeInsets.only(bottom:20.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.assignment_outlined, size: 20.sp, color: AppColors.textLightGrey),
                  SizedBox(width: 8.w),
                  Text(title, style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold)),
                ],
              ),
              IconButton(
                icon: Icon(Icons.edit_outlined, size: 20.sp, color: AppColors.textLightGrey),
                onPressed: onEdit,
              ),
            ],
          ),
          Divider(height: 15.h),
          ...items.entries.map((entry) => Padding(
            padding: EdgeInsets.only(bottom: 12.h),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: Text(entry.key, style: TextStyle(fontSize: 13.sp, color: AppColors.textLightGrey)),
                ),
                Expanded(
                  flex: 3,
                  child: Text(entry.value, style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500)),
                ),
              ],
            ),
          )).toList(),
        ],
      ),
    );
  }
}
