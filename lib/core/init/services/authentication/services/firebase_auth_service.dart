import 'package:firebase_auth/firebase_auth.dart';

import '../iauthentication_service.dart';

class FirebaseAuthService implements IAuthenticationService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  User? get currentUser => _firebaseAuth.currentUser;

  @override
  Future<void> initAuth() async {}

  @override
  Stream<User?> getAuthStateChanges() {
    return _firebaseAuth.authStateChanges();
  }

  @override
  Future<User?> loginEmailPassword(String email, String password) async {
    final UserCredential userCredential =
        await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
    return userCredential.user;
  }

  @override
  Future<User?> signUpEmailPassword(String email, String password) async {
    final UserCredential userCredential =
        await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
    return userCredential.user;
  }

  @override
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}
