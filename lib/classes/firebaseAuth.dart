
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthClass{
 
 final FirebaseAuth _auth = FirebaseAuth.instance;

 User? get currentUserState => _auth.currentUser;

Stream<User?> get authStateChange => _auth.authStateChanges();


Future<void> loginUserWithEmailAndPssword(
      {required email, required password}) async {
    await _auth.signInWithEmailAndPassword(
        email: email, password: password);
  }

  Future<void> registerUserEMailAndPassword(
      {required email, required password}) async {
    await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }


}