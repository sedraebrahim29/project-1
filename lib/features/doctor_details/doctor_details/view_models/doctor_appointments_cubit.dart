import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/doctor_appointments_repository.dart';
import '../models/doctor_appointment_models.dart';
import 'doctor_appointments_state.dart';

class DoctorAppointmentsCubit extends Cubit<DoctorAppointmentsState> {
  final DoctorAppointmentsRepository _repository;
  final int doctorId;

  DoctorAppointmentsCubit({required this.doctorId, DoctorAppointmentsRepository? repository})
      : _repository = repository ?? DoctorAppointmentsRepository(),
        super(const DoctorAppointmentsState());

  Future<void> load() async {
    emit(state.copyWith(status: DoctorAppointmentsStatus.loading));
    try {
      final all = await _repository.getAppointments(doctorId);
      emit(state.copyWith(status: DoctorAppointmentsStatus.loaded, all: all));
    } catch (_) {
      emit(state.copyWith(status: DoctorAppointmentsStatus.failure));
    }
  }

  void changeTab(DoctorAppointmentStatus tab) => emit(state.copyWith(selectedTab: tab));

  Future<void> markCompleted(String appointmentId) async {
    await _repository.updateStatus(
      doctorId: doctorId,
      appointmentId: appointmentId,
      status: DoctorAppointmentStatus.completed,
    );
    await load();
  }

  Future<void> cancel(String appointmentId) async {
    await _repository.updateStatus(
      doctorId: doctorId,
      appointmentId: appointmentId,
      status: DoctorAppointmentStatus.cancelled,
    );
    await load();
  }
}
