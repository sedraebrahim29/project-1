import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// تخزين محلي عام (key -> JSON) مبني فوق نفس الحزمة المستخدمة أصلاً
/// بـ [SecureStorageService] (core/network/secure_storage_service.dart)
/// حتى ما نحتاج نضيف أي dependency جديدة.
///
/// ⚠️ ليش موجود أصلاً: جدول عمل الطبيب / المواعيد / الإشعارات ما إلها
/// أي endpoint بالباك حالياً (راجع ملاحظات api_constants.dart). بدل ما
/// نعرض واجهات فارغة دايماً أو نستخدم بيانات وهمية بتضيع كل ما تسكّر
/// التطبيق، منخزنها محلياً على جهاز الطبيب - هيك القسم شغال 100% من
/// جهة الفرونت، وجاهز يتوصل بالباك بمجرد ما تنضاف الـ endpoints (نفس
/// الـ Cubits ما رح تتغيّر، بس بدّل جسم الدالة بنداء API حقيقي).
class LocalJsonStore {
  LocalJsonStore._internal();
  static final LocalJsonStore instance = LocalJsonStore._internal();

  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<void> writeJson(String key, dynamic value) async {
    await _storage.write(key: key, value: jsonEncode(value));
  }

  Future<dynamic> readJson(String key) async {
    final raw = await _storage.read(key: key);
    if (raw == null || raw.isEmpty) return null;
    try {
      return jsonDecode(raw);
    } catch (_) {
      return null;
    }
  }

  Future<void> delete(String key) async {
    await _storage.delete(key: key);
  }
}
