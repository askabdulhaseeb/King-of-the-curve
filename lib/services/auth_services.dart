
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final _auth = FirebaseAuth.instance;

  Stream<User> get currentUser => _auth.authStateChanges();

  Future<UserCredential> signInWithCredentials(AuthCredential credential) {

    return _auth.signInWithCredential(credential);
  }

  Future<UserCredential> signInWithCredentialsForApple(AuthCredential credential) async {


    return _auth.signInWithCredential(credential) ;
  }

  Future<void> logout() => _auth.signOut();
}
