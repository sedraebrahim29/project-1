import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';

class DoctorRegisterModel {

  final String? firstName;
  final String? lastName;
  final String? email;
  final String? password;
  final String? confirmPassword;
  final String? idCardNumber;

  final String? verificationCode;

  final String? phone;
  final String? dateOfBirth;
  final String? gender;
  final String? homeAddress;
  final double? latitude;
  final double? longitude;

  final XFile? idCardImage;
  final Uint8List? idCardBytes;

  final XFile? photoImage;
  final Uint8List? photoBytes;

  final XFile? licenseImage;
  final Uint8List? licenseBytes;

  final List<XFile> certificatesImages;
  final List<Uint8List> certificatesBytes;

  final String? registrationMode;
  final String? clinicId;

  final String? clinicName;
  final String? clinicAddress;
  final double? clinicLatitude;
  final double? clinicLongitude;
  final String? clinicPhone;
  final String? consultationFee;
  final XFile? clinicLicenseImage;
  final Uint8List? clinicLicenseBytes;

  // مضافة: مطلوبة من الباك بـ /auth/complete-profile (بكلا وضعي
  // join_clinic و create_clinic حسب الـ Postman collection) - كانت
  // ناقصة بالكامل بالموديل القديم وهاد كان سبب فشل الـ validation
  // ("department_ids" / "practice_start_date" required).
  final List<String> departmentIds;
  final String? practiceStartDate;

  DoctorRegisterModel({
    this.firstName,
    this.lastName,
    this.email,
    this.password,
    this.confirmPassword,
    this.idCardNumber,
    this.verificationCode,
    this.phone,
    this.dateOfBirth,
    this.gender,
    this.homeAddress,
    this.latitude,
    this.longitude,
    this.idCardImage,
    this.idCardBytes,
    this.photoImage,
    this.photoBytes,
    this.licenseImage,
    this.licenseBytes,
    this.certificatesImages = const [],
    this.certificatesBytes = const [],
    this.registrationMode,
    this.clinicId,
    this.clinicName,
    this.clinicAddress,
    this.clinicLatitude,
    this.clinicLongitude,
    this.clinicPhone,
    this.consultationFee,
    this.clinicLicenseImage,
    this.clinicLicenseBytes,
    this.departmentIds = const [],
    this.practiceStartDate,
  });

  DoctorRegisterModel copyWith({
    String? firstName,
    String? lastName,
    String? email,
    String? password,
    String? confirmPassword,
    String? idCardNumber,
    String? verificationCode,
    String? phone,
    String? dateOfBirth,
    String? gender,
    String? homeAddress,
    double? latitude,
    double? longitude,
    XFile? idCardImage,
    Uint8List? idCardBytes,
    XFile? photoImage,
    Uint8List? photoBytes,
    XFile? licenseImage,
    Uint8List? licenseBytes,
    List<XFile>? certificatesImages,
    List<Uint8List>? certificatesBytes,
    String? registrationMode,
    String? clinicId,
    String? clinicName,
    String? clinicAddress,
    double? clinicLatitude,
    double? clinicLongitude,
    String? clinicPhone,
    String? consultationFee,
    XFile? clinicLicenseImage,
    Uint8List? clinicLicenseBytes,
    List<String>? departmentIds,
    String? practiceStartDate,
  }) {
    return DoctorRegisterModel(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      idCardNumber: idCardNumber ?? this.idCardNumber,
      verificationCode: verificationCode ?? this.verificationCode,
      phone: phone ?? this.phone,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      gender: gender ?? this.gender,
      homeAddress: homeAddress ?? this.homeAddress,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      idCardImage: idCardImage ?? this.idCardImage,
      idCardBytes: idCardBytes ?? this.idCardBytes,
      photoImage: photoImage ?? this.photoImage,
      photoBytes: photoBytes ?? this.photoBytes,
      licenseImage: licenseImage ?? this.licenseImage,
      licenseBytes: licenseBytes ?? this.licenseBytes,
      certificatesImages: certificatesImages ?? this.certificatesImages,
      certificatesBytes: certificatesBytes ?? this.certificatesBytes,
      registrationMode: registrationMode ?? this.registrationMode,
      clinicId: clinicId ?? this.clinicId,
      clinicName: clinicName ?? this.clinicName,
      clinicAddress: clinicAddress ?? this.clinicAddress,
      clinicLatitude: clinicLatitude ?? this.clinicLatitude,
      clinicLongitude: clinicLongitude ?? this.clinicLongitude,
      clinicPhone: clinicPhone ?? this.clinicPhone,
      consultationFee: consultationFee ?? this.consultationFee,
      clinicLicenseImage: clinicLicenseImage ?? this.clinicLicenseImage,
      clinicLicenseBytes: clinicLicenseBytes ?? this.clinicLicenseBytes,
      departmentIds: departmentIds ?? this.departmentIds,
      practiceStartDate: practiceStartDate ?? this.practiceStartDate,
    );
  }

}
