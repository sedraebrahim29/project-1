import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';

// =============================================
// Widget - زرا Back و Next Step في الأسفل
// ثابتان في أسفل الشاشة دائماً
//
// الاستخدام:
//   BottomActionButtons(
//     onBack: () {},
//     onNextStep: () {},
//   )
// =============================================
class BottomActionButtons extends StatelessWidget {
  final VoidCallback onBack;
  final VoidCallback onNextStep;

  const BottomActionButtons({
    super.key,
    required this.onBack,
    required this.onNextStep,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: AppColors.borderGrey, width: 1),
        ),
      ),
      child: Row(
        children: [
          // --- زر Back: border فقط بدون fill ---
          Expanded(
            flex: 2, // أصغر من زر Next Step
            child: OutlinedButton(
              onPressed: onBack,
              style: OutlinedButton.styleFrom(
                side: const BorderSide(
                  color: AppColors.backButtonBorder,
                  width: 1.5,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(vertical: 14),
                backgroundColor: Colors.white,
              ),
              child: const Text(
                'Back',
                style: TextStyle(
                  color: AppColors.textDark,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),

          const SizedBox(width: 12),

          // --- زر Next Step: أخضر داكن مع سهم ---
          Expanded(
            flex: 3, // أكبر من زر Back
            child: ElevatedButton(
              onPressed: onNextStep,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryGreen,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(vertical: 14),
                elevation: 0,
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Next Step',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(width: 6),
                  // السهم → بعد النص
                  Icon(Icons.arrow_forward, color: Colors.white, size: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}