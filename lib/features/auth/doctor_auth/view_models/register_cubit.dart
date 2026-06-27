import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/register_model.dart';

part 'register_state.dart';

class DoctorRegisterCubit extends Cubit<DoctorRegisterState> {
  final PageController pageController = PageController();
  final int totalSteps = 5;

  DoctorRegisterCubit() : super(DoctorRegisterState(model: DoctorRegisterModel()));

  void updateRegisterModel(DoctorRegisterModel updatedModel) {
    emit(state.copyWith(model: updatedModel));
  }

  void nextStep(GlobalKey<FormState> formKey) {
    if (state.currentStep < totalSteps) {
      if (formKey.currentState?.validate() ?? true) {
        final nextStepNumber = state.currentStep + 1;
        emit(state.copyWith(currentStep: nextStepNumber));
        pageController.animateToPage(
          nextStepNumber - 1,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    } else {
      submitRegistration();
    }
  }

  void previousStep(BuildContext context) {
    if (state.currentStep > 1) {
      final prevStepNumber = state.currentStep - 1;
      emit(state.copyWith(currentStep: prevStepNumber));
      pageController.animateToPage(
        prevStepNumber - 1,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.pop(context);
    }
  }

  void jumpToStep(int stepNumber) {
    if (stepNumber >= 1 && stepNumber <= totalSteps) {
      emit(state.copyWith(currentStep: stepNumber));
      pageController.animateToPage(
        stepNumber - 1,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> submitRegistration() async {
    emit(state.copyWith(status: DoctorRegisterStatus.loading));
    try {
      final Map<String, dynamic> requestData = state.model.toJson();
      debugPrint('Sending Doctor Data: $requestData');
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));
      emit(state.copyWith(status: DoctorRegisterStatus.success));
    } catch (error) {
      emit(state.copyWith(status: DoctorRegisterStatus.failure, errorMessage: error.toString()));
    }
  }

  @override
  Future<void> close() {
    pageController.dispose();
    return super.close();
  }
}
