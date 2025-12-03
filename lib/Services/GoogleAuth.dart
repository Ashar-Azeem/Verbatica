// ignore_for_file: file_names
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;

  bool _initialized = false;

  Future<void> _initialize() async {
    try {
      await _googleSignIn.initialize(
        serverClientId: dotenv.env['GoogleAuthKey']!,
      );
      _initialized = true;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> _ensureInit() async {
    if (!_initialized) await _initialize();
  }

  Future<String> signInWithGoogle() async {
    await _ensureInit();
    try {
      final account = await _googleSignIn.authenticate(scopeHint: ['email']);
      print("hehehehe");
      final auth = account.authentication;
      final idToken = auth.idToken;

      if (idToken == null) {
        throw Exception('No ID token returned');
      }
      return idToken;
    } on GoogleSignInException catch (e) {
      throw Exception(e);
    } catch (e) {
      throw Exception(e);
    }
  }
}
