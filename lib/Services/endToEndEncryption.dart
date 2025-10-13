import 'dart:convert';
import 'dart:typed_data';
import 'package:cryptography/cryptography.dart';

class E2EEChat {
  final algorithm = X25519();
  final aes = AesGcm.with256bits();

  /// Generate key pair
  Future<Map<String, String>> generateKeyPair() async {
    final keyPair = await algorithm.newKeyPair();
    final publicKey = await keyPair.extractPublicKey();
    final privateKeyBytes = await keyPair.extractPrivateKeyBytes();
    return {
      'publicKey': base64Encode(publicKey.bytes),
      'privateKey': base64Encode(privateKeyBytes),
    };
  }

  /// Derive shared secret from your private key and the other user's public key
  Future<String> deriveSharedSecret(
    String myPrivateKeyB64,
    String theirPublicKeyB64,
  ) async {
    final myPrivateBytes = base64Decode(myPrivateKeyB64);
    final theirPublicBytes = base64Decode(theirPublicKeyB64);

    final myKeyPair = await algorithm.newKeyPairFromSeed(myPrivateBytes);
    final theirPubKey = SimplePublicKey(
      theirPublicBytes,
      type: KeyPairType.x25519,
    );

    final sharedSecret = await algorithm.sharedSecretKey(
      keyPair: myKeyPair,
      remotePublicKey: theirPubKey,
    );
    final sharedBytes = await sharedSecret.extractBytes();
    return base64Encode(sharedBytes);
  }

  /// Encrypt message and return one combined Base64 string
  Future<String> encrypt(String plaintext, String sharedSecretB64) async {
    final secretBytes = base64Decode(sharedSecretB64);
    final secretKey = SecretKey(secretBytes);
    final nonce = aes.newNonce();

    final box = await aes.encrypt(
      utf8.encode(plaintext),
      secretKey: secretKey,
      nonce: nonce,
    );

    // Combine into one: [nonce length (12 bytes) + MAC (16 bytes) + cipherText]
    final combined = Uint8List.fromList([
      ...nonce,
      ...box.mac.bytes,
      ...box.cipherText,
    ]);

    return base64Encode(combined);
  }

  /// Decrypt message (only needs ciphertext and shared secret)
  Future<String> decrypt(String combinedBase64, String sharedSecretB64) async {
    final secretBytes = base64Decode(sharedSecretB64);
    final secretKey = SecretKey(secretBytes);
    final data = base64Decode(combinedBase64);

    // AES-GCM: nonce (12 bytes), mac (16 bytes), rest is ciphertext
    final nonce = data.sublist(0, 12);
    final mac = Mac(data.sublist(12, 28));
    final cipherText = data.sublist(28);

    final box = SecretBox(cipherText, nonce: nonce, mac: mac);
    final clear = await aes.decrypt(box, secretKey: secretKey);
    return utf8.decode(clear);
  }
}

//Example of use:
// import 'package:verbatica/Services/endToEndEncryption.dart';

// void main() async {
//   final alice = E2EEChat();
//   final bob = E2EEChat();

//   // Generate key pairs
//   final aliceKeys = await alice.generateKeyPair();
//   final bobKeys = await bob.generateKeyPair();

//   // Derive shared secret (both sides get same key)
//   final aliceSecret = await alice.deriveSharedSecret(
//     aliceKeys['privateKey']!,
//     bobKeys['publicKey']!,
//   );
//   final bobSecret = await bob.deriveSharedSecret(
//     bobKeys['privateKey']!,
//     aliceKeys['publicKey']!,
//   );

//   // Encrypt message
//   final encrypted = await alice.encrypt(
//     "Hello Bob! This is E2E encrypted.",
//     aliceSecret,
//   );
//   print("Encrypted: $encrypted");

//   // Decrypt message
//   final decrypted = await alice.decrypt(encrypted, bobSecret);
//   print("Decrypted: $decrypted");
// }
