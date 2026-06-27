import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_strings.dart';
import '../view_models/register_cubit.dart';
import 'widgets/step_one_widget.dart';
import 'widgets/step_two_widget.dart';
import 'widgets/step_three_widget.dart';
import 'widgets/step_four_widget.dart';
import 'widgets/step_five_widget.dart';

class DoctorRegisterMainScreen extends StatefulWidget {
  const DoctorRegisterMainScreen({super.key});

  @override
  State<DoctorRegisterMainScreen> createState() => _DoctorRegisterMainScreenState();
}

class _DoctorRegisterMainScreenState extends State<DoctorRegisterMainScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocProvider(
      create: (context) => DoctorRegisterCubit(),
      child: BlocConsumer<DoctorRegisterCubit, DoctorRegisterState>(
        listener: (context, state) {
          if (state.status == DoctorRegisterStatus.success) {
            // Success navigation
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Registration successful!'), backgroundColor: Colors.green),
            );
          }
          if (state.status == DoctorRegisterStatus.failure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errorMessage ?? 'Error'), backgroundColor: Colors.red),
            );
          }
        },
        builder: (context, state) {
          final cubit = context.read<DoctorRegisterCubit>();

          return Scaffold(
            backgroundColor: theme.scaffoldBackgroundColor,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => cubit.previousStep(context),
              ),
              title: LinearProgressIndicator(
                value: state.currentStep / cubit.totalSteps,
                backgroundColor: theme.primaryColor.withOpacity(0.1),
                valueColor: AlwaysStoppedAnimation<Color>(theme.primaryColor),
                minHeight: 6.h,
                borderRadius: BorderRadius.circular(10),
              ),
              actions: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Center(
                    child: Text(
                      '${state.currentStep}/${cubit.totalSteps}',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp),
                    ),
                  ),
                ),
              ],
            ),
            body: Form(
              key: _formKey,
              child: Column(
                children: [
                  Expanded(
                    child: PageView(
                      controller: cubit.pageController,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        const StepOneWidgets(),
                        const StepTwoWidgets(),
                        StepThreeWidgets(),
                        const StepFourWidgets(),
                        const DoctorStepFiveWidget(),
                      ],
                    ),
                  ),
                  _buildBottomNavigation(context, state, cubit),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBottomNavigation(BuildContext context, DoctorRegisterState state, DoctorRegisterCubit cubit) {
    final isLastStep = state.currentStep == cubit.totalSteps;

    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5))
        ],
      ),
      child: Row(
        children: [
          if (state.currentStep > 1) ...[
            Expanded(
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  minimumSize: Size(double.infinity, 50.h),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                ),
                onPressed: () => cubit.previousStep(context),
                child: Text(AppStrings.back(context)),
              ),
            ),
            SizedBox(width: 12.w),
          ],
          Expanded(
            flex: 2,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50.h),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                backgroundColor: Theme.of(context).primaryColor,
              ),
              onPressed: () => cubit.nextStep(_formKey),
              child: state.status == DoctorRegisterStatus.loading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : Text(
                      isLastStep ? AppStrings.confirmSubmit(context) : AppStrings.nextStep(context),
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
