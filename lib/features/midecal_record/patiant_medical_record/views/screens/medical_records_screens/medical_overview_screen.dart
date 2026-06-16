import 'package:flutter/material.dart';

// --- Models ---
import '../../../../../../core/theme/app_colors.dart';
import '../../../models/medical_record_models/dashboard_overview_models.dart';
import '../../widgets/medical_records_widgets/dashboard_overview_widgets/overview_cards.dart';
import '../../widgets/medical_records_widgets/dashboard_overview_widgets/overview_tabs_bar.dart';
import '../../widgets/medical_records_widgets/dashboard_overview_widgets/patient_info_card.dart';
import '../../widgets/medical_records_widgets/dashboard_overview_widgets/recent_activity_card.dart';

// =============================================
// شاشة Medical Records - Overview
// تعرض: معلومات المريض + Tabs + Recent Activity
//        + Active Medications + Latest Vitals
// =============================================
class MedicalOverviewScreen extends StatefulWidget {
  const MedicalOverviewScreen({super.key});

  @override
  State<MedicalOverviewScreen> createState() => _MedicalOverviewScreenState();
}

class _MedicalOverviewScreenState extends State<MedicalOverviewScreen> {
  int _currentNavIndex = 1;  // Records محدد
  int _selectedTabIndex = 0; // Overview محدد

  // =============================================
  // بيانات المريض
  // =============================================
  static const PatientInfo _patient = PatientInfo(
    name: 'Alexander Vance',
    age: '35 yrs',
    dob: '12/04/1988',
    bloodType: 'A+',
    height: '180 cm',
    weight: '78 kg',
    avatarAsset: '',
  );

  // =============================================
  // بيانات Recent Activity
  // =============================================
  static const List<ActivityItem> _activities = [
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
  ];

  // =============================================
  // بيانات Active Medications
  // =============================================
  static const ActiveMedicationsData _medsData = ActiveMedicationsData(
    count: 2,
    label: 'current prescriptions',
  );

  // =============================================
  // بيانات Latest Vitals
  // =============================================
  static const LatestVitalsData _vitalsData = LatestVitalsData(
    bp: '120/80',
    hr: '72 bpm',
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(),
      bottomNavigationBar: _buildBottomNavBar(),
      body: _buildBody(),
    );
  }

  // =============================================
  // AppBar ♻️
  // =============================================
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.background,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back,
            color: AppColors.textDark, size: 22),
        onPressed: () => Navigator.pop(context),
      ),
      title: const Text(
        'Medical Records',
        style: TextStyle(
          color: AppColors.textDark,
          fontSize: 17,
          fontWeight: FontWeight.w700,
        ),
      ),
      centerTitle: false,
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: CircleAvatar(
            radius: 18,
            backgroundColor: AppColors.avatarBg,
            child: const Icon(Icons.person, color: Colors.grey, size: 20),
          ),
        ),
      ],
    );
  }

  // =============================================
  // Body Builder
  // =============================================
  Widget _buildBody() {
    return Column(
      children: [
        // كارد المريض + Tabs خارج الـ scroll
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
          child: PatientInfoCard(patient: _patient),
        ),

        const SizedBox(height: 12),

        // شريط الـ Tabs
        OverviewTabsBar(
          selectedIndex: _selectedTabIndex,
          onTabSelected: (i) => setState(() => _selectedTabIndex = i),
        ),

        // Divider تحت الـ Tabs
        const Divider(height: 1, color: AppColors.dividerColor),

        // باقي المحتوى قابل للـ scroll
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
            child: Column(
              children: [
                // Recent Activity
                RecentActivityCard(
                  activities: _activities,
                  onViewAll: () {},
                ),

                const SizedBox(height: 14),

                // Active Medications
                ActiveMedicationsCard(
                  data: _medsData,
                  onManage: () {},
                ),

                const SizedBox(height: 14),

                // Latest Vitals
                LatestVitalsCard(
                  data: _vitalsData,
                  onViewTrends: () {},
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // =============================================
  // BottomNavigationBar ♻️
  // =============================================
  Widget _buildBottomNavBar() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: AppColors.navBarShadow,
            blurRadius: 8,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: _currentNavIndex,
        onTap: (i) => setState(() => _currentNavIndex = i),
        backgroundColor: Colors.white,
        selectedItemColor: AppColors.primaryGreen,
        unselectedItemColor: AppColors.textGrey,
        selectedLabelStyle: const TextStyle(
            fontSize: 11, fontWeight: FontWeight.w500),
        unselectedLabelStyle: const TextStyle(fontSize: 11),
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.folder_outlined),
            activeIcon: Icon(Icons.folder),
            label: 'Records',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today_outlined),
            activeIcon: Icon(Icons.calendar_today),
            label: 'Visits',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}