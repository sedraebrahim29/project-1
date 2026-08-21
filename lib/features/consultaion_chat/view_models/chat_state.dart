import '../models/chat_message_model.dart';
import '../models/chat_model.dart';

enum ChatConversationsStatus { initial, loading, loaded, failure }

/// حالة واحدة مشتركة بين الطبيب والمريض - تغطي كل من:
/// 1) شاشة لائحة الاستشارات ("My Consultations"): [conversationsStatus] +
///    [conversations].
/// 2) شاشة محادثة مفتوحة محددة: [activeConversation] + [messages] +
///    [isSendingMessage] + [accessPhase] + [timeRemaining].
///
/// ما في DoctorChatState/PatientChatState منفصلين عمداً - نفس الحالة
/// تخدم الطرفين، والفرق الوحيد هو [currentUserId]/[isCurrentUserDoctor]
/// يلي بتحدد الواجهة عليهم مين "أنا" ومين "الطرف التاني".
class ChatState {
  final String currentUserId;
  final bool isCurrentUserDoctor;

  final ChatConversationsStatus conversationsStatus;
  final List<ChatConversation> conversations;

  final ChatConversation? activeConversation;
  final List<ChatMessage> messages;
  final bool isLoadingMessages;
  final bool isSendingMessage;

  /// حالة صلاحية الدردشة الحالية (بُنيت وقت آخر "تيك" للمؤقت) - راجع
  /// [ConsultationAccessPhase] بموديل chat_model.dart. null إذا ما في
  /// محادثة مفتوحة حالياً.
  final ConsultationAccessPhase? accessPhase;
  final Duration? timeRemaining;

  final String? errorMessage;

  const ChatState({
    required this.currentUserId,
    required this.isCurrentUserDoctor,
    this.conversationsStatus = ChatConversationsStatus.initial,
    this.conversations = const [],
    this.activeConversation,
    this.messages = const [],
    this.isLoadingMessages = false,
    this.isSendingMessage = false,
    this.accessPhase,
    this.timeRemaining,
    this.errorMessage,
  });

  bool get canSendMessage =>
      accessPhase == ConsultationAccessPhase.active ||
      accessPhase == ConsultationAccessPhase.graceWindow;

  ChatState copyWith({
    ChatConversationsStatus? conversationsStatus,
    List<ChatConversation>? conversations,
    ChatConversation? activeConversation,
    bool clearActiveConversation = false,
    List<ChatMessage>? messages,
    bool? isLoadingMessages,
    bool? isSendingMessage,
    ConsultationAccessPhase? accessPhase,
    Duration? timeRemaining,
    bool clearTimeRemaining = false,
    String? errorMessage,
    bool clearError = false,
  }) {
    return ChatState(
      currentUserId: currentUserId,
      isCurrentUserDoctor: isCurrentUserDoctor,
      conversationsStatus: conversationsStatus ?? this.conversationsStatus,
      conversations: conversations ?? this.conversations,
      activeConversation:
          clearActiveConversation ? null : (activeConversation ?? this.activeConversation),
      messages: messages ?? this.messages,
      isLoadingMessages: isLoadingMessages ?? this.isLoadingMessages,
      isSendingMessage: isSendingMessage ?? this.isSendingMessage,
      accessPhase: accessPhase ?? this.accessPhase,
      timeRemaining: clearTimeRemaining ? null : (timeRemaining ?? this.timeRemaining),
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}
