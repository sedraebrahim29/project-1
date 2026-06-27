part of 'register_cubit.dart';

enum DoctorRegisterStatus { initial, loading, success, failure }

class DoctorRegisterState {
  final int currentStep;
  final DoctorRegisterStatus status;
  final DoctorRegisterModel model;
  final String? errorMessage;

  const DoctorRegisterState({
    this.currentStep = 1,
    this.status = DoctorRegisterStatus.initial,
    required this.model,
    this.errorMessage,
  });

  DoctorRegisterState copyWith({
    int? currentStep,
    DoctorRegisterStatus? status,
    DoctorRegisterModel? model,
    String? errorMessage,
  }) {
    return DoctorRegisterState(
      currentStep: currentStep ?? this.currentStep,
      status: status ?? this.status,
      model: model ?? this.model,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
