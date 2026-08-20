import '../models/doctor_notification_model.dart';
import 'local_json_store.dart';

/// ⚠️ نفس ملاحظة appointments/schedule: لا يوجد endpoint إشعارات بالباك
/// بعد. مخزنة محلياً وجاهزة للاستبدال بنداء حقيقي (GET /doctor
/// /notifications) لاحقاً بدون أي تعديل على الـ Cubit.
class DoctorNotificationsRepository {
  String _key(int doctorId) => 'doctor_notifications_v1_$doctorId';

  Future<List<DoctorNotification>> getNotifications(int doctorId) async {
    final raw = await LocalJsonStore.instance.readJson(_key(doctorId));
    if (raw is List) {
      final items = raw.whereType<Map<String, dynamic>>().map(DoctorNotification.fromJson).toList()
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return items;
    }
    return const [];
  }

  Future<void> _saveAll(int doctorId, List<DoctorNotification> items) async {
    await LocalJsonStore.instance.writeJson(_key(doctorId), items.map((e) => e.toJson()).toList());
  }

  Future<void> markAsRead(int doctorId, String id) async {
    final all = await getNotifications(doctorId);
    final updated = all.map((n) => n.id == id ? n.copyWith(isRead: true) : n).toList();
    await _saveAll(doctorId, updated);
  }

  Future<void> markAllAsRead(int doctorId) async {
    final all = await getNotifications(doctorId);
    final updated = all.map((n) => n.copyWith(isRead: true)).toList();
    await _saveAll(doctorId, updated);
  }
}
