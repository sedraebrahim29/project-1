enum DoctorNotificationType { newAppointment, cancelledAppointment, message, system }

DoctorNotificationType _typeFromString(String raw) {
  switch (raw) {
    case 'cancelled_appointment':
      return DoctorNotificationType.cancelledAppointment;
    case 'message':
      return DoctorNotificationType.message;
    case 'system':
      return DoctorNotificationType.system;
    default:
      return DoctorNotificationType.newAppointment;
  }
}

String _typeToString(DoctorNotificationType type) {
  switch (type) {
    case DoctorNotificationType.cancelledAppointment:
      return 'cancelled_appointment';
    case DoctorNotificationType.message:
      return 'message';
    case DoctorNotificationType.system:
      return 'system';
    case DoctorNotificationType.newAppointment:
      return 'new_appointment';
  }
}

class DoctorNotification {
  final String id;
  final DoctorNotificationType type;
  final String title;
  final String body;
  final DateTime createdAt;
  final bool isRead;

  const DoctorNotification({
    required this.id,
    required this.type,
    required this.title,
    required this.body,
    required this.createdAt,
    this.isRead = false,
  });

  DoctorNotification copyWith({bool? isRead}) => DoctorNotification(
        id: id,
        type: type,
        title: title,
        body: body,
        createdAt: createdAt,
        isRead: isRead ?? this.isRead,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': _typeToString(type),
        'title': title,
        'body': body,
        'created_at': createdAt.toIso8601String(),
        'is_read': isRead,
      };

  factory DoctorNotification.fromJson(Map<String, dynamic> json) => DoctorNotification(
        id: json['id'].toString(),
        type: _typeFromString(json['type']?.toString() ?? ''),
        title: json['title']?.toString() ?? '',
        body: json['body']?.toString() ?? '',
        createdAt: DateTime.tryParse(json['created_at']?.toString() ?? '') ?? DateTime.now(),
        isRead: json['is_read'] as bool? ?? false,
      );
}
