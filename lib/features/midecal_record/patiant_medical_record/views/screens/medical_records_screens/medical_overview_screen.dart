import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// --- Models & Core ---
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/constants/app_strings.dart';
import '../../../models/medical_record_models/dashboard_overview_models.dart';
import '../../widgets/medical_records_widgets/dashboard_overview_widgets/overview_cards.dart';
import '../../widgets/medical_records_widgets/dashboard_overview_widgets/overview_tabs_bar.dart';
import '../../widgets/medical_records_widgets/dashboard_overview_widgets/patient_info_card.dart';
import '../../widgets/medical_records_widgets/dashboard_overview_widgets/recent_activity_card.dart';

class MedicalOverviewScreen extends StatefulWidget {
  const MedicalOverviewScreen({super.key});

  @override
  State<MedicalOverviewScreen> createState() => _MedicalOverviewScreenState();
}

class _MedicalOverviewScreenState extends State<MedicalOverviewScreen> {
  int _currentNavIndex = 1;
  int _selectedTabIndex = 0;

  static const PatientInfo _patient = PatientInfo(
    name: 'Alexander Vance',
    age: '35 yrs',
    dob: '12/04/1988',
    bloodType: 'A+',
    height: '180 cm',
    weight: '78 kg',
    avatarAsset: '',
  );

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
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            child: PatientInfoCard(patient: _patient),
          ),
          OverviewTabsBar(
            selectedIndex: _selectedTabIndex,
            onTabSelected: (i) => setState(() => _selectedTabIndex = i),
          ),
          const Divider(height: 1, color: AppColors.borderGrey),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16.w),
              child: Column(
                children: [
                  RecentActivityCard(
                    activities: const [
                      ActivityItem(
                        title: 'Complete Blood Count (CBC)',
                        subtitle: 'Results uploaded by Dr. Sarah Jenkins.',
                        timestamp: 'Today, 09:30 AM',
                        iconType: 'lab',
                      ),
                      ActivityItem(
                        title: 'Prescription Renewed',
                        subtitle: 'Lisinopril 10mg - 30 day supply.',
                        timestamp: 'Oct 24, 2023',
                        iconType: 'prescription',
                      ),
                    ],
                    onViewAll: () {},
                  ),
                  SizedBox(height: 16.h),
                  ActiveMedicationsCard(
                    data: const ActiveMedicationsData(count: 2, label: 'current prescriptions'),
                    onManage: () {},
                  ),
                  SizedBox(height: 16.h),
                  LatestVitalsCard(
                    data: const LatestVitalsData(bp: '120/80', hr: '72 bpm'),
                    onViewTrends: () {},
                  ),
                ],
              ),
            ),
          ),
        ],
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
