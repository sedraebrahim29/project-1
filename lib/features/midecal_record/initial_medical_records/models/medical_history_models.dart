import 'package:equatable/equatable.dart';

// =============================================
// Models - بيانات الحالة المرضية (Medical History)
// تم إعادة بنائها بالكامل لتطابق شكل الباك الفعلي (id + كل الحقول)
// بدل الموديل المبسّط القديم (title/subtitle بس، بدون id).
// كلها Equatable حتى الـ cubits تصير قابلة للاختبار بـ bloc_test
// (مقارنة بالقيمة مش بالـ identity).
// =============================================

// --- نوع القسم: بيحدد أي endpoint/repository method نستخدم عند
// الإضافة/التعديل/الحذف. بدونه، الشاشة ما رح تعرف تفرّق بين قسم وتاني. ---
enum MedicalSectionType { chronicCondition, surgery, allergy, familyHistory }

// --- حساسية (Allergy) ---
class Allergy extends Equatable {
  final int id;
  final String allergenType; // مثلاً: food / drug
  final String allergen;
  final String reaction;
  final String severity;
  final DateTime? createdAt;

  const Allergy({
    required this.id,
    required this.allergenType,
    required this.allergen,
    required this.reaction,
    required this.severity,
    this.createdAt,
  });

  factory Allergy.fromJson(Map<String, dynamic> json) => Allergy(
    id: json['id'] as int,
    allergenType: json['allergen_type']?.toString() ?? '',
    allergen: json['allergen']?.toString() ?? '',
    reaction: json['reaction']?.toString() ?? '',
    severity: json['severity']?.toString() ?? '',
    createdAt: json['created_at'] != null
        ? DateTime.tryParse(json['created_at'].toString())
        : null,
  );

  MedicalEntry toEntry() => MedicalEntry(
    id: id,
    title: allergen,
    subtitle: '$allergenType • $reaction • $severity',
  );

  @override
  List<Object?> get props => [id, allergenType, allergen, reaction, severity];
}

// --- مرض مزمن (Chronic Condition) ---
class ChronicCondition extends Equatable {
  final int id;
  final String conditionName;
  final String diagnosedAt; // تاريخ بصيغة yyyy-MM-dd من الباك
  final String? notes;
  final DateTime? createdAt;

  const ChronicCondition({
    required this.id,
    required this.conditionName,
    required this.diagnosedAt,
    this.notes,
    this.createdAt,
  });

  factory ChronicCondition.fromJson(Map<String, dynamic> json) => ChronicCondition(
    id: json['id'] as int,
    conditionName: json['condition_name']?.toString() ?? '',
    diagnosedAt: json['diagnosed_at']?.toString() ?? '',
    notes: json['notes']?.toString(),
    createdAt: json['created_at'] != null
        ? DateTime.tryParse(json['created_at'].toString())
        : null,
  );

  MedicalEntry toEntry() => MedicalEntry(
    id: id,
    title: conditionName,
    subtitle: 'Diagnosed: $diagnosedAt${notes != null && notes!.isNotEmpty ? ' • $notes' : ''}',
  );

  @override
  List<Object?> get props => [id, conditionName, diagnosedAt, notes];
}

// --- عملية جراحية (Surgery) ---
class Surgery extends Equatable {
  final int id;
  final String surgeryName;
  final String surgeryDate;
  final String? notes;
  final DateTime? createdAt;

  const Surgery({
    required this.id,
    required this.surgeryName,
    required this.surgeryDate,
    this.notes,
    this.createdAt,
  });

  factory Surgery.fromJson(Map<String, dynamic> json) => Surgery(
    id: json['id'] as int,
    surgeryName: json['surgery_name']?.toString() ?? '',
    surgeryDate: json['surgery_date']?.toString() ?? '',
    notes: json['notes']?.toString(),
    createdAt: json['created_at'] != null
        ? DateTime.tryParse(json['created_at'].toString())
        : null,
  );

  MedicalEntry toEntry() => MedicalEntry(
    id: id,
    title: surgeryName,
    subtitle: '$surgeryDate${notes != null && notes!.isNotEmpty ? ' • $notes' : ''}',
  );

  @override
  List<Object?> get props => [id, surgeryName, surgeryDate, notes];
}

// --- تاريخ عائلي (Family History) ---
class FamilyHistoryEntry extends Equatable {
  final int id;
  final String condition;
  final String relation;
  final String? notes;
  final DateTime? createdAt;

  const FamilyHistoryEntry({
    required this.id,
    required this.condition,
    required this.relation,
    this.notes,
    this.createdAt,
  });

  factory FamilyHistoryEntry.fromJson(Map<String, dynamic> json) => FamilyHistoryEntry(
    id: json['id'] as int,
    condition: json['condition']?.toString() ?? '',
    relation: json['relation']?.toString() ?? '',
    notes: json['notes']?.toString(),
    createdAt: json['created_at'] != null
        ? DateTime.tryParse(json['created_at'].toString())
        : null,
  );

  MedicalEntry toEntry() => MedicalEntry(
    id: id,
    title: condition,
    subtitle: '$relation${notes != null && notes!.isNotEmpty ? ' • $notes' : ''}',
  );

  @override
  List<Object?> get props => [id, condition, relation, notes];
}

// --- موديل العرض العام لكل عنصر داخل القسم (title/subtitle) ---
// مضاف عليه id (كان غايب بالكامل بالنسخة القديمة) حتى الشاشة تقدر
// تحدد أي عنصر حقيقي بالباك لما يصير عليه edit/delete.
class MedicalEntry extends Equatable {
  final int id;
  final String title;
  final String subtitle;

  const MedicalEntry({
    required this.id,
    required this.title,
    required this.subtitle,
  });

  @override
  List<Object?> get props => [id, title, subtitle];
}

// --- موديل القسم الكامل (Chronic Diseases, Surgeries...) ---
class MedicalSection extends Equatable {
  final MedicalSectionType type; // مضاف: يحدد أي repository method نستخدم
  final String title;
  final String iconAsset;
  final List<MedicalEntry> entries;
  final bool isExpanded;

  const MedicalSection({
    required this.type,
    required this.title,
    required this.iconAsset,
    this.entries = const [],
    this.isExpanded = false,
  });

  MedicalSection copyWith({
    MedicalSectionType? type,
    String? title,
    String? iconAsset,
    List<MedicalEntry>? entries,
    bool? isExpanded,
  }) {
    return MedicalSection(
      type: type ?? this.type,
      title: title ?? this.title,
      iconAsset: iconAsset ?? this.iconAsset,
      entries: entries ?? this.entries,
      isExpanded: isExpanded ?? this.isExpanded,
    );
  }

  @override
  List<Object?> get props => [type, title, iconAsset, entries, isExpanded];
}
