import '../models/doctor_notification_model.dart';

enum DoctorNotificationsStatus { initial, loading, loaded, failure }

class DoctorNotificationsState {
  final DoctorNotificationsStatus status;
  final List<DoctorNotification> items;

  const DoctorNotificationsState({
    this.status = DoctorNotificationsStatus.initial,
    this.items = const [],
  });

  int get unreadCount => items.where((n) => !n.isRead).length;

  DoctorNotificationsState copyWith({
    DoctorNotificationsStatus? status,
    List<DoctorNotification>? items,
  }) {
    return DoctorNotificationsState(
      status: status ?? this.status,
      items: items ?? this.items,
    );
  }
}
