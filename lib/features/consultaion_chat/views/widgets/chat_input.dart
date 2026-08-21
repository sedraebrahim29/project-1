import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:untitled3/core/constants/setting.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';

/// شريط كتابة الرسالة - نفس المكوّن يستخدمه الطبيب والمريض بدون أي
/// تمييز. نص فقط حالياً (بدون مرفقات/صور) حسب طلب المستخدم صراحة.
class ChatInput extends StatefulWidget {
  final ValueChanged<String> onSend;

  /// false لما تكون الاستشارة منتهية (أو ما بدأت بعد) - بيصير الحقل
  /// معطّل مع نص توضيحي بدل الـ hint العادي.
  final bool enabled;

  const ChatInput({super.key, required this.onSend, this.enabled = true});

  @override
  State<ChatInput> createState() => _ChatInputState();
}

class _ChatInputState extends State<ChatInput> {
  final TextEditingController _controller = TextEditingController();
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      final hasText = _controller.text.trim().isNotEmpty;
      if (hasText != _hasText) setState(() => _hasText = hasText);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleSend() {
    final text = _controller.text.trim();
    if (text.isEmpty || !widget.enabled) return;
    widget.onSend(text);
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    final settingsState = context.watch<SettingsCubit>().state;
    final isDark = settingsState.themeMode == ThemeMode.dark;

    final barBg = isDark ? AppColors.darkCard : AppColors.white;
    final fieldBg = isDark ? AppColors.darkBackground : AppColors.backgroundBeige;
    final textColor = isDark ? AppColors.darkText : AppColors.textDark;
    final primaryGreen = isDark ? AppColors.darkPrimaryGreen : AppColors.primaryGreen;
    final canSend = widget.enabled && _hasText;

    return SafeArea(
      top: false,
      child: Container(
        padding: EdgeInsets.fromLTRB(12.w, 8.h, 12.w, 8.h),
        decoration: BoxDecoration(
          color: barBg,
          boxShadow: isDark
              ? []
              : [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, -2))],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: Material(
                color: Colors.transparent,
                child: Container(
                  constraints: BoxConstraints(minHeight: 44.h, maxHeight: 120.h),
                  decoration: BoxDecoration(
                    color: fieldBg,
                    borderRadius: BorderRadius.circular(22.r),
                    border: isDark ? Border.all(color: Colors.white10, width: 1.w) : null,
                  ),
                  child: TextField(
                    controller: _controller,
                    enabled: widget.enabled,
                    minLines: 1,
                    maxLines: 5,
                    textInputAction: TextInputAction.newline,
                    style: TextStyle(color: textColor, fontSize: 14.sp),
                    decoration: InputDecoration(
                      isCollapsed: true,
                      hintText: widget.enabled
                          ? AppStrings.typeMessage(context)
                          : AppStrings.consultationEnded(context),
                      hintStyle: TextStyle(color: AppColors.textLightGrey, fontSize: 13.5.sp),
                      contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                      border: InputBorder.none,
                    ),
                    onSubmitted: (_) => _handleSend(),
                  ),
                ),
              ),
            ),
            SizedBox(width: 8.w),
            Material(
              color: canSend ? primaryGreen : primaryGreen.withOpacity(0.4),
              shape: const CircleBorder(),
              child: InkWell(
                customBorder: const CircleBorder(),
                onTap: canSend ? _handleSend : null,
                child: Padding(
                  padding: EdgeInsets.all(11.r),
                  child: Icon(Icons.send_rounded, color: Colors.white, size: 20.sp),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}