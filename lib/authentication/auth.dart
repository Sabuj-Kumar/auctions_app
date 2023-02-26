
import 'package:firebase_auth/firebase_auth.dart';

import '../local_storage/local_storage.dart';

class Auth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  User? get currentUser => _firebaseAuth.currentUser;

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<void> signInWithEmailAndPass({required String email, required String pass})async{
    final data = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: pass);
    await LocalStorage.setToken("${data.user?.uid}");
  }

  Future<void> createUser({required String email, required String pass})async{
    final data = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: pass);
    await LocalStorage.setToken("${data.user?.uid}");
  }

  Future<void> signOut()async{
    await _firebaseAuth.signOut();
  }
}