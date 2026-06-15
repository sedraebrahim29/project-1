import 'package:flutter/material.dart';

// --- Models ---
import '../../models/medical_record_models/encounter_model.dart';
import '../../theme/app_colors.dart';
import '../../widgets/medical_records/timeline_encounter_card.dart';

// =============================================
// شاشة Medical Records
// تعرض timeline للزيارات الطبية السابقة
// =============================================
class EncounterTimelineScreen extends StatefulWidget {
  const EncounterTimelineScreen({super.key});

  @override
  State<EncounterTimelineScreen> createState() => _MedicalRecordsScreenState();
}

class _MedicalRecordsScreenState extends State<EncounterTimelineScreen> {
  // index الـ BottomNav — Records = 1
  int _currentNavIndex = 1;

  // =============================================
  // بيانات الزيارات
  // =============================================
  final List<Encounter> _encounters = const [
    Encounter(
      date: 'OCT 24, 2023',
      visitType: 'FOLLOW-UP',
      doctorName: 'Dr. Sarah Jenkins',
      specialty: 'Cardiology',
      avatarAsset: 'assets/images/dr_sarah.png',
      diagnosisSummary:
      'Stable sinus rhythm. Mild hypertension noted, well-controlled with current medication regimen.',
      doctorNotes:
      'Patient reports feeling more energetic. Continue current dosage of Lisinopril. Recommended moderate aerobic exercise 3x a week. Schedule next routine check in 6 months.',
    ),
    Encounter(
      date: 'SEP 15, 2023',
      visitType: 'CONSULTATION',
      doctorName: 'Dr. Michael Chen',
      specialty: 'General Practice',
      avatarAsset: 'assets/images/dr_michael.png',
      diagnosisSummary:
      'Acute upper respiratory infection. Viral etiology suspected.',
      doctorNotes:
      'Advised rest, hydration, and over-the-counter antipyretics for fever management. Prescribed short course of cough suppressant for nighttime relief. Follow up if symptoms worsen or persist beyond 7-10 days.',
    ),
  ];

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
  // AppBar — سهم رجوع + عنوان + صورة profile
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
        // صورة الـ profile الدائرية يمين الـ AppBar
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
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- عنوان ووصف الشاشة ---
          const Text(
            'Encounters History',
            style: TextStyle(
              color: AppColors.textDark,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Chronological view of your medical visits and diagnoses.',
            style: TextStyle(
              color: AppColors.textGrey,
              fontSize: 13,
              height: 1.4,
            ),
          ),

          const SizedBox(height: 20),

          // =============================================
          // الـ Timeline — قائمة الزيارات
          // =============================================
          ...List.generate(_encounters.length, (index) {
            return TimelineEncounterCard(
              encounter: _encounters[index],
              isLast: index == _encounters.length - 1,
              onViewDetails: () {
                // التنقل لشاشة تفاصيل الزيارة
              },
            );
          }),

          const SizedBox(height: 8),

          // --- نص نهاية التاريخ ---
          const Center(
            child: Text(
              'End of recent history',
              style: TextStyle(
                color: AppColors.textGrey,
                fontSize: 12,
              ),
            ),
          ),

          const SizedBox(height: 16),
        ],
      ),
    );
  }

  // =============================================
  // BottomNavigationBar
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
        onTap: (index) => setState(() => _currentNavIndex = index),
        backgroundColor: Colors.white,
        selectedItemColor: AppColors.primaryGreen,
        unselectedItemColor: AppColors.textGrey,
        selectedLabelStyle: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w500,
        ),
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