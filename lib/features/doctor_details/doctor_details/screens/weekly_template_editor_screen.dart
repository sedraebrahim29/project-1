import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:untitled3/core/constants/setting.dart';
import '../../../../core/Theme/app_colors.dart';
import '../../../../core/constants/app_strings_doctor.dart';
import '../models/work_schedule_models.dart';
import '../view_models/work_schedule_cubit.dart';
import '../view_models/work_schedule_state.dart';

/// شاشة "تحديد جدول العمل" - رجعناها لنفس الأسلوب يلي كان متفق عليه
/// الأول: تفعيل أيام الأسبوع يلي الطبيب متواجد فيها بهاي العيادة، ولما
/// يفعّل يوم، بيقدر يحدد أوقات دوامه فيه (صباح/بعد ظهر/مساء - من/إلى)
/// كل فترة لحالها. هاي الشاشة هي الأداة الأساسية لبناء/تعديل القالب
/// الأسبوعي كامل دفعة وحدة، وبتحفظ بنداء وحدة (PUT /doctor/schedule/{clinic}).
class WeeklyTemplateEditorScreen extends StatefulWidget {
  final bool embedded;
  const WeeklyTemplateEditorScreen({super.key, this.embedded = false});

  @override
  State<WeeklyTemplateEditorScreen> createState() => _WeeklyTemplateEditorScreenState();
}

class _PeriodEdit {
  bool enabled;
  TimeOfDay start;
  TimeOfDay end;
  _PeriodEdit({this.enabled = false, required this.start, required this.end});
}

class _DayEdit {
  bool enabled;
  final Map<DaySection, _PeriodEdit> periods;
  _DayEdit({this.enabled = false, required this.periods});
}

class _WeeklyTemplateEditorScreenState extends State<WeeklyTemplateEditorScreen> {
  late Map<int, _DayEdit> _days; // dayOfWeek (0=Sun..6=Sat) -> edit state
  late int _consultationDuration;
  late int _breakDuration;
  late bool _bufferEnabled;
  int? _initializedForClinicIndex;

  _DayEdit _freshDay() => _DayEdit(periods: {
        DaySection.morning: _PeriodEdit(start: const TimeOfDay(hour: 9, minute: 0), end: const TimeOfDay(hour: 12, minute: 0)),
        DaySection.afternoon: _PeriodEdit(start: const TimeOfDay(hour: 13, minute: 0), end: const TimeOfDay(hour: 17, minute: 0)),
        DaySection.evening: _PeriodEdit(start: const TimeOfDay(hour: 17, minute: 30), end: const TimeOfDay(hour: 21, minute: 0)),
      });

  void _initFromSchedule(WorkScheduleState state) {
    // ✅ صار يعيد التهيئة كل ما تغيّر اختيار العيادة (مو مرة وحدة بس)،
    // حتى يعرض جدول العيادة الصح لما يبدّل من القائمة المنسدلة.
    if (_initializedForClinicIndex == state.selectedClinicIndex) return;
    _initializedForClinicIndex = state.selectedClinicIndex;
    _consultationDuration = state.schedule?.consultationDuration ?? 30;
    _breakDuration = state.schedule?.breakDuration ?? 10;
    _bufferEnabled = state.schedule?.bufferEnabled ?? true;
    _days = {for (var dow = 0; dow <= 6; dow++) dow: _freshDay()};

    final schedule = state.schedule;
    if (schedule != null) {
      for (final day in schedule.days) {
        final edit = _days[day.dayOfWeek] ?? _freshDay();
        if (day.sessions.isNotEmpty) edit.enabled = true;
        for (final session in day.sessions) {
          final section = _sectionFromKey(session.sessionType);
          if (section == null) continue;
          edit.periods[section] = _PeriodEdit(
            enabled: true,
            start: session.startTimeOfDay,
            end: session.endTimeOfDay,
          );
        }
        _days[day.dayOfWeek] = edit;
      }
    }
  }

  DaySection? _sectionFromKey(String key) {
    switch (key) {
      case 'morning':
        return DaySection.morning;
      case 'afternoon':
        return DaySection.afternoon;
      case 'evening':
        return DaySection.evening;
      default:
        return null;
    }
  }

  Future<void> _save(BuildContext context) async {
    final cubit = context.read<WorkScheduleCubit>();
    final days = <ScheduleDay>[];
    _days.forEach((dow, edit) {
      if (!edit.enabled) return;
      final sessions = <ScheduleSession>[];
      edit.periods.forEach((section, period) {
        if (!period.enabled) return;
        sessions.add(ScheduleSession(
          sessionType: section.sessionTypeKey,
          startTime: _fmt(period.start),
          endTime: _fmt(period.end),
        ));
      });
      if (sessions.isNotEmpty) {
        days.add(ScheduleDay(dayOfWeek: dow, sessions: sessions));
      }
    });

    await cubit.saveWeeklyTemplate(
      days,
      consultationDuration: _consultationDuration,
      breakDuration: _breakDuration,
      bufferEnabled: _bufferEnabled,
    );
    // إذا الشاشة "تاب" جوا DoctorMainLayoutScreen (مو صفحة مدفوعة
    // Navigator.push)، ما في شي نرجعله - منكتفي برسالة النجاح/الفشل
    // يلي BlocConsumer عم يعرضها أصلاً.
    if (!widget.embedded && context.mounted) Navigator.maybePop(context);
  }

  String _fmt(TimeOfDay t) => '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) {
    final settingsState = context.watch<SettingsCubit>().state;
    final isEn = settingsState.locale.languageCode == 'en';
    final isDark = settingsState.themeMode == ThemeMode.dark;
    final scaffoldBg = isDark ? AppColors.darkBackground : AppColors.backgroundBeige;
    final cardBg = isDark ? AppColors.darkCard : AppColors.white;
    final textColor = isDark ? AppColors.darkText : AppColors.textDark;
    final primaryGreen = isDark ? AppColors.darkPrimaryGreen : AppColors.primaryGreen;

    return Directionality(
      textDirection: isEn ? TextDirection.ltr : TextDirection.rtl,
      child: Scaffold(
        backgroundColor: scaffoldBg,
        appBar: widget.embedded
            ? null
            : AppBar(
                backgroundColor: scaffoldBg,
                elevation: 0,
                scrolledUnderElevation: 0,
                leading: IconButton(
                  icon: Icon(isEn ? Icons.arrow_back_rounded : Icons.arrow_forward_rounded, color: primaryGreen),
                  onPressed: () => Navigator.maybePop(context),
                ),
                title: Text(DoctorStrings.workScheduleManagement(context),
                    style: TextStyle(fontSize: 17.sp, fontWeight: FontWeight.w800, color: primaryGreen)),
              ),
        body: BlocConsumer<WorkScheduleCubit, WorkScheduleState>(
          listener: (context, state) {
            if (state.errorMessage != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.errorMessage!), backgroundColor: const Color(0xFFC0392B)),
              );
            }
          },
          builder: (context, state) {
            if (state.clinics.isEmpty) {
              return Center(
                child: Padding(
                  padding: EdgeInsets.all(24.w),
                  child: Text(DoctorStrings.noClinicsYet(context),
                      textAlign: TextAlign.center, style: TextStyle(color: AppColors.textLightGrey, fontSize: 13.sp)),
                ),
              );
            }
            if (state.status == WorkScheduleStatus.initial || state.status == WorkScheduleStatus.loading) {
              return const Center(child: CircularProgressIndicator());
            }
            _initFromSchedule(state);
            final isSaving = state.status == WorkScheduleStatus.saving;

            return Stack(
              children: [
                ListView(
                  padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 100.h),
                  physics: const BouncingScrollPhysics(),
                  children: [
                    if (state.clinics.length > 1)
                      _ClinicDropdown(state: state, isDark: isDark, onPick: (index) => context.read<WorkScheduleCubit>().selectClinic(index)),
                    if (state.clinics.length > 1) SizedBox(height: 16.h),
                    Container(
                      padding: EdgeInsets.all(14.w),
                      decoration: BoxDecoration(color: cardBg, borderRadius: BorderRadius.circular(14.r)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(DoctorStrings.duration(context),
                              style: TextStyle(fontSize: 13.5.sp, fontWeight: FontWeight.w700, color: primaryGreen)),
                          SizedBox(height: 10.h),
                          _stepperRow(DoctorStrings.durationMinutes(context, _consultationDuration), _consultationDuration, 10, 120, 5,
                              textColor, primaryGreen, (v) => setState(() => _consultationDuration = v)),
                          SizedBox(height: 10.h),
                          _stepperRow(DoctorStrings.breakDurationMinutes(context, _breakDuration), _breakDuration, 0, 60, 5, textColor, primaryGreen,
                              (v) => setState(() => _breakDuration = v)),
                          SizedBox(height: 6.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(DoctorStrings.bufferEnabled(context), style: TextStyle(fontSize: 13.sp, color: textColor)),
                              Switch.adaptive(
                                value: _bufferEnabled,
                                activeTrackColor: primaryGreen,
                                onChanged: (v) => setState(() => _bufferEnabled = v),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16.h),
                    for (var dow = 0; dow <= 6; dow++) ...[
                      _DayCard(
                        dayOfWeek: dow,
                        edit: _days[dow]!,
                        isDark: isDark,
                        onToggleDay: (v) => setState(() => _days[dow]!.enabled = v),
                        onTogglePeriod: (section, v) => setState(() => _days[dow]!.periods[section]!.enabled = v),
                        onPickStart: (section) async {
                          final picked = await showTimePicker(context: context, initialTime: _days[dow]!.periods[section]!.start);
                          if (picked != null) setState(() => _days[dow]!.periods[section]!.start = picked);
                        },
                        onPickEnd: (section) async {
                          final picked = await showTimePicker(context: context, initialTime: _days[dow]!.periods[section]!.end);
                          if (picked != null) setState(() => _days[dow]!.periods[section]!.end = picked);
                        },
                      ),
                      SizedBox(height: 10.h),
                    ],
                  ],
                ),
                if (isSaving)
                  Container(color: Colors.black.withOpacity(0.15), child: const Center(child: CircularProgressIndicator())),
              ],
            );
          },
        ),
        bottomNavigationBar: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: SizedBox(
              width: double.infinity,
              height: 50.h,
              child: ElevatedButton(
                onPressed: () => _save(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryGreen,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
                ),
                child: Text(DoctorStrings.saveSchedule(context),
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 15.sp)),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _stepperRow(String label, int value, int min, int max, int step, Color textColor, Color primaryGreen, ValueChanged<int> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 13.sp, color: textColor)),
        SizedBox(height: 8.h),
        Row(
          children: [
            _stepBtn(Icons.remove_rounded, primaryGreen, () => onChanged((value - step).clamp(min, max))),
            SizedBox(width: 14.w),
            SizedBox(
              width: 40.w,
              child: Text('$value', textAlign: TextAlign.center, style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w800, color: primaryGreen)),
            ),
            SizedBox(width: 14.w),
            _stepBtn(Icons.add_rounded, primaryGreen, () => onChanged((value + step).clamp(min, max))),
          ],
        ),
      ],
    );
  }

  Widget _stepBtn(IconData icon, Color primaryGreen, VoidCallback onTap) {
    return Material(
      color: primaryGreen.withOpacity(0.12),
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: SizedBox(
          width: 36,
          height: 36,
          child: Center(child: Icon(icon, size: 18, color: primaryGreen)),
        ),
      ),
    );
  }
}

class _DayCard extends StatelessWidget {
  final int dayOfWeek;
  final _DayEdit edit;
  final bool isDark;
  final ValueChanged<bool> onToggleDay;
  final void Function(DaySection, bool) onTogglePeriod;
  final void Function(DaySection) onPickStart;
  final void Function(DaySection) onPickEnd;

  const _DayCard({
    required this.dayOfWeek,
    required this.edit,
    required this.isDark,
    required this.onToggleDay,
    required this.onTogglePeriod,
    required this.onPickStart,
    required this.onPickEnd,
  });

  @override
  Widget build(BuildContext context) {
    final cardBg = isDark ? AppColors.darkCard : AppColors.white;
    final textColor = isDark ? AppColors.darkText : AppColors.textDark;
    final primaryGreen = isDark ? AppColors.darkPrimaryGreen : AppColors.primaryGreen;
    // DoctorStrings.weekdayFull بتتوقع اتفاقية DateTime (1=اثنين..7=أحد) -
    // نحول من اتفاقية الباك (0=أحد..6=سبت) قبل ما نناديها.
    final dateTimeWeekday = dayOfWeek == 0 ? 7 : dayOfWeek;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(color: cardBg, borderRadius: BorderRadius.circular(14.r)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(DoctorStrings.weekdayFull(context, dateTimeWeekday),
                    style: TextStyle(fontSize: 14.5.sp, fontWeight: FontWeight.w700, color: textColor)),
              ),
              Switch.adaptive(value: edit.enabled, activeTrackColor: primaryGreen, onChanged: onToggleDay),
            ],
          ),
          if (edit.enabled) ...[
            Padding(padding: EdgeInsets.symmetric(vertical: 6.h), child: Divider(height: 1, color: AppColors.borderGrey.withOpacity(0.4))),
            for (final section in DaySection.values) ...[
              _PeriodRow(
                section: section,
                edit: edit.periods[section]!,
                isDark: isDark,
                onToggle: (v) => onTogglePeriod(section, v),
                onPickStart: () => onPickStart(section),
                onPickEnd: () => onPickEnd(section),
              ),
              if (section != DaySection.values.last) SizedBox(height: 8.h),
            ],
          ],
        ],
      ),
    );
  }
}

class _PeriodRow extends StatelessWidget {
  final DaySection section;
  final _PeriodEdit edit;
  final bool isDark;
  final ValueChanged<bool> onToggle;
  final VoidCallback onPickStart;
  final VoidCallback onPickEnd;

  const _PeriodRow({
    required this.section,
    required this.edit,
    required this.isDark,
    required this.onToggle,
    required this.onPickStart,
    required this.onPickEnd,
  });

  String _label(BuildContext context) {
    switch (section) {
      case DaySection.morning:
        return DoctorStrings.morning(context);
      case DaySection.afternoon:
        return DoctorStrings.afternoon(context);
      case DaySection.evening:
        return DoctorStrings.evening(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final textColor = isDark ? AppColors.darkText : AppColors.textDark;
    final primaryGreen = isDark ? AppColors.darkPrimaryGreen : AppColors.primaryGreen;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: edit.enabled ? primaryGreen.withOpacity(0.06) : Colors.transparent,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: Text(_label(context), style: TextStyle(fontSize: 12.5.sp, fontWeight: FontWeight.w600, color: textColor))),
              Transform.scale(
                scale: 0.8,
                child: Switch.adaptive(value: edit.enabled, activeTrackColor: primaryGreen, onChanged: onToggle),
              ),
            ],
          ),
          if (edit.enabled)
            Row(
              children: [
                Expanded(child: _timeChip(context, DoctorStrings.startTime(context), edit.start, textColor, onPickStart)),
                SizedBox(width: 8.w),
                Expanded(child: _timeChip(context, DoctorStrings.endTime(context), edit.end, textColor, onPickEnd)),
              ],
            ),
        ],
      ),
    );
  }

  Widget _timeChip(BuildContext context, String label, TimeOfDay time, Color textColor, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
        decoration: BoxDecoration(border: Border.all(color: AppColors.borderGrey), borderRadius: BorderRadius.circular(8.r)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: TextStyle(fontSize: 10.5.sp, color: AppColors.textLightGrey)),
            Text(time.format(context), style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w700, color: textColor)),
          ],
        ),
      ),
    );
  }
}

/// (منقولة من work_schedule_screen.dart قبل حذفه - راجع تعليق الشاشة
/// بالأعلى: صار اختيار العيادة هون بالشاشة الأساسية، بدل ما يكون
/// موزّع بين شاشتين).
class _ClinicDropdown extends StatelessWidget {
  final WorkScheduleState state;
  final bool isDark;
  final ValueChanged<int> onPick;

  const _ClinicDropdown({required this.state, required this.isDark, required this.onPick});

  @override
  Widget build(BuildContext context) {
    final cardBg = isDark ? AppColors.darkCard : AppColors.white;
    final textColor = isDark ? AppColors.darkText : AppColors.textDark;

    return InkWell(
      borderRadius: BorderRadius.circular(12.r),
      onTap: state.clinics.length <= 1
          ? null
          : () => showModalBottomSheet(
                context: context,
                backgroundColor: cardBg,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20.r))),
                builder: (sheetContext) => SafeArea(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      for (var i = 0; i < state.clinics.length; i++)
                        ListTile(
                          title: Text(state.clinics[i].name, style: TextStyle(color: textColor, fontWeight: FontWeight.w600)),
                          trailing: i == state.selectedClinicIndex
                              ? Icon(Icons.check_rounded, color: isDark ? AppColors.darkPrimaryGreen : AppColors.primaryGreen)
                              : null,
                          onTap: () {
                            Navigator.pop(sheetContext);
                            onPick(i);
                          },
                        ),
                    ],
                  ),
                ),
              ),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        decoration: BoxDecoration(color: cardBg, borderRadius: BorderRadius.circular(12.r)),
        child: Row(
          children: [
            Expanded(
              child: Text(
                state.selectedClinic?.name ?? '',
                style: TextStyle(fontSize: 14.5.sp, fontWeight: FontWeight.w700, color: textColor),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (state.clinics.length > 1) Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.textLightGrey),
          ],
        ),
      ),
    );
  }
}
