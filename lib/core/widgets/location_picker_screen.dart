import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:untitled3/core/constants/setting.dart';
import '../theme/app_colors.dart';

/// شاشة اختيار موقع من خريطة حقيقية (OpenStreetMap عبر flutter_map -
/// بلا حاجة لأي API key، عكس Google Maps). تُستخدم من خطوات الريجستر
/// (مريض/طبيب/عيادة) لتحديد الإحداثيات (lat/lng) وقت إدخال العنوان،
/// حتى يقدر الباك لاحقاً يفلتر "أقرب الأطباء" جغرافياً.
///
/// ⚠️ يحتاج هالباكجات بالـ pubspec.yaml (مو مضافة من طرفي لأنه ما
/// معي وصول لملف pubspec.yaml بالمشروع):
///   flutter_map: ^7.0.2
///   latlong2: ^0.9.1
///   geolocator: ^13.0.1
/// ولأندرويد: صلاحية الموقع بـ AndroidManifest.xml:
///   <uses-permission android:name="android.permission.ACCESS_FINE_LOCATION"/>
class LocationPickerScreen extends StatefulWidget {
  /// إحداثيات أولية (لو كان محدد شي قبل هيك) - وإلا بيبلش بمركز دمشق
  /// افتراضياً (بما إنه التطبيق سوري) لحد ما يجيب موقع الجهاز أو يلمس
  /// المستخدم بالخريطة.
  final LatLng? initialPosition;

  const LocationPickerScreen({super.key, this.initialPosition});

  @override
  State<LocationPickerScreen> createState() => _LocationPickerScreenState();
}

class _LocationPickerScreenState extends State<LocationPickerScreen> {
  static const LatLng _damascusFallback = LatLng(33.5138, 36.2765);

  final MapController _mapController = MapController();
  late LatLng _picked;
  bool _isLocating = false;

  @override
  void initState() {
    super.initState();
    _picked = widget.initialPosition ?? _damascusFallback;
    if (widget.initialPosition == null) {
      // ما في إحداثيات سابقة - نحاول نجيب موقع الجهاز تلقائياً أول ما
      // تفتح الشاشة (وإذا رفض الصلاحية، بيضل عالمركز الافتراضي وبقدر
      // يلمس بالخريطة يدوياً).
      WidgetsBinding.instance.addPostFrameCallback((_) => _useCurrentLocation(silent: true));
    }
  }

  Future<void> _useCurrentLocation({bool silent = false}) async {
    setState(() => _isLocating = true);
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        if (!silent) _showMessage('خدمة الموقع مطفية على جهازك');
        return;
      }

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
        if (!silent) _showMessage('لازم توافق على صلاحية الموقع حتى نحدده تلقائياً');
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
      );
      final point = LatLng(position.latitude, position.longitude);
      setState(() => _picked = point);
      _mapController.move(point, 15);
    } catch (_) {
      if (!silent) _showMessage('تعذّر تحديد موقعك الحالي');
    } finally {
      if (mounted) setState(() => _isLocating = false);
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final settingsState = context.watch<SettingsCubit>().state;
    final isEn = settingsState.locale.languageCode == 'en';
    final isDark = settingsState.themeMode == ThemeMode.dark;
    final primaryGreen = isDark ? AppColors.darkPrimaryGreen : AppColors.primaryGreen;
    final scaffoldBg = isDark ? AppColors.darkBackground : AppColors.backgroundBeige;

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
          title: Text(isEn ? 'Pick location' : 'تحديد الموقع',
              style: TextStyle(fontWeight: FontWeight.w800, color: primaryGreen)),
        ),
        body: Stack(
          children: [
            FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: _picked,
                initialZoom: 13,
                onTap: (tapPosition, point) => setState(() => _picked = point),
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.medzone.app',
                ),
                MarkerLayer(markers: [
                  Marker(
                    point: _picked,
                    width: 42,
                    height: 42,
                    child: Icon(Icons.location_on_rounded, color: primaryGreen, size: 42),
                  ),
                ]),
              ],
            ),
            Positioned(
              bottom: 90,
              right: isEn ? 16 : null,
              left: isEn ? null : 16,
              child: FloatingActionButton.small(
                heroTag: 'use_current_location',
                backgroundColor: Colors.white,
                onPressed: _isLocating ? null : () => _useCurrentLocation(),
                child: _isLocating
                    ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                    : Icon(Icons.my_location_rounded, color: primaryGreen),
              ),
            ),
            Positioned(
              left: 16,
              right: 16,
              bottom: 16,
              child: SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context, _picked),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryGreen,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: Text(isEn ? 'Confirm this location' : 'تأكيد هالموقع',
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 15)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
