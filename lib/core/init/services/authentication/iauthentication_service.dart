abstract class IAuthenticationService {
  dynamic get currentUser;
  Future initAuth();
  Stream getAuthStateChanges();
  Future loginEmailPassword(String email, String password);
  Future signUpEmailPassword(String email, String password);
  Future signOut();
}
