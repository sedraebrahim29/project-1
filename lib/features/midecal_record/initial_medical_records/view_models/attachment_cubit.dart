import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/medical_record_repository.dart';
import '../../../../core/network/api_exception.dart';
import 'attachment_state.dart';

class AttachmentCubit extends Cubit<AttachmentState> {
  final MedicalRecordRepository _repository;

  AttachmentCubit({MedicalRecordRepository? repository})
      : _repository = repository ?? MedicalRecordRepository(),
        super(const AttachmentState());

  Future<void> loadAttachments() async {
    emit(state.copyWith(status: AttachmentStatus.loading, errorMessage: null));
    try {
      final attachments = await _repository.getAttachments();
      emit(state.copyWith(status: AttachmentStatus.loaded, attachments: attachments));
    } on ApiException catch (e) {
      emit(state.copyWith(status: AttachmentStatus.failure, errorMessage: e.message));
    }
  }

  /// [type] هو التصنيف يلي بيختاره المستخدم (مثلاً "Lab Results"،
  /// "X-ray photo")، مو اسم الملف - الباك ما بيخزن اسم الملف الأصلي.
  Future<void> uploadAttachment({
    required List<int> bytes,
    required String filename,
    required String type,
  }) async {
    emit(state.copyWith(status: AttachmentStatus.uploading, errorMessage: null));
    try {
      final ext = filename.contains('.') ? filename.split('.').last.toLowerCase() : '';
      final created = await _repository.uploadAttachment(
        bytes: bytes,
        filename: filename,
        type: type,
        mimeSubtype: ext.isNotEmpty ? ext : null,
      );
      emit(state.copyWith(
        status: AttachmentStatus.loaded,
        attachments: [...state.attachments, created],
      ));
    } on ApiException catch (e) {
      emit(state.copyWith(status: AttachmentStatus.failure, errorMessage: e.message));
    }
  }

  Future<void> deleteAttachment(int id) async {
    try {
      await _repository.deleteAttachment(id);
      emit(state.copyWith(attachments: state.attachments.where((a) => a.id != id).toList()));
    } on ApiException catch (e) {
      emit(state.copyWith(status: AttachmentStatus.failure, errorMessage: e.message));
    }
  }
}
