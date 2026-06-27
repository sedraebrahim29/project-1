/// نموذج بيانات الطبيب كما يصل من الـ API في شاشة القائمة
class DoctorListingModel {
  final String id;
  final String firstName;
  final String lastName;
  final String mainSpecialty;
  final String subSpecialty;
  final String? profileImageUrl;   // URL من السيرفر بعد الرفع
  final double rating;
  final int reviewCount;
  final List<String> workplaceNames;
  final String primaryWorkplaceType; // hospital / center / clinic
  final String? availabilityStatus;  // 'today' | 'tomorrow' | 'in_N_days' | null
  final int? availableInDays;
  final double consultationFee;      // أقل سعر من أماكن العمل
  final bool offersOnlineConsultation;
  final String? educationDegree;
  final String? experienceYears;
  final bool isFavourite;

  DoctorListingModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.mainSpecialty,
    required this.subSpecialty,
    this.profileImageUrl,
    required this.rating,
    required this.reviewCount,
    required this.workplaceNames,
    required this.primaryWorkplaceType,
    this.availabilityStatus,
    this.availableInDays,
    required this.consultationFee,
    required this.offersOnlineConsultation,
    this.educationDegree,
    this.experienceYears,
    this.isFavourite = false,
  });

  String get fullName => 'Dr. $firstName $lastName';

  String get initials {
    final f = firstName.isNotEmpty ? firstName[0].toUpperCase() : '';
    final l = lastName.isNotEmpty ? lastName[0].toUpperCase() : '';
    return '$f$l';
  }

  DoctorListingModel copyWith({bool? isFavourite}) => DoctorListingModel(
    id: id,
    firstName: firstName,
    lastName: lastName,
    mainSpecialty: mainSpecialty,
    subSpecialty: subSpecialty,
    profileImageUrl: profileImageUrl,
    rating: rating,
    reviewCount: reviewCount,
    workplaceNames: workplaceNames,
    primaryWorkplaceType: primaryWorkplaceType,
    availabilityStatus: availabilityStatus,
    availableInDays: availableInDays,
    consultationFee: consultationFee,
    offersOnlineConsultation: offersOnlineConsultation,
    educationDegree: educationDegree,
    experienceYears: experienceYears,
    isFavourite: isFavourite ?? this.isFavourite,
  );

  factory DoctorListingModel.fromJson(Map<String, dynamic> json) =>
      DoctorListingModel(
        id: json['id'] as String,
        firstName: json['firstName'] as String,
        lastName: json['lastName'] as String,
        mainSpecialty: json['mainSpecialty'] as String,
        subSpecialty: json['subSpecialty'] as String,
        profileImageUrl: json['profileImageUrl'] as String?,
        rating: (json['rating'] as num).toDouble(),
        reviewCount: json['reviewCount'] as int,
        workplaceNames: List<String>.from(json['workplaceNames'] as List),
        primaryWorkplaceType: json['primaryWorkplaceType'] as String,
        availabilityStatus: json['availabilityStatus'] as String?,
        availableInDays: json['availableInDays'] as int?,
        consultationFee: (json['consultationFee'] as num).toDouble(),
        offersOnlineConsultation:
        json['offersOnlineConsultation'] as bool? ?? false,
        educationDegree: json['educationDegree'] as String?,
        experienceYears: json['experienceYears'] as String?,
        isFavourite: json['isFavourite'] as bool? ?? false,
      );
}
