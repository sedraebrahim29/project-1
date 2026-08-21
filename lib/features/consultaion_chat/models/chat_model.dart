/// نموذج "المحادثة/الاستشارة" (Conversation) - مو رسالة مفردة، هاد
/// الموديل بيمثل الاستشارة نفسها بين طبيب ومريض محدّدين.
///
/// ليش ضروري (وليس اختياري): شاشة "My Consultations" (القسم 4-A بطلب
/// المستخدم) لازم تعرض لائحة استشارات (كل عنصر فيها: اسم الطرف التاني،
/// آخر رسالة، وقتها)، وهاد شي مختلف كلياً عن [ChatMessage] (رسالة
/// مفردة جوا استشارة وحدة). فبالتالي `chat_model.dart` ضروري هون.
///
/// كل [ChatConversation] مرتبطة بموعد/جدولة موجودة أصلاً بنظام الحجوزات
/// (appointmentId) - الطبيب هو يلي بيحدد مدة الاستشارة (consultationDuration)
/// عبر نظام الجدولة الموجود مسبقاً، والمريض بيضلّه إله صلاحية دردشة
/// إضافية (patientGraceMinutes) بعد انتهاء المدة الأساسية.
///
/// ⚠️ ما في endpoint حجوزات استشارة عن بعد (Online Consultation) بالباك
/// حالياً (نفس ملاحظة doctor_appointments_repository.dart) - لهيك هاد
/// الموديل مبني بس على الحقول يلي شاشة اللائحة/شاشة المحادثة محتاجاها
/// فعلياً هلق، وجاهز يتوصل ببيانات حجز حقيقية لاحقاً بدون ما تتغيّر
/// الواجهات أو الـ Cubit.
class ChatConversation {
  final String id;

  /// معرّف الموعد/الحجز الأصلي المرتبط بهاي الاستشارة (من نظام
  /// الجدولة/الحجوزات الموجود) - null إذا الاستشارة مو مرتبطة بحجز
  /// محدد (حالة نادرة، بس منتركها اختيارية تحسباً).
  final String? appointmentId;

  final String doctorId;
  final String doctorName;

  final String patientId;
  final String patientName;

  /// وقت بداية الاستشارة المجدولة (يحدده الطبيب عبر جدول العمل).
  final DateTime consultationStart;

  /// مدة الاستشارة بالدقائق كما حددها الطبيب بنظام الجدولة.
  final int consultationDurationMinutes;

  /// الوقت الإضافي (بالدقائق) يلي بيضل معطى للمريض بعد انتهاء المدة
  /// الأساسية - حسب الطلب: 10 دقائق إضافية ثابتة حالياً.
  final int patientGraceMinutes;

  final String? lastMessagePreview;
  final DateTime? lastMessageAt;

  /// عدد الرسائل غير المقروءة بالنسبة للمستخدم الحالي - تستخدمه شاشة
  /// اللائحة لعرض البادج الأخضر ولفلتر "Unread". لا علاقة له بالباك
  /// حالياً (يُحسب/يُخزَّن محلياً فقط - راجع ملاحظة chat_repository.dart).
  final int unreadCount;

  /// وسم "عاجل" (Urgent) اختياري - يُستخدم لفلتر "Urgent" ولعرض نقطة
  /// حمراء على الصورة الرمزية ولون مختلف للوقت باللائحة. تحديد هذا
  /// الوسم فعلياً (مثلاً بناءً على كلمات مفتاحية أو تصنيف الطبيب) قرار
  /// يخص الباك لاحقاً - هلق هو مجرد حقل عرض بالواجهة.
  final bool isUrgent;

  const ChatConversation({
    required this.id,
    this.appointmentId,
    required this.doctorId,
    required this.doctorName,
    required this.patientId,
    required this.patientName,
    required this.consultationStart,
    this.consultationDurationMinutes = 30,
    this.patientGraceMinutes = 10,
    this.lastMessagePreview,
    this.lastMessageAt,
    this.unreadCount = 0,
    this.isUrgent = false,
  });

  DateTime get consultationEnd =>
      consultationStart.add(Duration(minutes: consultationDurationMinutes));

  /// النهاية الفعلية لصلاحية دردشة المريض (مدة الاستشارة + 10 دقائق إضافية).
  DateTime get patientAccessEnd =>
      consultationEnd.add(Duration(minutes: patientGraceMinutes));

  /// اسم الطرف الآخر بالنسبة للمستخدم الحالي - الواجهة هي يلي بتقرر
  /// "أنا طبيب ولا مريض" (isCurrentUserDoctor) وبتعرض الاسم المناسب،
  /// الموديل نفسه ما بيفترض أي دور ثابت.
  String otherParticipantName({required bool isCurrentUserDoctor}) =>
      isCurrentUserDoctor ? patientName : doctorName;

  ChatConversation copyWith({
    String? lastMessagePreview,
    DateTime? lastMessageAt,
    int? unreadCount,
    bool? isUrgent,
  }) {
    return ChatConversation(
      id: id,
      appointmentId: appointmentId,
      doctorId: doctorId,
      doctorName: doctorName,
      patientId: patientId,
      patientName: patientName,
      consultationStart: consultationStart,
      consultationDurationMinutes: consultationDurationMinutes,
      patientGraceMinutes: patientGraceMinutes,
      lastMessagePreview: lastMessagePreview ?? this.lastMessagePreview,
      lastMessageAt: lastMessageAt ?? this.lastMessageAt,
      unreadCount: unreadCount ?? this.unreadCount,
      isUrgent: isUrgent ?? this.isUrgent,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'appointment_id': appointmentId,
    'doctor_id': doctorId,
    'doctor_name': doctorName,
    'patient_id': patientId,
    'patient_name': patientName,
    'consultation_start': consultationStart.toIso8601String(),
    'consultation_duration_minutes': consultationDurationMinutes,
    'patient_grace_minutes': patientGraceMinutes,
    'last_message_preview': lastMessagePreview,
    'last_message_at': lastMessageAt?.toIso8601String(),
    'unread_count': unreadCount,
    'is_urgent': isUrgent,
  };

  factory ChatConversation.fromJson(Map<String, dynamic> json) =>
      ChatConversation(
        id: json['id'].toString(),
        appointmentId: json['appointment_id']?.toString(),
        doctorId: json['doctor_id']?.toString() ?? '',
        doctorName: json['doctor_name']?.toString() ?? '',
        patientId: json['patient_id']?.toString() ?? '',
        patientName: json['patient_name']?.toString() ?? '',
        consultationStart:
        DateTime.tryParse(json['consultation_start']?.toString() ?? '') ??
            DateTime.now(),
        consultationDurationMinutes:
        int.tryParse('${json['consultation_duration_minutes'] ?? 30}') ??
            30,
        unreadCount: int.tryParse('${json['unread_count'] ?? 0}') ?? 0,
        isUrgent: json['is_urgent'] == true,
        patientGraceMinutes:
        int.tryParse('${json['patient_grace_minutes'] ?? 10}') ?? 10,
        lastMessagePreview: json['last_message_preview']?.toString(),
        lastMessageAt: json['last_message_at'] == null
            ? null
            : DateTime.tryParse(json['last_message_at'].toString()),
      );
}

/// حالة صلاحية الدردشة بلحظة معينة - مستعملة بس لعرض شريط الحالة
/// بأعلى شاشة المحادثة (القسم 7 بالطلب). التطبيق الفعلي/الإلزامي لهاي
/// الحالة (منع الإرسال فعلياً من السيرفر) رح ينضاف مع الباك لاحقاً.
enum ConsultationAccessPhase {
  /// لسا وقتها ما اجا (consultationStart بالمستقبل).
  scheduled,

  /// الاستشارة شغالة ضمن مدتها الأساسية.
  active,

  /// انتهت المدة الأساسية بس المريض لسا ضمن الـ 10 دقائق الإضافية
  /// (ما بتصير هاي الحالة عند الطبيب - عنده بتصير [ended] مباشرة).
  graceWindow,

  /// انتهت صلاحية الدردشة بالكامل.
  ended,
}

extension ChatConversationPhaseX on ChatConversation {
  /// بيحسب حالة الاستشارة الحالية بالنسبة لدور المستخدم (الطبيب صلاحيته
  /// بتنتهي عند consultationEnd، المريض عنده الـ 10 دقائق الإضافية).
  ConsultationAccessPhase phaseFor({
    required bool isCurrentUserDoctor,
    DateTime? now,
  }) {
    final n = now ?? DateTime.now();
    if (n.isBefore(consultationStart)) return ConsultationAccessPhase.scheduled;

    final effectiveEnd = isCurrentUserDoctor ? consultationEnd : patientAccessEnd;
    if (n.isAfter(effectiveEnd)) return ConsultationAccessPhase.ended;

    if (!isCurrentUserDoctor && n.isAfter(consultationEnd)) {
      return ConsultationAccessPhase.graceWindow;
    }
    return ConsultationAccessPhase.active;
  }

  /// الوقت المتبقي حتى انتهاء صلاحية الدردشة لهاد المستخدم، null إذا
  /// لسا الاستشارة ما بدأت أو خلصت أصلاً.
  Duration? remainingFor({required bool isCurrentUserDoctor, DateTime? now}) {
    final n = now ?? DateTime.now();
    final effectiveEnd = isCurrentUserDoctor ? consultationEnd : patientAccessEnd;
    final diff = effectiveEnd.difference(n);
    if (diff.isNegative) return null;
    return diff;
  }
}