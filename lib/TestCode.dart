import 'package:verbatica/Services/endToEndEncryption.dart'; // adjust your import
// or directly import the file where E2EEChat is located.

void main() async {
  final e2ee = E2EEChat();

  List<Map<String, String>> keyPairs = [];

  for (int i = 0; i < 10; i++) {
    final pair = await e2ee.generateKeyPair();
    keyPairs.add(pair);
  }

  // Print all key pairs
  for (int i = 0; i < keyPairs.length; i++) {
    print("Pair ${i + 1}:");
    print("Public Key:  ${keyPairs[i]['publicKey']}");
    print("Private Key: ${keyPairs[i]['privateKey']}");
    print("----------------------------------------");
  }
}
