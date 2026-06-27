// =============================================
// Models - بيانات Comprehensive History
// =============================================

// --- موديل حالة مرضية واحدة داخل القسم ---
class ConditionEntry {
  final String name;        // "Hypertension"
  final String status;      // "Active" / "Inactive"
  final String diagnosedYear; // "2018"
  final String description; // النص التفصيلي

  const ConditionEntry({
    required this.name,
    required this.status,
    required this.diagnosedYear,
    required this.description,
  });
}

// --- موديل القسم الكامل ---
class HistorySection {
  final String title;                // "Chronic Diseases"
  final String iconType;             // لتحديد الأيقونة
  final List<ConditionEntry> entries; // الحالات داخل القسم
  final bool isExpanded;

  const HistorySection({
    required this.title,
    required this.iconType,
    this.entries = const [],
    this.isExpanded = false,
  });

  HistorySection copyWith({bool? isExpanded}) {
    return HistorySection(
      title: title,
      iconType: iconType,
      entries: entries,
      isExpanded: isExpanded ?? this.isExpanded,
    );
  }
}