import '../models/attached_model.dart';

enum AttachmentStatus { initial, loading, loaded, uploading, failure }

class AttachmentState {
  final AttachmentStatus status;
  final List<AttachedFile> attachments;
  final String? errorMessage;

  const AttachmentState({
    this.status = AttachmentStatus.initial,
    this.attachments = const [],
    this.errorMessage,
  });

  AttachmentState copyWith({
    AttachmentStatus? status,
    List<AttachedFile>? attachments,
    String? errorMessage,
  }) {
    return AttachmentState(
      status: status ?? this.status,
      attachments: attachments ?? this.attachments,
      errorMessage: errorMessage,
    );
  }
}
