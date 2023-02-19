import 'package:firebase_auth/firebase_auth.dart';

import 'iauthentication_service.dart';
import 'services/firebase_auth_service.dart';

class AuthenticationManager implements IAuthenticationService {
  static final AuthenticationManager _instance = AuthenticationManager._init();
  static AuthenticationManager get instance => _instance;

  AuthenticationManager._init();

  IAuthenticationService _auth = FirebaseAuthService();
  IAuthenticationService get auth => _auth;

  @override
  User? get currentUser => _auth.currentUser;

  void changeDatabase(IAuthenticationService auth) {
    _auth = auth;
  }

  @override
  Future<void> initAuth() async {
    await _auth.initAuth();
  }

  @override
  Stream<User?> getAuthStateChanges() {
    return _auth.getAuthStateChanges() as Stream<User?>;
  }

  @override
  Future<User?> loginEmailPassword(String email, String password) async {
    return await _auth.loginEmailPassword(email, password);
  }

  @override
  Future<User?> signUpEmailPassword(String email, String password) async {
    return await _auth.signUpEmailPassword(email, password);
  }

  @override
  Future<void> signOut() async {
    await _auth.signOut();
  }
}
