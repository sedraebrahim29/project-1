import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/constants/app_strings.dart';
import '../../view_models/register_cubit.dart';

class DoctorStepFiveWidget extends StatelessWidget {
  const DoctorStepFiveWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final themeColor = Theme.of(context).primaryColor;
    final cubit = context.read<DoctorRegisterCubit>();

    return BlocBuilder<DoctorRegisterCubit, DoctorRegisterState>(
      builder: (context, state) {
        final m = state.model;
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
                'Review your professional profile before submitting',
                style: TextStyle(fontSize: 13.sp, color: AppColors.textLightGrey),
              ),
              SizedBox(height: 25.h),

              // Step 1: Account Info
              _buildReviewSection(
                context,
                title: 'Account Information',
                onEdit: () => cubit.jumpToStep(1),
                items: {
                  'Full Name': '${m.firstName} ${m.lastName}',
                  'Email': m.email ?? '—',
                  'Prof. Email': m.professionalEmail ?? 'Not provided',
                  'Phone': m.phoneNumber ?? '—',
                },
              ),

              // Step 2: Personal & Specialties
              _buildReviewSection(
                context,
                title: 'Specialty & Details',
                onEdit: () => cubit.jumpToStep(2),
                items: {
                  'Birth Date': m.dateOfBirth ?? '—',
                  'Gender': m.gender ?? '—',
                  'Address': m.homeAddress ?? '—',
                  'Specialty': '${m.mainSpecialty} / ${m.subSpecialty}',
                },
              ),

              // Step 3: Documents
              _buildReviewSection(
                context,
                title: 'Documents',
                onEdit: () => cubit.jumpToStep(3),
                items: {
                  'Degree': m.educationDegree ?? '—',
                  'License #': m.licenseNumber ?? '—',
                  'Certificates': (m.universityDegreeImage != null && m.licenseImage != null) ? 'Uploaded' : 'Incomplete',
                },
              ),

              // Step 4: Professional Info
              _buildReviewSection(
                context,
                title: 'Work & Experience',
                onEdit: () => cubit.jumpToStep(4),
                items: {
                  'Workplaces': '${m.workplaces.length} added',
                  'Experience': '${m.experienceYears ?? '0'} years',
                  'Bio': m.bio != null && m.bio!.length > 20 ? '${m.bio!.substring(0, 20)}...' : (m.bio ?? '—'),
                  'Online Consult': (m.offersOnlineConsultation ?? false) ? 'Enabled' : 'Disabled',
                },
              ),

              SizedBox(height: 30.h),
            ],
          ),
        );
      },
    );
  }

  Widget _buildReviewSection(BuildContext context, {required String title, required VoidCallback onEdit, required Map<String, String> items}) {
    return Container(
      margin: EdgeInsets.only(bottom: 20.h),
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
              Text(title, style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold)),
              IconButton(icon: Icon(Icons.edit_outlined, size: 20.sp, color: AppColors.textLightGrey), onPressed: onEdit),
            ],
          ),
          Divider(height: 15.h),
          ...items.entries.map((e) => Padding(
            padding: EdgeInsets.only(bottom: 10.h),
            child: Row(
              children: [
                Expanded(flex: 2, child: Text(e.key, style: TextStyle(fontSize: 13.sp, color: AppColors.textLightGrey))),
                Expanded(flex: 3, child: Text(e.value, style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500))),
              ],
            ),
          )),
        ],
      ),
    );
  }
}
