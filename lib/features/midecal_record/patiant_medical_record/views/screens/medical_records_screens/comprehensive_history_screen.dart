import 'package:flutter/material.dart';

// --- Models ---

import '../../../../../../core/theme/app_colors.dart';
import '../../../models/medical_record_models/comprehensive_history_models.dart';
import '../../widgets/medical_records_widgets/comprehensive_history_widgets/history_section_tile_widget.dart';

// =============================================
// شاشة Comprehensive History
// تعرض أقسام قابلة للطي: Chronic Diseases,
// Surgeries, Allergies, Family History, Other
// =============================================
class ComprehensiveHistoryScreen extends StatefulWidget {
  const ComprehensiveHistoryScreen({super.key});

  @override
  State<ComprehensiveHistoryScreen> createState() =>
      _ComprehensiveHistoryScreenState();
}

class _ComprehensiveHistoryScreenState
    extends State<ComprehensiveHistoryScreen> {

  int _currentNavIndex = 1; // Records محدد

  // =============================================
  // بيانات الأقسام — Chronic Diseases مفتوح افتراضياً
  // =============================================
  late List<HistorySection> _sections;

  @override
  void initState() {
    super.initState();
    _sections = [
      // --- Chronic Diseases: مفتوح مع حالتين ---
      const HistorySection(
        title: 'Chronic Diseases',
        iconType: 'chronic',
        isExpanded: true,
        entries: [
          ConditionEntry(
            name: 'Hypertension',
            status: 'Active',
            diagnosedYear: '2018',
            description:
            'Currently managed with Amlodipine 5mg daily. Blood pressure readings remain stable within target ranges during recent home monitoring.',
          ),
          ConditionEntry(
            name: 'Type 2 Diabetes',
            status: 'Active',
            diagnosedYear: '2020',
            description:
            'Diet-controlled with supplemental Metformin 500mg. Last HbA1c at 6.2% indicating good glycemic control.',
          ),
        ],
      ),

      // --- Surgeries: مغلق ---
      const HistorySection(
        title: 'Surgeries',
        iconType: 'surgery',
        isExpanded: false,
      ),

      // --- Allergies: مغلق ---
      const HistorySection(
        title: 'Allergies',
        iconType: 'allergy',
        isExpanded: false,
      ),

      // --- Family History: مغلق ---
      const HistorySection(
        title: 'Family History',
        iconType: 'family',
        isExpanded: false,
      ),

      // --- Other Conditions: مغلق ---
      const HistorySection(
        title: 'Other conditions',
        iconType: 'other',
        isExpanded: false,
      ),
    ];
  }

  // فتح/غلق القسم
  void _toggleSection(int index) {
    setState(() {
      _sections[index] = _sections[index].copyWith(
        isExpanded: !_sections[index].isExpanded,
      );
    });
  }

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
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- عنوان ووصف ---
          const Text(
            'Comprehensive History',
            style: TextStyle(
              color: AppColors.textDark,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Review your diagnosed conditions, procedures, and relevant medical background.',
            style: TextStyle(
              color: AppColors.textGrey,
              fontSize: 13,
              height: 1.4,
            ),
          ),

          const SizedBox(height: 20),

          // --- الكارد الأبيض الموحد لكل الأقسام ---
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: const [
                BoxShadow(
                  color: AppColors.cardShadow,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
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