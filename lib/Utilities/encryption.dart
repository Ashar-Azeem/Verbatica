import 'dart:convert';
import 'dart:isolate';

import 'package:encrypt/encrypt.dart' as encrypt;
import 'dart:math';
import 'dart:typed_data';

//Secret key, hide this at the end
const String aesKey = '12345678901234567890123456789012';

// Generate secure random IV
Uint8List generateRandomIVBytes() {
  final random = Random.secure();
  return Uint8List.fromList(List<int>.generate(16, (_) => random.nextInt(256)));
}

// Encrypt text to Base64
String encryptText(String plainText, String keyString, Uint8List ivBytes) {
  final key = encrypt.Key.fromUtf8(keyString);
  final iv = encrypt.IV(ivBytes);
  final encrypter = encrypt.Encrypter(
    encrypt.AES(key, mode: encrypt.AESMode.cbc),
  );
  final encrypted = encrypter.encrypt(plainText, iv: iv);
  return encrypted.base64;
}

// Encrypt media (image/video) in memory
String encryptBytes(Uint8List fileBytes, String keyString, Uint8List ivBytes) {
  final key = encrypt.Key.fromUtf8(keyString);
  final iv = encrypt.IV(ivBytes);
  final encrypter = encrypt.Encrypter(
    encrypt.AES(key, mode: encrypt.AESMode.cbc),
  );
  final encrypted = encrypter.encryptBytes(fileBytes, iv: iv);
  return base64Encode(encrypted.bytes);
}

class EncryptionParams {
  final Uint8List bytes;
  final String key;
  final Uint8List iv;
  EncryptionParams(this.bytes, this.key, this.iv);
}

Future<String> encryptInIsolate(EncryptionParams params) async {
  final p = ReceivePort();
  await Isolate.spawn(_encryptWorker, [p.sendPort, params]);
  return await p.first;
}

void _encryptWorker(List<dynamic> args) {
  SendPort sendPort = args[0];
  EncryptionParams params = args[1];

  final result = encryptBytes(params.bytes, params.key, params.iv);
  sendPort.send(result);
}
