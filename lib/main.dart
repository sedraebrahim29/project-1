import 'package:flutter/material.dart';

import 'features/midecal_record/patiant_medical_record/views/screens/medical_records_screens/medical_overview_screen.dart';



void main() {
  runApp(const Mediverse());
}

class Mediverse extends StatelessWidget {
  const Mediverse({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mediverse',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Roboto',
        scaffoldBackgroundColor: const Color(0xFFF2F2EF),
      ),
      home: const MedicalOverviewScreen(),
    );
  }
}