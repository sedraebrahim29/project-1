import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/constants/app_strings.dart';
import '../../view_models/register_cubit.dart';
import '../../models/register_model.dart';

class StepFourWidgets extends StatefulWidget {
  const StepFourWidgets({super.key});

  @override
  State<StepFourWidgets> createState() => _StepFourWidgetsState();
}

class _StepFourWidgetsState extends State<StepFourWidgets> {
  void _addWorkplace(BuildContext context, DoctorRegisterCubit cubit, DoctorRegisterState state) {
    String? selectedType;
    final nameController = TextEditingController();
    final daysController = TextEditingController();
    final hoursController = TextEditingController();
    final durationController = TextEditingController();
    final feeController = TextEditingController();

    final List<String> workplaceTypes = [
      AppStrings.hospital(context),
      AppStrings.center(context),
      AppStrings.clinic(context)
    ];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppStrings.addWorkplace(context)),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                items: workplaceTypes.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                onChanged: (val) => selectedType = val,
                decoration: InputDecoration(hintText: AppStrings.workplaceType(context)),
              ),
              TextField(controller: nameController, decoration: InputDecoration(hintText: AppStrings.workplaceName(context))),
              TextField(controller: daysController, decoration: InputDecoration(hintText: AppStrings.workingHours(context))),
              TextField(controller: hoursController, decoration: InputDecoration(hintText: AppStrings.workingHours(context))),
              TextField(controller: durationController, decoration: InputDecoration(hintText: AppStrings.duration(context))),
              TextField(controller: feeController, decoration: InputDecoration(hintText: AppStrings.fee(context)), keyboardType: TextInputType.number),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text(AppStrings.back(context))),
          TextButton(
            onPressed: () {
              if (selectedType != null && nameController.text.isNotEmpty) {
                final newWorkplace = WorkplaceInfo(
                  type: selectedType!,
                  name: nameController.text,
                  workDays: daysController.text,
                  workHours: hoursController.text,
                  consultationDuration: durationController.text,
                  fee: feeController.text,
                );
                final updatedList = List<WorkplaceInfo>.from(state.model.workplaces)..add(newWorkplace);
                cubit.updateRegisterModel(state.model.copyWith(workplaces: updatedList));
                Navigator.pop(context);
              }
            },
            child: Text(AppStrings.confirmSubmit(context)),
          ),
        ],
      ),
    );
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
              Text(AppStrings.professionalInfo(context), style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.bold, color: themeColor)),
              SizedBox(height: 5.h),
              Text(AppStrings.workplaceExperienceHint(context), style: TextStyle(fontSize: 13.sp, color: AppColors.textLightGrey)),
              SizedBox(height: 25.h),

              Text(AppStrings.workplaces(context), style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w500)),
              SizedBox(height: 10.h),
              ...state.model.workplaces.map((w) => Card(
                    child: ListTile(
                      title: Text(w.name),
                      subtitle: Text('${w.type} | ${w.fee}'),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          final updatedList = List<WorkplaceInfo>.from(state.model.workplaces)..remove(w);
                          cubit.updateRegisterModel(state.model.copyWith(workplaces: updatedList));
                        },
                      ),
                    ),
                  )),
              SizedBox(height: 10.h),
              OutlinedButton.icon(
                onPressed: () => _addWorkplace(context, cubit, state),
                icon: const Icon(Icons.add),
                label: Text(AppStrings.addWorkplace(context)),
                style: OutlinedButton.styleFrom(minimumSize: Size(double.infinity, 45.h)),
              ),

              SizedBox(height: 20.h),
              Text('${AppStrings.experienceYearsLabel(context)} ${AppStrings.optional(context)}', style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w500)),
              SizedBox(height: 6.h),
              TextFormField(
                initialValue: state.model.experienceYears,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: AppStrings.experienceYearsLabel(context),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r)),
                ),
                onChanged: (val) => cubit.updateRegisterModel(state.model.copyWith(experienceYears: val)),
              ),

              SizedBox(height: 20.h),
              Text(AppStrings.briefBio(context), style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w500)),
              SizedBox(height: 6.h),
              TextFormField(
                initialValue: state.model.bio,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: AppStrings.bioHintText(context),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r)),
                ),
                onChanged: (val) => cubit.updateRegisterModel(state.model.copyWith(bio: val)),
              ),

              SizedBox(height: 20.h),
              SwitchListTile(
                title: Text(AppStrings.onlineConsultation(context)),
                subtitle: Text(AppStrings.onlineConsultationDesc(context)),
                value: state.model.offersOnlineConsultation ?? false,
                onChanged: (val) => cubit.updateRegisterModel(state.model.copyWith(offersOnlineConsultation: val)),
                activeColor: themeColor,
              ),

              if (state.model.offersOnlineConsultation ?? false) ...[
                SizedBox(height: 10.h),
                Text(AppStrings.duration(context), style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w500)),
                SizedBox(height: 6.h),
                TextFormField(
                  initialValue: state.model.onlineConsultationDuration,
                  decoration: InputDecoration(hintText: 'e.g. 30 mins', border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r))),
                  onChanged: (val) => cubit.updateRegisterModel(state.model.copyWith(onlineConsultationDuration: val)),
                ),
                SizedBox(height: 15.h),
                Text(AppStrings.fee(context), style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w500)),
                SizedBox(height: 6.h),
                TextFormField(
                  initialValue: state.model.onlineConsultationFee,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(hintText: 'Fee', border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r))),
                  onChanged: (val) => cubit.updateRegisterModel(state.model.copyWith(onlineConsultationFee: val)),
                ),
                SizedBox(height: 15.h),
                Text(AppStrings.availability(context), style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w500)),
                SizedBox(height: 6.h),
                TextFormField(
                  initialValue: state.model.onlineAvailability,
                  decoration: InputDecoration(hintText: 'e.g. Daily 8pm-10pm', border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r))),
                  onChanged: (val) => cubit.updateRegisterModel(state.model.copyWith(onlineAvailability: val)),
                ),
              ],
              SizedBox(height: 30.h),
            ],
          ),
        );
      },
    );
  }
}
