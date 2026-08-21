import '../../doctor_details/data/local_json_store.dart';
import '../models/chat_message_model.dart';
import '../models/chat_model.dart';

/// ⚠️ لا يوجد endpoint شات بالباك حالياً (لا REST ولا WebSocket). هاد
/// الملف عبارة عن "عقد" (interface: [ChatRepository]) + تنفيذ محلي
/// مؤقت ([LocalChatRepository]) بيخزّن المحادثات/الرسائل على الجهاز
/// عبر [LocalJsonStore] (نفس الآلية المستخدمة أصلاً بـ
/// doctor_appointments_repository.dart لعدم وجود endpoint حجوزات).
///
/// لما يضاف باك حقيقي للشات (REST لجلب المحادثات/الرسائل + WebSocket
/// أو polling للرسائل الحية)، المطلوب فقط إنشاء تنفيذ جديد لـ
/// [ChatRepository] (مثلاً RemoteChatRepository) ينادي Dio/الـ
/// WebSocket الحقيقي، وتبديله مكان [LocalChatRepository] بمكان إنشاء
/// الـ [ChatCubit] - الـ Cubit والواجهات كلها بتضلها تشتغل بدون أي
/// تعديل لأنها بتتعامل فقط مع [ChatConversation]/[ChatMessage].
abstract class ChatRepository {
  /// يرجع لائحة استشارات/محادثات المستخدم الحالي (طبيب أو مريض).
  Future<List<ChatConversation>> getConversations({
    required String currentUserId,
    required bool isCurrentUserDoctor,
  });

  /// يرجع كل رسائل استشارة محددة، مرتبة تصاعدياً بالوقت.
  Future<List<ChatMessage>> getMessages(String conversationId);

  /// يخزّن رسالة جديدة ويرجعها بعد "التأكيد" (محلياً حالياً = فوراً،
  /// من الباك لاحقاً = بعد رد السيرفر/تأكيد الـ WebSocket).
  Future<ChatMessage> sendMessage(ChatMessage message);
}

/// تنفيذ محلي مؤقت لـ [ChatRepository] - بيخزّن كل شي بالـ secure
/// storage على جهاز المستخدم فقط (زي أي كاش محلي)، وما إله أي علاقة
/// بمزامنة بين جهازي الطبيب والمريض الحقيقيين (هاد شغل الباك لاحقاً).
class LocalChatRepository implements ChatRepository {
  // ⚠️ v2 بدل v1: عملنا "bump" لنسخة المفتاح عمداً حتى أي بيانات تجريبية
  // قديمة محفوظة بجهاز المستخدم من تجارب سابقة (قبل تصحيح توقيت
  // consultationStart) تتجاهل تلقائياً، وتتولّد بيانات Mock جديدة
  // بأول فتح للتطبيق - بدل ما تضل عالقة لأبد الدهر وتظهر "Consultation
  // ended" بشكل خاطئ اعتماداً على بيانات قديمة انخزنت من زمان.
  String _conversationsKey(String userId) => 'chat_conversations_v2_$userId';
  String _messagesKey(String conversationId) => 'chat_messages_v2_$conversationId';

  @override
  Future<List<ChatConversation>> getConversations({
    required String currentUserId,
    required bool isCurrentUserDoctor,
  }) async {
    final raw = await LocalJsonStore.instance.readJson(_conversationsKey(currentUserId));
    if (raw is List && raw.isNotEmpty) {
      return raw
          .whereType<Map<String, dynamic>>()
          .map(ChatConversation.fromJson)
          .toList()
        ..sort((a, b) =>
            (b.lastMessageAt ?? b.consultationStart).compareTo(a.lastMessageAt ?? a.consultationStart));
    }

    // ------------------------------------------------------------------
    // بيانات تجريبية (MOCK) مؤقتة فقط - لإظهار شكل الواجهة قبل توفر أي
    // endpoint حجوزات/استشارات فعلي. أول ما تنضاف بيانات حقيقية (أو
    // أول ما يبعت المستخدم رسالة)، بيتم تخزينها فعلياً وما رح تظهر هاي
    // البيانات التجريبية مرة ثانية لنفس المستخدم.
    // ------------------------------------------------------------------
    final seeded = _mockConversationsFor(currentUserId, isCurrentUserDoctor);
    await _saveConversations(currentUserId, seeded);
    return seeded;
  }

  @override
  Future<List<ChatMessage>> getMessages(String conversationId) async {
    final raw = await LocalJsonStore.instance.readJson(_messagesKey(conversationId));
    if (raw is List) {
      return raw.whereType<Map<String, dynamic>>().map(ChatMessage.fromJson).toList()
        ..sort((a, b) => a.timestamp.compareTo(b.timestamp));
    }
    return const [];
  }

  @override
  Future<ChatMessage> sendMessage(ChatMessage message) async {
    final all = await getMessages(message.conversationId);
    final confirmed = message.copyWith(status: MessageDeliveryStatus.sent);
    final updated = [...all, confirmed];
    await LocalJsonStore.instance.writeJson(
      _messagesKey(message.conversationId),
      updated.map((m) => m.toJson()).toList(),
    );

    // نحدّث "آخر رسالة" بلائحة المحادثات لكل من الطبيب والمريض حتى
    // تنعكس فوراً بشاشة "My Consultations" لكل الطرفين محلياً.
    await _touchConversationLastMessage(
      userId: message.senderId,
      conversationId: message.conversationId,
      preview: message.content,
      at: message.timestamp,
    );
    await _touchConversationLastMessage(
      userId: message.receiverId,
      conversationId: message.conversationId,
      preview: message.content,
      at: message.timestamp,
    );

    return confirmed;
  }

  Future<void> _touchConversationLastMessage({
    required String userId,
    required String conversationId,
    required String preview,
    required DateTime at,
  }) async {
    final raw = await LocalJsonStore.instance.readJson(_conversationsKey(userId));
    if (raw is! List) return;
    final list = raw.whereType<Map<String, dynamic>>().map(ChatConversation.fromJson).toList();
    final idx = list.indexWhere((c) => c.id == conversationId);
    if (idx == -1) return;
    list[idx] = list[idx].copyWith(lastMessagePreview: preview, lastMessageAt: at);
    await _saveConversations(userId, list);
  }

  Future<void> _saveConversations(String userId, List<ChatConversation> conversations) async {
    await LocalJsonStore.instance.writeJson(
      _conversationsKey(userId),
      conversations.map((c) => c.toJson()).toList(),
    );
  }

  List<ChatConversation> _mockConversationsFor(String currentUserId, bool isCurrentUserDoctor) {
    final now = DateTime.now();

    // ⚠️ ملاحظة مهمة: consultationStart هون مقصود إنه يكون "قريب" لكل
    // المحادثات (حتى لو آخر رسالة كانت من زمان - lastMessageAt) حتى تضل
    // الاستشارة "فعّالة" وتقدر تفتح المحادثة وتبعت رسائل عادي بالتجربة
    // المحلية (Demo) - تماماً متل ما كانت قبل. lastMessageAt/lastMessagePreview
    // هني بس مسؤولين عن شكل اللائحة (اليوم/أمس/Tue...)، وما إلهم أي علاقة
    // بحساب حالة/صلاحية الاستشارة (consultationStart/consultationEnd).
    if (isCurrentUserDoctor) {
      return [
        ChatConversation(
          id: 'mock_c1_$currentUserId',
          doctorId: currentUserId,
          doctorName: 'Dr. ${_maskName(currentUserId)}',
          patientId: 'mock_patient_1',
          patientName: 'Sarah Jenkins',
          consultationStart: now.subtract(const Duration(minutes: 10)),
          consultationDurationMinutes: 30,
          lastMessagePreview: 'I was wondering about the side effects of...',
          lastMessageAt: now.subtract(const Duration(minutes: 2)),
          unreadCount: 2,
        ),
        ChatConversation(
          id: 'mock_c2_$currentUserId',
          doctorId: currentUserId,
          doctorName: 'Dr. ${_maskName(currentUserId)}',
          patientId: 'mock_patient_2',
          patientName: 'Michael Chen',
          consultationStart: now.subtract(const Duration(minutes: 10)),
          consultationDurationMinutes: 30,
          lastMessagePreview: 'Thank you, doctor. I will schedule',
          lastMessageAt: now.subtract(const Duration(days: 1, hours: 3)),
        ),
        ChatConversation(
          id: 'mock_c3_$currentUserId',
          doctorId: currentUserId,
          doctorName: 'Dr. ${_maskName(currentUserId)}',
          patientId: 'mock_patient_3',
          patientName: 'Elena Rodriguez',
          consultationStart: now.subtract(const Duration(minutes: 10)),
          consultationDurationMinutes: 30,
          lastMessagePreview: "The pain hasn't subsided since tal",
          lastMessageAt: now.subtract(const Duration(days: 2)),
          isUrgent: true,
        ),
      ];
    }

    return [
      ChatConversation(
        id: 'mock_c1_$currentUserId',
        doctorId: 'mock_doctor_1',
        doctorName: 'Dr. Ahmad Kareem',
        patientId: currentUserId,
        patientName: _maskName(currentUserId),
        consultationStart: now.subtract(const Duration(minutes: 5)),
        consultationDurationMinutes: 30,
        lastMessagePreview: 'How are you feeling today?',
        lastMessageAt: now.subtract(const Duration(minutes: 1)),
        unreadCount: 1,
      ),
      ChatConversation(
        id: 'mock_c2_$currentUserId',
        doctorId: 'mock_doctor_2',
        doctorName: 'Dr. Ali Mansour',
        patientId: currentUserId,
        patientName: _maskName(currentUserId),
        consultationStart: now.subtract(const Duration(minutes: 5)),
        consultationDurationMinutes: 30,
        lastMessagePreview: 'Please send your latest lab report.',
        lastMessageAt: now.subtract(const Duration(days: 1, hours: 2)),
      ),
      ChatConversation(
        id: 'mock_c3_$currentUserId',
        doctorId: 'mock_doctor_3',
        doctorName: 'Dr. Rana Saleh',
        patientId: currentUserId,
        patientName: _maskName(currentUserId),
        consultationStart: now.subtract(const Duration(minutes: 5)),
        consultationDurationMinutes: 30,
        lastMessagePreview: 'Please come in for an urgent follow-up.',
        lastMessageAt: now.subtract(const Duration(days: 3)),
        isUrgent: true,
      ),
    ];
  }

  String _maskName(String id) => id.length <= 4 ? 'User' : 'User ${id.substring(0, 4)}';
}