import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:untitled3/core/constants/setting.dart';
import '../theme/app_colors.dart';

/// ⚠️ تبسيط: هاي أعيد بناؤها لتعتمد بس على geolocator (بلا flutter_map
/// ولا latlong2) بعد ما واجه المشروع مشاكل بحل الاعتمادات (dependency
/// resolution) مع الباكجات التلاتة سوا. هيك التغيير الوحيد المطلوب
/// بـ pubspec.yaml هو باكج وحدة بس:
///   geolocator: ^13.0.1
///
/// بدل خريطة تفاعلية بيسحب فيها المستخدم دبوس، هلق في زر "استخدم
/// موقعي الحالي" (GPS الجهاز مباشرة) + خيار احتياطي لإدخال خط الطول/
/// العرض يدوياً لو حابب يعطي إحداثيات غير موقعه الحالي بالضبط أو إذا
/// رفض صلاحية الموقع.
class LocationPickField extends StatefulWidget {
  final double? latitude;
  final double? longitude;
  final void Function(double latitude, double longitude) onPicked;
  final String? label;

  const LocationPickField({
    super.key,
    required this.latitude,
    required this.longitude,
    required this.onPicked,
    this.label,
  });

  @override
  State<LocationPickField> createState() => _LocationPickFieldState();
}

class _LocationPickFieldState extends State<LocationPickField> {
  bool _isLocating = false;
  bool _manualMode = false;
  late final TextEditingController _latController;
  late final TextEditingController _lngController;

  @override
  void initState() {
    super.initState();
    _latController = TextEditingController(text: widget.latitude?.toString() ?? '');
    _lngController = TextEditingController(text: widget.longitude?.toString() ?? '');
  }

  @override
  void dispose() {
    _latController.dispose();
    _lngController.dispose();
    super.dispose();
  }

  bool get _hasValue => widget.latitude != null && widget.longitude != null;

  Future<void> _useCurrentLocation() async {
    setState(() => _isLocating = true);
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _showMessage('خدمة الموقع مطفية على جهازك');
        return;
      }

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
        _showMessage('لازم توافق على صلاحية الموقع حتى نحدده تلقائياً');
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
      );
      widget.onPicked(position.latitude, position.longitude);
      setState(() {
        _latController.text = position.latitude.toString();
        _lngController.text = position.longitude.toString();
      });
    } catch (_) {
      _showMessage('تعذّر تحديد موقعك الحالي - جرب الإدخال اليدوي');
    } finally {
      if (mounted) setState(() => _isLocating = false);
    }
  }

  void _showMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  void _submitManual() {
    final lat = double.tryParse(_latController.text.trim());
    final lng = double.tryParse(_lngController.text.trim());
    if (lat == null || lng == null) {
      _showMessage('أدخل رقم صحيح لخطي الطول والعرض');
      return;
    }
    widget.onPicked(lat, lng);
    setState(() => _manualMode = false);
  }

  @override
  Widget build(BuildContext context) {
    final settingsState = context.watch<SettingsCubit>().state;
    final isEn = settingsState.locale.languageCode == 'en';
    final isDark = settingsState.themeMode == ThemeMode.dark;
    final primaryGreen = isDark ? AppColors.darkPrimaryGreen : AppColors.primaryGreen;
    final textColor = isDark ? AppColors.darkText : AppColors.textDark;

    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: _hasValue ? primaryGreen.withOpacity(0.08) : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: _hasValue ? primaryGreen.withOpacity(0.35) : AppColors.borderGrey),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(_hasValue ? Icons.location_on_rounded : Icons.location_searching_rounded, size: 18, color: primaryGreen),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  _hasValue
                      ? (isEn
                          ? 'Location set (${widget.latitude!.toStringAsFixed(4)}, ${widget.longitude!.toStringAsFixed(4)})'
                          : 'تم تحديد الموقع (${widget.latitude!.toStringAsFixed(4)}, ${widget.longitude!.toStringAsFixed(4)})')
                      : (widget.label ?? (isEn ? 'Set your location' : 'تحديد موقعك')),
                  style: TextStyle(fontSize: 12.5, color: _hasValue ? textColor : AppColors.textLightGrey, fontWeight: _hasValue ? FontWeight.w600 : FontWeight.w500),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _isLocating ? null : _useCurrentLocation,
                  icon: _isLocating
                      ? const SizedBox(width: 14, height: 14, child: CircularProgressIndicator(strokeWidth: 2))
                      : Icon(Icons.my_location_rounded, size: 16, color: primaryGreen),
                  label: Text(isEn ? 'Use current location' : 'استخدام موقعي الحالي', style: TextStyle(fontSize: 11.5, color: primaryGreen)),
                  style: OutlinedButton.styleFrom(side: BorderSide(color: primaryGreen.withOpacity(0.4))),
                ),
              ),
              const SizedBox(width: 8),
              TextButton(
                onPressed: () => setState(() => _manualMode = !_manualMode),
                child: Text(isEn ? 'Manual' : 'إدخال يدوي', style: TextStyle(fontSize: 11.5, color: AppColors.textLightGrey)),
              ),
            ],
          ),
          if (_manualMode) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _latController,
                    keyboardType: const TextInputType.numberWithOptions(signed: true, decimal: true),
                    decoration: const InputDecoration(isDense: true, hintText: 'Latitude', border: OutlineInputBorder()),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _lngController,
                    keyboardType: const TextInputType.numberWithOptions(signed: true, decimal: true),
                    decoration: const InputDecoration(isDense: true, hintText: 'Longitude', border: OutlineInputBorder()),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(onPressed: _submitManual, icon: Icon(Icons.check_circle, color: primaryGreen)),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
