import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';

class RegisterModel {
  // Step 1
  final String? email;
  final String? phoneNumber;
  final String? password;
  final String? confirmPassword;
  // Step 2
  final String? firstName;
  final String? lastName;
  final String? dateOfBirth;
  final String? gender;
  final String? homeAddress;
  final String? streetAddress;
  final String? cityStateZip;

  // Step 3
  final XFile? scannedImage;
  final Uint8List? webImageBytes;
  RegisterModel({
    this.email,
    this.phoneNumber,
    this.password,
    this.lastName,
    this.confirmPassword,
    this.firstName,
    this.dateOfBirth,
    this.gender,
    this.homeAddress,
    this.streetAddress,
    this.cityStateZip,
    this.scannedImage,
    this.webImageBytes,
  });

  RegisterModel copyWith({
    String? email,
    String? phoneNumber,
    String? password,
    String? confirmPassword,
    String? firstName,
    String? lastName,
    String? dateOfBirth,
    String? gender,
    String? streetAddress,
    String? cityStateZip,
    String? homeAddress,
    XFile? scannedImage,
    Uint8List? webImageBytes,
  }) {
    return RegisterModel(
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      password: password ?? this.password,
      confirmPassword:confirmPassword ?? this.confirmPassword,
      firstName: firstName ?? this.firstName,
      lastName:lastName ?? this.lastName,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      gender: gender ?? this.gender,
      homeAddress:homeAddress??this.homeAddress,
      streetAddress: streetAddress ?? this.streetAddress,
      cityStateZip: cityStateZip ?? this.cityStateZip,
      scannedImage: scannedImage ?? this.scannedImage,
      webImageBytes:webImageBytes??this.webImageBytes,
    );
  }


  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'phone_number': phoneNumber,
      'password': password,
      'confirmPassword':confirmPassword,
      'firstName': firstName,
      'lastName' : lastName,
      'homeAddress' : homeAddress,
      'dob': dateOfBirth,
      'gender': gender?.toLowerCase(),
      'address': {
        'street': streetAddress,
        'city_state_zip': cityStateZip,
      }
    };
  }
}
