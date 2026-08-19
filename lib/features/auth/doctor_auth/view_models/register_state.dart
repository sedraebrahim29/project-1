import '../models/register_model.dart';

abstract class DoctorRegisterState {
  final int currentStep;
  final DoctorRegisterModel model;

  const DoctorRegisterState({
    required this.currentStep,
    required this.model,
  });
}

class DoctorRegisterInitial extends DoctorRegisterState {
  DoctorRegisterInitial()
      : super(
    currentStep: 1,
    model: DoctorRegisterModel(gender: 'male', registrationMode: 'join_clinic'),
  );
}

class DoctorRegisterStepChanged extends DoctorRegisterState {
  const DoctorRegisterStepChanged({
    required super.currentStep,
    required super.model,
  });

  DoctorRegisterStepChanged copyWith({
    int? currentStep,
    DoctorRegisterModel? model,
  }) {
    return DoctorRegisterStepChanged(
      currentStep: currentStep ?? this.currentStep,
      model: model ?? this.model,
    );
  }
}

class DoctorRegisterStepSubmitting extends DoctorRegisterState {
  const DoctorRegisterStepSubmitting({
    required super.currentStep,
    required super.model,
  });
}

class DoctorRegisterSubmitSuccess extends DoctorRegisterState {
  const DoctorRegisterSubmitSuccess({
    required super.currentStep,
    required super.model,
  });
}


class DoctorRegisterSubmitFailure extends DoctorRegisterState {
  final String errorMessage;
  const DoctorRegisterSubmitFailure({
    required super.currentStep,
    required super.model,
    required this.errorMessage,
  });
}
