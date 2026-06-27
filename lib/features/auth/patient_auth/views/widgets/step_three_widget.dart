import 'dart:typed_data';
import 'package:flutter/foundation.dart'; // للتحقق من البيئة kIsWeb
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/constants/app_strings.dart';
import '../../view_models/register_cubit.dart';
import '../../view_models/register_state.dart';

class StepThreeWidgets extends StatelessWidget {
  StepThreeWidgets({super.key});

  final ImagePicker _picker = ImagePicker();

  void _showPickOptions(BuildContext context, RegisterCubit cubit, RegisterState state) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16.r))),
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt_outlined),
              title: const Text('Take a Photo / التقاط صورة'),
              onTap: () async {
                Navigator.pop(context);
                final XFile? image = await _picker.pickImage(source: ImageSource.camera, imageQuality: 85);
                if (image != null) {
                  final bytes = await image.readAsBytes(); // قراءة البايتات فوراً للـ Web
                  cubit.updateRegisterModel(state.model.copyWith(scannedImage: image, webImageBytes: bytes));
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.image_outlined),
              title: const Text('Browse Files / تصفح الملفات'),
              onTap: () async {
                Navigator.pop(context);
                final XFile? image = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 85);
                if (image != null) {
                  final bytes = await image.readAsBytes(); // قراءة البايتات فوراً للـ Web
                  cubit.updateRegisterModel(state.model.copyWith(scannedImage: image, webImageBytes: bytes));
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = Theme.of(context).primaryColor;
    final cubit = context.read<RegisterCubit>();

    return BlocBuilder<RegisterCubit, RegisterState>(
      builder: (context, state) {
        final hasImage = state.model.webImageBytes != null || state.model.scannedImage != null;

        return SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 25.h),
              if (!hasImage)
                _buildStepThreeInitialWidgets(context, themeColor, cubit, state)
              else
                _buildStepThreeSuccessWidgets(context, themeColor, cubit, state),
              SizedBox(height: 20.h),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStepThreeInitialWidgets(BuildContext context, Color themeColor, RegisterCubit cubit, RegisterState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(AppStrings.verifyYourIdentity(context), style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.bold, color: themeColor)),
        SizedBox(height: 10.h),
        Text(AppStrings.uploadClearImage(context), style: TextStyle(fontSize: 13.sp, color: AppColors.textLightGrey)),
        SizedBox(height: 25.h),
        GestureDetector(
          onTap: () => _showPickOptions(context, cubit, state),
          child: Container(
            width: double.infinity,
            height: 180.h,
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: Colors.grey.withOpacity(0.3)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.camera_alt_outlined, color: themeColor, size: 40.sp),
                SizedBox(height: 15.h),
                Text(AppStrings.tapToCapture(context), style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600, color: themeColor)),
                Text(AppStrings.orBrowseFiles(context), style: TextStyle(fontSize: 13.sp, color: AppColors.textLightGrey)),
              ],
            ),
          ),
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
              Expanded(child: Text(AppStrings.identityDataEncrypted(context), style: TextStyle(fontSize: 13.sp, color: AppColors.textLightGrey, height: 1.4))),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStepThreeSuccessWidgets(BuildContext context, Color themeColor, RegisterCubit cubit, RegisterState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(AppStrings.identityVerificationTitle(context), style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.bold, color: themeColor)),
        SizedBox(height: 10.h),
        Text(AppStrings.documentScannedSuccessfully(context), style: TextStyle(fontSize: 13.sp, color: AppColors.textLightGrey)),
        SizedBox(height: 25.h),
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: double.infinity,
              height: 200.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12.r),
                // الحل الذكي هنا: استخدام Image.memory بدلاً من Image.file لتعمل الصورة على الويب والموبايل
                child: Image.memory(
                  state.model.webImageBytes!,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(10.w),
              decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
              child: const Icon(Icons.check_circle, color: Colors.green, size: 50),
            ),
            Positioned(
              bottom: 10.h,
              left: 10.w,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(color: Colors.black.withOpacity(0.6), borderRadius: BorderRadius.circular(4.r)),
                child: Row(
                  children: [
                    Icon(Icons.insert_drive_file_outlined, color: Colors.white, size: 16.sp),
                    SizedBox(width: 5.w),
                    Text(
                      state.model.scannedImage?.name ?? "document.jpg",
                      style: TextStyle(fontSize: 12.sp, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 30.h),
        SizedBox(
          width: double.infinity,
          height: 50.h,
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: themeColor),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
            ),
            onPressed: () {
              cubit.updateRegisterModel(state.model.copyWith(scannedImage: null, webImageBytes: null));
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.replay, color: themeColor, size: 20.sp),
                SizedBox(width: 8.w),
                Text(AppStrings.retake(context), style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold, color: themeColor)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
