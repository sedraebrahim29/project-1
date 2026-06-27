import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';

class WorkplaceInfo {
  final String type;
  final String name;
  final String workDays;
  final String workHours;
  final String consultationDuration;
  final String fee;

  WorkplaceInfo({
    required this.type,
    required this.name,
    required this.workDays,
    required this.workHours,
    required this.consultationDuration,
    required this.fee,
  });

  WorkplaceInfo copyWith({
    String? type,
    String? name,
    String? workDays,
    String? workHours,
    String? consultationDuration,
    String? fee,
  }) {
    return WorkplaceInfo(
      type: type ?? this.type,
      name: name ?? this.name,
      workDays: workDays ?? this.workDays,
      workHours: workHours ?? this.workHours,
      consultationDuration: consultationDuration ?? this.consultationDuration,
      fee: fee ?? this.fee,
    );
  }

  Map<String, dynamic> toJson() => {
    'type': type,
    'name': name,
    'workDays': workDays,
    'workHours': workHours,
    'consultationDuration': consultationDuration,
    'fee': fee,
  };
}

class DoctorRegisterModel {
  // Step 1
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? professionalEmail;
  final String? phoneNumber;
  final String? password;
  final String? confirmPassword;

  // Step 2
  final String? dateOfBirth;
  final String? gender;
  final String? homeAddress;
  final String? mainSpecialty;
  final String? subSpecialty;

  // Step 3
  final XFile? universityDegreeImage;
  final Uint8List? universityDegreeBytes;
  final String? educationDegree;
  final XFile? licenseImage;
  final Uint8List? licenseBytes;
  final String? licenseNumber;

  // Step 4
  final List<WorkplaceInfo> workplaces;
  final String? experienceYears;
  final String? bio;
  final bool? offersOnlineConsultation;
  final String? onlineConsultationDuration;
  final String? onlineConsultationFee;
  final String? onlineAvailability;

  // ✅ الصورة الشخصية — جديد
  final XFile? profileImage;
  final Uint8List? profileImageBytes;

  DoctorRegisterModel({
    this.firstName,
    this.lastName,
    this.email,
    this.professionalEmail,
    this.phoneNumber,
    this.password,
    this.confirmPassword,
    this.dateOfBirth,
    this.gender,
    this.homeAddress,
    this.mainSpecialty,
    this.subSpecialty,
    this.universityDegreeImage,
    this.universityDegreeBytes,
    this.educationDegree,
    this.licenseImage,
    this.licenseBytes,
    this.licenseNumber,
    this.workplaces = const [],
    this.experienceYears,
    this.bio,
    this.offersOnlineConsultation = false,
    this.onlineConsultationDuration,
    this.onlineConsultationFee,
    this.onlineAvailability,
    this.profileImage,
    this.profileImageBytes,
  });

  DoctorRegisterModel copyWith({
    String? firstName,
    String? lastName,
    String? email,
    String? professionalEmail,
    String? phoneNumber,
    String? password,
    String? confirmPassword,
    String? dateOfBirth,
    String? gender,
    String? homeAddress,
    String? mainSpecialty,
    String? subSpecialty,
    XFile? universityDegreeImage,
    Uint8List? universityDegreeBytes,
    String? educationDegree,
    XFile? licenseImage,
    Uint8List? licenseBytes,
    String? licenseNumber,
    List<WorkplaceInfo>? workplaces,
    String? experienceYears,
    String? bio,
    bool? offersOnlineConsultation,
    String? onlineConsultationDuration,
    String? onlineConsultationFee,
    String? onlineAvailability,
    XFile? profileImage,
    Uint8List? profileImageBytes,
  }) {
    return DoctorRegisterModel(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      professionalEmail: professionalEmail ?? this.professionalEmail,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      gender: gender ?? this.gender,
      homeAddress: homeAddress ?? this.homeAddress,
      mainSpecialty: mainSpecialty ?? this.mainSpecialty,
      subSpecialty: subSpecialty ?? this.subSpecialty,
      universityDegreeImage: universityDegreeImage ?? this.universityDegreeImage,
      universityDegreeBytes: universityDegreeBytes ?? this.universityDegreeBytes,
      educationDegree: educationDegree ?? this.educationDegree,
      licenseImage: licenseImage ?? this.licenseImage,
      licenseBytes: licenseBytes ?? this.licenseBytes,
      licenseNumber: licenseNumber ?? this.licenseNumber,
      workplaces: workplaces ?? this.workplaces,
      experienceYears: experienceYears ?? this.experienceYears,
      bio: bio ?? this.bio,
      offersOnlineConsultation:
      offersOnlineConsultation ?? this.offersOnlineConsultation,
      onlineConsultationDuration:
      onlineConsultationDuration ?? this.onlineConsultationDuration,
      onlineConsultationFee:
      onlineConsultationFee ?? this.onlineConsultationFee,
      onlineAvailability: onlineAvailability ?? this.onlineAvailability,
      profileImage: profileImage ?? this.profileImage,
      profileImageBytes: profileImageBytes ?? this.profileImageBytes,
    );
  }

  /// الاسم الكامل للطبيب
  String get fullName => '${firstName ?? ''} ${lastName ?? ''}'.trim();

  /// الأحرف الأولى للعرض في الـ avatar عند غياب الصورة
  String get initials {
    final f = (firstName?.isNotEmpty == true) ? firstName![0].toUpperCase() : '';
    final l = (lastName?.isNotEmpty == true) ? lastName![0].toUpperCase() : '';
    return '$f$l';
  }

  Map<String, dynamic> toJson() => {
    'firstName': firstName,
    'lastName': lastName,
    'email': email,
    'professionalEmail': professionalEmail,
    'phoneNumber': phoneNumber,
    'password': password,
    'dateOfBirth': dateOfBirth,
    'gender': gender,
    'homeAddress': homeAddress,
    'mainSpecialty': mainSpecialty,
    'subSpecialty': subSpecialty,
    'educationDegree': educationDegree,
    'licenseNumber': licenseNumber,
    'workplaces': workplaces.map((w) => w.toJson()).toList(),
    'experienceYears': experienceYears,
    'bio': bio,
    'onlineConsultation': {
      'offered': offersOnlineConsultation,
      'duration': onlineConsultationDuration,
      'fee': onlineConsultationFee,
      'availability': onlineAvailability,
    },
  };
}
