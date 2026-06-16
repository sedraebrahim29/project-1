import 'package:flutter/material.dart';

// --- Models ---
import '../../../../../../core/theme/app_colors.dart';
import '../../../models/medical_profile_models/medication_model.dart';
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
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(),

      // FAB الأخضر + أسفل يمين الشاشة
      floatingActionButton: _buildFAB(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,

      // الزران ثابتان في الأسفل
      bottomNavigationBar: BottomActionButtons(
        onBack: () => Navigator.pop(context),
        onNextStep: () {
          // التنقل للخطوة التالية
        },
      ),

      body: _buildBody(),
    );
  }

  // =============================================
  // AppBar Builder — نفس تصميم الواجهة السابقة
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
        'Medical Profile',
        style: TextStyle(
          color: AppColors.textDark,
          fontSize: 17,
          fontWeight: FontWeight.w700,
        ),
      ),
      centerTitle: false,
    );
  }

  // =============================================
  // FAB Builder — زر + الأخضر الدائري
  // =============================================
  Widget _buildFAB() {
    return FloatingActionButton(
      onPressed: () {
        // هنا بتفتح dialog أو شاشة إضافة دواء جديد
      },
      backgroundColor: AppColors.primaryGreen,
      elevation: 4,
      shape: const CircleBorder(), // دائرة كاملة
      child: const Icon(Icons.add, color: Colors.white, size: 26),
    );
  }

  // =============================================
  // Body Builder
  // =============================================
  Widget _buildBody() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 80),
      // padding سفلي 80 عشان الـ FAB ما يغطي آخر كارد
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- شريط التقدم: Step 3 of 5 = 60% ---
          // نفس الـ widget المستخدم بالشاشة السابقة
          const StepProgressBar(currentStep: 2, totalSteps: 4),

          const SizedBox(height: 24),

          // --- عنوان الصفحة والوصف ---
          const Text(
            'Medications',
            style: TextStyle(
              color: AppColors.textDark,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Please review or add your current prescribed\nmedications and dosages.',
            style: TextStyle(
              color: AppColors.textGrey,
              fontSize: 13,
              height: 1.5,
            ),
          ),

          const SizedBox(height: 20),

          // =============================================
          // قائمة الأدوية — استدعاء MedicationCard
          // لكل دواء ببياناته وكولباكاته
          // =============================================
          ..._medications.map(
                (medication) => MedicationCard(
              medication: medication,
              onMenuTap: () => _showMenuOptions(medication),
            ),
          ),
        ],
      ),
    );
  }

  // =============================================
  // قائمة الخيارات عند الضغط على الـ 3 نقاط
  // =============================================
  void _showMenuOptions(Medication medication) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // خط علوي صغير دلالة على الـ bottom sheet
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: AppColors.borderGrey,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            // خيار التعديل
            ListTile(
              leading: const Icon(Icons.edit_outlined,
                  color: AppColors.textDark),
              title: const Text('Edit',
                  style: TextStyle(color: AppColors.textDark)),
              onTap: () => Navigator.pop(context),
            ),
            // خيار الحذف
            ListTile(
              leading: const Icon(Icons.delete_outline,
                  color: AppColors.cancelRed),
              title: const Text('Delete',
                  style: TextStyle(color: AppColors.cancelRed)),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }
}