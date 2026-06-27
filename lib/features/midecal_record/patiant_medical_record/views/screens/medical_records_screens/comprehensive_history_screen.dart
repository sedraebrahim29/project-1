import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// --- Models & Core ---
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/constants/app_strings.dart';
import '../../../models/medical_record_models/comprehensive_history_models.dart';
import '../../widgets/medical_records_widgets/comprehensive_history_widgets/history_section_tile_widget.dart';

class ComprehensiveHistoryScreen extends StatefulWidget {
  const ComprehensiveHistoryScreen({super.key});

  @override
  State<ComprehensiveHistoryScreen> createState() =>
      _ComprehensiveHistoryScreenState();
}

class _ComprehensiveHistoryScreenState
    extends State<ComprehensiveHistoryScreen> {

  int _currentNavIndex = 1;

  late List<HistorySection> _sections;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _sections = [
      HistorySection(
        title: AppStrings.chronicDiseases(context),
        iconType: 'chronic',
        isExpanded: true,
        entries: [
          const ConditionEntry(
            name: 'Hypertension',
            status: 'Active',
            diagnosedYear: '2018',
            description:
            'Currently managed with Amlodipine 5mg daily. Blood pressure readings remain stable within target ranges during recent home monitoring.',
          ),
          const ConditionEntry(
            name: 'Type 2 Diabetes',
            status: 'Active',
            diagnosedYear: '2020',
            description:
            'Diet-controlled with supplemental Metformin 500mg. Last HbA1c at 6.2% indicating good glycemic control.',
          ),
        ],
      ),
      HistorySection(
        title: AppStrings.surgeries(context),
        iconType: 'surgery',
        isExpanded: false,
      ),
      HistorySection(
        title: AppStrings.allergies(context),
        iconType: 'allergy',
        isExpanded: false,
      ),
      HistorySection(
        title: AppStrings.familyHistory(context),
        iconType: 'family',
        isExpanded: false,
      ),
      HistorySection(
        title: AppStrings.otherConditions(context),
        iconType: 'other',
        isExpanded: false,
      ),
    ];
  }

  void _toggleSection(int index) {
    setState(() {
      _sections[index] = _sections[index].copyWith(
        isExpanded: !_sections[index].isExpanded,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: AppColors.backgroundBeige,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundBeige,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textDark),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          AppStrings.medicalRecords(context),
          style: theme.textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 18.sp,
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: CircleAvatar(
              radius: 18.r,
              backgroundColor: AppColors.borderGrey,
              child: Icon(Icons.person, color: AppColors.textLightGrey, size: 20.sp),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNavBar(),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppStrings.comprehensiveHistory(context),
              style: TextStyle(
                color: AppColors.textDark,
                fontSize: 22.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'Review your diagnosed conditions, procedures, and relevant medical background.',
              style: TextStyle(
                color: AppColors.textLightGrey,
                fontSize: 14.sp,
                height: 1.4,
              ),
            ),
            SizedBox(height: 24.h),
            Container(
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(12.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12.r),
                child: Column(
                  children: List.generate(_sections.length, (index) {
                    return HistorySectionTile(
                      section: _sections[index],
                      onToggle: () => _toggleSection(index),
                    );
                  }),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavBar() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -2)),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: _currentNavIndex,
        onTap: (i) => setState(() => _currentNavIndex = i),
        backgroundColor: AppColors.white,
        selectedItemColor: AppColors.primaryGreen,
        unselectedItemColor: AppColors.textLightGrey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.folder_outlined), label: 'Records'),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today_outlined), label: 'Visits'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profile'),
        ],
      ),
    );
  }
}
