import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:untitled3/features/auth/Login.dart';
import 'package:untitled3/features/midecal_record/patiant_medical_record/views/screens/medical_records_screens/medical_overview_screen.dart';
import 'core/theme/app_theme.dart';
import 'core/constants/setting.dart';
import 'features/midecal_record/initial_medical_records/views/screens/medical_profile_screens/medical_history_screen.dart';
import 'features/midecal_record/initial_medical_records/views/screens/medical_profile_screens/review_submit_screen.dart';
import 'features/patient_details/views/doctor_listing_screen.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SettingsCubit(),
      child: BlocBuilder<SettingsCubit, SettingsState>(
        builder: (context, state) {
          return ScreenUtilInit(
            designSize: const Size(360, 690),
            minTextAdapt: true,
            splitScreenMode: true,
            builder: (context, child) {
              return MaterialApp(
                title: 'MedZone',
                debugShowCheckedModeBanner: false,
                theme: AppTheme.lightTheme,
                darkTheme: AppTheme.darkTheme,
                themeMode: state.themeMode,
                locale: state.locale,
                // السطر الخارق التالي يقوم بتغيير حجم الخطوط ديناميكياً في التطبيق ككل!
                builder: (context, widget) {
                  return MediaQuery(
                    // نأخذ إعدادات الشاشة الحالية ونقوم بتعديل الـ textScaleFactor الخاص بها
                    data: MediaQuery.of(context).copyWith(
                      textScaleFactor: MediaQuery.of(context).textScaleFactor * state.scaleFactor,
                    ),
                    child: widget!,
                  );
                },
                home: const LoginScreen(),
              );
            },
          );
        },
      ),
    );
  }
}
