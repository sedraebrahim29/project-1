import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:untitled3/features/auth/Login.dart';
import 'core/theme/app_theme.dart';
import 'core/constants/setting.dart';


import 'features/auth/doctor_auth/view_models/register_cubit.dart';
import 'features/auth/doctor_auth/view_models/register_state.dart';
import 'features/auth/doctor_auth/views/doctor_register_screen.dart';
import 'features/auth/patient_auth/views/account_under_review_screen.dart';
import 'features/consultaion_chat/views/doctor_chat_screen.dart';
import 'features/midecal_record/initial_medical_records/views/screens/medical_profile_screens/medical_history_screen.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return  MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => SettingsCubit(),
        ),
        BlocProvider(
          create: (context) => DoctorRegisterCubit(),
        ),
      ],
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

                builder: (context, widget) {
                  return MediaQuery(

                    data: MediaQuery.of(context).copyWith(
                      textScaleFactor: MediaQuery.of(context).textScaleFactor * state.scaleFactor,
                    ),
                    child: widget!,
                  );
                },
                home:  DoctorChatScreen(doctorId: 1),
              );
            },
          );
        },
      ),
    );
  }
}