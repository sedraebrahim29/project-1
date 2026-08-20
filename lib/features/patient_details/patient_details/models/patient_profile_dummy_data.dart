class PatientProfileModel {
  final String id;
  final String firstName;
  final String lastName;
  final String? avatarUrl;
  final String dateOfBirth;
  final String gender;
  final String email;
  final bool isEmailVerified;
  final String phoneNumber;
  final String homeAddress;

  const PatientProfileModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    this.avatarUrl,
    required this.dateOfBirth,
    required this.gender,
    required this.email,
    this.isEmailVerified = false,
    required this.phoneNumber,
    required this.homeAddress,
  });

  String get fullName => '$firstName $lastName';

  String get initials {
    final f = firstName.isNotEmpty ? firstName[0].toUpperCase() : '';
    final l = lastName.isNotEmpty ? lastName[0].toUpperCase() : '';
    return '$f$l';
  }

  /// يبني بروفايل المريض من user object الحقيقي القادم من رد /auth/login
  /// (data.user) - نفس الأسلوب المستخدم بـ PatientInfo.fromUserJson
  /// بالسجل الطبي، حتى شاشة "My Profile" تعرض بيانات المريض الحقيقية
  /// المدخلة بالريجستر بدل dummyPatientProfile.
  factory PatientProfileModel.fromUserJson(Map<String, dynamic> json) {
    final profile = json['profile'] as Map<String, dynamic>?;
    return PatientProfileModel(
      id: json['id']?.toString() ?? '',
      firstName: json['first_name']?.toString() ?? '',
      lastName: json['last_name']?.toString() ?? '',
      avatarUrl: json['avatar_url']?.toString() ?? profile?['avatar_url']?.toString(),
      dateOfBirth: json['dob']?.toString() ?? '',
      gender: json['gender']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      isEmailVerified: json['email_verified_at'] != null,
      phoneNumber: json['phone']?.toString() ?? '',
      homeAddress: json['address']?.toString() ?? '',
    );
  }
}

const PatientProfileModel dummyPatientProfile = PatientProfileModel(
  id: 'p1',
  firstName: 'Alexander',
  lastName: 'Vance',
  dateOfBirth: '12/04/1988',
  gender: 'Male',
  email: 'alexander.vance@mail.com',
  isEmailVerified: true,
  phoneNumber: '+963 930 112 233',
  homeAddress: 'Al-Hamidiyah Street, Building 42, Floor 3, Damascus, Syria',
);
