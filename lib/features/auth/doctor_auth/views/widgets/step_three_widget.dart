import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/constants/app_strings.dart';
import '../../view_models/register_cubit.dart';

class StepThreeWidgets extends StatelessWidget {
  StepThreeWidgets({super.key});

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(BuildContext context, DoctorRegisterCubit cubit, DoctorRegisterState state, bool isDegree) async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 85);
    if (image != null) {
      final Uint8List bytes = await image.readAsBytes();
      if (isDegree) {
        cubit.updateRegisterModel(state.model.copyWith(universityDegreeImage: image, universityDegreeBytes: bytes));
      } else {
        cubit.updateRegisterModel(state.model.copyWith(licenseImage: image, licenseBytes: bytes));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = Theme.of(context).primaryColor;
    final cubit = context.read<DoctorRegisterCubit>();

    return BlocBuilder<DoctorRegisterCubit, DoctorRegisterState>(
      builder: (context, state) {
        return SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 15.h),
              Text(
                AppStrings.professionalDocuments(context),
                style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.bold, color: themeColor),
              ),
              SizedBox(height: 5.h),
              Text(
                AppStrings.uploadCertificatesHint(context),
                style: TextStyle(fontSize: 13.sp, color: AppColors.textLightGrey),
              ),
              SizedBox(height: 25.h),

              // 1. University Degree
              Text(AppStrings.universityDegree(context), style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w500)),
              SizedBox(height: 8.h),
              _buildUploadBox(
                context,
                themeColor,
                state.model.universityDegreeBytes,
                () => _pickImage(context, cubit, state, true),
              ),
              SizedBox(height: 15.h),
              Text(AppStrings.educationDegree(context), style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w500)),
              SizedBox(height: 6.h),
              TextFormField(
                initialValue: state.model.educationDegree,
                validator: (val) => (val == null || val.isEmpty) ? AppStrings.requiredField(context) : null,
                decoration: InputDecoration(
                  hintText: AppStrings.educationDegree(context),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r)),
                ),
                onChanged: (value) {
                  cubit.updateRegisterModel(state.model.copyWith(educationDegree: value));
                },
              ),

              SizedBox(height: 25.h),
              const Divider(),
              SizedBox(height: 25.h),

              // 2. Professional License
              Text(AppStrings.practiceLicense(context), style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w500)),
              SizedBox(height: 8.h),
              _buildUploadBox(
                context,
                themeColor,
                state.model.licenseBytes,
                () => _pickImage(context, cubit, state, false),
              ),
              SizedBox(height: 15.h),
              Text(AppStrings.licenseNumber(context), style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w500)),
              SizedBox(height: 6.h),
              TextFormField(
                initialValue: state.model.licenseNumber,
                validator: (val) => (val == null || val.isEmpty) ? AppStrings.requiredField(context) : null,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: AppStrings.licenseNumber(context),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r)),
                ),
                onChanged: (value) {
                  cubit.updateRegisterModel(state.model.copyWith(licenseNumber: value));
                },
              ),
              SizedBox(height: 20.h),
            ],
          ),
        );
      },
    );
  }

  Widget _buildUploadBox(BuildContext context, Color themeColor, Uint8List? bytes, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 120.h,
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.05),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: Colors.grey.withOpacity(0.3)),
        ),
        child: bytes == null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.cloud_upload_outlined, color: themeColor, size: 30.sp),
                  SizedBox(height: 8.h),
                  Text(AppStrings.uploadImage(context), style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600, color: themeColor)),
                ],
              )
            : Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12.r),
                    child: Image.memory(bytes, width: double.infinity, height: 120.h, fit: BoxFit.cover),
                  ),
                  Positioned(
                    top: 5,
                    right: 5,
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 12.r,
                      child: Icon(Icons.edit, size: 14.sp, color: themeColor),
                    ),
                  ),
                  const Center(child: Icon(Icons.check_circle, color: Colors.green, size: 40)),
                ],
              ),
      ),
    );
  }
}
