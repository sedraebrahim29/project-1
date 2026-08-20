import '../models/doctor_appointment_models.dart';

enum DoctorAppointmentsStatus { initial, loading, loaded, failure }

class DoctorAppointmentsState {
  final DoctorAppointmentsStatus status;
  final List<DoctorAppointment> all;
  final DoctorAppointmentStatus selectedTab;

  const DoctorAppointmentsState({
    this.status = DoctorAppointmentsStatus.initial,
    this.all = const [],
    this.selectedTab = DoctorAppointmentStatus.upcoming,
  });

  List<DoctorAppointment> get visible {
    final filtered = all.where((a) => a.status == selectedTab).toList();
    filtered.sort((a, b) => selectedTab == DoctorAppointmentStatus.upcoming
        ? a.dateTime.compareTo(b.dateTime)
        : b.dateTime.compareTo(a.dateTime));
    return filtered;
  }

  DoctorAppointmentsState copyWith({
    DoctorAppointmentsStatus? status,
    List<DoctorAppointment>? all,
    DoctorAppointmentStatus? selectedTab,
  }) {
    return DoctorAppointmentsState(
      status: status ?? this.status,
      all: all ?? this.all,
      selectedTab: selectedTab ?? this.selectedTab,
    );
  }
}
