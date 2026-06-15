import 'package:flutter/material.dart';

// --- Models ---
import '../../models/medical_profile_models/review_models.dart';
import '../../theme/app_colors.dart';
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
    ReviewMedication(name: 'Metformin', details: '500mg • Twice daily with meals'),
    ReviewMedication(name: 'Lisinopril', details: '10mg • Once daily in the morning'),
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
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(),
      body: _buildBody(context),
    );
  }

  // =============================================
  // AppBar — نفس تصميم الشاشات السابقة ♻️
  // =============================================
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.background,
      elevation: 0,
      leading: Builder(
        builder: (context) => IconButton(
          icon: const Icon(Icons.arrow_back,
              color: AppColors.textDark, size: 22),
          onPressed: () => Navigator.pop(context),
        ),
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
  // Body Builder
  // =============================================
  Widget _buildBody(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // --- شريط التقدم Step 4 of 4 = 100% ---
          // هاد الستيب ما فيه trailingLabel — بيعرض 100%
          const StepProgressBar(currentStep: 4, totalSteps: 4),

          const SizedBox(height: 16),

          // --- عنوان Review & Submit مع 100% ---
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Review & Submit',
                style: TextStyle(
                  color: AppColors.textDark,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              // نسبة 100% يمين العنوان
              const Text(
                '100%',
                style: TextStyle(
                  color: AppColors.textGrey,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // وصف الصفحة
          const Text(
            'Please verify that all the information provided is correct before finalizing your profile creation. A complete and accurate profile ensures better care.',
            style: TextStyle(
              color: AppColors.textGrey,
              fontSize: 13,
              height: 1.5,
            ),
          ),

          const SizedBox(height: 20),

          // =============================================
          // قسم Basic Info
          // =============================================
          ReviewSectionCard(
            icon: Icons.person_outline,
            title: 'Basic Info',
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
            title: 'History',
            onEdit: () {
              // رجوع لشاشة Medical History
            },
            children: [
              // Known Allergies label
              const Text(
                'Known Allergies',
                style: TextStyle(
                  color: AppColors.textGrey,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 6),
              // chips الحساسية بـ Wrap عشان تنتقل لسطر لو كثرت
              Wrap(
                children: _allergies
                    .map((a) => AllergyTag(name: a.name))
                    .toList(),
              ),
              const SizedBox(height: 12),

              // Chronic Conditions
              const ReviewInfoField(
                label: 'Chronic Conditions',
                value: 'Type 2 Diabetes, Hypertension',
              ),

              // Past Surgeries
              const ReviewInfoField(
                label: 'Past Surgeries / Procedures',
                value: 'Appendectomy (2005), ACL Reconstruction\nRight Knee (2018)',
              ),
            ],
          ),

          // =============================================
          // قسم Meds
          // =============================================
          ReviewSectionCard(
            icon: Icons.medication_outlined,
            title: 'Meds',
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
            title: 'Attachments',
            onEdit: () {
              // رجوع لشاشة Upload Files
            },
            children: _attachments
                .map((a) => ReviewAttachmentCard(
              name: a.name,
              details: a.details,
              isPdf: a.isPdf,
            ))
                .toList(),
          ),

          const SizedBox(height: 8),

          // =============================================
          // زر Confirm & Submit — عريض أخضر داكن
          // =============================================
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                // إرسال البيانات
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryGreen,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
                elevation: 0,
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Confirm & Submit Profile',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(width: 8),
                  // أيقونة ✓ دائرية بعد النص
                  Icon(Icons.check_circle_outline,
                      color: Colors.white, size: 18),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // =============================================
          // نص Privacy Policy في الأسفل
          // =============================================
          _buildPrivacyText(),
        ],
      ),
    );
  }

  // =============================================
  // نص الخصوصية مع روابط خضراء
  // =============================================
  Widget _buildPrivacyText() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // أيقونة قفل
          const Icon(
            Icons.lock_outline,
            size: 16,
            color: AppColors.textGrey,
          ),
          const SizedBox(width: 8),
          // النص مع الروابط
          Expanded(
            child: RichText(
              text: TextSpan(
                style: const TextStyle(
                  color: AppColors.textGrey,
                  fontSize: 12,
                  height: 1.5,
                ),
                children: [
                  const TextSpan(
                    text: 'Your data is securely encrypted. By submitting, you agree to the ',
                  ),
                  // رابط Terms of Service أخضر
                  TextSpan(
                    text: 'Terms of Service',
                    style: const TextStyle(
                      color: AppColors.primaryGreen,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const TextSpan(text: ' and acknowledge the '),
                  // رابط Privacy Policy أخضر
                  TextSpan(
                    text: 'Privacy Policy',
                    style: const TextStyle(
                      color: AppColors.primaryGreen,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const TextSpan(
                    text: ' regarding your Protected Health Information (PHI).',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}