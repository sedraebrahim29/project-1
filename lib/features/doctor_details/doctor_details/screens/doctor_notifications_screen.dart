import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:untitled3/core/constants/setting.dart';
import '../../../../core/Theme/app_colors.dart';
import '../../../../core/constants/app_strings_doctor.dart';

import '../models/doctor_notification_model.dart';
import '../view_models/doctor_notifications_cubit.dart';
import '../view_models/doctor_notifications_state.dart';

class DoctorNotificationsScreen extends StatelessWidget {
  const DoctorNotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settingsState = context.watch<SettingsCubit>().state;
    final isEn = settingsState.locale.languageCode == 'en';
    final isDark = settingsState.themeMode == ThemeMode.dark;
    final textColor = isDark ? AppColors.darkText : AppColors.textDark;
    final primaryGreen = isDark ? AppColors.darkPrimaryGreen : AppColors.primaryGreen;
    final scaffoldBg = isDark ? AppColors.darkBackground : AppColors.backgroundBeige;
    final cardBg = isDark ? AppColors.darkCard : AppColors.white;

    return Directionality(
      textDirection: isEn ? TextDirection.ltr : TextDirection.rtl,
      child: Scaffold(
        backgroundColor: scaffoldBg,
        appBar: AppBar(
          backgroundColor: scaffoldBg,
          elevation: 0,
          scrolledUnderElevation: 0,
          leading: IconButton(
            icon: Icon(isEn ? Icons.arrow_back_rounded : Icons.arrow_forward_rounded, color: primaryGreen),
            onPressed: () => Navigator.maybePop(context),
          ),
          title: Text(DoctorStrings.doctorNotifications(context),
              style: TextStyle(fontSize: 17.sp, fontWeight: FontWeight.w800, color: primaryGreen)),
          actions: [
            BlocBuilder<DoctorNotificationsCubit, DoctorNotificationsState>(
              builder: (context, state) {
                if (state.items.isEmpty) return const SizedBox.shrink();
                return TextButton(
                  onPressed: () => context.read<DoctorNotificationsCubit>().markAllAsRead(),
                  child: Text(DoctorStrings.markAllRead(context),
                      style: TextStyle(color: primaryGreen, fontSize: 12.5.sp, fontWeight: FontWeight.w700)),
                );
              },
            ),
          ],
        ),
        body: BlocBuilder<DoctorNotificationsCubit, DoctorNotificationsState>(
          builder: (context, state) {
            final cubit = context.read<DoctorNotificationsCubit>();

            if (state.status == DoctorNotificationsStatus.loading || state.status == DoctorNotificationsStatus.initial) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state.items.isEmpty) {
              return Center(
                child: Padding(
                  padding: EdgeInsets.all(24.w),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.notifications_none_rounded, size: 40.sp, color: AppColors.textLightGrey),
                      SizedBox(height: 12.h),
                      Text(DoctorStrings.noNotificationsYet(context),
                          style: TextStyle(color: textColor, fontSize: 15.sp, fontWeight: FontWeight.w700)),
                    ],
                  ),
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () => cubit.load(),
              child: ListView.separated(
                physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
                padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 24.h),
                itemCount: state.items.length,
                separatorBuilder: (_, __) => SizedBox(height: 10.h),
                itemBuilder: (context, index) {
                  final n = state.items[index];
                  return InkWell(
                    onTap: () => cubit.markAsRead(n.id),
                    borderRadius: BorderRadius.circular(14.r),
                    child: Container(
                      padding: EdgeInsets.all(14.w),
                      decoration: BoxDecoration(
                        color: cardBg,
                        borderRadius: BorderRadius.circular(14.r),
                        border: n.isRead ? null : Border.all(color: primaryGreen.withOpacity(0.4)),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 8.w,
                            height: 8.w,
                            margin: EdgeInsets.only(top: 5.h),
                            decoration: BoxDecoration(
                              color: n.isRead ? Colors.transparent : primaryGreen,
                              shape: BoxShape.circle,
                            ),
                          ),
                          SizedBox(width: 10.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(n.title, style: TextStyle(fontSize: 13.5.sp, fontWeight: FontWeight.w700, color: textColor)),
                                SizedBox(height: 4.h),
                                Text(n.body, style: TextStyle(fontSize: 12.5.sp, color: AppColors.textLightGrey, height: 1.4)),
                                SizedBox(height: 6.h),
                                Text(n.createdAt.toString().split('.').first,
                                    style: TextStyle(fontSize: 11.sp, color: AppColors.textLightGrey)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
