import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/widgets/location_pick_field.dart';
import '../../view_models/register_cubit.dart';
import '../../view_models/register_state.dart';
import '../../models/register_model.dart';

class StepFourWidgets extends StatelessWidget {
  StepFourWidgets({super.key});

  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    final themeColor = Theme.of(context).primaryColor;
    final cubit = context.read<DoctorRegisterCubit>();

    return BlocBuilder<DoctorRegisterCubit, DoctorRegisterState>(
      builder: (context, state) {
        final model = state.model;
        final mode = model.registrationMode ?? 'join_clinic';

        return SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 15.h),
              Text('Clinic Setup', style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.bold, color: themeColor)),
              SizedBox(height: 5.h),
              Text(
                'Join an existing clinic or create a new one',
                style: TextStyle(fontSize: 13.sp, color: AppColors.textLightGrey),
              ),
              SizedBox(height: 25.h),

              // اختيار الوضع
              Container(
                decoration: BoxDecoration(color: Colors.grey.withOpacity(0.1), borderRadius: BorderRadius.circular(8.r)),
                padding: EdgeInsets.all(4.w),
                child: Row(
                  children: [
                    _buildModeButton(context, cubit, model, mode, value: 'join_clinic', label: 'Join Clinic'),
                    _buildModeButton(context, cubit, model, mode, value: 'create_clinic', label: 'Create Clinic'),
                  ],
                ),
              ),
              SizedBox(height: 25.h),

              if (mode == 'join_clinic') ...[
                Text('Clinic ID', style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w500)),
                SizedBox(height: 6.h),
                TextFormField(
                  initialValue: model.clinicId,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: 'Enter the clinic ID',
                    prefixIcon: const Icon(Icons.local_hospital_outlined),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r)),
                  ),
                  onChanged: (value) => cubit.updateRegisterModel(model.copyWith(clinicId: value)),
                ),
                SizedBox(height: 8.h),
                Text(
                  'Temporary: ask your clinic admin for its ID. This will be replaced with a search field once available.',
                  style: TextStyle(fontSize: 11.sp, color: AppColors.textLightGrey),
                ),
                SizedBox(height: 15.h),
                Text('Your Consultation Fee at this Clinic', style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w500)),
                SizedBox(height: 6.h),
                TextFormField(
                  initialValue: model.consultationFee,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                    hintText: '20',
                    prefixIcon: const Icon(Icons.payments_outlined),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r)),
                  ),
                  onChanged: (value) => cubit.updateRegisterModel(model.copyWith(consultationFee: value)),
                ),
              ] else ...[
                // create_clinic
                Text('Clinic Name', style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w500)),
                SizedBox(height: 6.h),
                TextFormField(
                  initialValue: model.clinicName,
                  decoration: InputDecoration(hintText: 'Clinic name', border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r))),
                  onChanged: (value) => cubit.updateRegisterModel(model.copyWith(clinicName: value)),
                ),
                SizedBox(height: 15.h),
                Text('Clinic Address', style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w500)),
                SizedBox(height: 6.h),
                TextFormField(
                  initialValue: model.clinicAddress,
                  decoration: InputDecoration(hintText: 'Clinic address', border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r))),
                  onChanged: (value) => cubit.updateRegisterModel(model.copyWith(clinicAddress: value)),
                ),
                LocationPickField(
                  latitude: model.clinicLatitude,
                  longitude: model.clinicLongitude,
                  label: 'تحديد موقع العيادة من الخريطة',
                  onPicked: (lat, lng) => cubit.updateRegisterModel(
                    model.copyWith(clinicLatitude: lat, clinicLongitude: lng),
                  ),
                ),
                SizedBox(height: 15.h),
                Text('Clinic Phone', style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w500)),
                SizedBox(height: 6.h),
                TextFormField(
                  initialValue: model.clinicPhone,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(hintText: 'Clinic phone', border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r))),
                  onChanged: (value) => cubit.updateRegisterModel(model.copyWith(clinicPhone: value)),
                ),
                SizedBox(height: 15.h),
                Text('Consultation Fee at this Clinic', style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w500)),
                SizedBox(height: 6.h),
                TextFormField(
                  initialValue: model.consultationFee,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                    hintText: '20',
                    prefixIcon: const Icon(Icons.payments_outlined),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r)),
                  ),
                  onChanged: (value) => cubit.updateRegisterModel(model.copyWith(consultationFee: value)),
                ),
                SizedBox(height: 20.h),
                Text('Clinic License', style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w500)),
                SizedBox(height: 8.h),
                _buildUploadBox(context, themeColor, model.clinicLicenseBytes, () async {
                  final XFile? image = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 85);
                  if (image != null) {
                    final Uint8List bytes = await image.readAsBytes();
                    cubit.updateRegisterModel(model.copyWith(clinicLicenseImage: image, clinicLicenseBytes: bytes));
                  }
                }),
              ],
              SizedBox(height: 20.h),
            ],
          ),
        );
      },
    );
  }

  Widget _buildModeButton(BuildContext context, DoctorRegisterCubit cubit, DoctorRegisterModel model, String currentMode,
      {required String value, required String label}) {
    final isSelected = currentMode == value;
    final themeColor = Theme.of(context).primaryColor;

    return Expanded(
      child: GestureDetector(
        onTap: () => cubit.updateRegisterModel(model.copyWith(registrationMode: value)),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 10.h),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(6.r),
            boxShadow: isSelected ? [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 2))] : [],
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: isSelected ? themeColor : AppColors.textLightGrey,
            ),
          ),
        ),
      ),
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
            Text('Upload Image', style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600, color: themeColor)),
          ],
        )
            : Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12.r),
              child: Image.memory(bytes, width: double.infinity, height: 120.h, fit: BoxFit.cover),
            ),
            const Center(child: Icon(Icons.check_circle, color: Colors.green, size: 40)),
          ],
        ),
      ),
    );
  }
}
