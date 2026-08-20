import '../models/doctor_appointment_models.dart';
import 'local_json_store.dart';

/// ⚠️ لا يوجد endpoint حجوزات/مواعيد بالباك حالياً (ولا حتى من جهة
/// المريض - شاشة "Bookings" عنده لسا Placeholder). لما يضيف الباك
/// endpoints فعلية (GET /doctor/appointments، PATCH .../status..)، بدّل
/// جسم الدوال هون بنداءات Dio حقيقية - الـ Cubit وواجهات العرض ما
/// رح تحتاج أي تعديل لأنها بتتعامل مع [DoctorAppointment] فقط.
class DoctorAppointmentsRepository {
  String _key(int doctorId) => 'doctor_appointments_v1_$doctorId';

  Future<List<DoctorAppointment>> getAppointments(int doctorId) async {
    final raw = await LocalJsonStore.instance.readJson(_key(doctorId));
    if (raw is List) {
      return raw
          .whereType<Map<String, dynamic>>()
          .map(DoctorAppointment.fromJson)
          .toList()
        ..sort((a, b) => a.dateTime.compareTo(b.dateTime));
    }
    return const [];
  }

  Future<void> _saveAll(int doctorId, List<DoctorAppointment> appointments) async {
    await LocalJsonStore.instance.writeJson(
      _key(doctorId),
      appointments.map((a) => a.toJson()).toList(),
    );
  }

  Future<void> updateStatus({
    required int doctorId,
    required String appointmentId,
    required DoctorAppointmentStatus status,
  }) async {
    final all = await getAppointments(doctorId);
    final updated = all
        .map((a) => a.id == appointmentId ? a.copyWith(status: status) : a)
        .toList();
    await _saveAll(doctorId, updated);
  }
}
