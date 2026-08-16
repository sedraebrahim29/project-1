import 'package:equatable/equatable.dart';

// =============================================
// Model - بيانات الدواء (Medication)
// أعيد بناؤه بالكامل ليطابق شكل الباك الفعلي (/patient/medical-record/medications)
// النسخة القديمة كانت ناقصة id بالكامل - ما كان فيها تحديث ولا حذف ولا "stop" ممكن.
// مضاف Equatable: بدونها bloc_test بيقارن الكائنات بالـ identity مش
// بالقيمة، فحتى لو نفس البيانات تماماً، الاختبار بيفشل لأنه Object
// جديد ≠ Object قديم. لازم إضافة equatable لـ pubspec.yaml.
// =============================================
class Medication extends Equatable {
  final int id;
  final String drugName;
  final String form;       // مثلاً: tablet
  final String strength;   // مثلاً: 500mg
  final String source;     // مثلاً: self_reported
  final String status;     // active / stopped
  final String dosage;
  final String frequency;
  final String route;      // مثلاً: oral
  final String startDate;
  final String? endDate;
  final String? stoppedAt;
  final String? stopReason;
  final String? notes;
  final bool editable;
  final DateTime? createdAt;

  const Medication({
    required this.id,
    required this.drugName,
    required this.form,
    required this.strength,
    required this.source,
    required this.status,
    required this.dosage,
    required this.frequency,
    required this.route,
    required this.startDate,
    this.endDate,
    this.stoppedAt,
    this.stopReason,
    this.notes,
    this.editable = true,
    this.createdAt,
  });

  // توافق مع MedicationCard القديم (كان بيقرأ medication.name)
  String get name => drugName;

  bool get isStopped => status.toLowerCase() == 'stopped';

  @override
  List<Object?> get props => [
    id,
    drugName,
    form,
    strength,
    source,
    status,
    dosage,
    frequency,
    route,
    startDate,
    endDate,
    stoppedAt,
    stopReason,
    notes,
    editable,
  ];

  factory Medication.fromJson(Map<String, dynamic> json) => Medication(
    id: json['id'] as int,
    drugName: json['drug_name']?.toString() ?? '',
    form: json['form']?.toString() ?? '',
    strength: json['strength']?.toString() ?? '',
    source: json['source']?.toString() ?? '',
    status: json['status']?.toString() ?? 'active',
    dosage: json['dosage']?.toString() ?? '',
    frequency: json['frequency']?.toString() ?? '',
    route: json['route']?.toString() ?? '',
    startDate: json['start_date']?.toString() ?? '',
    endDate: json['end_date']?.toString(),
    stoppedAt: json['stopped_at']?.toString(),
    stopReason: json['stop_reason']?.toString(),
    notes: json['notes']?.toString(),
    editable: json['editable'] as bool? ?? true,
    createdAt: json['created_at'] != null
        ? DateTime.tryParse(json['created_at'].toString())
        : null,
  );
}
