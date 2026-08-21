import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:untitled3/core/constants/setting.dart';
import '../../../../core/Theme/app_colors.dart';
import '../../../../core/constants/app_strings_doctor.dart';
import '../models/doctor_appointment_models.dart';
import '../view_models/doctor_appointments_cubit.dart';
import '../view_models/doctor_appointments_state.dart';
import 'widgets/appointment_card_widget.dart';

/// شاشة مواعيد الطبيب - حسب المرضى الحاجزين عبر زر "Book"، مقسّمة إلى
/// ثلاث حالات (قادمة/مكتملة/ملغاة) مع تفاصيل كل حجز وإدارة حالته.
class DoctorAppointmentsScreen extends StatelessWidget {
  const DoctorAppointmentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settingsState = context.watch<SettingsCubit>().state;
    final isDark = settingsState.themeMode == ThemeMode.dark;
    final textColor = isDark ? AppColors.darkText : AppColors.textDark;
    final primaryGreen = isDark ? AppColors.darkPrimaryGreen : AppColors.primaryGreen;

    return BlocBuilder<DoctorAppointmentsCubit, DoctorAppointmentsState>(
      builder: (context, state) {
        final cubit = context.read<DoctorAppointmentsCubit>();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 8.h),
              child: Text(DoctorStrings.doctorAppointments(context),
                  style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.w800, color: primaryGreen)),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Row(
                children: [
                  _TabChip(
                    label: DoctorStrings.upcoming(context),
                    selected: state.selectedTab == DoctorAppointmentStatus.upcoming,
                    isDark: isDark,
                    onTap: () => cubit.changeTab(DoctorAppointmentStatus.upcoming),
                  ),
                  SizedBox(width: 8.w),
                  _TabChip(
                    label: DoctorStrings.completed(context),
                    selected: state.selectedTab == DoctorAppointmentStatus.completed,
                    isDark: isDark,
                    onTap: () => cubit.changeTab(DoctorAppointmentStatus.completed),
                  ),
                  SizedBox(width: 8.w),
                  _TabChip(
                    label: DoctorStrings.cancelled(context),
                    selected: state.selectedTab == DoctorAppointmentStatus.cancelled,
                    isDark: isDark,
                    onTap: () => cubit.changeTab(DoctorAppointmentStatus.cancelled),
                  ),
                ],
              ),
            ),
            SizedBox(height: 8.h),
            Expanded(
              child: state.status == DoctorAppointmentsStatus.loading
                  ? const Center(child: CircularProgressIndicator())
                  : state.visible.isEmpty
                      ? Center(
                          child: Padding(
                            padding: EdgeInsets.all(24.w),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.event_note_outlined, size: 40.sp, color: AppColors.textLightGrey),
                                SizedBox(height: 12.h),
                                Text(DoctorStrings.noAppointmentsYet(context),
                                    style: TextStyle(color: textColor, fontSize: 15.sp, fontWeight: FontWeight.w700)),
                                SizedBox(height: 6.h),
                                Text(DoctorStrings.noAppointmentsHint(context),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: AppColors.textLightGrey, fontSize: 12.5.sp, height: 1.5)),
                              ],
                            ),
                          ),
                        )
                      : RefreshIndicator(
                          onRefresh: () => cubit.load(),
                          child: ListView.builder(
                            physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
                            padding: EdgeInsets.fromLTRB(16.w, 4.h, 16.w, 24.h),
                            itemCount: state.visible.length,
                            itemBuilder: (context, index) {
                              final appointment = state.visible[index];
                              return AppointmentCardWidget(
                                appointment: appointment,
                                isDark: isDark,
                                onTap: () => _showDetails(context, appointment, cubit, isDark),
                              );
                            },
                          ),
                        ),
            ),
          ],
        );
      },
    );
  }

  void _showDetails(
    BuildContext context,
    DoctorAppointment appointment,
    DoctorAppointmentsCubit cubit,
    bool isDark,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? AppColors.darkCard : AppColors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20.r))),
      builder: (sheetContext) {
        final textColor = isDark ? AppColors.darkText : AppColors.textDark;
        final primaryGreen = isDark ? AppColors.darkPrimaryGreen : AppColors.primaryGreen;

        return Padding(
          padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 28.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(DoctorStrings.appointmentDetails(sheetContext),
                  style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w800, color: primaryGreen)),
              SizedBox(height: 16.h),
              _DetailLine(label: 'Patient', value: appointment.patientName, textColor: textColor),
              if (appointment.clinicName != null)
                _DetailLine(label: 'Clinic', value: appointment.clinicName!, textColor: textColor),
              _DetailLine(
                  label: DoctorStrings.reasonForVisit(sheetContext),
                  value: appointment.reason ?? '-',
                  textColor: textColor),
              _DetailLine(
                  label: DoctorStrings.bookedOn(sheetContext),
                  value: appointment.bookedAt.toString().split('.').first,
                  textColor: textColor),
              SizedBox(height: 20.h),
              if (appointment.status == DoctorAppointmentStatus.upcoming) ...[
                SizedBox(
                  width: double.infinity,
                  height: 46.h,
                  child: ElevatedButton(
                    onPressed: () {
                      cubit.markCompleted(appointment.id);
                      Navigator.pop(sheetContext);
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: primaryGreen, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r))),
                    child: Text(DoctorStrings.markCompleted(sheetContext),
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
                  ),
                ),
                SizedBox(height: 10.h),
                SizedBox(
                  width: double.infinity,
                  height: 46.h,
                  child: OutlinedButton(
                    onPressed: () {
                      cubit.cancel(appointment.id);
                      Navigator.pop(sheetContext);
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFFC0392B)),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
                    ),
                    child: Text(DoctorStrings.cancelAppointment(sheetContext),
                        style: const TextStyle(color: Color(0xFFC0392B), fontWeight: FontWeight.w700)),
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}

class _DetailLine extends StatelessWidget {
  final String label;
  final String value;
  final Color textColor;
  const _DetailLine({required this.label, required this.value, required this.textColor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 90.w,
            child: Text(label, style: TextStyle(color: AppColors.textLightGrey, fontSize: 12.5.sp)),
          ),
          Expanded(
            child: Text(value, style: TextStyle(color: textColor, fontSize: 13.5.sp, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }
}

class _TabChip extends StatelessWidget {
  final String label;
  final bool selected;
  final bool isDark;
  final VoidCallback onTap;

  const _TabChip({required this.label, required this.selected, required this.isDark, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final primaryGreen = isDark ? AppColors.darkPrimaryGreen : AppColors.primaryGreen;
    final cardBg = isDark ? AppColors.darkCard : AppColors.white;
    final textColor = isDark ? AppColors.darkText : AppColors.textDark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 9.h),
        decoration: BoxDecoration(
          color: selected ? primaryGreen : cardBg,
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Text(label,
            style: TextStyle(
                color: selected ? Colors.white : textColor, fontWeight: FontWeight.w600, fontSize: 12.5.sp)),
      ),
    );
  }
}
