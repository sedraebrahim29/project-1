import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/constants/app_strings.dart';
import '../../data/departments_repository.dart';
import '../../models/department_model.dart';
import '../../view_models/register_cubit.dart';
import '../../view_models/register_state.dart';

class DoctorStepFiveWidget extends StatefulWidget {
  const DoctorStepFiveWidget({super.key});

  @override
  State<DoctorStepFiveWidget> createState() => _DoctorStepFiveWidgetState();
}

class _DoctorStepFiveWidgetState extends State<DoctorStepFiveWidget> {
  late final Future<List<DepartmentModel>> _departmentsFuture;

  @override
  void initState() {
    super.initState();
    _departmentsFuture = DepartmentsRepository().getDepartments();
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = Theme.of(context).primaryColor;
    final cubit = context.read<DoctorRegisterCubit>();

    return BlocBuilder<DoctorRegisterCubit, DoctorRegisterState>(
      builder: (context, state) {
        final m = state.model;
        final fullName = "${m.firstName ?? ''} ${m.lastName ?? ''}".trim();
        final mode = m.registrationMode ?? 'join_clinic';

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
                  'Full Name': fullName.isNotEmpty ? fullName : '—',
                  'Email': m.email ?? '—',
                  'ID Card Number': m.idCardNumber ?? '—',
                  'Password': m.password != null ? '••••••••••••' : '—',
                },
              ),

              // Step 3: Personal Info
              _buildReviewSection(
                context,
                title: 'Personal Information',
                onEdit: () => cubit.jumpToStep(3),
                items: {
                  'Birth Date': m.dateOfBirth ?? '—',
                  'Gender': m.gender ?? '—',
                  'Address': m.homeAddress ?? '—',
                  'Phone': m.phone ?? '—',
                },
              ),

<<<<<<< HEAD
              // Step 4: Specialty + Documents
              FutureBuilder<List<DepartmentModel>>(
                future: _departmentsFuture,
                builder: (context, snapshot) {
                  final allDepartments = snapshot.data ?? const [];
                  final selectedNames = m.departmentIds
                      .map((id) => allDepartments.firstWhere(
                            (d) => d.id.toString() == id,
                            orElse: () => DepartmentModel(id: 0, name: id),
                          ).name)
                      .toList();

                  return _buildReviewSection(
                    context,
                    title: 'Specialty & Documents',
                    onEdit: () => cubit.jumpToStep(4),
                    items: {
                      'Specialty': selectedNames.isNotEmpty ? selectedNames.join('، ') : '—',
                      'Practice Start Date': m.practiceStartDate ?? '—',
                      'National ID': m.idCardBytes != null ? 'Uploaded' : 'Missing',
                      'Personal Photo': m.photoBytes != null ? 'Uploaded' : 'Missing',
                      'Practice License': m.licenseBytes != null ? 'Uploaded' : 'Missing',
                      'Certificates': m.certificatesBytes.isNotEmpty ? '${m.certificatesBytes.length} uploaded' : 'None',
                    },
                  );
=======
              // Step 4: Documents
              _buildReviewSection(
                context,
                title: 'Documents',
                onEdit: () => cubit.jumpToStep(4),
                items: {
                  'National ID': m.idCardBytes != null ? 'Uploaded' : 'Missing',
                  'Personal Photo': m.photoBytes != null ? 'Uploaded' : 'Missing',
                  'Practice License': m.licenseBytes != null ? 'Uploaded' : 'Missing',
                  'Certificates': m.certificatesBytes.isNotEmpty ? '${m.certificatesBytes.length} uploaded' : 'None',
>>>>>>> 6f2cf5c88c0f04be6d75e9a7241f4aeaf98d82f7
                },
              ),

              // Step 5: Clinic Setup
              _buildReviewSection(
                context,
                title: 'Clinic Setup',
                onEdit: () => cubit.jumpToStep(5),
                items: mode == 'join_clinic'
                    ? {
                  'Mode': 'Join Existing Clinic',
                  'Clinic ID': m.clinicId ?? '—',
                }
                    : {
                  'Mode': 'Create New Clinic',
                  'Clinic Name': m.clinicName ?? '—',
                  'Clinic Address': m.clinicAddress ?? '—',
                  'Clinic Phone': m.clinicPhone ?? '—',
                  'Clinic License': m.clinicLicenseBytes != null ? 'Uploaded' : 'Missing',
                },
              ),

              if (state is DoctorRegisterSubmitFailure) ...[
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(14.w),
                  margin: EdgeInsets.only(bottom: 15.h),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(10.r),
                    border: Border.all(color: Colors.red.withOpacity(0.3)),
                  ),
                  child: Text(state.errorMessage, style: TextStyle(color: Colors.red, fontSize: 13.sp)),
                ),
              ],

              SizedBox(height: 30.h),
            ],
          ),
        );
      },
    );
  }

  Widget _buildReviewSection(BuildContext context,
      {required String title, required VoidCallback onEdit, required Map<String, String> items}) {
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
