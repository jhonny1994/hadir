import 'dart:convert';
import 'package:crypto/crypto.dart';

class QRUtils {
  static String generateSessionQR(String sessionId, DateTime timestamp) {
    final data = '$sessionId:${timestamp.toIso8601String()}';
    final bytes = utf8.encode(data);
    final hash = sha256.convert(bytes);
    return base64Url.encode(hash.bytes);
  }

  static bool validateQRCode(
    String qrCode,
    String sessionId,
    DateTime timestamp,
  ) {
    final expectedQR = generateSessionQR(sessionId, timestamp);
    return qrCode == expectedQR;
  }

  static String generateBackupCode() {
    final random =
        List.generate(6, (_) => DateTime.now().millisecondsSinceEpoch);
    final bytes = utf8.encode(random.join());
    final hash = sha256.convert(bytes);
    return base64Url.encode(hash.bytes).substring(0, 6).toUpperCase();
  }

  static String generateJoinCode() {
    final random =
        List.generate(4, (_) => DateTime.now().millisecondsSinceEpoch);
    final bytes = utf8.encode(random.join());
    final hash = sha256.convert(bytes);
    return base64Url.encode(hash.bytes).substring(0, 6).toUpperCase();
  }
}
