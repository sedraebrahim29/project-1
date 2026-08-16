import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// --- Models & Core ---
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/constants/app_strings.dart';
import '../../../models/medical_record_models/encounter_model.dart';
import '../../widgets/medical_records_widgets/timeline_encounter_card.dart';

// =============================================
// ⚠️ ملاحظة: هاي الشاشة مش مربوطة بأي endpoint حالياً - ما في
// Encounters/Visits API بالـ Postman collection المرسل. تركناها متل
// ما هي (بياناتها Mock). مو مضافة كتاب بشاشة MedicalOverviewScreen
// الجديدة لهاد السبب. لو حبيتوا تفعّلوها لاحقاً، لازم أولاً endpoint
// بالباك يرجع سجل الزيارات/اللقاءات الطبية.
// =============================================
class EncounterTimelineScreen extends StatefulWidget {
  const EncounterTimelineScreen({super.key});

  @override
  State<EncounterTimelineScreen> createState() => _EncounterTimelineScreenState();
}

class _EncounterTimelineScreenState extends State<EncounterTimelineScreen> {
  int _currentNavIndex = 1;

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
              AppStrings.encountersHistory(context),
              style: TextStyle(
                color: AppColors.textDark,
                fontSize: 22.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'Chronological views of your medical visits and diagnoses.',
              style: TextStyle(
                color: AppColors.textLightGrey,
                fontSize: 14.sp,
                height: 1.4,
              ),
            ),
            SizedBox(height: 24.h),
            ...List.generate(_encounters.length, (index) {
              return TimelineEncounterCard(
                encounter: _encounters[index],
                isLast: index == _encounters.length - 1,
                onViewDetails: () {},
              );
            }),
            SizedBox(height: 16.h),
            Center(
              child: Text(
                'End of recent history',
                style: TextStyle(
                  color: AppColors.textLightGrey,
                  fontSize: 12.sp,
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
