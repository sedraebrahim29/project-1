import 'package:flutter/material.dart';

import '../../../../models/medical_record_models/medical_attachment_models.dart';

// =============================================
// Widget - كارد الصورة الطبية
// كارد داكن مع gradient أسفله + اسم + تاريخ
// + نوع الملف + أيقونة download
//
// الاستخدام:
//   MedicalImageCard(image: image, onDownload: () {})
// =============================================
class MedicalImageCard extends StatelessWidget {
  final MedicalImage image;
  final VoidCallback onDownload;

  const MedicalImageCard({
    super.key,
    required this.image,
    required this.onDownload,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Stack(
        children: [
          // --- الصورة الخلفية الداكنة ---
          Container(
            height: 150,
            width: double.infinity,
            color: const Color(0xFF1A1A2E), // خلفية داكنة بديل الصورة
            child: image.imageAsset.isNotEmpty
                ? Image.asset(image.imageAsset, fit: BoxFit.cover)
                : const Center(
              child: Icon(
                Icons.image_outlined,
                color: Colors.white38,
                size: 40,
              ),
            ),
          ),

          // --- Gradient أسفل الكارد لإظهار النص ---
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.fromLTRB(10, 24, 10, 10),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Color(0xCC000000), // أسود شفاف 80%
                  ],
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // --- اسم الصورة + تاريخ + نوع ---
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          image.title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${image.date} • ${image.fileType}',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // --- أيقونة Download دائرية ---
                  GestureDetector(
                    onTap: onDownload,
                    child: Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white54,
                          width: 1,
                        ),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.download_outlined,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    ),
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