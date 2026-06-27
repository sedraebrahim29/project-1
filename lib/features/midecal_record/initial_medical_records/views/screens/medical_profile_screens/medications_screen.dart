import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// --- Models ---
import '../../../../../../core/constants/app_strings.dart';
import '../../../../../../core/constants/setting.dart';
import '../../../models/medical_profile_models/medication_model.dart';

// --- Widgets ---
import '../../widgets/medical_profile_widgets/medical_history_widgets/bottom_action_buttons.dart';
import '../../widgets/medical_profile_widgets/medical_history_widgets/step_progress_bar.dart';
import '../../widgets/medical_profile_widgets/medications/medication_card.dart';

// =============================================
// الشاشة الرئيسية - Medical Profile / Step 3
// مسؤوليتها:
// ١. تحتفظ ببيانات الأدوية
// ٢. تبني هيكل الشاشة (AppBar, Body, FAB, Bottom)
// ٣. تستدعي الـ widgets وتمرر البيانات
// =============================================
class MedicationsScreen extends StatefulWidget {
  const MedicationsScreen({super.key});

  @override
  State<MedicationsScreen> createState() => _MedicationsScreenState();
}

class _MedicationsScreenState extends State<MedicationsScreen> {
  // =============================================
  // بيانات الأدوية
  // =============================================
  final List<Medication> _medications = const [
    Medication(
      name: 'Metformin',
      dosage: '500mg',
      frequency: 'Once daily',
      status: 'Active',
    ),
    Medication(
      name: 'Lisinopril',
      dosage: '10mg',
      frequency: 'Twice daily',
      status: 'Active',
    ),
    Medication(
      name: 'Atorvastatin',
      dosage: '20mg',
      frequency: 'Once daily at bedtime',
      status: 'Active',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: _buildAppBar(theme),

      // FAB المتجاوب مع ألوان الثيم الأساسية للتطبيق
      floatingActionButton: _buildFAB(theme),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,

      // الزران ثابتان في الأسفل متصلان بمسار النقل التدفقي للشاشات
      bottomNavigationBar: BottomActionButtons(
        onBack: () => Navigator.pop(context),
        onNextStep: () {
          // هنا يتم توجيه المستخدم للشاشة التالية في الخطوة 4 (رفع الملفات أو المراجعة)
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
  // FAB Builder
  // =============================================
  Widget _buildFAB(ThemeData theme) {
    return FloatingActionButton(
      onPressed: () {
        // فتح Dialog أو شاشة إضافة دواء جديد
      },
      backgroundColor: theme.primaryColor,
      elevation: 4,
      shape: const CircleBorder(),
      child: const Icon(Icons.add, color: Colors.white, size: 26),
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
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 80),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- شريط التقدم: Step 3 of 4 ---
          const StepProgressBar(currentStep: 2, totalSteps: 4),

          const SizedBox(height: 24),

          // --- عنوان الصفحة والوصف من ملف الترجمة الموحد ---
          Text(
            AppStrings.medicationsTitle(context),
            style: TextStyle(
              color: theme.textTheme.bodyLarge?.color,
              fontSize: 24 * scaleFactor,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            AppStrings.medicationsDesc(context),
            style: TextStyle(
              color: theme.textTheme.bodyMedium?.color,
              fontSize: 13 * scaleFactor,
              height: 1.5,
            ),
          ),

          const SizedBox(height: 20),

          // =============================================
          // قائمة الأدوية المعتمدة على الـ Card المتجاوب
          // =============================================
          ..._medications.map(
            (medication) => MedicationCard(
              medication: medication,
              onMenuTap: () => _showMenuOptions(medication, theme),
            ),
          ),
        ],
      ),
    );
  }

  // =============================================
  // قائمة الخيارات (BottomSheet) المترجمة والمتجاوبة
  // =============================================
  void _showMenuOptions(Medication medication, ThemeData theme) {
    final scaleFactor = BlocProvider.of<SettingsCubit>(
      context,
    ).state.scaleFactor;
    final isDark = theme.brightness == Brightness.dark;
    final currentLang = BlocProvider.of<SettingsCubit>(
      context,
    ).state.locale.languageCode;

    showModalBottomSheet(
      context: context,
      backgroundColor: theme.cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: isDark ? Colors.grey[700] : Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            // خيار التعديل المترجم داخلياً بناءً على اللغات المدعومة بالـ Cubit
            ListTile(
              leading: Icon(
                Icons.edit_outlined,
                color: theme.textTheme.bodyLarge?.color,
              ),
              title: Text(
                currentLang == 'en' ? 'Edit' : 'تعديل',
                style: TextStyle(
                  color: theme.textTheme.bodyLarge?.color,
                  fontSize: 16 * scaleFactor,
                ),
              ),
              onTap: () => Navigator.pop(context),
            ),
            // خيار الحذف المترجم
            ListTile(
              leading: const Icon(
                Icons.delete_outline,
                color: Color(0xFFD32F2F),
              ),
              title: Text(
                currentLang == 'en' ? 'Delete' : 'حذف',
                style: TextStyle(
                  color: const Color(0xFFD32F2F),
                  fontSize: 16 * scaleFactor,
                ),
              ),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }
}
