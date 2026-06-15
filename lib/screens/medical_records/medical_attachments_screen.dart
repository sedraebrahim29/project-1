import 'package:flutter/material.dart';

// --- Models ---
import '../../models/medical_record_models/medical_attachment_models.dart';
import '../../theme/app_colors.dart';
import '../../widgets/medical_records/medical_attachments_widgets/lab_result_item.dart';
import '../../widgets/medical_records/medical_attachments_widgets/medical_image_card.dart';
import '../../widgets/medical_records/medical_attachments_widgets/prescription_card.dart';

// =============================================
// شاشة Medical Attachments
// تعرض: Medical Images + Lab Results + Prescriptions
// =============================================
class MedicalAttachmentsScreen extends StatefulWidget {
  const MedicalAttachmentsScreen({super.key});

  @override
  State<MedicalAttachmentsScreen> createState() =>
      _MedicalAttachmentsScreenState();
}

class _MedicalAttachmentsScreenState
    extends State<MedicalAttachmentsScreen> {

  // index الـ BottomNav — Records = 1
  int _currentNavIndex = 1;

  // =============================================
  // بيانات الصور الطبية
  // =============================================
  final List<MedicalImage> _medicalImages = const [
    MedicalImage(
      title: 'Chest X-Ray',
      date: 'Oct 12, 2023',
      fileType: 'JPG',
      imageAsset: '', // ضع مسار الصورة هنا
    ),
    MedicalImage(
      title: 'Brain MRI Scan',
      date: 'Sep 05, 2023',
      fileType: 'DICOM',
      imageAsset: '',
    ),
  ];

  // =============================================
  // بيانات نتائج المختبر
  // =============================================
  final List<LabResult> _labResults = const [
    LabResult(
      title: 'Lipid Panel',
      date: 'Oct 14, 2023',
      fileType: 'PDF',
      fileSize: '1.2 MB',
      iconType: 'flask',
    ),
    LabResult(
      title: 'Comprehensive Metabolic',
      date: 'Aug 22, 2023',
      fileType: 'PDF',
      fileSize: '0.8 MB',
      iconType: 'microscope',
    ),
  ];

  // =============================================
  // بيانات الوصفات الطبية
  // =============================================
  final List<Prescription> _prescriptions = const [
    Prescription(
      medicationName: 'Amoxicillin 500mg',
      doctorName: 'Dr. Sarah Jenkins',
      fileType: 'Digital Signature PDF',
      status: 'ACTIVE',
    ),
    Prescription(
      medicationName: 'Lisinopril 10mg',
      doctorName: 'Dr. Robert Chen',
      fileType: 'Digital Signature PDF',
      status: 'EXPIRED',
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
  // AppBar — نفس Medical Records ♻️
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
      centerTitle: true,
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
          // --- عنوان ووصف الشاشة ---
          const Text(
            'Attachments',
            style: TextStyle(
              color: AppColors.textDark,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'View and download your lab results, prescriptions, and medical imaging files.',
            style: TextStyle(
              color: AppColors.textGrey,
              fontSize: 13,
              height: 1.4,
            ),
          ),

          const SizedBox(height: 24),

          // =============================================
          // قسم Medical Images
          // =============================================
          _SectionHeader(
            title: 'Medical Images',
            onViewAll: () {},
          ),
          const SizedBox(height: 12),

          // Grid عمودين للصور
          GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 1.1, // نسبة العرض للارتفاع
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(), // منع scroll داخلي
            children: _medicalImages
                .map((img) => MedicalImageCard(
              image: img,
              onDownload: () {},
            ))
                .toList(),
          ),

          const SizedBox(height: 24),

          // =============================================
          // قسم Lab Results — كارد أبيض موحد
          // =============================================
          const Text(
            'Lab Results',
            style: TextStyle(
              color: AppColors.textDark,
              fontSize: 17,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),

          // كارد أبيض واحد يحتوي على كل النتائج
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
            child: Column(
              children: List.generate(_labResults.length, (index) {
                return LabResultItem(
                  result: _labResults[index],
                  // divider بين العناصر فقط، لا يظهر بعد الأخير
                  showDivider: index != _labResults.length - 1,
                  onDownload: () {},
                );
              }),
            ),
          ),

          const SizedBox(height: 24),

          // =============================================
          // قسم Prescriptions
          // =============================================
          const Text(
            'Prescriptions',
            style: TextStyle(
              color: AppColors.textDark,
              fontSize: 17,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),

          // كل وصفة بكارد مستقل
          ..._prescriptions.map((prescription) => PrescriptionCard(
            prescription: prescription,
            onView: () {},
            onDownload: () {},
          )),
        ],
      ),
    );
  }

  // =============================================
  // BottomNavigationBar ♻️ نفس Medical Records
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

// =============================================
// Widget - هيدر القسم مع "View All"
// بيتكرر بس بقسم Medical Images
// =============================================
class _SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback onViewAll;

  const _SectionHeader({required this.title, required this.onViewAll});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: AppColors.textDark,
            fontSize: 17,
            fontWeight: FontWeight.w600,
          ),
        ),
        GestureDetector(
          onTap: onViewAll,
          child: const Text(
            'View All',
            style: TextStyle(
              color: AppColors.primaryGreen,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}