// =============================================
// Models - بيانات Comprehensive History
// عمّمنا ConditionEntry (كانت مبنية بس لحالة "مرض مزمن": name + status +
// diagnosedYear + description) حتى تصلح لكل أقسام Comprehensive History
// الأربعة الحقيقية (Chronic Diseases / Surgeries / Allergies / Family
// History) بدل ما تظهر كلمة "DIAGNOSED" بالغلط تحت عملية جراحية مثلاً.
// =============================================

// --- موديل حالة واحدة داخل أي قسم ---
class ConditionEntry {
  final String name;         // "Hypertension" / "Cholecystectomy" / "Penicillin"...
  final String? status;      // نص الـ badge بجانب الاسم - null يخفي الـ badge
  final String metaLabel;    // "Diagnosed" / "Surgery date" / "Reaction" / "Relation"
  final String metaValue;    // القيمة المقابلة للـ metaLabel
  final String description;  // نص تفصيلي إضافي (notes) - ممكن يكون فاضي

  const ConditionEntry({
    required this.name,
    this.status,
    required this.metaLabel,
    required this.metaValue,
    this.description = '',
  });
}

// --- موديل القسم الكامل ---
class HistorySection {
  final String title;                 // "Chronic Diseases"
  final String iconType;              // لتحديد الأيقونة
  final List<ConditionEntry> entries; // الحالات داخل القسم
  final bool isExpanded;

  const HistorySection({
    required this.title,
    required this.iconType,
    this.entries = const [],
    this.isExpanded = false,
  });

  HistorySection copyWith({bool? isExpanded, List<ConditionEntry>? entries}) {
    return HistorySection(
      title: title,
      iconType: iconType,
      entries: entries ?? this.entries,
      isExpanded: isExpanded ?? this.isExpanded,
    );
  }
}
