import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:untitled3/core/constants/setting.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../models/chat_model.dart';
import '../view_models/chat_cubit.dart';
import '../view_models/chat_state.dart';
import 'widgets/chat_input.dart';
import 'widgets/message_bubble.dart';

/// خلفية الوضع الداكن الخاصة بفيتشر الاستشارات - أخضر غامق (مو رمادي/أسود
/// افتراضي) حتى يتناسب مع باقي ألوان التطبيق (AppColors.primaryGreen /
/// darkPrimaryGreen). عرّفناها هون محلياً بدل التعديل على core/Theme/app_colors.dart
/// المشترك مع باقي الشاشات - حتى ما نأثر على أي فيتشر تاني بالتطبيق.
const Color _consultationDarkBg = Color(0xFF122019);

/// نقطة الدخول للشات من جهة الطبيب (تاب "شات" بـ DoctorBottomNavBar).
/// Widget من دون Scaffold/AppBar خاص فيه - هو "body" بيترّكب جوا
/// DoctorMainLayoutScreen (نفس أسلوب DoctorAppointmentsScreen)، لأنو
/// الـ AppBar والـ BottomNav موجودين أصلاً بالشاشة الأم.
///
/// ملاحظة معمارية: شاشة "المحادثة المفتوحة" (ConsultationChatDetailScreen)
/// وبطاقة عنصر اللائحة (ConsultationListTile) معرّفين بهاد الملف
/// ومشتركين مع PatientChatScreen (يستوردهم من هون) بدل ما ننشئ ملفات
/// إضافية - المستخدم حدد صراحة أسماء الملفات المطلوبة بالمجلد (القسم
/// 23 بالطلب) ومافيها ملف مخصص لشاشة المحادثة المفردة، فتفادينا تكرار
/// نفس الواجهة بملفين مختلفين (doctor/patient) عن طريق تعريفها مرة
/// وحدة هون واستيرادها.
class DoctorChatScreen extends StatefulWidget {
  final int doctorId;

  const DoctorChatScreen({super.key, required this.doctorId});

  @override
  State<DoctorChatScreen> createState() => _DoctorChatScreenState();
}

class _DoctorChatScreenState extends State<DoctorChatScreen> {
  late final ChatCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = ChatCubit(currentUserId: widget.doctorId.toString(), isCurrentUserDoctor: true)
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

/// جسم شاشة اللائحة - مشترك بالكامل (نفس الكود بالضبط) بين الطبيب
/// والمريض، الفرق فقط بمصدر البيانات (isCurrentUserDoctor بالـ Cubit).
/// عام (public) عمداً حتى يستورده patient_chat_screen.dart بدل ما
/// يعيد كتابة نفس الواجهة (راجع التعليق المعماري بأعلى هالملف).
///
/// 🎨 التصميم هون مطابق للـ mockup يلي زوّدنا فيه المستخدم (CareFlow):
/// شريط بحث "Search messages..." + أزرار فلترة (All / Unread / Urgent)
/// + بطاقات لائحة بيضاء/داكنة مسطحة (بدون حدود واضحة، بس ظل خفيف)
/// فيها صورة رمزية، اسم، آخر رسالة، والوقت + بادج/نقطة حسب الحالة.
/// أضفنا كمان زر تبديل فاتح/داكن (مو موجود بالـ mockup، انطلب صراحة)
/// بجانب شريط البحث مباشرة.
class ConsultationsListBody extends StatefulWidget {
  const ConsultationsListBody({super.key});

  @override
  State<ConsultationsListBody> createState() => _ConsultationsListBodyState();
}

enum _ConsultationFilter { all, unread, urgent }

class _ConsultationsListBodyState extends State<ConsultationsListBody> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';
  _ConsultationFilter _filter = _ConsultationFilter.all;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      final q = _searchController.text.trim().toLowerCase();
      if (q != _query) setState(() => _query = q);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<ChatConversation> _applyFilters(List<ChatConversation> conversations, bool isCurrentUserDoctor) {
    var list = conversations;

    if (_query.isNotEmpty) {
      list = list.where((c) {
        final name = c.otherParticipantName(isCurrentUserDoctor: isCurrentUserDoctor).toLowerCase();
        final preview = (c.lastMessagePreview ?? '').toLowerCase();
        return name.contains(_query) || preview.contains(_query);
      }).toList();
    }

    switch (_filter) {
      case _ConsultationFilter.unread:
        return list.where((c) => c.unreadCount > 0).toList();
      case _ConsultationFilter.urgent:
        return list.where((c) => c.isUrgent).toList();
      case _ConsultationFilter.all:
        return list;
    }
  }

  @override
  Widget build(BuildContext context) {
    final settingsState = context.watch<SettingsCubit>().state;
    final isDark = settingsState.themeMode == ThemeMode.dark;
    final textColor = isDark ? AppColors.darkText : AppColors.textDark;
    final fieldBg = isDark ? AppColors.darkCard : AppColors.white;
    final primaryGreen = isDark ? AppColors.darkPrimaryGreen : AppColors.primaryGreen;
    final fieldBorder = isDark ? Colors.white10 : AppColors.borderGrey;

    return BlocBuilder<ChatCubit, ChatState>(
      builder: (context, state) {
        final cubit = context.read<ChatCubit>();
        final filtered = _applyFilters(state.conversations, state.isCurrentUserDoctor);

        // 🔧 Material يلي لافّين فيه هون بدل ما نرجّع الـ Column مباشرة
        // بيحل 3 مشاكل مع بعض:
        // 1. الخط الأصفر تحت كل نص: بيصير لما الـ Text/TextField ما
        //    تحتهم Material حقيقي بأقرب سلف، فبيصير عندها TextStyle
        //    افتراضي فيه underline أصفر واضح كتحذير من Flutter. هلق
        //    الشاشة صارت تجيب Material أكيد مهما كان مكان تركيبها.
        // 2. الخلفية السوداء: صرنا نحدد لون الخلفية صراحة - أخضر غامق
        //    بالدارك مود، بيج فاتح باللايت - بدل ما تعتمد على خلفية
        //    افتراضية جايي من فوق.
        // 3. تغطية الشريط العلوي: SafeArea بأعلى الشاشة عم يضيف مسافة
        //    حتى المحتوى ما ينحجب وراء status bar الموبايل.
        return Material(
          color: isDark ? _consultationDarkBg : AppColors.backgroundBeige,
          child: SafeArea(
            top: true,
            bottom: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // --- شريط البحث + زر تبديل الوضع الفاتح/الداكن ---
                Padding(
                  padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Material(
                          color: Colors.transparent,
                          child: Container(
                            height: 46.h,
                            padding: EdgeInsets.symmetric(horizontal: 14.w),
                            decoration: BoxDecoration(
                              color: fieldBg,
                              borderRadius: BorderRadius.circular(14.r),
                              border: Border.all(color: fieldBorder, width: 1.w),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.search_rounded, color: AppColors.textLightGrey, size: 20.sp),
                                SizedBox(width: 8.w),
                                Expanded(
                                  child: TextField(
                                    controller: _searchController,
                                    style: TextStyle(color: textColor, fontSize: 14.sp),
                                    decoration: InputDecoration(
                                      isCollapsed: true,
                                      border: InputBorder.none,
                                      hintText: AppStrings.searchMessages(context),
                                      hintStyle: TextStyle(color: AppColors.textLightGrey, fontSize: 14.sp),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 10.w),
                      // زر تبديل الوضع الفاتح/الداكن - مضاف بناءً على طلب المستخدم
                      // صراحة، بيستخدم SettingsCubit.toggleTheme() الموجود أصلاً
                      // (نفس الآلية المستخدمة بقائمة الإعدادات settings_drawer_widget.dart).
                      Semantics(
                        button: true,
                        label: isDark ? 'Switch to light mode' : 'Switch to dark mode',
                        child: GestureDetector(
                          onTap: () => context.read<SettingsCubit>().toggleTheme(),
                          child: Container(
                            width: 46.h,
                            height: 46.h,
                            decoration: BoxDecoration(
                              color: fieldBg,
                              borderRadius: BorderRadius.circular(14.r),
                              border: Border.all(color: fieldBorder, width: 1.w),
                            ),
                            child: Icon(
                              isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
                              color: primaryGreen,
                              size: 20.sp,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // --- شرائح الفلترة All / Unread / Urgent ---
                Padding(
                  padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 0),
                  child: Row(
                    children: [
                      _FilterChip(
                        label: AppStrings.filterAll(context),
                        selected: _filter == _ConsultationFilter.all,
                        isDark: isDark,
                        onTap: () => setState(() => _filter = _ConsultationFilter.all),
                      ),
                      SizedBox(width: 8.w),
                      _FilterChip(
                        label: AppStrings.filterUnread(context),
                        selected: _filter == _ConsultationFilter.unread,
                        isDark: isDark,
                        onTap: () => setState(() => _filter = _ConsultationFilter.unread),
                      ),
                      SizedBox(width: 8.w),
                      _FilterChip(
                        label: AppStrings.filterUrgent(context),
                        selected: _filter == _ConsultationFilter.urgent,
                        isDark: isDark,
                        onTap: () => setState(() => _filter = _ConsultationFilter.urgent),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10.h),

                Expanded(
                  child: state.conversationsStatus == ChatConversationsStatus.loading
                      ? const Center(child: CircularProgressIndicator())
                      : filtered.isEmpty
                      ? Center(
                    child: Padding(
                      padding: EdgeInsets.all(24.w),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.chat_bubble_outline_rounded, size: 40.sp, color: AppColors.textLightGrey),
                          SizedBox(height: 12.h),
                          Text(AppStrings.noConsultationsYet(context),
                              style: TextStyle(color: textColor, fontSize: 15.sp, fontWeight: FontWeight.w700)),
                          SizedBox(height: 6.h),
                          Text(AppStrings.noConsultationsHint(context),
                              textAlign: TextAlign.center,
                              style: TextStyle(color: AppColors.textLightGrey, fontSize: 12.5.sp, height: 1.5)),
                        ],
                      ),
                    ),
                  )
                      : RefreshIndicator(
                    onRefresh: () => cubit.loadConversations(),
                    child: ListView.builder(
                      physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
                      padding: EdgeInsets.fromLTRB(16.w, 4.h, 16.w, 24.h),
                      itemCount: filtered.length,
                      itemBuilder: (context, index) {
                        final conversation = filtered[index];
                        return ConsultationListTile(
                          conversation: conversation,
                          isCurrentUserDoctor: state.isCurrentUserDoctor,
                          isDark: isDark,
                          onTap: () async {
                            await cubit.openConversation(conversation);
                            if (!context.mounted) return;
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => BlocProvider.value(
                                  value: cubit,
                                  child: const ConsultationChatDetailScreen(),
                                ),
                              ),
                            );
                            cubit.stopPhaseTimer();
                          },
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// شريحة فلترة واحدة (All/Unread/Urgent) - مطابقة لشكل الـ mockup:
/// شريحة محددة معبّأة باللون الأساسي مع نص أبيض، وغير محددة بحدود خفيفة.
class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final bool isDark;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.selected,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final primaryGreen = isDark ? AppColors.darkPrimaryGreen : AppColors.primaryGreen;
    final unselectedBg = isDark ? AppColors.darkCard : AppColors.white;
    final unselectedText = isDark ? AppColors.darkText : AppColors.textDark;
    final borderColor = isDark ? Colors.white10 : AppColors.borderGrey;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 9.h),
        decoration: BoxDecoration(
          color: selected ? primaryGreen : unselectedBg,
          borderRadius: BorderRadius.circular(24.r),
          border: selected ? null : Border.all(color: borderColor, width: 1.w),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.white : unselectedText,
            fontSize: 13.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

/// عنصر واحد بلائحة "استشاراتي" - مشترك بين الطبيب والمريض، بيعرض اسم
/// الطرف الآخر (يحدده isCurrentUserDoctor) وآخر رسالة ووقتها + بادج
/// غير مقروء (unreadCount) أو مؤشر عاجل (isUrgent) حسب بيانات المحادثة.
class ConsultationListTile extends StatelessWidget {
  final ChatConversation conversation;
  final bool isCurrentUserDoctor;
  final bool isDark;
  final VoidCallback onTap;

  const ConsultationListTile({
    super.key,
    required this.conversation,
    required this.isCurrentUserDoctor,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cardBgColor = isDark ? AppColors.darkCard : AppColors.white;
    final textColor = isDark ? AppColors.darkText : AppColors.textDark;
    final primaryGreenColor = isDark ? AppColors.darkPrimaryGreen : AppColors.primaryGreen;
    const urgentRed = Color(0xFFC0392B);

    final otherName = conversation.otherParticipantName(isCurrentUserDoctor: isCurrentUserDoctor);
    final initials = _initialsOf(otherName);
    final hasUnread = conversation.unreadCount > 0;
    final timeColor = conversation.isUrgent ? urgentRed : AppColors.textLightGrey;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 10.h),
        padding: EdgeInsets.all(12.r),
        decoration: BoxDecoration(
          color: cardBgColor,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDark ? 0.22 : 0.05),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                CircleAvatar(
                  radius: 26.r,
                  backgroundColor: isDark ? Colors.black26 : AppColors.backgroundBeige,
                  child: Text(initials,
                      style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold, color: primaryGreenColor)),
                ),
                // نقطة حمراء صغيرة على الصورة الرمزية لما تكون المحادثة عاجلة
                // (Urgent) - مطابقة لعنصر "Elena Rodriguez" بالـ mockup.
                if (conversation.isUrgent)
                  Positioned(
                    right: -1,
                    bottom: -1,
                    child: Container(
                      width: 12.w,
                      height: 12.w,
                      decoration: BoxDecoration(
                        color: urgentRed,
                        shape: BoxShape.circle,
                        border: Border.all(color: cardBgColor, width: 2.w),
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(otherName,
                      style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w700, color: textColor),
                      overflow: TextOverflow.ellipsis),
                  SizedBox(height: 3.h),
                  Text(
                    conversation.lastMessagePreview ?? AppStrings.noMessagesYet(context),
                    style: TextStyle(fontSize: 12.5.sp, color: AppColors.textLightGrey, height: 1.35),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            SizedBox(width: 8.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (conversation.lastMessageAt != null)
                  Text(
                    _formatRelative(context, conversation.lastMessageAt!),
                    style: TextStyle(fontSize: 11.sp, color: timeColor, fontWeight: conversation.isUrgent ? FontWeight.w700 : FontWeight.w400),
                  ),
                if (hasUnread) ...[
                  SizedBox(height: 8.h),
                  Container(
                    width: 20.w,
                    height: 20.w,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(color: primaryGreenColor, shape: BoxShape.circle),
                    child: Text(
                      conversation.unreadCount > 9 ? '9+' : '${conversation.unreadCount}',
                      style: TextStyle(color: Colors.white, fontSize: 10.5.sp, fontWeight: FontWeight.w700),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _initialsOf(String name) {
    final parts = name.trim().split(RegExp(r'\s+')).where((p) => p.isNotEmpty).toList();
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    return (parts.first.substring(0, 1) + parts.last.substring(0, 1)).toUpperCase();
  }

  String _formatRelative(BuildContext context, DateTime time) {
    final now = DateTime.now();
    final isToday = now.year == time.year && now.month == time.month && now.day == time.day;
    final yesterday = now.subtract(const Duration(days: 1));
    final isYesterday =
        yesterday.year == time.year && yesterday.month == time.month && yesterday.day == time.day;

    if (isToday) {
      final hour24 = time.hour;
      final period = hour24 >= 12 ? 'PM' : 'AM';
      var hour12 = hour24 % 12;
      if (hour12 == 0) hour12 = 12;
      final minute = time.minute.toString().padLeft(2, '0');
      return '$hour12:$minute $period';
    }
    if (isYesterday) return AppStrings.yesterday(context);

    // خلال آخر أسبوع: اسم اليوم مختصر (مطابق لمثال "Tue" بالـ mockup).
    final daysAgo = now.difference(time).inDays;
    if (daysAgo < 7) return AppStrings.weekdayShort(context, time.weekday);

    return '${time.day}/${time.month}/${time.year}';
  }
}

/// شاشة المحادثة المفردة المفتوحة - مشتركة بالكامل بين الطبيب والمريض
/// (القسم 4-B بالطلب). لا تحتاج أي بارامتر لأنها بتقرأ المحادثة
/// النشطة (activeConversation) من الـ [ChatCubit] المُمرَّر إلها عبر
/// BlocProvider.value وقت الفتح (راجع ConsultationsListBody).
class ConsultationChatDetailScreen extends StatefulWidget {
  const ConsultationChatDetailScreen({super.key});

  @override
  State<ConsultationChatDetailScreen> createState() => _ConsultationChatDetailScreenState();
}

class _ConsultationChatDetailScreenState extends State<ConsultationChatDetailScreen> {
  final ScrollController _scrollController = ScrollController();
  int _lastMessageCount = 0;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottomIfNeeded(int messageCount) {
    if (messageCount == _lastMessageCount) return;
    _lastMessageCount = messageCount;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final settingsState = context.watch<SettingsCubit>().state;
    final isDark = settingsState.themeMode == ThemeMode.dark;
    final scaffoldBg = isDark ? _consultationDarkBg : AppColors.backgroundBeige;
    final appBarBg = isDark ? AppColors.darkCard : AppColors.white;
    final textColor = isDark ? AppColors.darkText : AppColors.textDark;
    final primaryGreen = isDark ? AppColors.darkPrimaryGreen : AppColors.primaryGreen;

    return BlocBuilder<ChatCubit, ChatState>(
      builder: (context, state) {
        final conversation = state.activeConversation;
        if (conversation == null) {
          // ما في محادثة نشطة (لم تُفتح بشكل صحيح) - حماية بسيطة بدل شاشة فاضية بيضاء.
          return Scaffold(
            backgroundColor: scaffoldBg,
            body: Center(child: Text(AppStrings.somethingWentWrong(context), style: TextStyle(color: textColor))),
          );
        }

        final otherName = conversation.otherParticipantName(isCurrentUserDoctor: state.isCurrentUserDoctor);
        _scrollToBottomIfNeeded(state.messages.length);

        return Scaffold(
          backgroundColor: scaffoldBg,
          appBar: AppBar(
            backgroundColor: appBarBg,
            elevation: 0,
            scrolledUnderElevation: 0,
            iconTheme: IconThemeData(color: textColor),
            titleSpacing: 8.w,
            title: Row(
              children: [
                CircleAvatar(
                  radius: 18.r,
                  backgroundColor: primaryGreen.withOpacity(0.15),
                  child: Icon(Icons.person_outline, color: primaryGreen, size: 18.sp),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(otherName,
                          style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w700, color: textColor),
                          overflow: TextOverflow.ellipsis),
                      Text(AppStrings.onlineConsultation(context),
                          style: TextStyle(fontSize: 11.sp, color: AppColors.textLightGrey)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          body: SafeArea(
            child: Column(
              children: [
                _ConsultationStatusBanner(
                  phase: state.accessPhase,
                  timeRemaining: state.timeRemaining,
                  isDark: isDark,
                ),
                Expanded(
                  child: state.isLoadingMessages
                      ? const Center(child: CircularProgressIndicator())
                      : state.messages.isEmpty
                      ? Center(
                    child: Padding(
                      padding: EdgeInsets.all(24.w),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.forum_outlined, size: 36.sp, color: AppColors.textLightGrey),
                          SizedBox(height: 10.h),
                          Text(AppStrings.noMessagesYet(context),
                              style: TextStyle(color: textColor, fontSize: 14.5.sp, fontWeight: FontWeight.w700)),
                          SizedBox(height: 4.h),
                          Text(AppStrings.noMessagesHint(context),
                              textAlign: TextAlign.center,
                              style: TextStyle(color: AppColors.textLightGrey, fontSize: 12.sp)),
                        ],
                      ),
                    ),
                  )
                      : ListView.builder(
                    controller: _scrollController,
                    padding: EdgeInsets.fromLTRB(14.w, 12.h, 14.w, 12.h),
                    itemCount: state.messages.length,
                    itemBuilder: (context, index) {
                      final message = state.messages[index];
                      return MessageBubble(
                        message: message,
                        isMine: message.isSentBy(state.currentUserId),
                        onRetry: () => context.read<ChatCubit>().retryMessage(message.id),
                      );
                    },
                  ),
                ),
                ChatInput(
                  enabled: state.canSendMessage,
                  onSend: (text) => context.read<ChatCubit>().sendMessage(text),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// شريط حالة الاستشارة (فعّالة/الوقت المتبقي/منتهية/وقت إضافي للمريض)
/// - عرض فقط، بدون أي تطبيق فعلي لمنع الإرسال (هاد بيصير بالباك لاحقاً
/// - راجع تعليق القسم 7 بالطلب "Do NOT implement backend enforcement").
class _ConsultationStatusBanner extends StatelessWidget {
  final ConsultationAccessPhase? phase;
  final Duration? timeRemaining;
  final bool isDark;

  const _ConsultationStatusBanner({required this.phase, required this.timeRemaining, required this.isDark});

  @override
  Widget build(BuildContext context) {
    if (phase == null) return const SizedBox.shrink();

    late final Color bg;
    late final Color fg;
    late final IconData icon;
    late final String label;

    switch (phase!) {
      case ConsultationAccessPhase.scheduled:
        bg = AppColors.textLightGrey.withOpacity(0.12);
        fg = AppColors.textLightGrey;
        icon = Icons.schedule_rounded;
        label = AppStrings.consultationNotStarted(context);
        break;
      case ConsultationAccessPhase.active:
        final primaryGreen = isDark ? AppColors.darkPrimaryGreen : AppColors.primaryGreen;
        bg = primaryGreen.withOpacity(0.12);
        fg = primaryGreen;
        icon = Icons.circle;
        label = '${AppStrings.consultationActive(context)}'
            '${timeRemaining != null ? ' • ${AppStrings.timeRemaining(context)}: ${_formatDuration(timeRemaining!)}' : ''}';
        break;
      case ConsultationAccessPhase.graceWindow:
        const amber = Color(0xFFB98900);
        bg = amber.withOpacity(0.12);
        fg = amber;
        icon = Icons.hourglass_bottom_rounded;
        label = '${AppStrings.extraTime(context)}'
            '${timeRemaining != null ? ' • ${_formatDuration(timeRemaining!)}' : ''}';
        break;
      case ConsultationAccessPhase.ended:
        const danger = Color(0xFFC0392B);
        bg = danger.withOpacity(0.10);
        fg = danger;
        icon = Icons.event_busy_rounded;
        label = AppStrings.consultationEnded(context);
        break;
    }

    return Container(
      width: double.infinity,
      color: bg,
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
      child: Row(
        children: [
          Icon(icon, size: phase == ConsultationAccessPhase.active ? 8.sp : 15.sp, color: fg),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(label, style: TextStyle(color: fg, fontSize: 12.sp, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }

  String _formatDuration(Duration d) {
    final minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    if (d.inHours > 0) {
      return '${d.inHours}:$minutes:$seconds';
    }
    return '$minutes:$seconds';
  }
}