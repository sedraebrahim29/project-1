
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../Login.dart'; // تأكدي من استدعاء ملف الـ Login الرئيسي الخاص بكِ

class AccountUnderReviewScreen extends StatelessWidget {
  const AccountUnderReviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F5), // لون الخلفية الفاتح المتناسق مع تصاميمكِ
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(),

              // أيقونة الصح الخضراء الدائرية الكبيرة المطابقة للصورة المرفوعة
              Container(
                padding: EdgeInsets.all(20.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 15,
                      offset: const Offset(0, 4),
                    )
                  ],
                ),
                child: Icon(
                  Icons.check_circle,
                  color: const Color(0xFF2E5A44), // اللون الزيتي الخاص بالتطبيق
                  size: 64.sp,
                ),
              ),
              SizedBox(height: 35.h),

              // العنوان الرئيسي لانتظار موافقة الإدارة
              Text(
                'Your account is under review',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF111111),
                ),
              ),
              SizedBox(height: 15.h),

              // الشرح التوضيحي للـ 24 ساعة
              Text(
                'Verification may take up to 24 hours. You can explore the app with limited access in the meantime.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: AppColors.textLightGrey,
                  height: 1.5,
                ),
              ),
              SizedBox(height: 40.h),

              // بطاقة التوثيق الآمن (Secure Verification)
              Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: Colors.grey.withOpacity(0.1)),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(10.w),
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.05),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.security_outlined,
                        color: AppColors.textLightGrey,
                        size: 22.sp,
                      ),
                    ),
                    SizedBox(width: 16.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Secure Verification',
                            style: TextStyle(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF111111),
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            'Ensuring a safe medical environment',
                            style: TextStyle(
                              fontSize: 13.sp,
                              color: AppColors.textLightGrey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const Spacer(),

              // زر التوجيه والعودة إلى صفحة الـ Login
              SizedBox(
                width: double.infinity,
                height: 52.h,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2E5A44),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    elevation: 0,
                  ),
                  onPressed: () {
                    // الانتقال لشاشة اللوجن وتصفير مكدس الصفحات حتى لا يستطيع العودة للخلف
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => const LoginScreen()),
                          (route) => false,
                    );
                  },
                  child: Text(
                    'Go to Home',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }
}
