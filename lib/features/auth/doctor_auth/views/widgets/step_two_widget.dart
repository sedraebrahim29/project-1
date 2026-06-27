import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/constants/app_strings.dart';
import '../../view_models/register_cubit.dart';

class StepTwoWidgets extends StatelessWidget {
  const StepTwoWidgets({super.key});

  @override
  Widget build(BuildContext context) {
    final themeColor = Theme.of(context).primaryColor;
    final cubit = context.read<DoctorRegisterCubit>();

    return BlocBuilder<DoctorRegisterCubit, DoctorRegisterState>(
      builder: (context, state) {
        final currentGender = state.model.gender ?? 'female';
        final mainSpecialty = state.model.mainSpecialty;

        final List<String> mainSpecialties = AppStrings.mainSpecialties(context);
        final List<String> subSpecialties = mainSpecialty != null
            ? AppStrings.subSpecialties(context, mainSpecialty)
            : [];

        return SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 15.h),
              Text(
                AppStrings.personalDetails(context),
                style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.bold, color: themeColor),
              ),
              SizedBox(height: 5.h),
              Text(
                AppStrings.providePersonalInfo(context),
                style: TextStyle(fontSize: 13.sp, color: AppColors.textLightGrey),
              ),
              SizedBox(height: 25.h),

              // 1. Date of Birth
              Text(AppStrings.dateOfBirth(context), style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w500)),
              SizedBox(height: 6.h),
              TextFormField(
                controller: TextEditingController(text: state.model.dateOfBirth),
                key: ValueKey(state.model.dateOfBirth),
                readOnly: true,
                validator: (val) => (val == null || val.isEmpty) ? AppStrings.requiredField(context) : null,
                decoration: InputDecoration(
                  hintText: AppStrings.dateOfBirthHint(context),
                  prefixIcon: const Icon(Icons.calendar_today_outlined),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r)),
                ),
                onTap: () async {
                  final pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now().subtract(const Duration(days: 365 * 30)),
                    firstDate: DateTime(1940),
                    lastDate: DateTime.now(),
                  );
                  if (pickedDate != null) {
                    final formattedDate = "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
                    cubit.updateRegisterModel(state.model.copyWith(dateOfBirth: formattedDate));
                  }
                },
              ),
              SizedBox(height: 15.h),

              // 2. Gender
              Text(AppStrings.gender(context), style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w500)),
              SizedBox(height: 8.h),
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                padding: EdgeInsets.all(4.w),
                child: Row(
                  children: [
                    _buildGenderButton(context, cubit, state, currentGender, value: 'male', label: AppStrings.male(context)),
                    _buildGenderButton(context, cubit, state, currentGender, value: 'female', label: AppStrings.female(context)),
                  ],
                ),
              ),
              SizedBox(height: 15.h),

              // 3. Home Address
              Text(AppStrings.homeAddress(context), style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w500)),
              SizedBox(height: 6.h),
              TextFormField(
                initialValue: state.model.homeAddress,
                validator: (val) => (val == null || val.isEmpty) ? AppStrings.requiredField(context) : null,
                decoration: InputDecoration(
                  hintText: AppStrings.homeAddress(context),
                  prefixIcon: const Icon(Icons.location_on_outlined),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r)),
                ),
                onChanged: (value) {
                  cubit.updateRegisterModel(state.model.copyWith(homeAddress: value));
                },
              ),
              SizedBox(height: 15.h),

              // 4. Main Specialty
              Text(AppStrings.mainSpecialty(context), style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w500)),
              SizedBox(height: 6.h),
              DropdownButtonFormField<String>(
                value: mainSpecialty,
                validator: (val) => (val == null) ? AppStrings.requiredField(context) : null,
                items: mainSpecialties.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value, style: TextStyle(fontSize: 14.sp)),
                  );
                }).toList(),
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r)),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12.w),
                ),
                onChanged: (val) {
                  cubit.updateRegisterModel(state.model.copyWith(mainSpecialty: val, subSpecialty: null));
                },
                hint: Text(AppStrings.selectSpecialty(context)),
              ),
              SizedBox(height: 15.h),

              // 5. Sub Specialty
              Text(AppStrings.subSpecialty(context), style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w500)),
              SizedBox(height: 6.h),
              DropdownButtonFormField<String>(
                value: state.model.subSpecialty,
                validator: (val) => (val == null) ? AppStrings.requiredField(context) : null,
                items: subSpecialties.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value, style: TextStyle(fontSize: 14.sp)),
                  );
                }).toList(),
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r)),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12.w),
                ),
                onChanged: (val) {
                  cubit.updateRegisterModel(state.model.copyWith(subSpecialty: val));
                },
                hint: Text(AppStrings.selectSpecialty(context)),
              ),
              SizedBox(height: 20.h),
            ],
          ),
        );
      },
    );
  }

  Widget _buildGenderButton(BuildContext context, DoctorRegisterCubit cubit, DoctorRegisterState state, String currentGender, {required String value, required String label}) {
    final isSelected = currentGender == value;
    final themeColor = Theme.of(context).primaryColor;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          cubit.updateRegisterModel(state.model.copyWith(gender: value));
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 10.h),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(6.r),
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
}
