import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/constants/app_strings.dart';
import '../../view_models/register_cubit.dart';
import '../../view_models/register_state.dart';
import '../../models/register_model.dart';

class StepThreeWidgets extends StatelessWidget {
  StepThreeWidgets({super.key});

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickSingleImage(
      BuildContext context,
      DoctorRegisterCubit cubit,
      DoctorRegisterModel model, {
        required DoctorRegisterModel Function(XFile image, Uint8List bytes) apply,
      }) async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 85);
    if (image != null) {
      final Uint8List bytes = await image.readAsBytes();
      cubit.updateRegisterModel(apply(image, bytes));
    }
  }

  Future<void> _pickCertificates(BuildContext context, DoctorRegisterCubit cubit, DoctorRegisterModel model) async {
    final List<XFile> picked = await _picker.pickMultiImage(imageQuality: 85);
    if (picked.isEmpty) return;

    final newImages = List<XFile>.from(model.certificatesImages)..addAll(picked);
    final newBytesList = List<Uint8List>.from(model.certificatesBytes);
    for (final file in picked) {
      newBytesList.add(await file.readAsBytes());
    }

    cubit.updateRegisterModel(model.copyWith(certificatesImages: newImages, certificatesBytes: newBytesList));
  }

  void _removeCertificate(DoctorRegisterCubit cubit, DoctorRegisterModel model, int index) {
    final newImages = List<XFile>.from(model.certificatesImages)..removeAt(index);
    final newBytesList = List<Uint8List>.from(model.certificatesBytes)..removeAt(index);
    cubit.updateRegisterModel(model.copyWith(certificatesImages: newImages, certificatesBytes: newBytesList));
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = Theme.of(context).primaryColor;
    final cubit = context.read<DoctorRegisterCubit>();

    return BlocBuilder<DoctorRegisterCubit, DoctorRegisterState>(
      builder: (context, state) {
        final model = state.model;
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


              Text('National ID Card', style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w500)),
              SizedBox(height: 8.h),
              _buildUploadBox(
                context,
                themeColor,
                model.idCardBytes,
                    () => _pickSingleImage(
                  context,
                  cubit,
                  model,
                  apply: (image, bytes) => model.copyWith(idCardImage: image, idCardBytes: bytes),
                ),
              ),

              SizedBox(height: 25.h),
              const Divider(),
              SizedBox(height: 25.h),

              Text('Personal Photo', style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w500)),
              SizedBox(height: 8.h),
              _buildUploadBox(
                context,
                themeColor,
                model.photoBytes,
                    () => _pickSingleImage(
                  context,
                  cubit,
                  model,
                  apply: (image, bytes) => model.copyWith(photoImage: image, photoBytes: bytes),
                ),
              ),

              SizedBox(height: 25.h),
              const Divider(),
              SizedBox(height: 25.h),

              Text(AppStrings.practiceLicense(context), style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w500)),
              SizedBox(height: 8.h),
              _buildUploadBox(
                context,
                themeColor,
                model.licenseBytes,
                    () => _pickSingleImage(
                  context,
                  cubit,
                  model,
                  apply: (image, bytes) => model.copyWith(licenseImage: image, licenseBytes: bytes),
                ),
              ),

              SizedBox(height: 25.h),
              const Divider(),
              SizedBox(height: 25.h),
              Text('Certificates', style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w500)),
              SizedBox(height: 8.h),
              Wrap(
                spacing: 10.w,
                runSpacing: 10.h,
                children: [
                  ...List.generate(model.certificatesBytes.length, (index) {
                    return Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10.r),
                          child: Image.memory(model.certificatesBytes[index], width: 80.w, height: 80.h, fit: BoxFit.cover),
                        ),
                        Positioned(
                          top: -4,
                          right: -4,
                          child: GestureDetector(
                            onTap: () => _removeCertificate(cubit, model, index),
                            child: const CircleAvatar(radius: 10, backgroundColor: Colors.red, child: Icon(Icons.close, size: 14, color: Colors.white)),
                          ),
                        ),
                      ],
                    );
                  }),
                  GestureDetector(
                    onTap: () => _pickCertificates(context, cubit, model),
                    child: Container(
                      width: 80.w,
                      height: 80.h,
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(10.r),
                        border: Border.all(color: Colors.grey.withOpacity(0.3)),
                      ),
                      child: Icon(Icons.add, color: themeColor),
                    ),
                  ),
                ],
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
