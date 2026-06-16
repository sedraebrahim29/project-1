// =============================================
// Models - بيانات الواجهة فقط، لا يوجد UI هنا
// =============================================

// --- موديل كل عنصر داخل القسم (مرض، عملية، حساسية...) ---
class MedicalEntry {
  final String title;       // اسم الحالة: "Type 2 Diabetes"
  final String subtitle;    // التفاصيل: "Diagnosed: 2018 • Controlled with medication"

  const MedicalEntry({
    required this.title,
    required this.subtitle,
  });
}

// --- موديل القسم الكامل (Chronic Diseases, Surgeries...) ---
class MedicalSection {
  final String title;              // عنوان القسم
  final String iconAsset;          // مسار أيقونة القسم من assets
  final List<MedicalEntry> entries; // قائمة العناصر داخل القسم
  final bool isExpanded;           // هل القسم مفتوح أم مغلق

  const MedicalSection({
    required this.title,
    required this.iconAsset,
    this.entries = const [],
    this.isExpanded = false,
  });

  // نسخة معدّلة من القسم (لأن الكلاس immutable)
  MedicalSection copyWith({
    String? title,
    String? iconAsset,
    List<MedicalEntry>? entries,
    bool? isExpanded,
  }) {
    return MedicalSection(
      title: title ?? this.title,
      iconAsset: iconAsset ?? this.iconAsset,
      entries: entries ?? this.entries,
      isExpanded: isExpanded ?? this.isExpanded,
    );
  }
}