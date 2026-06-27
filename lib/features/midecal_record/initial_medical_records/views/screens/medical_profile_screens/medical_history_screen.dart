import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// --- Models ---
import '../../../../../../core/constants/app_strings.dart';
import '../../../../../../core/constants/setting.dart';
import '../../../models/medical_profile_models/medical_history_models.dart';

// --- Widgets ---
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
  void didChangeDependencies() {
    super.didChangeDependencies();
    // نستخدم didChangeDependencies حتى نتمكن من الوصول لـ AppStrings المعتمدة على الـ context
    _sections = [
      // --- Chronic Diseases: مفتوح مع عنصرين ---
      MedicalSection(
        title: AppStrings.chronicDiseasesSection(context),
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
        title: AppStrings.surgeriesSection(context),
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
        title: AppStrings.allergiesSection(context),
        iconAsset: 'assets/icons/allergy.png',
        isExpanded: false,
        entries: const [],
      ),

      // --- Family History: مغلق بدون عناصر ---
      MedicalSection(
        title: AppStrings.familyHistorySection(context),
        iconAsset: 'assets/icons/family.png',
        isExpanded: false,
        entries: const [],
      ),
    ];
  }

  // =============================================
  // أيقونة كل قسم تتبع ثيم وألوان التطبيق ديناميكياً
  // =============================================
  Widget _getSectionIcon(int index, ThemeData theme) {
    switch (index) {
      case 0: // Chronic Diseases
        return const Icon(
          Icons.monitor_heart_outlined,
          size: 20,
          color: Color(0xFFD32F2F),
        );
      case 1: // Surgeries
        return Icon(
          Icons.content_cut,
          size: 20,
          color: theme.textTheme.bodyMedium?.color,
        );
      case 2: // Allergies
        return const Icon(
          Icons.coronavirus_outlined,
          size: 20,
          color: Color(0xFFD32F2F),
        );
      case 3: // Family History
        return Icon(
          Icons.people_outline,
          size: 20,
          color: theme.textTheme.bodyMedium?.color,
        );
      default:
        return Icon(
          Icons.medical_services_outlined,
          size: 20,
          color: theme.primaryColor,
        );
    }
  }

  Color _getSectionIconBg(int index, ThemeData theme) {
    // نعتمد على ألوان متناسقة مع الوضع الداكن والفاتح من الـ theme
    final isDark = theme.brightness == Brightness.dark;
    switch (index) {
      case 0:
      case 2:
        return isDark
            ? const Color(0xFF421D1D)
            : const Color(0xFFFFEBEE); // وردي / أحمر خفيف
      case 1:
      case 3:
        return theme.cardColor; // رمادي متوافق مع الخلفية والبطاقات
      default:
        return theme.primaryColor.withAlpha(26);
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
      final updatedEntries = List<MedicalEntry>.from(
        _sections[sectionIndex].entries,
      )..remove(entry);
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
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: _buildAppBar(theme),
      bottomNavigationBar: BottomActionButtons(
        onBack: () => Navigator.pop(context),
        onNextStep: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const MedicationsScreen()),
          );
        },
      ),
      body: _buildBody(theme),
    );
  }

  // =============================================
  // AppBar Builder
  // =============================================
  PreferredSizeWidget _buildAppBar(ThemeData theme) {
    final scaleFactor = BlocProvider.of<SettingsCubit>(
      context,
    ).state.scaleFactor;
    return AppBar(
      backgroundColor: theme.scaffoldBackgroundColor,
      elevation: 0,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back,
          color: theme.textTheme.bodyLarge?.color,
          size: 22,
        ),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text(
        AppStrings.medicalProfileTitle(context),
        style: TextStyle(
          color: theme.textTheme.bodyLarge?.color,
          fontSize: 17 * scaleFactor,
          fontWeight: FontWeight.w700,
        ),
      ),
      centerTitle: false,
    );
  }

  // =============================================
  // Body Builder
  // =============================================
  Widget _buildBody(ThemeData theme) {
    final scaleFactor = BlocProvider.of<SettingsCubit>(
      context,
    ).state.scaleFactor;
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- شريط التقدم: Step 2 of 5 = 40% ---
          const StepProgressBar(currentStep: 1, totalSteps: 4),

          const SizedBox(height: 24),

          // --- عنوان القسم والوصف المترجمين ---
          Text(
            AppStrings.medicalHistoryTitle(context),
            style: TextStyle(
              color: theme.textTheme.bodyLarge?.color,
              fontSize: 24 * scaleFactor,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            AppStrings.medicalHistoryDesc(context),
            style: TextStyle(
              color: theme.textTheme.bodyMedium?.color,
              fontSize: 13 * scaleFactor,
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
              iconWidget: _getSectionIcon(index, theme),
              iconBgColor: _getSectionIconBg(index, theme),
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
