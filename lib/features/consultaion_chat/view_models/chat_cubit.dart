import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/chat_repository.dart';
import '../models/chat_message_model.dart';
import '../models/chat_model.dart';
import 'chat_state.dart';

/// Cubit واحد مشترك بين الطبيب والمريض - ما في DoctorChatCubit ولا
/// PatientChatCubit. الفرق بين الدورين بيتحدد فقط عبر [currentUserId]/
/// [isCurrentUserDoctor] يلي بينمررو وقت الإنشاء (من DoctorChatScreen
/// أو PatientChatScreen)، ونفس الكود بالضبط بيشتغل عليهم الاثنين.
///
/// نفس الـ instance بتنعاد استخدامه (عبر BlocProvider.value) من شاشة
/// اللائحة "My Consultations" لحتى شاشة المحادثة المفتوحة (نفس نمط
/// DoctorMainLayoutScreen مع DoctorNotificationsCubit).
class ChatCubit extends Cubit<ChatState> {
  final ChatRepository _repository;
  Timer? _phaseTimer;

  ChatCubit({
    required String currentUserId,
    required bool isCurrentUserDoctor,
    ChatRepository? repository,
  })  : _repository = repository ?? LocalChatRepository(),
        super(ChatState(
          currentUserId: currentUserId,
          isCurrentUserDoctor: isCurrentUserDoctor,
        ));

  // -------------------------------------------------------------
  // لائحة الاستشارات ("My Consultations")
  // -------------------------------------------------------------

  Future<void> loadConversations() async {
    emit(state.copyWith(conversationsStatus: ChatConversationsStatus.loading, clearError: true));
    try {
      final conversations = await _repository.getConversations(
        currentUserId: state.currentUserId,
        isCurrentUserDoctor: state.isCurrentUserDoctor,
      );
      emit(state.copyWith(
        conversationsStatus: ChatConversationsStatus.loaded,
        conversations: conversations,
      ));
    } catch (_) {
      emit(state.copyWith(conversationsStatus: ChatConversationsStatus.failure));
    }
  }

  // -------------------------------------------------------------
  // محادثة مفتوحة
  // -------------------------------------------------------------

  Future<void> openConversation(ChatConversation conversation) async {
    _phaseTimer?.cancel();
    emit(state.copyWith(
      activeConversation: conversation,
      isLoadingMessages: true,
      messages: const [],
      clearError: true,
    ));

    _recomputeAccessPhase();
    _phaseTimer = Timer.periodic(const Duration(seconds: 1), (_) => _recomputeAccessPhase());

    try {
      final messages = await _repository.getMessages(conversation.id);
      emit(state.copyWith(messages: messages, isLoadingMessages: false));
    } catch (_) {
      emit(state.copyWith(
        isLoadingMessages: false,
        errorMessage: 'failed_to_load_messages',
      ));
    }
  }

  /// تُستدعى عند مغادرة شاشة المحادثة (dispose) حتى نوقف مؤقت حساب
  /// الوقت المتبقي بدون داعي لإبقاء activeConversation/messages -
  /// هيك إذا رجع المستخدم على نفس المحادثة بسرعة ما منعيد تحميلها.
  void stopPhaseTimer() => _phaseTimer?.cancel();

  void _recomputeAccessPhase() {
    final conversation = state.activeConversation;
    if (conversation == null) return;
    final phase = conversation.phaseFor(isCurrentUserDoctor: state.isCurrentUserDoctor);
    final remaining = conversation.remainingFor(isCurrentUserDoctor: state.isCurrentUserDoctor);
    emit(state.copyWith(
      accessPhase: phase,
      timeRemaining: remaining,
      clearTimeRemaining: remaining == null,
    ));
  }

  Future<void> sendMessage(String content) async {
    final conversation = state.activeConversation;
    final text = content.trim();
    if (conversation == null || text.isEmpty) return;
    if (!state.canSendMessage) return;

    final receiverId =
        state.isCurrentUserDoctor ? conversation.patientId : conversation.doctorId;

    final optimisticMessage = ChatMessage(
      id: 'local_${DateTime.now().microsecondsSinceEpoch}',
      conversationId: conversation.id,
      senderId: state.currentUserId,
      receiverId: receiverId,
      content: text,
      timestamp: DateTime.now(),
      status: MessageDeliveryStatus.sending,
    );

    emit(state.copyWith(
      messages: [...state.messages, optimisticMessage],
      isSendingMessage: true,
    ));

    try {
      final confirmed = await _repository.sendMessage(optimisticMessage);
      final updated = state.messages
          .map((m) => m.id == optimisticMessage.id ? confirmed : m)
          .toList();
      emit(state.copyWith(messages: updated, isSendingMessage: false));
    } catch (_) {
      final updated = state.messages
          .map((m) => m.id == optimisticMessage.id
              ? m.copyWith(status: MessageDeliveryStatus.failed)
              : m)
          .toList();
      emit(state.copyWith(messages: updated, isSendingMessage: false));
    }
  }

  /// إعادة محاولة إرسال رسالة فشلت (راجع MessageDeliveryStatus.failed).
  Future<void> retryMessage(String messageId) async {
    final message = state.messages.where((m) => m.id == messageId).toList();
    if (message.isEmpty) return;
    final updated = state.messages
        .map((m) => m.id == messageId ? m.copyWith(status: MessageDeliveryStatus.sending) : m)
        .toList();
    emit(state.copyWith(messages: updated));

    try {
      final confirmed = await _repository.sendMessage(message.first);
      final refreshed =
          state.messages.map((m) => m.id == messageId ? confirmed : m).toList();
      emit(state.copyWith(messages: refreshed));
    } catch (_) {
      final refreshed = state.messages
          .map((m) => m.id == messageId ? m.copyWith(status: MessageDeliveryStatus.failed) : m)
          .toList();
      emit(state.copyWith(messages: refreshed));
    }
  }

  @override
  Future<void> close() {
    _phaseTimer?.cancel();
    return super.close();
  }
}
