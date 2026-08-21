import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../view_models/chat_cubit.dart';
import 'doctor_chat_screen.dart' show ConsultationsListBody;

/// نقطة الدخول للشات من جهة المريض (تاب "المحادثات" بـ CustomBottomNavBar).
///
/// نفس بنية DoctorChatScreen بالضبط - الفرق الوحيد هو تمرير
/// isCurrentUserDoctor: false للـ [ChatCubit]. الواجهة الفعلية (اللائحة
/// وشاشة المحادثة المفردة) مشتركة 100% ومستوردة من doctor_chat_screen.dart
/// (ConsultationsListBody / ConsultationListTile / ConsultationChatDetailScreen)
/// بدل ما تتكرر - راجع التعليق المعماري بأعلى ذاك الملف لتفسير ليش
/// الشاشة المشتركة موجودة هناك تحديداً (قيد أسماء الملفات المحددة
/// بالقسم 23 من الطلب ما فيها ملف مستقل لشاشة المحادثة المفردة).
class PatientChatScreen extends StatefulWidget {
  final String patientId;

  const PatientChatScreen({super.key, required this.patientId});

  @override
  State<PatientChatScreen> createState() => _PatientChatScreenState();
}

class _PatientChatScreenState extends State<PatientChatScreen> {
  late final ChatCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = ChatCubit(currentUserId: widget.patientId, isCurrentUserDoctor: false)
      ..loadConversations();
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: const ConsultationsListBody(),
    );
  }
}
