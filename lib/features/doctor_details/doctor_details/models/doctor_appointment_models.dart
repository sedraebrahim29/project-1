/// حالة الموعد كما يديرها الطبيب: قادم (لسا رح يجي) / مكتمل (المريض
/// اجا فعلاً) / ملغى.
enum DoctorAppointmentStatus { upcoming, completed, cancelled }

DoctorAppointmentStatus doctorAppointmentStatusFromString(String raw) {
  switch (raw) {
    case 'completed':
      return DoctorAppointmentStatus.completed;
    case 'cancelled':
      return DoctorAppointmentStatus.cancelled;
    default:
      return DoctorAppointmentStatus.upcoming;
  }
}

extension DoctorAppointmentStatusX on DoctorAppointmentStatus {
  String get asString {
    switch (this) {
      case DoctorAppointmentStatus.completed:
        return 'completed';
      case DoctorAppointmentStatus.cancelled:
        return 'cancelled';
      case DoctorAppointmentStatus.upcoming:
        return 'upcoming';
    }
  }
}

/// موعد محجوز من طرف مريض عبر زر "Book" (راجع ملاحظة data/doctor
/// _appointments_repository.dart بخصوص عدم وجود endpoint حجوزات بعد).
class DoctorAppointment {
  final String id;
  final String patientName;
  final String? patientAvatarUrl;
  final String? clinicName;
  final DateTime dateTime;
  final DoctorAppointmentStatus status;
  final String? reason;
  final DateTime bookedAt;

  const DoctorAppointment({
    required this.id,
    required this.patientName,
    this.patientAvatarUrl,
    this.clinicName,
    required this.dateTime,
    required this.status,
    this.reason,
    required this.bookedAt,
  });

  DoctorAppointment copyWith({DoctorAppointmentStatus? status}) => DoctorAppointment(
        id: id,
        patientName: patientName,
        patientAvatarUrl: patientAvatarUrl,
        clinicName: clinicName,
        dateTime: dateTime,
        status: status ?? this.status,
        reason: reason,
        bookedAt: bookedAt,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'patient_name': patientName,
        'patient_avatar_url': patientAvatarUrl,
        'clinic_name': clinicName,
        'date_time': dateTime.toIso8601String(),
        'status': status.asString,
        'reason': reason,
        'booked_at': bookedAt.toIso8601String(),
      };

  factory DoctorAppointment.fromJson(Map<String, dynamic> json) => DoctorAppointment(
        id: json['id'].toString(),
        patientName: json['patient_name']?.toString() ?? '',
        patientAvatarUrl: json['patient_avatar_url']?.toString(),
        clinicName: json['clinic_name']?.toString(),
        dateTime: DateTime.tryParse(json['date_time']?.toString() ?? '') ?? DateTime.now(),
        status: doctorAppointmentStatusFromString(json['status']?.toString() ?? 'upcoming'),
        reason: json['reason']?.toString(),
        bookedAt: DateTime.tryParse(json['booked_at']?.toString() ?? '') ?? DateTime.now(),
      );
}
