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
