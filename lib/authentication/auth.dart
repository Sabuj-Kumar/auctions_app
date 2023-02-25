
import 'package:firebase_auth/firebase_auth.dart';

class Auth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  User? get currentUser => _firebaseAuth.currentUser;

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<void> signInWithEmailAndPass({required String email, required String pass})async{
    await _firebaseAuth.signInWithEmailAndPassword(email: email, password: pass);
  }

  Future<void> createUser({required String email, required String pass})async{
    await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: pass);
  }

  Future<void> signOut()async{
    await _firebaseAuth.signOut();
  }
}