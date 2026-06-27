// lib/core/constants/app_strings.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled3/core/constants/setting.dart';
class AppStrings {
  static bool _isEn(BuildContext context) {
    return BlocProvider.of<SettingsCubit>(context).state.locale.languageCode ==
        'en';
  }

  // --- General & Login ---
  static String welcomeMessage(BuildContext context) =>
      _isEn(context) ? 'Welcome to MedZone' : 'مرحباً بك في MedZone';
  static String login(BuildContext context) =>
      _isEn(context) ? 'Login' : 'تسجيل الدخول';
  static String signIn(BuildContext context) =>
      _isEn(context) ? 'Sign In' : 'دخول';
  static String signUpAs(BuildContext context) =>
      _isEn(context) ? 'Sign up as' : 'التسجيل كـ';
  static String doctor(BuildContext context) =>
      _isEn(context) ? 'Doctor' : 'طبيب';
  static String patient(BuildContext context) =>
      _isEn(context) ? 'Patient' : 'مريض';
  static String createAccount(BuildContext context) =>
      _isEn(context) ? ' Register' : 'إنشاء حساب';
  static String forgotPassword(BuildContext context) =>
      _isEn(context) ? 'Forgot Password?' : 'نسيت كلمة المرور؟';
  static String rememberDevice(BuildContext context) =>
      _isEn(context) ? 'Remember this device' : 'تذكر هذا الجهاز';
  static String orContinue(BuildContext context) =>
      _isEn(context) ? 'OR CONTINUE WITH' : 'أو المتابعة بواسطة';
  static String google(BuildContext context) =>
      _isEn(context) ? 'Google' : 'غوغل';
  static String apple(BuildContext context) => _isEn(context) ? 'Apple' : 'آبل';

  // --- Footer & Legal -
  static String loginFooterPre(BuildContext context) => _isEn(context)
      ? 'By logging in, you agree to our '
      : 'بتسجيل الدخول، فإنك توافق على ';
  static String termsOfService(BuildContext context) =>
      _isEn(context) ? 'Terms of Service' : 'شروط الخدمة';
  static String loginFooterAnd(BuildContext context) =>
      _isEn(context) ? ' and ' : ' و ';
  static String privacyPolicy(BuildContext context) =>
      _isEn(context) ? 'Privacy Policy.' : 'سياسة الخصوصية.';
  static String termsReviewNote(BuildContext context) => _isEn(context)
      ? 'By submitting this form, you agree to our Terms of Service and acknowledge our Privacy Policy regarding the handling of your medical and personal data.'
      : 'بتقديم هذا النموذج، فإنك توافق على شروط الخدمة الخاصة بنا وتقر بسياسة الخصوصية المتعلقة بالتعامل مع بياناتك الطبية والشخصية.';

  // --- Basic Information ---
  static String firstName(BuildContext context) =>
      _isEn(context) ? 'First Name' : 'الاسم الأول';
  static String firstNameHint(BuildContext context) =>
      _isEn(context) ? 'John' : 'أحمد';
  static String lastName(BuildContext context) =>
      _isEn(context) ? 'Last Name' : 'الاسم الأخير';
  static String lastNameHint(BuildContext context) =>
      _isEn(context) ? 'Doe' : 'العلوان';
  static String fullName(BuildContext context) =>
      _isEn(context) ? 'Full Name' : 'الاسم الكامل';
  static String emailAddress(BuildContext context) =>
      _isEn(context) ? 'Email Address' : 'البريد الإلكتروني';
  static String emailHint(BuildContext context) =>
      _isEn(context) ? 'example@mail.com' : 'example@mail.com';
  static String professionalEmail(BuildContext context) =>
      _isEn(context) ? 'Professional Email' : 'البريد الإلكتروني المهني';
  static String phoneNumber(BuildContext context) =>
      _isEn(context) ? 'Phone Number' : 'رقم الهاتف';
  static String phoneHint(BuildContext context) =>
      _isEn(context) ? '+963 9xx xxx xxx' : '+963 9xx xxx xxx';
  static String password(BuildContext context) =>
      _isEn(context) ? 'Password' : 'كلمة المرور';
  static String passwordHint(BuildContext context) =>
      _isEn(context) ? '••••••••' : '••••••••';
  static String confirmPassword(BuildContext context) =>
      _isEn(context) ? 'Confirm Password' : 'تأكيد كلمة المرور';

  // --- Step Titles & Subtitles ---
  static String tellUsAboutYourself(BuildContext context) =>
      _isEn(context) ? 'Tell us about yourself' : 'أخبرنا عن نفسك';
  static String provideBasicInfo(BuildContext context) => _isEn(context)
      ? 'Please provide your basic information'
      : 'يرجى إدخال معلوماتك الأساسية لبدء التسجيل';
  static String personalDetails(BuildContext context) =>
      _isEn(context) ? 'Personal Details' : 'التفاصيل الشخصية';
  static String personalDetailsHint(BuildContext context) =>
      _isEn(context) ? 'Personal Details' : 'تفاصيل شخصية';
  static String providePersonalInfo(BuildContext context) => _isEn(context)
      ? 'Please enter your personal details accurately'
      : 'يرجى إدخال معلوماتك الشخصية بدقة';
  static String professionalDocuments(BuildContext context) =>
      _isEn(context) ? 'Professional Documents' : 'الوثائق المهنية';
  static String uploadCertificatesHint(BuildContext context) => _isEn(context)
      ? 'Please upload your certificates for verification'
      : 'يرجى تحميل شهاداتك للتحقق من هويتك المهنية';
  static String professionalInfo(BuildContext context) =>
      _isEn(context) ? 'Professional Information' : 'المعلومات المهنية';
  static String workplaceExperienceHint(BuildContext context) => _isEn(context)
      ? 'Current workplaces and experience'
      : 'أماكن العمل الحالية والخبرة';
  static String reviewSubmit(BuildContext context) =>
      _isEn(context) ? 'Review & Submit' : 'المراجعة والإرسال';
  static String reviewInstructions(BuildContext context) => _isEn(context)
      ? 'Please review your information below before submitting.'
      : 'يرجى مراجعة معلوماتك أدناه قبل الإرسال النهائي.';

  // --- Detailed Personal Info ---
  static String dateOfBirth(BuildContext context) =>
      _isEn(context) ? 'Date of Birth' : 'تاريخ الميلاد';
  static String dateOfBirthHint(BuildContext context) =>
      _isEn(context) ? 'YYYY-MM-DD' : 'YYYY-MM-DD';
  static String gender(BuildContext context) =>
      _isEn(context) ? 'Gender' : 'الجنس';
  static String selectGender(BuildContext context) =>
      _isEn(context) ? 'Select Gender' : 'اختر الجنس';
  static String male(BuildContext context) => _isEn(context) ? 'Male' : 'ذكر';
  static String female(BuildContext context) =>
      _isEn(context) ? 'Female' : 'أنثى';
  static String nationality(BuildContext context) =>
      _isEn(context) ? 'Nationality' : 'الجنسية';
  static String enterFullAddress(BuildContext context) =>
      _isEn(context) ? 'Enter Full Address' : 'ادخل عنوانك الكامل';
  static String nationalIdNumber(BuildContext context) =>
      _isEn(context) ? 'National ID Number' : 'رقم الهوية الوطنية';
  static String nationalityHint(BuildContext context) =>
      _isEn(context) ? 'e.g. Syrian' : 'مثال: سوري';
  static String residentialAddress(BuildContext context) =>
      _isEn(context) ? 'Residential Address' : 'مكان الإقامة / العنوان';
  static String homeAddress(BuildContext context) =>
      _isEn(context) ? 'Home Address' : 'عنوان السكن';
  static String streetAddress(BuildContext context) =>
      _isEn(context) ? 'Street Address' : 'عنوان الشارع';
  static String cityStateZip(BuildContext context) =>
      _isEn(context) ? 'City, State, Zip' : 'المدينة، الولاية، الرمز البريدي';
  static String addressHint(BuildContext context) =>
      _isEn(context) ? 'Street, City, Country' : 'الشارع، المدينة، الدولة';

  // --- Professional/Doctor Specific ---
  static String mainSpecialty(BuildContext context) =>
      _isEn(context) ? 'Main Specialty' : 'التخصص الرئيسي';
  static String subSpecialty(BuildContext context) =>
      _isEn(context) ? 'Sub Specialty' : 'التخصص الفرعي';
  static String selectSpecialty(BuildContext context) =>
      _isEn(context) ? 'Select Specialty' : 'اختر التخصص';
  static String universityDegree(BuildContext context) =>
      _isEn(context) ? 'University Degree' : 'الشهادة الجامعية';
  static String educationDegree(BuildContext context) =>
      _isEn(context) ? 'Education Degree' : 'الدرجة العلمية';
  static String practiceLicense(BuildContext context) =>
      _isEn(context) ? 'Practice License' : 'مزاولة المهنة';
  static String licenseNumber(BuildContext context) =>
      _isEn(context) ? 'License Number' : 'رقم الترخيص';
  static String uploadImage(BuildContext context) =>
      _isEn(context) ? 'Upload Image' : 'رفع صورة';
  static String workplaces(BuildContext context) =>
      _isEn(context) ? 'Workplaces' : 'أماكن العمل';
  static String addWorkplace(BuildContext context) =>
      _isEn(context) ? 'Add Workplace' : 'إضافة مكان عمل';
  static String workplaceType(BuildContext context) =>
      _isEn(context) ? 'Workplace Type' : 'نوع مكان العمل';
  static String workplaceName(BuildContext context) =>
      _isEn(context) ? 'Workplace Name' : 'اسم مكان العمل';
  static String hospital(BuildContext context) =>
      _isEn(context) ? 'Hospital' : 'مستشفى';
  static String center(BuildContext context) =>
      _isEn(context) ? 'Medical Center' : 'مركز طبي';
  static String clinic(BuildContext context) =>
      _isEn(context) ? 'Clinic' : 'عيادة';
  static String experienceYearsLabel(BuildContext context) =>
      _isEn(context) ? 'Experience Years' : 'سنوات الخبرة';
  static String briefBio(BuildContext context) =>
      _isEn(context) ? 'Brief Bio' : 'نبذة عنك';
  static String optional(BuildContext context) =>
      _isEn(context) ? '(Optional)' : '(اختياري)';
  static String bioHintText(BuildContext context) => _isEn(context)
      ? 'Write a small bio...'
      : 'اكتب نبذة مختصرة عن مسيرتك المهنية...';
  static String onlineConsultation(BuildContext context) =>
      _isEn(context) ? 'Online Consultation' : 'استشارات الكترونية';
  static String onlineConsultationDesc(BuildContext context) => _isEn(context)
      ? 'Enable temporary chat consultations'
      : 'تفعيل خاصية الاستشارات عبر الشات المؤقت';
  static String duration(BuildContext context) =>
      _isEn(context) ? 'Duration' : 'المدة';
  static String fee(BuildContext context) => _isEn(context) ? 'Fee' : 'السعر';
  static String availability(BuildContext context) =>
      _isEn(context) ? 'Availability on App' : 'ساعات التواجد على التطبيق';
  static String workingHours(BuildContext context) =>
      _isEn(context) ? 'Working Hours' : 'ساعات العمل';

  // --- Identity Verification (Patient) ---
  static String verifyYourIdentity(BuildContext context) =>
      _isEn(context) ? 'Verify your identity' : 'تحقق من هويتك';
  static String uploadClearImage(BuildContext context) => _isEn(context)
      ? 'Upload a clear image of your national ID or passport to continue.'
      : 'قم بتحميل صورة واضحة لبطاقة الهوية الوطنية أو جواز السفر للمتابعة.';
  static String tapToCapture(BuildContext context) =>
      _isEn(context) ? 'Tap to capture' : 'انقر للالتقاط';
  static String orBrowseFiles(BuildContext context) =>
      _isEn(context) ? 'or browse files' : 'أو تصفح الملفات';
  static String identityDataEncrypted(BuildContext context) => _isEn(context)
      ? 'Your identity data is encrypted and stored securely following medical compliance standards.'
      : 'بيانات هويتك مشفرة ومخزنة بشكل آمن باتباع معايير الامتثال الطبي.';
  static String identityVerificationTitle(BuildContext context) =>
      _isEn(context) ? 'Identity Verification' : 'التحقق من الهوية';
  static String documentScannedSuccessfully(BuildContext context) =>
      _isEn(context)
          ? 'Your document has been successfully scanned and verified.'
          : 'تم مسح مستندك والتحقق منه بنجاح.';

  // --- Review Sections ---
  static String basicInfo(BuildContext context) =>
      _isEn(context) ? 'Basic Info' : 'المعلومات الأساسية';
  static String accountInfo(BuildContext context) =>
      _isEn(context) ? 'Account Information' : 'معلومات الحساب';
  static String specialtyAndDetails(BuildContext context) =>
      _isEn(context) ? 'Specialty & Details' : 'التخصص والتفاصيل';
  static String documents(BuildContext context) =>
      _isEn(context) ? 'Documents' : 'الوثائق';
  static String workAndExperience(BuildContext context) =>
      _isEn(context) ? 'Work & Experience' : 'العمل والخبرة';

  // --- Buttons & Navigation ---
  static String nextStep(BuildContext context) =>
      _isEn(context) ? 'Next Step' : 'الخطوة التالية';
  static String back(BuildContext context) =>
      _isEn(context) ? 'Back' : 'السابق';
  static String submit(BuildContext context) =>
      _isEn(context) ? 'Submit' : 'إرسال البيانات';
  static String confirmSubmit(BuildContext context) =>
      _isEn(context) ? 'Confirm & Submit' : 'تأكيد وإرسال';
  static String retake(BuildContext context) =>
      _isEn(context) ? 'Retake' : 'إعادة التقاط';
  static String cancel(BuildContext context) =>
      _isEn(context) ? 'Cancel' : 'إلغاء';
  static String add(BuildContext context) => _isEn(context) ? 'Add' : 'إضافة';
  static String saveDraft(BuildContext context) =>
      _isEn(context) ? 'Save Draft' : 'حفظ كمسودة';
  static String continueText(BuildContext context) =>
      _isEn(context) ? 'Continue' : 'متابعة';

  // --- Validations & Warnings ---
  static String requiredField(BuildContext context) =>
      _isEn(context) ? 'This field is required' : 'هذا الحقل مطلوب';
  static String invalidEmail(BuildContext context) => _isEn(context)
      ? 'Please enter a valid email address'
      : 'يرجى إدخال بريد إلكتروني صحيح';
  static String passwordLengthWarning(BuildContext context) => _isEn(context)
      ? 'Must be at least 8 characters'
      : 'يجب ألا تقل عن 8 خانات أو رموز';
  static String passwordsDoNotMatch(BuildContext context) =>
      _isEn(context) ? 'Passwords do not match' : 'كلمات المرور غير متطابقة';
  static String viewProfile(BuildContext context) =>
      _isEn(context) ? 'viewProfile' : 'الملف الشخصي';
  static String findDoctorTitle(BuildContext context) =>
      _isEn(context) ? 'find Doctor' : 'البحث عن دكتور';

  // --- Specialties Lists ---
  static List<String> mainSpecialties(BuildContext context) => _isEn(context)
      ? ['Medicine', 'Dentistry', 'Pharmacy']
      : ['الطب البشري', 'طب الأسنان', 'الصيدلة'];

  static List<String> subSpecialties(BuildContext context, String main) {
    final isEn = _isEn(context);
    if (main == 'Medicine' || main == 'الطب البشري') {
      return isEn
          ? [
        'Cardiology',
        'Dermatology',
        'Neurology',
        'Pediatrics',
        'Surgery',
        'Orthopedics',
        'Ophthalmology',
        'ENT',
      ]
          : [
        'قلبية',
        'جلدية',
        'عصبية',
        'أطفال',
        'جراحة عامة',
        'عظمية',
        'عينية',
        'أذن أنف حنجرة',
      ];
    }
    if (main == 'Dentistry' || main == 'طب الأسنان') {
      return isEn
          ? [
        'Orthodontics',
        'Endodontics',
        'Oral Surgery',
        'Periodontics',
        'Pedodontics',
      ]
          : ['تقويم', 'معالجة لبية', 'جراحة فم', 'لثة', 'أسنان أطفال'];
    }
    if (main == 'Pharmacy' || main == 'الصيدلة') {
      return isEn
          ? ['Clinical Pharmacy', 'Pharmacology']
          : ['صيدلة سريرية', 'علم أدوية'];
    }
    return isEn ? ['General'] : ['عام'];
  }

  static String reviewSubmitTitle(BuildContext context) =>
      _isEn(context) ? 'Review & Submit' : 'المراجعة والإرسال';
  static String reviewSubmitDesc(BuildContext context) => _isEn(context)
      ? 'Please verify that all the information provided is correct before finalizing your profile creation. A complete and accurate profile ensures better care.'
      : 'يرجى التحقق من أن جميع المعلومات المقدمة صحيحة قبل إنهاء إنشاء ملفك الشخصي. الملف الشخصي الكامل والدقيق يضمن رعاية أفضل.';

  static String basicInfoSection(BuildContext context) =>
      _isEn(context) ? 'Basic Info' : 'المعلومات الأساسية';
  static String historySection(BuildContext context) =>
      _isEn(context) ? 'History' : 'السجل الطبي';
  static String medsSection(BuildContext context) =>
      _isEn(context) ? 'Meds' : 'الأدوية';

  static String knownAllergiesLabel(BuildContext context) =>
      _isEn(context) ? 'Known Allergies' : 'الحساسية المعروفة';
  static String chronicConditionsLabel(BuildContext context) =>
      _isEn(context) ? 'Chronic Conditions' : 'الأمراض المزمنة';
  static String pastSurgeriesLabel(BuildContext context) => _isEn(context)
      ? 'Past Surgeries / Procedures'
      : 'العمليات الجراحية / الإجراءات السابقة';

  static String confirmSubmitButton(BuildContext context) =>
      _isEn(context) ? 'Confirm & Submit Profile' : 'تأكيد وإرسال الملف الشخصي';

  static String privacyStatementPrefix(BuildContext context) => _isEn(context)
      ? 'Your data is securely encrypted. By submitting, you agree to the '
      : 'بياناتك مشفرة بشكل آمن. من خلال الإرسال، فإنك توافق على ';
  static String termsOfServiceLink(BuildContext context) =>
      _isEn(context) ? 'Terms of Service' : 'شروط الخدمة';
  static String privacyStatementMiddle(BuildContext context) =>
      _isEn(context) ? ' and acknowledge the ' : ' وتقر بـ ';
  static String privacyPolicyLink(BuildContext context) =>
      _isEn(context) ? 'Privacy Policy' : 'سياسة الخصوصية';
  static String privacyStatementSuffix(BuildContext context) => _isEn(context)
      ? ' regarding your Protected Health Information (PHI).'
      : ' فيما يتعلق بمعلوماتك الصحية المحمية (PHI).';
  static String medicalProfileTitle(BuildContext context) =>
      _isEn(context) ? 'Medical Profile' : 'الملف الطبي';
  static String attachmentsSection(BuildContext context) =>
      _isEn(context) ? 'Attachments Section' : 'قسم المرفقات';
  static String uploadFilesTitle(BuildContext context) =>
      _isEn(context) ? 'Upload Files' : 'تحميل الملفات';
  static String uploadFilesDesc(BuildContext context) => _isEn(context)
      ? 'Please provide any relevant documents to complete your profile. This helps us tailor your care.'
      : 'يرجى تقديم أي وثائق طبية ذات صلة لإكمال ملفك التعريفي ومساعدتنا في تخصيص الرعاية الخاصة بك.';
  static String attachedFilesSection(BuildContext context) =>
      _isEn(context) ? 'Attached Files Section' : 'قسم الملفات المرفقة';

  // --- نصوص إضافية مستخدمة في الشاشات السابقة لضمان الاكتمال التام ---
  static String medicalHistoryTitle(BuildContext context) =>
      _isEn(context) ? 'Medical History' : 'التاريخ الطبي';
  static String medicalHistoryDesc(BuildContext context) => _isEn(context)
      ? 'Please provide details about your past and current medical conditions to help us tailor your care.'
      : 'يرجى تقديم تفاصيل حول حالتك الطبية السابقة والحالية لمساعدتنا في تخصيص رعاية صحية لك.';
  static String chronicDiseasesSection(BuildContext context) =>
      _isEn(context) ? 'Chronic Diseases' : 'الأمراض المزمنة';
  static String surgeriesSection(BuildContext context) =>
      _isEn(context) ? 'Surgeries' : 'العمليات الجراحية';
  static String allergiesSection(BuildContext context) =>
      _isEn(context) ? 'Allergies' : 'الحساسية';
  static String familyHistorySection(BuildContext context) =>
      _isEn(context) ? 'Family History' : 'التاريخ الطبي للعائلة';
  static String medicationsTitle(BuildContext context) =>
      _isEn(context) ? 'Medications' : 'الأدوية';
  static String medicationsDesc(BuildContext context) => _isEn(context)
      ? 'Please review or add your current prescribed medications and dosages.'
      : 'يرجى مراجعة أو إضافة أدوية وجرعات موصوفة لك حالياً.';
  static String attachedFilesTitle(BuildContext context) =>
      _isEn(context) ? 'Attached Files' : 'الملفات المرفقة';
  static String addNew(BuildContext context) =>
      _isEn(context) ? 'Add New ' : 'اضافة جديدة ';
  static String tapToUpload(BuildContext context) =>
      _isEn(context) ? 'Tap to upload file' : 'اضغط لرفع الملف';
  static String orDragDrop(BuildContext context) =>
      _isEn(context) ? 'or drag and drop here' : 'أو قم بسحب وإفلاته هنا';
  static String medicalRecords(BuildContext context) =>
      _isEn(context) ? 'medical Record' : 'السجل الطبي';
  static String encountersHistory(BuildContext context) =>
      _isEn(context) ? 'encounters History' : 'تواريخ المقابلات';
  static String comprehensiveHistory(BuildContext context) =>
      _isEn(context) ? 'Comprehensive History' : 'التاريخ المرضي الشامل';
  static String otherConditions(BuildContext context) =>
      _isEn(context) ? 'Other Conditions' : 'حالات اخرى';
  static String familyHistory(BuildContext context) =>
      _isEn(context) ? 'Family History' : 'التاريخ العائلي (وراثة)';
  static String allergies(BuildContext context) =>
      _isEn(context) ? 'allergies' : 'الحساسية';
  static String surgeries(BuildContext context) =>
      _isEn(context) ? 'surgeries' : 'العمليات الجراحية';
  static String chronicDiseases(BuildContext context) =>
      _isEn(context) ? 'Chronic Diseases' : 'الامراض المزمنة';
  static String viewAll(BuildContext context) =>
      _isEn(context) ? 'view All' : 'عرض الكل';
  static String view(BuildContext context) =>
      _isEn(context) ? 'view' : 'عرض';
  static String download(BuildContext context) =>
      _isEn(context) ? 'download' : 'تحميل';
  static String prescriptions(BuildContext context) =>
      _isEn(context) ? 'prescriptions' : 'وصفة طبية';
  static String labResults(BuildContext context) =>
      _isEn(context) ? 'labResults' : 'نتائج مخبرية';
  static String medicalImages(BuildContext context) =>
      _isEn(context) ? 'Medical Images' : 'صور طبية';
  static String attachments(BuildContext context) =>
      _isEn(context) ? 'attachments' : 'المرفقات';
  static String activeMedications(BuildContext context) =>
      _isEn(context) ? 'Active Medications' : 'الادوية الحالية';
  static String currentPrescriptions(BuildContext context) =>
      _isEn(context) ? 'Current Prescriptions' : 'الوصفات الطبية الحالية';
  static String manage(BuildContext context) =>
      _isEn(context) ? 'Manage' : 'ادارة';
  static String latestVitals(BuildContext context) =>
      _isEn(context) ? 'Latest Vitals' : 'اخر المستجدات';
  static String viewTrends(BuildContext context) =>
      _isEn(context) ? 'View Trends' : 'عرض الشائعات ';
  static String medications(BuildContext context) =>
      _isEn(context) ? 'medications' : 'الادوية';
  static String history(BuildContext context) =>
      _isEn(context) ? 'history' : 'التاريخ';
  static String overview(BuildContext context) =>
      _isEn(context) ? 'Overview' :'معلومات عامة';
  static String recentActivity(BuildContext context) =>
      _isEn(context) ? 'recent Activity' : 'النشاطات الاخيرة';
  static String diagnosisSummary(BuildContext context) =>
      _isEn(context) ? 'Diagnosis Summary' : 'ملخص التشخيص';
  static String viewFullDetails(BuildContext context) =>
      _isEn(context) ? 'View Full Details' : 'عرض التفاصيل الكاملة';
  static String diagnosed(BuildContext context) => _isEn(context) ? 'Diagnosed' : 'تم التشخيص';
}
