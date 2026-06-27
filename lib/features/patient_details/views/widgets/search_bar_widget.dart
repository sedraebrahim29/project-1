// lib/features/patient_home/views/widgets/search_bar_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PatientSearchBarWidget extends StatelessWidget {
  final double scale;
  const PatientSearchBarWidget({super.key, required this.scale});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      height: 42.h,
      child: TextFormField(
        style: TextStyle(fontSize: (13 * scale).sp),
        decoration: InputDecoration(
          hintText: 'Search by name, specialty, or condition...',
          hintStyle: TextStyle(color: theme.textTheme.bodyMedium?.color, fontSize: (12 * scale).sp),
          prefixIcon: Icon(Icons.search, color: theme.textTheme.bodyMedium?.color, size: 20.sp),
          filled: true,
          fillColor: theme.cardColor,
          contentPadding: EdgeInsets.symmetric(vertical: 8.h),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: theme.dividerColor),
            borderRadius: BorderRadius.circular(10.r),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: theme.primaryColor),
            borderRadius: BorderRadius.circular(10.r),
          ),
        ),
      ),
    );
  }
}
