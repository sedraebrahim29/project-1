import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// --- Models & Core ---
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/constants/app_strings.dart';
import '../../../models/medical_record_models/medical_attachment_models.dart';
import '../../widgets/medical_records_widgets/medical_attachments_widgets/lab_result_item.dart';
import '../../widgets/medical_records_widgets/medical_attachments_widgets/medical_image_card.dart';
import '../../widgets/medical_records_widgets/medical_attachments_widgets/prescription_card.dart';

// =============================================
// شاشة Medical Attachments
// تعرض: Medical Images + Lab Results + Prescriptions
// تم التحديث لتتوافق مع الهوية البصرية الجديدة
// =============================================
class MedicalAttachmentsScreen extends StatefulWidget {
  const MedicalAttachmentsScreen({super.key});

  @override
  State<MedicalAttachmentsScreen> createState() =>
      _MedicalAttachmentsScreenState();
}

class _MedicalAttachmentsScreenState
    extends State<MedicalAttachmentsScreen> {

  int _currentNavIndex = 1;

  // =============================================
  // بيانات تجريبية (يتم جلبها من API مستقبلاً)
  // =============================================
  final List<MedicalImage> _medicalImages = const [
    MedicalImage(
      title: 'Chest X-Ray',
      date: 'Oct 12, 2023',
      fileType: 'JPG',
      imageAsset: '',
    ),
    MedicalImage(
      title: 'Brain MRI Scan',
      date: 'Sep 05, 2023',
      fileType: 'DICOM',
      imageAsset: '',
    ),
  ];

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
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: AppColors.backgroundBeige,
      appBar: _buildAppBar(theme),
      bottomNavigationBar: _buildBottomNavBar(),
      body: _buildBody(),
    );
  }

  // =============================================
  // AppBar ♻️
  // =============================================
  PreferredSizeWidget _buildAppBar(ThemeData theme) {
    return AppBar(
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
      centerTitle: false,
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
    );
  }

  // =============================================
  // Body Builder
  // =============================================
  Widget _buildBody() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- عنوان الشاشة ---
          Text(
            AppStrings.attachments(context),
            style: TextStyle(
              color: AppColors.textDark,
              fontSize: 22.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'View and download your lab results, prescriptions, and medical imaging files.',
            style: TextStyle(
              color: AppColors.textLightGrey,
              fontSize: 14.sp,
              height: 1.4,
            ),
          ),

          SizedBox(height: 24.h),

          // =============================================
          // قسم الصور الطبية
          // =============================================
          _SectionHeader(
            title: AppStrings.medicalImages(context),
            onViewAll: () {},
          ),
          SizedBox(height: 12.h),

          GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 12.w,
            mainAxisSpacing: 12.h,
            childAspectRatio: 1.1,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: _medicalImages
                .map((img) => MedicalImageCard(
              image: img,
              onDownload: () {},
            ))
                .toList(),
          ),

          SizedBox(height: 24.h),

          // =============================================
          // قسم نتائج المختبر
          // =============================================
          Text(
            AppStrings.labResults(context),
            style: TextStyle(
              color: AppColors.textDark,
              fontSize: 17.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 12.h),

          Container(
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(12.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: List.generate(_labResults.length, (index) {
                return LabResultItem(
                  result: _labResults[index],
                  showDivider: index != _labResults.length - 1,
                  onDownload: () {},
                );
              }),
            ),
          ),

          SizedBox(height: 24.h),

          // =============================================
          // قسم الوصفات الطبية
          // =============================================
          Text(
            AppStrings.prescriptions(context),
            style: TextStyle(
              color: AppColors.textDark,
              fontSize: 17.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 12.h),

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
  // BottomNavigationBar ♻️
  // =============================================
  Widget _buildBottomNavBar() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: _currentNavIndex,
        onTap: (index) => setState(() => _currentNavIndex = index),
        backgroundColor: AppColors.white,
        selectedItemColor: AppColors.primaryGreen,
        unselectedItemColor: AppColors.textLightGrey,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
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

// =============================================
// هيدر القسم مع زر "عرض الكل"
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
          style: TextStyle(
            color: AppColors.textDark,
            fontSize: 17.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        GestureDetector(
          onTap: onViewAll,
          child: Text(
            AppStrings.viewAll(context),
            style: TextStyle(
              color: AppColors.primaryGreen,
              fontSize: 13.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
