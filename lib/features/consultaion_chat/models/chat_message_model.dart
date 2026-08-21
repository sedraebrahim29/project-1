/// نموذج رسالة واحدة داخل محادثة الاستشارة (consultation_chat).
///
/// ⚠️ لا يوجد endpoint/باك خاص بالشات حالياً (راجع ملاحظة data/
/// chat_repository.dart). الحقول هون مبنية بس على شغلات UI محتاجينها
/// فعلياً هلق + جاهزة تتوصل بباك حقيقي بدون ما نغيّر بنية الموديل:
/// id/senderId/receiverId/content/timestamp أساسيات لأي شات، و
/// [status] مضاف لأنو الإرسال بيصير "متفائل" (optimistic) من واجهة
/// المستخدم مباشرة (نعرض الرسالة فوراً وهي "قيد الإرسال")، فمنحتاج
/// طريقة نعكس فيها لاحقاً إذا نجح الإرسال أو فشل.
///
/// ما ضفنا حقول زيادة (seen/read, attachments, images...) لأنها مو
/// مطلوبة بالمرحلة الحالية (نص فقط) - بس الموديل جاهز يوسّع لهيك حقول
/// بسهولة لاحقاً (attachmentUrl مثلاً) بدون ما نكسر أي كود موجود.
enum MessageDeliveryStatus {
  /// الرسالة انبعتت من المستخدم محلياً وبعدها ما توكدت (مافي باك حالياً
  /// فهاي الحالة بتتحول لـ [sent] بعد محاكاة بسيطة بالـ Repository).
  sending,

  /// الرسالة انبعتت (محلياً حالياً، من الباك لاحقاً).
  sent,

  /// فشل الإرسال (مثلاً لأنو انتهت مدة الاستشارة) - المستخدم فيه يعيد
  /// المحاولة بالضغط على الرسالة.
  failed,
}

MessageDeliveryStatus messageDeliveryStatusFromString(String raw) {
  switch (raw) {
    case 'sent':
      return MessageDeliveryStatus.sent;
    case 'failed':
      return MessageDeliveryStatus.failed;
    default:
      return MessageDeliveryStatus.sending;
  }
}

extension MessageDeliveryStatusX on MessageDeliveryStatus {
  String get asString {
    switch (this) {
      case MessageDeliveryStatus.sent:
        return 'sent';
      case MessageDeliveryStatus.failed:
        return 'failed';
      case MessageDeliveryStatus.sending:
        return 'sending';
    }
  }
}

class ChatMessage {
  final String id;
  final String conversationId;
  final String senderId;
  final String receiverId;
  final String content;
  final DateTime timestamp;
  final MessageDeliveryStatus status;

  const ChatMessage({
    required this.id,
    required this.conversationId,
    required this.senderId,
    required this.receiverId,
    required this.content,
    required this.timestamp,
    this.status = MessageDeliveryStatus.sent,
  });

  /// هل هاي الرسالة مبعوتة من المستخدم الحالي؟ هيك بتحدد الواجهة
  /// (message_bubble.dart) محاذاة/تلوين الفقاعة بدون ما "تعرف" إذا
  /// المستخدم الحالي طبيب أو مريض - فقط تقارن الـ id.
  bool isSentBy(String currentUserId) => senderId == currentUserId;

  ChatMessage copyWith({
    String? id,
    String? conversationId,
    String? senderId,
    String? receiverId,
    String? content,
    DateTime? timestamp,
    MessageDeliveryStatus? status,
  }) {
    return ChatMessage(
      id: id ?? this.id,
      conversationId: conversationId ?? this.conversationId,
      senderId: senderId ?? this.senderId,
      receiverId: receiverId ?? this.receiverId,
      content: content ?? this.content,
      timestamp: timestamp ?? this.timestamp,
      status: status ?? this.status,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'conversation_id': conversationId,
        'sender_id': senderId,
        'receiver_id': receiverId,
        'content': content,
        'timestamp': timestamp.toIso8601String(),
        'status': status.asString,
      };

  factory ChatMessage.fromJson(Map<String, dynamic> json) => ChatMessage(
        id: json['id'].toString(),
        conversationId: json['conversation_id']?.toString() ?? '',
        senderId: json['sender_id']?.toString() ?? '',
        receiverId: json['receiver_id']?.toString() ?? '',
        content: json['content']?.toString() ?? '',
        timestamp: DateTime.tryParse(json['timestamp']?.toString() ?? '') ??
            DateTime.now(),
        status: messageDeliveryStatusFromString(
            json['status']?.toString() ?? 'sent'),
      );
}
