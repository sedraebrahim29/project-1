import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:untitled3/core/constants/setting.dart';
import '../../../../core/Theme/app_colors.dart';
import '../../../../core/constants/app_strings_doctor.dart';
import '../../../../core/widgets/location_pick_field.dart';
import '../data/clinics_repository.dart';
import '../data/doctor_repository.dart';
import '../models/clinic_model.dart';

/// شاشة "إضافة عيادة" (طبيب مسجّل أصلاً وبدو ينضم أو ينشئ عيادة ثانية).
///
/// ✅ تحديث 16/8 حسب الكولكشن الأخير: التخصص/القسم ما عاد له علاقة
/// بالانضمام لعيادة (بينحدد مرة وحدة بالريجستر ومستقل عن أي عيادة) -
/// فشلنا خانة اختيار القسم نهائياً من وضع "Join"، وصار المطلوب بس
/// clinic_id + رسم الكشف (consultation_fee). وضع "Create Clinic" صار
/// حقيقي 100% هلق (POST /doctor/profile/clinics/create) بعد ما كان
/// معطّل بانتظار الباك.
class JoinClinicScreen extends StatefulWidget {
  final List<int> alreadyJoinedClinicIds;

  const JoinClinicScreen({super.key, this.alreadyJoinedClinicIds = const []});

  @override
  State<JoinClinicScreen> createState() => _JoinClinicScreenState();
}

class _JoinClinicScreenState extends State<JoinClinicScreen> {
  final DoctorRepository _doctorRepository = DoctorRepository();
  final ClinicsRepository _clinicsRepository = ClinicsRepository();
  final ImagePicker _picker = ImagePicker();

  String _mode = 'join_clinic';
  bool _isSubmitting = false;

  // --- Join mode ---
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _joinFeeController = TextEditingController();
  bool _isSearching = false;
  ClinicModel? _foundClinic;
  String? _searchError;

  // --- Create mode ---
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _createFeeController = TextEditingController();
  double? _latitude;
  double? _longitude;
  Uint8List? _licenseBytes;
  String? _licenseFileName;

  @override
  void dispose() {
    _idController.dispose();
    _joinFeeController.dispose();
    _nameController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    _createFeeController.dispose();
    super.dispose();
  }

  Future<void> _lookup() async {
    final id = int.tryParse(_idController.text.trim());
    if (id == null) return;
    setState(() {
      _isSearching = true;
      _foundClinic = null;
      _searchError = null;
    });
    final clinic = await _clinicsRepository.getClinicById(id);
    if (!mounted) return;
    setState(() {
      _isSearching = false;
      _foundClinic = clinic;
      if (clinic == null) _searchError = DoctorStrings.clinicNotFound(context);
    });
  }

  Future<void> _join() async {
    final clinic = _foundClinic;
    final fee = double.tryParse(_joinFeeController.text.trim());
    if (clinic == null || fee == null) return;
    setState(() => _isSubmitting = true);
    try {
      await _doctorRepository.joinClinic(clinicId: clinic.id, consultationFee: fee);
      if (!mounted) return;
      Navigator.pop(context, true);
    } catch (e) {
      _showError(e);
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  Future<void> _pickLicense() async {
    final XFile? file = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 85);
    if (file == null) return;
    final bytes = await file.readAsBytes();
    setState(() {
      _licenseBytes = bytes;
      _licenseFileName = file.name;
    });
  }

  Future<void> _createClinic() async {
    final name = _nameController.text.trim();
    final address = _addressController.text.trim();
    final phone = _phoneController.text.trim();
    final fee = double.tryParse(_createFeeController.text.trim());
    if (name.isEmpty || address.isEmpty || phone.isEmpty || fee == null) {
      _showMessage('عبّي كل الحقول المطلوبة (بما فيها رسم الكشف)');
      return;
    }
    setState(() => _isSubmitting = true);
    try {
      await _doctorRepository.createClinic(
        name: name,
        address: address,
        phone: phone,
        consultationFee: fee,
        licenseBytes: _licenseBytes,
        licenseFileName: _licenseFileName,
        latitude: _latitude,
        longitude: _longitude,
      );
      if (!mounted) return;
      Navigator.pop(context, true);
    } catch (e) {
      _showError(e);
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  void _showError(Object e) => _showMessage('$e');

  void _showMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message), backgroundColor: const Color(0xFFC0392B)));
  }

  @override
  Widget build(BuildContext context) {
    final settingsState = context.watch<SettingsCubit>().state;
    final isEn = settingsState.locale.languageCode == 'en';
    final isDark = settingsState.themeMode == ThemeMode.dark;
    final scaffoldBg = isDark ? AppColors.darkBackground : AppColors.backgroundBeige;
    final cardBg = isDark ? AppColors.darkCard : AppColors.white;
    final textColor = isDark ? AppColors.darkText : AppColors.textDark;
    final primaryGreen = isDark ? AppColors.darkPrimaryGreen : AppColors.primaryGreen;

    final alreadyJoined = _foundClinic != null && widget.alreadyJoinedClinicIds.contains(_foundClinic!.id);

    return Directionality(
      textDirection: isEn ? TextDirection.ltr : TextDirection.rtl,
      child: Scaffold(
        backgroundColor: scaffoldBg,
        appBar: AppBar(
          backgroundColor: scaffoldBg,
          elevation: 0,
          scrolledUnderElevation: 0,
          leading: IconButton(
            icon: Icon(isEn ? Icons.arrow_back_rounded : Icons.arrow_forward_rounded, color: primaryGreen),
            onPressed: () => Navigator.maybePop(context),
          ),
          title: Text(DoctorStrings.joinClinic(context),
              style: TextStyle(fontSize: 17.sp, fontWeight: FontWeight.w800, color: primaryGreen)),
        ),
        body: Stack(
          children: [
            ListView(
              padding: EdgeInsets.all(16.w),
              children: [
                Container(
                  decoration: BoxDecoration(color: AppColors.textLightGrey.withOpacity(0.10), borderRadius: BorderRadius.circular(8.r)),
                  padding: EdgeInsets.all(4.w),
                  child: Row(
                    children: [
                      Expanded(
                        child: _ModeButton(
                          label: DoctorStrings.joinExistingClinicMode(context),
                          selected: _mode == 'join_clinic',
                          isDark: isDark,
                          onTap: () => setState(() => _mode = 'join_clinic'),
                        ),
                      ),
                      Expanded(
                        child: _ModeButton(
                          label: DoctorStrings.createNewClinicMode(context),
                          selected: _mode == 'create_clinic',
                          isDark: isDark,
                          onTap: () => setState(() => _mode = 'create_clinic'),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20.h),

                if (_mode == 'join_clinic') ...[
                  Text(DoctorStrings.clinicIdLabel(context), style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w500, color: textColor)),
                  SizedBox(height: 6.h),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _idController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText: DoctorStrings.enterClinicIdHint(context),
                            prefixIcon: const Icon(Icons.local_hospital_outlined),
                            filled: true,
                            fillColor: cardBg,
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r), borderSide: BorderSide.none),
                          ),
                          onSubmitted: (_) => _lookup(),
                        ),
                      ),
                      SizedBox(width: 8.w),
                      SizedBox(
                        height: 48.h,
                        child: ElevatedButton(
                          onPressed: _isSearching ? null : _lookup,
                          style: ElevatedButton.styleFrom(
                              backgroundColor: primaryGreen, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r))),
                          child: _isSearching
                              ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                              : Text(DoctorStrings.lookUpClinic(context), style: const TextStyle(color: Colors.white)),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  Text(DoctorStrings.clinicIdTempNote(context), style: TextStyle(fontSize: 11.sp, color: AppColors.textLightGrey)),

                  if (_searchError != null) ...[
                    SizedBox(height: 14.h),
                    Text(_searchError!, style: const TextStyle(color: Color(0xFFC0392B), fontSize: 12.5)),
                  ],

                  if (_foundClinic != null) ...[
                    SizedBox(height: 18.h),
                    Container(
                      padding: EdgeInsets.all(14.w),
                      decoration: BoxDecoration(color: cardBg, borderRadius: BorderRadius.circular(14.r)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.local_hospital_outlined, size: 18.sp, color: primaryGreen),
                              SizedBox(width: 8.w),
                              Expanded(
                                child: Text(_foundClinic!.name,
                                    style: TextStyle(fontSize: 14.5.sp, fontWeight: FontWeight.w700, color: textColor)),
                              ),
                            ],
                          ),
                          if (_foundClinic!.address != null) ...[
                            SizedBox(height: 4.h),
                            Text(_foundClinic!.address!, style: TextStyle(fontSize: 12.sp, color: AppColors.textLightGrey)),
                          ],
                          SizedBox(height: 14.h),
                          if (alreadyJoined)
                            Text(DoctorStrings.alreadyJoinedThisClinic(context),
                                style: TextStyle(fontSize: 12.5.sp, color: primaryGreen, fontWeight: FontWeight.w600))
                          else ...[
                            Text(DoctorStrings.consultationFeeLabel(context),
                                style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600, color: textColor)),
                            SizedBox(height: 6.h),
                            TextField(
                              controller: _joinFeeController,
                              keyboardType: const TextInputType.numberWithOptions(decimal: true),
                              decoration: InputDecoration(
                                hintText: '20',
                                isDense: true,
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r)),
                              ),
                            ),
                            SizedBox(height: 14.h),
                            SizedBox(
                              width: double.infinity,
                              height: 46.h,
                              child: ElevatedButton(
                                onPressed: _isSubmitting ? null : _join,
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: primaryGreen, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r))),
                                child: Text(DoctorStrings.confirmJoin(context), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ] else ...[
                  // --- Create Clinic mode (حقيقية هلق) ---
                  _LabeledField(label: 'اسم العيادة', controller: _nameController, textColor: textColor, cardBg: cardBg),
                  SizedBox(height: 12.h),
                  _LabeledField(label: 'عنوان العيادة', controller: _addressController, textColor: textColor, cardBg: cardBg),
                  LocationPickField(
                    latitude: _latitude,
                    longitude: _longitude,
                    label: 'تحديد موقع العيادة',
                    onPicked: (lat, lng) => setState(() {
                      _latitude = lat;
                      _longitude = lng;
                    }),
                  ),
                  SizedBox(height: 12.h),
                  _LabeledField(label: 'رقم هاتف العيادة', controller: _phoneController, textColor: textColor, cardBg: cardBg, keyboardType: TextInputType.phone),
                  SizedBox(height: 12.h),
                  _LabeledField(label: DoctorStrings.consultationFeeLabel(context), controller: _createFeeController, textColor: textColor, cardBg: cardBg, keyboardType: const TextInputType.numberWithOptions(decimal: true)),
                  SizedBox(height: 12.h),
                  Text('ترخيص العيادة (اختياري)', style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600, color: textColor)),
                  SizedBox(height: 6.h),
                  InkWell(
                    onTap: _pickLicense,
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(vertical: 16.h),
                      decoration: BoxDecoration(color: cardBg, borderRadius: BorderRadius.circular(10.r), border: Border.all(color: AppColors.borderGrey)),
                      alignment: Alignment.center,
                      child: Text(
                        _licenseFileName ?? 'اختر صورة ترخيص العيادة',
                        style: TextStyle(fontSize: 12.5.sp, color: _licenseFileName != null ? primaryGreen : AppColors.textLightGrey),
                      ),
                    ),
                  ),
                  SizedBox(height: 20.h),
                  SizedBox(
                    width: double.infinity,
                    height: 48.h,
                    child: ElevatedButton(
                      onPressed: _isSubmitting ? null : _createClinic,
                      style: ElevatedButton.styleFrom(
                          backgroundColor: primaryGreen, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r))),
                      child: Text('إنشاء العيادة', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'رح تنحفظ العيادة بحالة "قيد المراجعة" لحد ما يوافق عليها الأدمن.',
                    style: TextStyle(fontSize: 11.sp, color: AppColors.textLightGrey),
                  ),
                ],
              ],
            ),
            if (_isSubmitting)
              Container(color: Colors.black.withOpacity(0.15), child: const Center(child: CircularProgressIndicator())),
          ],
        ),
      ),
    );
  }
}

class _LabeledField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final Color textColor;
  final Color cardBg;
  final TextInputType? keyboardType;

  const _LabeledField({required this.label, required this.controller, required this.textColor, required this.cardBg, this.keyboardType});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600, color: textColor)),
        SizedBox(height: 6.h),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            filled: true,
            fillColor: cardBg,
            isDense: true,
            contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r), borderSide: BorderSide.none),
          ),
        ),
      ],
    );
  }
}

class _ModeButton extends StatelessWidget {
  final String label;
  final bool selected;
  final bool isDark;
  final VoidCallback onTap;

  const _ModeButton({required this.label, required this.selected, required this.isDark, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final primaryGreen = isDark ? AppColors.darkPrimaryGreen : AppColors.primaryGreen;
    final textColor = isDark ? AppColors.darkText : AppColors.textDark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10.h),
        decoration: BoxDecoration(
          color: selected ? primaryGreen : Colors.transparent,
          borderRadius: BorderRadius.circular(6.r),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(fontSize: 12.5.sp, fontWeight: FontWeight.w700, color: selected ? Colors.white : textColor),
        ),
      ),
    );
  }
}
