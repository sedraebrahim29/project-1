import 'package:flutter/material.dart';
import 'package:mediverse/screens/appointments/appointment_screen.dart';
import 'package:mediverse/screens/medical_profile/attachment_screen.dart';
import 'package:mediverse/screens/medical_profile/medical_history_screen.dart';
import 'package:mediverse/screens/medical_profile/medications_screen.dart';
import 'package:mediverse/screens/medical_profile/review_submit_screen.dart';
import 'package:mediverse/screens/medical_records/encounter_timeline_screen.dart';
import 'package:mediverse/screens/medical_records/medical_attachments_screen.dart';



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
      home: const MedicalAttachmentsScreen(),
    );
  }
}