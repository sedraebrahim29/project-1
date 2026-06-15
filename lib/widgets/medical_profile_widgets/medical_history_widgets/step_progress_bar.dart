import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';


// =============================================
// Widget - شريط التقدم العلوي
// يعرض: "STEP X OF Y" يسار، النسبة % يمين،
//        وشريط أخضر ممتلئ بنسبة معينة
//
// الاستخدام:
//   StepProgressBar(currentStep: 2, totalSteps: 5)
// =============================================
class StepProgressBar extends StatelessWidget {
  final int currentStep;
  final int totalSteps;

  const StepProgressBar({
    super.key,
    required this.currentStep,
    required this.totalSteps,
  });

  // حساب النسبة المئوية تلقائياً
  double get _progressValue => currentStep / totalSteps;
  int get _percentage => (_progressValue * 100).round();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // --- صف النص: STEP X OF Y  و  XX% ---
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'STEP $currentStep OF $totalSteps',
              style: const TextStyle(
                color: AppColors.textGrey,
                fontSize: 11,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.8, // تباعد الحروف يعطي مظهر احترافي
              ),
            ),
            Text(
              '$_percentage%',
              style: const TextStyle(
                color: AppColors.textGrey,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),

        // --- شريط التقدم ---
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: _progressValue,
            minHeight: 6,
            backgroundColor: AppColors.progressBg,
            valueColor:  AlwaysStoppedAnimation<Color>(
              AppColors.progressFill,
            ),
          ),
        ),
      ],
    );
  }
}