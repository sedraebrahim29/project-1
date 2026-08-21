import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:untitled3/core/constants/setting.dart';

import '../../../../core/theme/app_colors.dart';
import '../../models/chat_message_model.dart';

/// فقاعة رسالة واحدة - Widget قابل لإعادة الاستخدام بالكامل بين الطبيب
/// والمريض. ما فيها أي افتراض ثابت "شكل رسائل الطبيب X" أو "شكل رسائل
/// المريض Y" - الملكية بتتحدد فقط عبر [message.isSentBy(currentUserId)]
/// يلي بتحسبها شاشة المحادثة وتمررها كـ [isMine].
class MessageBubble extends StatelessWidget {
  final ChatMessage message;
  final bool isMine;

  /// تُستدعى فقط إذا فشل إرسال الرسالة (status == failed) والمستخدم
  /// ضغط عليها لإعادة المحاولة.
  final VoidCallback? onRetry;

  const MessageBubble({
    super.key,
    required this.message,
    required this.isMine,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final settingsState = context.watch<SettingsCubit>().state;
    final isDark = settingsState.themeMode == ThemeMode.dark;

    final myBubbleColor = isDark ? AppColors.darkPrimaryGreen : AppColors.primaryGreen;
    final otherBubbleColor = isDark ? AppColors.darkCard : AppColors.white;
    final myTextColor = Colors.white;
    final otherTextColor = isDark ? AppColors.darkText : AppColors.textDark;
    final timeColor = isMine ? Colors.white70 : AppColors.textLightGrey;

    final bubbleRadius = BorderRadius.only(
      topLeft: Radius.circular(16.r),
      topRight: Radius.circular(16.r),
      bottomLeft: Radius.circular(isMine ? 16.r : 4.r),
      bottomRight: Radius.circular(isMine ? 4.r : 16.r),
    );

    return Align(
      alignment: isMine ? AlignmentDirectional.centerEnd : AlignmentDirectional.centerStart,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 4.h),
        constraints: BoxConstraints(maxWidth: 0.76.sw),
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: isMine ? myBubbleColor : otherBubbleColor,
          borderRadius: bubbleRadius,
          border: !isMine && !isDark ? Border.all(color: AppColors.borderGrey, width: 1.w) : null,
          boxShadow: isDark
              ? []
              : [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 4, offset: const Offset(0, 2))],
        ),
        child: GestureDetector(
          onTap: message.status == MessageDeliveryStatus.failed ? onRetry : null,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                message.content,
                style: TextStyle(
                  color: isMine ? myTextColor : otherTextColor,
                  fontSize: 14.sp,
                  height: 1.4,
                ),
              ),
              SizedBox(height: 4.h),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _formatTime(message.timestamp),
                    style: TextStyle(color: timeColor, fontSize: 10.5.sp),
                  ),
                  if (isMine) ...[
                    SizedBox(width: 4.w),
                    _StatusIcon(status: message.status),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatTime(DateTime time) {
    final hour24 = time.hour;
    final period = hour24 >= 12 ? 'PM' : 'AM';
    var hour12 = hour24 % 12;
    if (hour12 == 0) hour12 = 12;
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour12:$minute $period';
  }
}

class _StatusIcon extends StatelessWidget {
  final MessageDeliveryStatus status;
  const _StatusIcon({required this.status});

  @override
  Widget build(BuildContext context) {
    switch (status) {
      case MessageDeliveryStatus.sending:
        return SizedBox(
          width: 10.sp,
          height: 10.sp,
          child: const CircularProgressIndicator(strokeWidth: 1.6, color: Colors.white70),
        );
      case MessageDeliveryStatus.sent:
        return Icon(Icons.done_rounded, size: 13.sp, color: Colors.white70);
      case MessageDeliveryStatus.failed:
        return Icon(Icons.error_outline_rounded, size: 13.sp, color: const Color(0xFFFFCDD2));
    }
  }
}
