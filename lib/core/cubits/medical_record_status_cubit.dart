import 'package:flutter_bloc/flutter_bloc.dart';

/// ✅ 18/8: هالـ Cubit موجود عشان مشكلة حقيقية كانت عم تصير: كنا
/// نحسب "hasMedicalRecord" مرة وحدة بس من currentUserJson وقت تسجيل
/// الدخول (profile.has_medical_data)، وهاد الفلاغ ما كان بيتحدث أبداً
/// خلال نفس الجلسة - فلو المريض عبّى سجله الطبي لأول مرة، لما يرجع
/// عالـ Overview كان لسا يشوف "ادخل سجلك الطبي" (رغم إنه فعلياً محفوظ
/// بالباك)، وإذا دخل تاني كان يلاقي كل البيانات محفوظة أصلاً - تكرار
/// مربك وخطأ واضح.
///
/// الحل: Cubit بسيط موفّر مرة وحدة على مستوى MainLayoutScreen (أعلى
/// الشجرة)، وأي شاشة تحته - حتى لو Navigator.push (متل معالج تعبئة
/// السجل الطبي لأول مرة) - قادرة توصله عبر context.read وتحدّثه فوراً
/// بمجرد ما يخلّص المريض التعبئة، بدون أي حاجة لتسجيل خروج/دخول جديد.
class MedicalRecordStatusCubit extends Cubit<bool> {
  MedicalRecordStatusCubit(super.initialValue);

  /// يُستدعى فور نجاح حفظ السجل الطبي لأول مرة (بنهاية المعالج) - كل
  /// شاشة عم تراقب هالـ Cubit (متل MainLayoutScreen) رح تنعمل rebuild
  /// فوراً وتعرض الحالة الصحيحة.
  void markHasRecord() => emit(true);
}
