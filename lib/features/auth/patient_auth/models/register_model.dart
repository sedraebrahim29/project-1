class RegisterModel {
  final String? email;
  final String? password;
  final String? confirmPassword;
  final String? firstName;
  final String? lastName;
  final String? idCardNumber;

  final String? phone;
  final String? dateOfBirth;
  final String? gender;
  final String? homeAddress;
<<<<<<< HEAD
  final double? latitude;
  final double? longitude;
=======
>>>>>>> 6f2cf5c88c0f04be6d75e9a7241f4aeaf98d82f7
  final String? bloodType;

  final String? verificationCode;

  RegisterModel({
    this.email,
    this.password,
    this.confirmPassword,
    this.firstName,
    this.lastName,
    this.idCardNumber,
    this.phone,
    this.dateOfBirth,
    this.gender,
    this.homeAddress,
<<<<<<< HEAD
    this.latitude,
    this.longitude,
=======
>>>>>>> 6f2cf5c88c0f04be6d75e9a7241f4aeaf98d82f7
    this.bloodType,
    this.verificationCode,
  });

  RegisterModel copyWith({
    String? email,
    String? password,
    String? confirmPassword,
    String? firstName,
    String? lastName,
    String? idCardNumber,
    String? phone,
    String? dateOfBirth,
    String? gender,
    String? homeAddress,
<<<<<<< HEAD
    double? latitude,
    double? longitude,
=======
>>>>>>> 6f2cf5c88c0f04be6d75e9a7241f4aeaf98d82f7
    String? bloodType,
    String? verificationCode,
  }) {
    return RegisterModel(
      email: email ?? this.email,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      idCardNumber: idCardNumber ?? this.idCardNumber,
      phone: phone ?? this.phone,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      gender: gender ?? this.gender,
      homeAddress: homeAddress ?? this.homeAddress,
<<<<<<< HEAD
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
=======
>>>>>>> 6f2cf5c88c0f04be6d75e9a7241f4aeaf98d82f7
      bloodType: bloodType ?? this.bloodType,
      verificationCode: verificationCode ?? this.verificationCode,
    );
  }

}
