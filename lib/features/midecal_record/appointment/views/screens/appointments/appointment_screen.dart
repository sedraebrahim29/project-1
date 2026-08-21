/*import 'package:flutter/material.dart';

// استدعاء الـ model والـ widgets والألوان
import '../../../../../../core/theme/app_colors.dart';
import '../../../view_models/appointment_model.dart';
import '../../widgets/appointments_widgets/past_appointment_card.dart';
import '../../widgets/appointments_widgets/upcoming_appointment_card.dart';

class AppointmentsScreen extends StatefulWidget {
  const AppointmentsScreen({super.key});

  @override
  State<AppointmentsScreen> createState() => _AppointmentsScreenState();
}

class _AppointmentsScreenState extends State<AppointmentsScreen> {
  // index الـ BottomNav المحدد حالياً (Bookings = 2)
  int _currentNavIndex = 2;

   // بيانات المواعيد القادمة

  final List<Appointment> _upcomingAppointments = const [
    Appointment(
      doctorName: 'Dr. Sarah Jenkins',
      specialty: 'Cardiology',
      date: 'Oct 24, 2023',
      time: '10:00 AM',
      status: 'Upcoming',
      avatarAsset: 'assets/images/dr_sarah.png',
    ),
    Appointment(
      doctorName: 'Dr. Marcus\nThorne',
      specialty: 'General Practice',
      date: 'Nov 02, 2023',
      time: '2:30 PM',
      status: 'Upcoming',
      avatarAsset: 'assets/images/dr_marcus.png',
    ),
  ];

  // بيانات المواعيد السابقة
  final List<Appointment> _pastAppointments = const [
    Appointment(
      doctorName: 'Dr. Emily Chen',
      specialty: 'Dermatology',
      date: 'Sep 15, 2023',
      status: 'Completed',
      avatarAsset: 'assets/images/dr_emily.png',
    ),
    Appointment(
      doctorName: 'Dr. Robert Hayes',
      specialty: 'Orthopedics',
      date: 'Aug 28, 2023',
      status: 'Cancelled',
      avatarAsset: 'assets/images/dr_robert.png',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(),
      body: _buildBody(),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  // =============================================
  // AppBar Builder
  // =============================================
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.background,
      elevation: 0,
      centerTitle: true,
      leading: const Padding(
        padding: EdgeInsets.only(left: 16),
        child: CircleAvatar(
          backgroundColor: AppColors.textDark,
          radius: 18,
          child: Icon(Icons.person, color: Colors.white, size: 20),
        ),
      ),
      title: const Text(
        'VMC Health',
        style: TextStyle(
          color: AppColors.textDark,
          fontSize: 17,
          fontWeight: FontWeight.w600,
        ),
      ),
      actions: const [
        Padding(
          padding: EdgeInsets.only(right: 16),
          child: Icon(
            Icons.notifications_outlined,
            color: AppColors.textDark,
            size: 24,
          ),
        ),
      ],
    );
  }

  // =============================================
  // Body Builder - هيكل الصفحة فقط
  // =============================================
  Widget _buildBody() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- عنوان الصفحة والوصف ---
          const Text(
            'Appointments',
            style: TextStyle(
              color: AppColors.textDark,
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Manage your upcoming visits and views medical history.',
            style: TextStyle(color: AppColors.textGrey, fontSize: 13),
          ),
          const SizedBox(height: 20),

          // =============================================
          // قسم Upcoming
          // =============================================
          const Text(
            'Upcoming',
            style: TextStyle(
              color: AppColors.textDark,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),

          // استدعاء UpcomingAppointmentCard لكل موعد
          ..._upcomingAppointments.map(
                (appointment) => UpcomingAppointmentCard(
              appointment: appointment,
            ),
          ),

          const SizedBox(height: 24),

          // =============================================
          // قسم Past History
          // =============================================
          const Text(
            'Past History',
            style: TextStyle(
              color: AppColors.textDark,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),

          // استدعاء PastAppointmentCard لكل موعد سابق
          ..._pastAppointments.map(
                (appointment) => PastAppointmentCard(
              appointment: appointment,
            ),
          ),

          const SizedBox(height: 16),
        ],
      ),
    );
  }

  // =============================================
  // BottomNavigationBar Builder
  // =============================================
  Widget _buildBottomNavBar() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: AppColors.navBarShadow,
            blurRadius: 8,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: _currentNavIndex,
        onTap: (index) => setState(() => _currentNavIndex = index),
        backgroundColor: Colors.white,
        selectedItemColor: AppColors.primaryGreen,
        unselectedItemColor: AppColors.textGrey,
        selectedLabelStyle: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w500,
        ),
        unselectedLabelStyle: const TextStyle(fontSize: 11),
        type: BottomNavigationBarType.fixed, // يظهر كل الـ labels
        elevation: 0,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.medical_services_outlined),
            activeIcon: Icon(Icons.medical_services),
            label: 'Doctors',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today_outlined),
            activeIcon: Icon(Icons.calendar_today),
            label: 'Bookings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline),
            activeIcon: Icon(Icons.chat_bubble),
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.folder_outlined),
            activeIcon: Icon(Icons.folder),
            label: 'Records',
          ),
        ],
      ),
    );
  }
}*/
