import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/doctor_notifications_repository.dart';
import 'doctor_notifications_state.dart';

class DoctorNotificationsCubit extends Cubit<DoctorNotificationsState> {
  final DoctorNotificationsRepository _repository;
  final int doctorId;

  DoctorNotificationsCubit({required this.doctorId, DoctorNotificationsRepository? repository})
      : _repository = repository ?? DoctorNotificationsRepository(),
        super(const DoctorNotificationsState());

  Future<void> load() async {
    emit(state.copyWith(status: DoctorNotificationsStatus.loading));
    try {
      final items = await _repository.getNotifications(doctorId);
      emit(state.copyWith(status: DoctorNotificationsStatus.loaded, items: items));
    } catch (_) {
      emit(state.copyWith(status: DoctorNotificationsStatus.failure));
    }
  }

  Future<void> markAsRead(String id) async {
    await _repository.markAsRead(doctorId, id);
    await load();
  }

  Future<void> markAllAsRead() async {
    await _repository.markAllAsRead(doctorId);
    await load();
  }
}
