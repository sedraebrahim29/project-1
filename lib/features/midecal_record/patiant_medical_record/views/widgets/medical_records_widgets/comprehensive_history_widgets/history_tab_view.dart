import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../../core/theme/app_colors.dart';
import '../../../../../../../core/constants/app_strings.dart';
import '../../../../../initial_medical_records/models/medical_history_models.dart';
import '../../../../models/medical_record_models/comprehensive_history_models.dart';
import 'history_section_tile_widget.dart';

// =============================================
// محتوى تاب "History" - نفس تصميم Comprehensive History الأكورديون
// الموجود مسبقاً، بس مبني الآن من بيانات حقيقية (Allergy/ChronicCondition/
// Surgery/FamilyHistoryEntry) بدل بيانات وهمية. قسم "Other Conditions"
// اتشال لأنه ما في endpoint له بالباك (كان دايماً فاضي أصلاً).
// =============================================
class HistoryTabView extends StatefulWidget {
  final List<Allergy> allergies;
  final List<ChronicCondition> chronicConditions;
  final List<Surgery> surgeries;
  final List<FamilyHistoryEntry> familyHistory;

  const HistoryTabView({
    super.key,
    required this.allergies,
    required this.chronicConditions,
    required this.surgeries,
    required this.familyHistory,
  });

  @override
  State<HistoryTabView> createState() => _HistoryTabViewState();
}

class _HistoryTabViewState extends State<HistoryTabView> {
  // فتح "Chronic Diseases" افتراضياً بس - نفس سلوك التصميم المرجعي
  final List<bool> _expanded = [true, false, false, false];

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    final sections = <HistorySection>[
      HistorySection(
        title: AppStrings.chronicDiseases(context),
        iconType: 'chronic',
        isExpanded: _expanded[0],
        entries: widget.chronicConditions
            .map((c) => ConditionEntry(
                  name: c.conditionName,
                  status: AppStrings.active(context),
                  metaLabel: AppStrings.diagnosed(context),
                  metaValue: c.diagnosedAt,
                  description: c.notes ?? '',
                ))
            .toList(),
      ),
      HistorySection(
        title: AppStrings.surgeries(context),
        iconType: 'surgery',
        isExpanded: _expanded[1],
        entries: widget.surgeries
            .map((s) => ConditionEntry(
                  name: s.surgeryName,
                  metaLabel: AppStrings.surgeryDateLabel(context),
                  metaValue: s.surgeryDate,
                  description: s.notes ?? '',
                ))
            .toList(),
      ),
      HistorySection(
        title: AppStrings.allergies(context),
        iconType: 'allergy',
        isExpanded: _expanded[2],
        entries: widget.allergies
            .map((a) => ConditionEntry(
                  name: a.allergen,
                  status: a.severity,
                  metaLabel: AppStrings.reactionLabel(context),
                  metaValue: a.reaction,
                  description: '',
                ))
            .toList(),
      ),
      HistorySection(
        title: AppStrings.familyHistory(context),
        iconType: 'family',
        isExpanded: _expanded[3],
        entries: widget.familyHistory
            .map((f) => ConditionEntry(
                  name: f.condition,
                  metaLabel: AppStrings.relationLabel(context),
                  metaValue: f.relation,
                  description: f.notes ?? '',
                ))
            .toList(),
      ),
    ];

    return Container(
      decoration: BoxDecoration(
        color: isDarkMode ? AppColors.darkCard : AppColors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: isDarkMode ? Colors.black.withOpacity(0.2) : Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.r),
        child: Column(
          children: List.generate(sections.length, (index) {
            return Column(
              children: [
                HistorySectionTile(
                  section: sections[index],
                  onToggle: () => setState(() => _expanded[index] = !_expanded[index]),
                ),
                if (sections[index].isExpanded && sections[index].entries.isEmpty)
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                    child: Text(
                      AppStrings.noHistoryRecordsYet(context),
                      style: TextStyle(color: AppColors.textLightGrey, fontSize: 12.sp),
                    ),
                  ),
              ],
            );
          }),
        ),
      ),
    );
  }
}
