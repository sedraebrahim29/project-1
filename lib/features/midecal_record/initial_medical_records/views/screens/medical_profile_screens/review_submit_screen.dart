import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// --- Models ---
import '../../../../../../core/constants/app_strings.dart';
import '../../../../../../core/constants/setting.dart';
import '../../../models/medical_profile_models/review_models.dart';

// --- Widgets ---
import '../../widgets/medical_profile_widgets/medical_history_widgets/step_progress_bar.dart';
import '../../widgets/medical_profile_widgets/review/review_section_card.dart';

// =============================================
// الشاشة الرئيسية - Medical Profile / Step 4
// Review & Submit — شاشة المراجعة النهائية
// =============================================
class ReviewSubmitScreen extends StatelessWidget {
  const ReviewSubmitScreen({super.key});

  // =============================================
  // بيانات Basic Info
  // =============================================
  static const List<InfoField> _basicInfoFields = [
    InfoField(label: 'Full Legal Name', value: 'Jonathan Edward Doe'),
    InfoField(label: 'Date of Birth', value: 'August 14, 1982'),
    InfoField(label: 'Sex Assigned at Birth', value: 'Male'),
    InfoField(label: 'Phone Number', value: '(555) 019-2837'),
    InfoField(
      label: 'Primary Address',
      value: '1248 Evergreen Terrace, Suite 4B\nSpringfield, OR 97477',
    ),
  ];

  // =============================================
  // بيانات History
  // =============================================
  static const List<AllergyChip> _allergies = [
    AllergyChip(name: 'Amoyicillin'),
    AllergyChip(name: 'Latey'),
  ];

  // =============================================
  // بيانات Meds
  // =============================================
  static const List<ReviewMedication> _medications = [
    ReviewMedication(
      name: 'Metformin',
      details: '500mg • Twice daily with meals',
    ),
    ReviewMedication(
      name: 'Lisinopril',
      details: '10mg • Once daily in the morning',
    ),
  ];

  // =============================================
  // بيانات Attachments
  // =============================================
  static const List<ReviewAttachment> _attachments = [
    ReviewAttachment(
      name: 'Drivers_License_Front.jpg',
      details: '2.1 MB • Uploaded Today',
      isPdf: false,
    ),
    ReviewAttachment(
      name: 'BlueCross_Insurance_Card.pdf',
      details: '850 KB • Uploaded Today',
      isPdf: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: _buildAppBar(context),
      body: _buildBody(context),
    );
  }

  // =============================================
  // AppBar — نفس تصميم الشاشات السابقة ♻️
  // =============================================
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    final theme = Theme.of(context);
    final scaleFactor = BlocProvider.of<SettingsCubit>(
      context,
    ).state.scaleFactor;

    return AppBar(
      backgroundColor: theme.scaffoldBackgroundColor,
      elevation: 0,
      leading: Builder(
        builder: (context) => IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: theme.textTheme.bodyLarge?.color,
            size: 22,
          ),
          onPressed: () => Navigator.pop(context),
        ),
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
  Widget _buildBody(BuildContext context) {
    final theme = Theme.of(context);
    final scaleFactor = BlocProvider.of<SettingsCubit>(
      context,
    ).state.scaleFactor;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- شريط التقدم Step 4 of 4 = 100% ---
          const StepProgressBar(currentStep: 4, totalSteps: 4),

          const SizedBox(height: 16),

          // --- عنوان Review & Submit مع 100% ---
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                AppStrings.reviewSubmitTitle(context),
                style: TextStyle(
                  color: theme.textTheme.bodyLarge?.color,
                  fontSize: 22 * scaleFactor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '100%',
                style: TextStyle(
                  color: theme.textTheme.bodyMedium?.color,
                  fontSize: 13 * scaleFactor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // وصف الصفحة
          Text(
            AppStrings.reviewSubmitDesc(context),
            style: TextStyle(
              color: theme.textTheme.bodyMedium?.color,
              fontSize: 13 * scaleFactor,
              height: 1.5,
            ),
          ),

          const SizedBox(height: 20),

          // =============================================
          // قسم Basic Info
          // =============================================
          ReviewSectionCard(
            icon: Icons.person_outline,
            title: AppStrings.basicInfoSection(context),
            onEdit: () {
              // رجوع لشاشة Basic Info
            },
            children: _basicInfoFields
                .map((f) => ReviewInfoField(label: f.label, value: f.value))
                .toList(),
          ),

          // =============================================
          // قسم History
          // =============================================
          ReviewSectionCard(
            icon: Icons.history,
            title: AppStrings.historySection(context),
            onEdit: () {
              // رجوع لشاشة Medical History
            },
            children: [
              Text(
                AppStrings.knownAllergiesLabel(context),
                style: TextStyle(
                  color: theme.textTheme.bodyMedium?.color,
                  fontSize: 12 * scaleFactor,
                ),
              ),
              const SizedBox(height: 6),
              Wrap(
                children: _allergies
                    .map((a) => AllergyTag(name: a.name))
                    .toList(),
              ),
              const SizedBox(height: 12),

              ReviewInfoField(
                label: AppStrings.chronicConditionsLabel(context),
                value: 'Type 2 Diabetes, Hypertension',
              ),

              ReviewInfoField(
                label: AppStrings.pastSurgeriesLabel(context),
                value:
                    'Appendectomy (2005), ACL Reconstruction\nRight Knee (2018)',
              ),
            ],
          ),

          // =============================================
          // قسم Meds
          // =============================================
          ReviewSectionCard(
            icon: Icons.medication_outlined,
            title: AppStrings.medsSection(context),
            onEdit: () {
              // رجوع لشاشة Medications
            },
            children: _medications
                .map((m) => ReviewMedCard(name: m.name, details: m.details))
                .toList(),
          ),

          // =============================================
          // قسم Attachments
          // =============================================
          ReviewSectionCard(
            icon: Icons.attach_file,
            title: AppStrings.attachmentsSection(context),
            onEdit: () {
              // رجوع لشاشة Upload Files
            },
            children: _attachments
                .map(
                  (a) => ReviewAttachmentCard(
                    name: a.name,
                    details: a.details,
                    isPdf: a.isPdf,
                  ),
                )
                .toList(),
          ),

          const SizedBox(height: 8),

          // =============================================
          // زر Confirm & Submit — عريض متوافق مع ثيم اللون الرئيسي للبرنامج
          // =============================================
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                // إرسال البيانات
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
                elevation: 0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    AppStrings.confirmSubmitButton(context),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15 * scaleFactor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(
                    Icons.check_circle_outline,
                    color: Colors.white,
                    size: 18,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // =============================================
          // نص Privacy Policy في الأسفل
          // =============================================
          _buildPrivacyText(context),
        ],
      ),
    );
  }

  // =============================================
  // نص الخصوصية مع روابط ملونة حسب الـ Primary Color
  // =============================================
  Widget _buildPrivacyText(BuildContext context) {
    final theme = Theme.of(context);
    final scaleFactor = BlocProvider.of<SettingsCubit>(
      context,
    ).state.scaleFactor;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.lock_outline,
            size: 16,
            color: theme.textTheme.bodyMedium?.color,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: TextStyle(
                  color: theme.textTheme.bodyMedium?.color,
                  fontSize: 12 * scaleFactor,
                  height: 1.5,
                ),
                children: [
                  TextSpan(text: AppStrings.privacyStatementPrefix(context)),
                  TextSpan(
                    text: AppStrings.termsOfServiceLink(context),
                    style: TextStyle(
                      color: theme.primaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  TextSpan(text: AppStrings.privacyStatementMiddle(context)),
                  TextSpan(
                    text: AppStrings.privacyPolicyLink(context),
                    style: TextStyle(
                      color: theme.primaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  TextSpan(text: AppStrings.privacyStatementSuffix(context)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
