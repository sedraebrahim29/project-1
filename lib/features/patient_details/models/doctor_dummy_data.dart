
/// عيادة واحدة من عيادات الطبيب (بمعرّفها الحقيقي id) - لازم الـ id
/// تحديداً لاستدعاء GET /doctors/{id}/availability بشكل صحيح لكل عيادة
/// (مو بس الاسم للعرض متل workplaceNames).
class DoctorListingClinicRef {
  final int id;
  final String name;
  final double? consultationFee;

  const DoctorListingClinicRef({required this.id, required this.name, this.consultationFee});
}

class DoctorListingModel {
  final String id;
  final String firstName;
  final String lastName;
  final String mainSpecialty;
  final String subSpecialty;
  final String? profileImageUrl;
  final double rating;
  final int reviewCount;
  final List<String> workplaceNames;
  final List<DoctorListingClinicRef> clinicRefs;
  final String primaryWorkplaceType;
  final String? availabilityStatus;
  final int? availableInDays;
  final double consultationFee;
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
    this.clinicRefs = const [],
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
    clinicRefs: clinicRefs,
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

  /// يبني الموديل من شكل الاستجابة الحقيقي لباقي الـ API (snake_case،
  /// نفس بنية account/career/departments/clinics المستخدمة برد
  /// GET /doctor/profile) - يُستخدم من DoctorListingRepository لما ينضاف
  /// endpoint لائحة الأطباء العامة بالباك (راجع ApiConstants.doctorsPublicList).
  /// ✅ يبني الموديل من الشكل الحقيقي المؤكد لرد GET /doctors (لائحة
  /// عامة) - مختلف عن شكل GET /doctor/profile (self): هون "name" اسم
  /// كامل مدمج (مو first/last منفصلين)، والأقسام (departments) عامة
  /// مستقلة عن العيادة، وكل عيادة معها consultation_fee خاص فيها.
  factory DoctorListingModel.fromApiJson(Map<String, dynamic> json) {
    final fullName = json['name']?.toString().trim() ?? '';
    final spaceIndex = fullName.indexOf(' ');
    final firstName = spaceIndex == -1 ? fullName : fullName.substring(0, spaceIndex);
    final lastName = spaceIndex == -1 ? '' : fullName.substring(spaceIndex + 1);

    final departments = json['departments'] as List? ?? const [];
    final clinics = json['clinics'] as List? ?? const [];
    final qualifications = json['qualifications'] as List? ?? const [];

    // نفضّل رسم أول عيادة فعّالة (active) كسعر افتراضي للعرض، وإلا
    // نرجع لـ online_consultation_fee (رسم الاستشارة عن بعد العام).
    double fee = 0;
    final activeClinic = clinics.cast<Map>().where((c) => c['status'] == 'active').toList();
    final feeSource = activeClinic.isNotEmpty ? activeClinic.first : (clinics.isNotEmpty ? clinics.first as Map : null);
    if (feeSource != null && feeSource['consultation_fee'] != null) {
      fee = double.tryParse('${feeSource['consultation_fee']}') ?? 0;
    } else if (json['online_consultation_fee'] != null) {
      fee = double.tryParse('${json['online_consultation_fee']}') ?? 0;
    }

    return DoctorListingModel(
      id: json['id']?.toString() ?? '',
      firstName: firstName,
      lastName: lastName,
      mainSpecialty: departments.isNotEmpty ? (departments.first['name']?.toString() ?? '') : '',
      subSpecialty: departments.length > 1 ? (departments[1]['name']?.toString() ?? '') : '',
      profileImageUrl: json['photo_url']?.toString(),
      rating: 0,
      reviewCount: 0,
      workplaceNames: clinics.map((c) => c['name']?.toString() ?? '').where((s) => s.isNotEmpty).toList(),
      clinicRefs: clinics.cast<Map>().map((c) => DoctorListingClinicRef(
            id: c['id'] is int ? c['id'] as int : int.tryParse('${c['id']}') ?? 0,
            name: c['name']?.toString() ?? '',
            consultationFee: c['consultation_fee'] == null ? null : double.tryParse('${c['consultation_fee']}'),
          )).toList(),
      primaryWorkplaceType: 'clinic',
      consultationFee: fee,
      offersOnlineConsultation: json['online_consultation_fee'] != null,
      educationDegree: qualifications.isNotEmpty ? qualifications.first['degree']?.toString() : null,
    );
  }
}


final List<DoctorListingModel> dummyDoctors = [
  DoctorListingModel(id:'1',firstName:'Sarah',lastName:'Jenkins',mainSpecialty:'Medicine',subSpecialty:'Cardiology',rating:4.9,reviewCount:128,workplaceNames:['City Heart Hospital'],primaryWorkplaceType:'hospital',availabilityStatus:'today',consultationFee:150,offersOnlineConsultation:true,experienceYears:'12',isFavourite:true),
  DoctorListingModel(id:'2',firstName:'Marcus',lastName:'Chen',mainSpecialty:'Medicine',subSpecialty:'General Practice',rating:4.8,reviewCount:95,workplaceNames:['BlueCare Medical Center'],primaryWorkplaceType:'center',availabilityStatus:'tomorrow',consultationFee:90,offersOnlineConsultation:false,experienceYears:'8'),
  DoctorListingModel(id:'3',firstName:'Emily',lastName:'Thorne',mainSpecialty:'Medicine',subSpecialty:'Dermatology',rating:4.9,reviewCount:210,workplaceNames:['Skin & Beauty Clinic'],primaryWorkplaceType:'clinic',availabilityStatus:'today',consultationFee:120,offersOnlineConsultation:true,experienceYears:'15'),
  DoctorListingModel(id:'4',firstName:'Ali',lastName:'Khalid',mainSpecialty:'Dentistry',subSpecialty:'Orthodontics',rating:4.7,reviewCount:67,workplaceNames:['Smile Pro Dental Center'],primaryWorkplaceType:'center',availabilityStatus:'in_N_days',availableInDays:3,consultationFee:80,offersOnlineConsultation:false,experienceYears:'6'),
];
