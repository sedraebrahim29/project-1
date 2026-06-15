import 'package:flutter/material.dart';

// --- Models ---
import '../../models/medical_profile_models/medical_history_models.dart';
import '../../theme/app_colors.dart';
import '../../widgets/medical_profile_widgets/medical_history_widgets/bottom_action_buttons.dart';
import '../../widgets/medical_profile_widgets/medical_history_widgets/medical_section_card.dart';
import '../../widgets/medical_profile_widgets/medical_history_widgets/step_progress_bar.dart';
import 'medications_screen.dart';


// =============================================
// الشاشة الرئيسية - Medical Profile / Step 2
// مسؤوليتها:
// ١. تحتفظ بحالة الأقسام (مفتوح/مغلق + البيانات)
// ٢. تبني هيكل الصفحة (AppBar, Body, Bottom)
// ٣. تستدعي الـ widgets وتمرر البيانات والـ callbacks
// =============================================
class MedicalHistoryScreen extends StatefulWidget {
  const MedicalHistoryScreen({super.key});

  @override
  State<MedicalHistoryScreen> createState() => _MedicalProfileScreenState();
}

class _MedicalProfileScreenState extends State<MedicalHistoryScreen> {

  // =============================================
  // حالة الأقسام - قابلة للتعديل (mutable state)
  // Chronic Diseases و Surgeries مفتوحان افتراضياً
  // =============================================
  late List<MedicalSection> _sections;

  @override
  void initState() {
    super.initState();
    _sections = [
      // --- Chronic Diseases: مفتوح مع عنصرين ---
      MedicalSection(
        title: 'Chronic Diseases',
        iconAsset: 'assets/icons/chronic.png',
        isExpanded: true,
        entries: const [
          MedicalEntry(
            title: 'Type 2 Diabetes',
            subtitle: 'Diagnosed: 2018 • Controlled with medication',
          ),
          MedicalEntry(
            title: 'Hypertension',
            subtitle: 'Diagnosed: 2020 • Daily monitoring',
          ),
        ],
      ),

      // --- Surgeries: مفتوح مع عنصر واحد ---
      MedicalSection(
        title: 'Surgeries',
        iconAsset: 'assets/icons/surgery.png',
        isExpanded: true,
        entries: const [
          MedicalEntry(
            title: 'Appendectomy',
            subtitle: 'Year: 2012 • No complications',
          ),
        ],
      ),

      // --- Allergies: مغلق بدون عناصر ---
      MedicalSection(
        title: 'Allergies',
        iconAsset: 'assets/icons/allergy.png',
        isExpanded: false,
        entries: const [],
      ),

      // --- Family History: مغلق بدون عناصر ---
      MedicalSection(
        title: 'Family History',
        iconAsset: 'assets/icons/family.png',
        isExpanded: false,
        entries: const [],
      ),
    ];
  }

  // =============================================
  // أيقونة كل قسم وألوان خلفيتها
  // (مفصولة عن الـ model لأنها UI بحتة)
  // =============================================
  Widget _getSectionIcon(int index) {
    switch (index) {
      case 0: // Chronic Diseases - أيقونة نبضات قلب
        return const Icon(Icons.monitor_heart_outlined,
            size: 20, color: Color(0xFFD32F2F));
      case 1: // Surgeries - أيقونة مقص طبي
        return const Icon(Icons.content_cut,
            size: 20, color: Color(0xFF555555));
      case 2: // Allergies - أيقونة فيروس/حساسية
        return const Icon(Icons.coronavirus_outlined,
            size: 20, color: Color(0xFFD32F2F));
      case 3: // Family History - أيقونة عائلة
        return const Icon(Icons.people_outline,
            size: 20, color: Color(0xFF555555));
      default:
        return const Icon(Icons.medical_services_outlined,
            size: 20, color: Color(0xFF555555));
    }
  }

  Color _getSectionIconBg(int index) {
    switch (index) {
      case 0: return AppColors.iconBgPink;  // Chronic - وردي
      case 1: return AppColors.iconBgGrey;  // Surgeries - رمادي
      case 2: return AppColors.iconBgPink;   // Allergies - أحمر فاتح
      case 3: return AppColors.iconBgDark;  // Family - رمادي داكن
      default: return AppColors.iconBgGrey;
    }
  }

  // =============================================
  // فتح/غلق القسم عند الضغط على السهم
  // =============================================
  void _toggleSection(int index) {
    setState(() {
      _sections[index] = _sections[index].copyWith(
        isExpanded: !_sections[index].isExpanded,
      );
    });
  }

  // =============================================
  // حذف عنصر من قسم معين
  // =============================================
  void _deleteEntry(int sectionIndex, MedicalEntry entry) {
    setState(() {
      final updatedEntries = List<MedicalEntry>.from(_sections[sectionIndex].entries)
        ..remove(entry);
      _sections[sectionIndex] = _sections[sectionIndex].copyWith(
        entries: updatedEntries,
      );
    });
  }

  // =============================================
  // Build
  // =============================================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(),
      // bottomNavigationBar ثابت في الأسفل
      bottomNavigationBar: BottomActionButtons(
        onBack: () => Navigator.pop(context),
        onNextStep: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const MedicationsScreen(),
            ),
          );
        },
      ),
      body: _buildBody(),
    );
  }

  // =============================================
  // AppBar Builder
  // =============================================
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.background,
      elevation: 0,
      leading: IconButton(
        // سهم الرجوع للخلف
        icon: const Icon(Icons.arrow_back, color: AppColors.textDark, size: 22),
        onPressed: () => Navigator.pop(context),
      ),
      title: const Text(
        'Medical Profile',
        style: TextStyle(
          color: AppColors.textDark,
          fontSize: 17,
          fontWeight: FontWeight.w700,
        ),
      ),
      centerTitle: false, // العنوان على اليسار بجانب السهم
    );
  }

  // =============================================
  // Body Builder
  // =============================================
  Widget _buildBody() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- شريط التقدم: Step 2 of 5 = 40% ---
          const StepProgressBar(currentStep: 1, totalSteps: 4),

          const SizedBox(height: 24),

          // --- عنوان القسم والوصف ---
          const Text(
            'Medical History',
            style: TextStyle(
              color: AppColors.textDark,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Please provide details about your past and current\nmedical conditions to help us tailor your care.',
            style: TextStyle(
              color: AppColors.textGrey,
              fontSize: 13,
              height: 1.5,
            ),
          ),

          const SizedBox(height: 20),

          // =============================================
          // قائمة الأقسام - استدعاء MedicalSectionCard
          // لكل قسم بياناته وأيقونته وكولباكاته
          // =============================================
          ...List.generate(_sections.length, (index) {
            return MedicalSectionCard(
              section: _sections[index],
              iconWidget: _getSectionIcon(index),
              iconBgColor: _getSectionIconBg(index),
              onToggle: () => _toggleSection(index),
              onAddNew: () {
                // هنا بتفتح dialog أو شاشة إضافة عنصر جديد
              },
              onEdit: (entry) {
                // هنا بتفتح dialog تعديل العنصر
              },
              onDelete: (entry) => _deleteEntry(index, entry),
            );
          }),
        ],
      ),
    );
  }
}