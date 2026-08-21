import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:untitled3/core/constants/setting.dart';
import '../../../../core/Theme/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../auth/Login.dart';

import '../models/patient_profile_dummy_data.dart';
import '../views/widgets/settings_drawer_widget.dart';
import 'widgets/confirm_action_dialog.dart';

/// Displays the signed-in patient's profile. Pass [profile] explicitly when
/// wiring this up to a real data source — it defaults to the dummy record
/// so the screen can be dropped in and pushed on its own.
class PatientProfileScreen extends StatelessWidget {
  final PatientProfileModel profile;

  const PatientProfileScreen({super.key, this.profile = dummyPatientProfile});

  @override
  Widget build(BuildContext context) {
    final settingsState = context.watch<SettingsCubit>().state;
    final settingsCubit = context.read<SettingsCubit>();
    final isEn = settingsState.locale.languageCode == 'en';
    final currentScale = settingsState.fontScale;
    final isDark = settingsState.themeMode == ThemeMode.dark;

    double nameSize = 22.sp;
    double sectionLabelSize = 12.sp;
    double rowLabelSize = 12.sp;
    double rowValueSize = 15.sp;
    if (currentScale == FontScale.medium) {
      nameSize = 25.sp; sectionLabelSize = 14.sp; rowLabelSize = 14.sp; rowValueSize = 17.sp;
    } else if (currentScale == FontScale.large) {
      nameSize = 28.sp; sectionLabelSize = 16.sp; rowLabelSize = 16.sp; rowValueSize = 19.sp;
    }

    final scaffoldBg = isDark ? AppColors.darkBackground : AppColors.backgroundBeige;
    final cardBg = isDark ? AppColors.darkCard : AppColors.white;
    final textColor = isDark ? AppColors.darkText : AppColors.textDark;
    final primaryGreenColor = isDark ? AppColors.darkPrimaryGreen : AppColors.primaryGreen;
    const dangerColor = Color(0xFFC0392B);

    return Directionality(
      textDirection: isEn ? TextDirection.ltr : TextDirection.rtl,
      child: Scaffold(
        backgroundColor: scaffoldBg,
        appBar: AppBar(
          backgroundColor: scaffoldBg,
          elevation: 0,
          scrolledUnderElevation: 0,
          titleSpacing: 4.w,
          leading: IconButton(
            icon: Icon(isEn ? Icons.arrow_back_rounded : Icons.arrow_forward_rounded, color: primaryGreenColor),
            onPressed: () => Navigator.maybePop(context),
          ),
          title: Text(
            AppStrings.profile(context),
            style: TextStyle(fontSize: nameSize * 0.8, fontWeight: FontWeight.w800, color: primaryGreenColor),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.more_vert_rounded, color: textColor),
              onPressed: () => showSettingsDrawer(context),
            ),
          ],
        ),
        body: ListView(
          padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 32.h),
          physics: const BouncingScrollPhysics(),
          children: [
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 56.r,
                    backgroundColor: primaryGreenColor.withOpacity(0.15),
                    backgroundImage: profile.avatarUrl != null ? NetworkImage(profile.avatarUrl!) : null,
                    child: profile.avatarUrl == null
                        ? Text(
                      profile.initials,
                      style: TextStyle(fontSize: 34.sp, fontWeight: FontWeight.bold, color: primaryGreenColor),
                    )
                        : null,
                  ),
                  Positioned(
                    bottom: 0,
                    right: isEn ? 0 : null,
                    left: isEn ? null : 0,
                    child: Container(
                      width: 30.r,
                      height: 30.r,
                      decoration: BoxDecoration(
                        color: primaryGreenColor,
                        shape: BoxShape.circle,
                        border: Border.all(color: scaffoldBg, width: 2.w),
                      ),
                      child: Icon(Icons.camera_alt_rounded, color: AppColors.white, size: 14.sp),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 14.h),
            Text(
              profile.fullName,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: nameSize, fontWeight: FontWeight.w800, color: primaryGreenColor),
            ),
            SizedBox(height: 10.h),
            Center(
              child: OutlinedButton.icon(
                onPressed: () {},
                icon: Icon(Icons.edit_outlined, size: 16.sp, color: primaryGreenColor),
                label: Text(AppStrings.editProfile(context), style: TextStyle(color: primaryGreenColor, fontWeight: FontWeight.w600)),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: primaryGreenColor.withOpacity(0.4), width: 1.w),
                  padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 10.h),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.r)),
                ),
              ),
            ),
            SizedBox(height: 28.h),

            _SectionLabel(AppStrings.personalInformation(context), sectionLabelSize),
            SizedBox(height: 10.h),
            _InfoCard(cardBg: cardBg, children: [
              _InfoRow(
                icon: Icons.calendar_today_rounded,
                label: AppStrings.dateOfBirth(context),
                value: profile.dateOfBirth,
                iconBg: primaryGreenColor,
                textColor: textColor,
                labelSize: rowLabelSize,
                valueSize: rowValueSize,
              ),
              _rowDivider(),
              _InfoRow(
                icon: Icons.person_outline_rounded,
                label: AppStrings.gender(context),
                value: profile.gender == 'Male' ? AppStrings.male(context) : AppStrings.female(context),
                iconBg: primaryGreenColor,
                textColor: textColor,
                labelSize: rowLabelSize,
                valueSize: rowValueSize,
              ),
            ]),
            SizedBox(height: 24.h),

            _SectionLabel(AppStrings.contactDetails(context), sectionLabelSize),
            SizedBox(height: 10.h),
            _InfoCard(cardBg: cardBg, children: [
              _InfoRow(
                icon: Icons.mail_outline_rounded,
                label: AppStrings.email(context),
                value: profile.email,
                iconBg: primaryGreenColor,
                textColor: textColor,
                labelSize: rowLabelSize,
                valueSize: rowValueSize,
                trailing: profile.isEmailVerified
                    ? Icon(Icons.verified_rounded, color: AppColors.textLightGrey, size: 18.sp)
                    : null,
              ),
              _rowDivider(),
              _InfoRow(
                icon: Icons.call_outlined,
                label: AppStrings.phoneNumber(context),
                value: profile.phoneNumber,
                iconBg: primaryGreenColor,
                textColor: textColor,
                labelSize: rowLabelSize,
                valueSize: rowValueSize,
              ),
            ]),
            SizedBox(height: 24.h),

            _SectionLabel(AppStrings.address(context), sectionLabelSize),
            SizedBox(height: 10.h),
            _InfoCard(cardBg: cardBg, children: [
              _InfoRow(
                icon: Icons.location_on_outlined,
                label: AppStrings.homeAddress(context),
                value: profile.homeAddress,
                iconBg: primaryGreenColor,
                textColor: textColor,
                labelSize: rowLabelSize,
                valueSize: rowValueSize,
              ),
            ]),
            SizedBox(height: 24.h),

            _SectionLabel(AppStrings.appSettings(context), sectionLabelSize),
            SizedBox(height: 10.h),
            _InfoCard(cardBg: cardBg, children: [
              _ActionRow(
                icon: Icons.lock_outline_rounded,
                label: AppStrings.changePassword(context),
                textColor: textColor,
                labelSize: rowValueSize,
                trailing: Icon(Icons.chevron_right_rounded, color: AppColors.textLightGrey),
                onTap: () {},
              ),
              _rowDivider(),
              _ActionRow(
                onTap: () {},
                icon: Icons.notifications_none_rounded,
                label: AppStrings.notificationSettings(context),
                textColor: textColor,
                labelSize: rowValueSize,
                trailing: Transform.scale(
                  scale: 0.85,
                  child: Switch.adaptive(
                    value: settingsState.notificationsEnabled,
                    activeColor: isDark ? AppColors.darkBackground : AppColors.white,
                    activeTrackColor: primaryGreenColor,
                    onChanged: settingsCubit.toggleNotifications,
                  ),
                ),
              ),
              _rowDivider(),
              _ActionRow(
                icon: Icons.logout_rounded,
                label: AppStrings.logOut(context),
                textColor: dangerColor,
                iconColor: dangerColor,
                labelSize: rowValueSize,
                onTap: () async {
                  final loggedOut = await showConfirmActionDialog(
                    context,
                    title: AppStrings.logOutConfirmTitle(context),
                    description: AppStrings.logOutConfirmDesc(context),
                    confirmLabel: AppStrings.logOut(context),
                    cancelLabel: AppStrings.cancel(context),
                    onConfirm: (cubit) => cubit.logOut(),
                  );
                  // بعد ما يأكد وتنمسح جلسته فعلياً (توكن + نداء /auth/logout)،
                  // منوديه لشاشة تسجيل الدخول ومنمسح كامل تاريخ التنقل خلفها
                  // حتى ما يقدر يرجع بزر الـ back لصفحات كانت تحتاج تسجيل دخول.
                  if (loggedOut == true && context.mounted) {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (_) => const LoginScreen()),
                      (route) => false,
                    );
                  }
                },
              ),
              _rowDivider(),
              _ActionRow(
                icon: Icons.delete_outline_rounded,
                label: AppStrings.deleteAccount(context),
                textColor: dangerColor,
                iconColor: dangerColor,
                labelSize: rowValueSize,
                showIconBg: false,
                onTap: () => showConfirmActionDialog(
                  context,
                  title: AppStrings.deleteAccountTitle(context),
                  description: AppStrings.deleteAccountDesc(context),
                  confirmLabel: AppStrings.delete(context),
                  cancelLabel: AppStrings.cancel(context),
                  onConfirm: (cubit) => cubit.deleteAccount(),
                ),
              ),
            ]),
          ],
        ),
      ),
    );
  }

  static Widget _rowDivider() => Divider(color: AppColors.borderGrey.withOpacity(0.4), height: 1);
}

class _SectionLabel extends StatelessWidget {
  final String text;
  final double size;
  const _SectionLabel(this.text, this.size);

  @override
  Widget build(BuildContext context) {
    return Text(
      text.toUpperCase(),
      style: TextStyle(fontSize: size, fontWeight: FontWeight.w700, color: AppColors.textLightGrey, letterSpacing: 0.6),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final Color cardBg;
  final List<Widget> children;
  const _InfoCard({required this.cardBg, required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
      decoration: BoxDecoration(color: cardBg, borderRadius: BorderRadius.circular(16.r)),
      child: Column(children: children),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color iconBg;
  final Color textColor;
  final double labelSize;
  final double valueSize;
  final Widget? trailing;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.iconBg,
    required this.textColor,
    required this.labelSize,
    required this.valueSize,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 34.r,
            height: 34.r,
            decoration: BoxDecoration(color: iconBg.withOpacity(0.12), borderRadius: BorderRadius.circular(10.r)),
            alignment: Alignment.center,
            child: Icon(icon, size: 17.sp, color: iconBg),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: TextStyle(fontSize: labelSize, color: AppColors.textLightGrey)),
                SizedBox(height: 3.h),
                Text(value, style: TextStyle(fontSize: valueSize, fontWeight: FontWeight.w700, color: textColor)),
              ],
            ),
          ),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}

class _ActionRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color textColor;
  final Color? iconColor;
  final double labelSize;
  final Widget? trailing;
  final bool showIconBg;
  final VoidCallback onTap;

  const _ActionRow({
    required this.icon,
    required this.label,
    required this.textColor,
    this.iconColor,
    required this.labelSize,
    this.trailing,
    this.showIconBg = true,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 14.h),
        child: Row(
          children: [
            Icon(icon, size: 20.sp, color: iconColor ?? textColor),
            SizedBox(width: 14.w),
            Expanded(
              child: Text(label, style: TextStyle(fontSize: labelSize, fontWeight: FontWeight.w600, color: textColor)),
            ),
            if (trailing != null) trailing!,
          ],
        ),
      ),
    );
  }
}
