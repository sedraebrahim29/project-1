// =============================================
// موديلات بروفايل الطبيب - مبنية بالكامل من استجابة GET /doctor/profile
// الحقيقية (راجع Postman collection: Doctor / doctor profile)، بنفس
// أسلوب PatientInfo.fromUserJson المستخدم بالسجل الطبي للمريض.
// =============================================

/// عيادة/مكان عمل مرتبط بحساب الطبيب (من data.clinics بالرد الحقيقي).
class DoctorClinicRef {
  final int id;
  final String name;
  final String? phone;
  final String? address;
  final double? latitude;
  final double? longitude;
  final String status;
  final double? consultationFee;

  const DoctorClinicRef({
    required this.id,
    required this.name,
    this.phone,
    this.address,
    this.latitude,
    this.longitude,
    this.status = 'active',
    this.consultationFee,
  });

  factory DoctorClinicRef.fromJson(Map<String, dynamic> json) => DoctorClinicRef(
        id: json['id'] is int ? json['id'] as int : int.tryParse('${json['id']}') ?? 0,
        name: json['name']?.toString() ?? '',
        phone: json['phone']?.toString(),
        address: json['address']?.toString(),
        latitude: json['latitude'] == null ? null : double.tryParse('${json['latitude']}'),
        longitude: json['longitude'] == null ? null : double.tryParse('${json['longitude']}'),
        status: json['status']?.toString() ?? 'active',
        consultationFee: json['consultation_fee'] == null ? null : double.tryParse('${json['consultation_fee']}'),
      );
}

/// قسم/تخصص مرتبط بحساب الطبيب (من data.departments).
class DoctorDepartmentRef {
  final int id;
  final String name;
  final String? description;

  const DoctorDepartmentRef({required this.id, required this.name, this.description});

  factory DoctorDepartmentRef.fromJson(Map<String, dynamic> json) => DoctorDepartmentRef(
        id: json['id'] is int ? json['id'] as int : int.tryParse('${json['id']}') ?? 0,
        name: json['name']?.toString() ?? '',
        description: json['description']?.toString(),
      );
}

/// مؤهل علمي واحد (من data.profile.qualifications).
class DoctorQualification {
  final String degree;
  final String institution;
  final int? year;

  const DoctorQualification({required this.degree, required this.institution, this.year});

  factory DoctorQualification.fromJson(Map<String, dynamic> json) => DoctorQualification(
        degree: json['degree']?.toString() ?? '',
        institution: json['institution']?.toString() ?? '',
        year: json['year'] is int ? json['year'] as int : int.tryParse('${json['year']}'),
      );
}

/// بروفايل الطبيب الكامل - يغذي شاشة Doctor Home وشاشة Doctor Profile
/// معاً حتى ما يصير في نداءين مختلفين لنفس البيانات.
class DoctorProfileInfo {
  final int? doctorId;
  final String firstName;
  final String lastName;
  final String email;
  final String? phone;
  final String? dob;
  final String? gender;
  final String? address;
  final String? photoUrl;
  final String verificationStatus; // verified / pending / rejected
  final String? practiceStartDate;
  final int? experienceYears;
  final String? biography;
  final double? consultationFee;
  final List<String> languages;
  final List<DoctorQualification> qualifications;
  final List<DoctorDepartmentRef> departments;
  final List<DoctorClinicRef> clinics;

  const DoctorProfileInfo({
    this.doctorId,
    required this.firstName,
    required this.lastName,
    required this.email,
    this.phone,
    this.dob,
    this.gender,
    this.address,
    this.photoUrl,
    this.verificationStatus = 'pending',
    this.practiceStartDate,
    this.experienceYears,
    this.biography,
    this.consultationFee,
    this.languages = const [],
    this.qualifications = const [],
    this.departments = const [],
    this.clinics = const [],
  });

  String get fullName => '$firstName $lastName'.trim();

  String get initials {
    final f = firstName.isNotEmpty ? firstName[0].toUpperCase() : '';
    final l = lastName.isNotEmpty ? lastName[0].toUpperCase() : '';
    return '$f$l';
  }

  String get mainSpecialty => departments.isNotEmpty ? departments.first.name : '';

  /// يبني نسخة أولية سريعة من user object القادم من /auth/login (متوفر
  /// فوراً بعد الدخول) - قبل ما يوصل رد /doctor/profile الأغنى بالتفاصيل.
  /// هيك أول فريم ما بيضل فاضي.
  factory DoctorProfileInfo.fromLoginUserJson(Map<String, dynamic> json) {
    return DoctorProfileInfo(
      firstName: json['first_name']?.toString() ?? '',
      lastName: json['last_name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      phone: json['phone']?.toString(),
      dob: json['dob']?.toString(),
      gender: json['gender']?.toString(),
      address: json['address']?.toString(),
    );
  }

  /// يبني النسخة الكاملة من data الحقيقية لـ GET /doctor/profile.
  factory DoctorProfileInfo.fromApiJson(Map<String, dynamic> json) {
    final account = json['account'] as Map<String, dynamic>? ?? {};
    final verification = json['verification'] as Map<String, dynamic>? ?? {};
    final career = json['career'] as Map<String, dynamic>? ?? {};
    final documents = json['documents'] as Map<String, dynamic>? ?? {};
    final profile = json['profile'] as Map<String, dynamic>?;

    return DoctorProfileInfo(
      doctorId: json['id'] is int ? json['id'] as int : int.tryParse('${json['id']}'),
      firstName: account['first_name']?.toString() ?? '',
      lastName: account['last_name']?.toString() ?? '',
      email: account['email']?.toString() ?? '',
      phone: account['phone']?.toString(),
      dob: account['dob']?.toString(),
      gender: account['gender']?.toString(),
      address: account['address']?.toString(),
      photoUrl: documents['photo_url']?.toString(),
      verificationStatus: verification['status']?.toString() ?? 'pending',
      practiceStartDate: career['practice_start_date']?.toString(),
      experienceYears: career['experience_years'] is int
          ? career['experience_years'] as int
          : int.tryParse('${career['experience_years']}'),
      biography: profile?['biography']?.toString(),
      consultationFee: profile?['consultation_fee'] == null
          ? null
          : double.tryParse('${profile?['consultation_fee']}'),
      languages: profile?['languages'] is List
          ? List<String>.from((profile!['languages'] as List).map((e) => e.toString()))
          : const [],
      qualifications: profile?['qualifications'] is List
          ? (profile!['qualifications'] as List)
              .map((e) => DoctorQualification.fromJson(e as Map<String, dynamic>))
              .toList()
          : const [],
      departments: json['departments'] is List
          ? (json['departments'] as List)
              .map((e) => DoctorDepartmentRef.fromJson(e as Map<String, dynamic>))
              .toList()
          : const [],
      clinics: json['clinics'] is List
          ? (json['clinics'] as List)
              .map((e) => DoctorClinicRef.fromJson(e as Map<String, dynamic>))
              .toList()
          : const [],
    );
  }

  DoctorProfileInfo copyWith({
    String? biography,
    double? consultationFee,
    List<String>? languages,
  }) {
    return DoctorProfileInfo(
      doctorId: doctorId,
      firstName: firstName,
      lastName: lastName,
      email: email,
      phone: phone,
      dob: dob,
      gender: gender,
      address: address,
      photoUrl: photoUrl,
      verificationStatus: verificationStatus,
      practiceStartDate: practiceStartDate,
      experienceYears: experienceYears,
      biography: biography ?? this.biography,
      consultationFee: consultationFee ?? this.consultationFee,
      languages: languages ?? this.languages,
      qualifications: qualifications,
      departments: departments,
      clinics: clinics,
    );
  }

  static const empty = DoctorProfileInfo(firstName: '', lastName: '', email: '');
}
