import 'package:firebase_auth/firebase_auth.dart';
import 'package:user_app/Models/Users/user_model.dart';
import 'package:user_app/Services/Auth/users_db.dart';

class Auth {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? get currentUser => _auth.currentUser;

 

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<void> registerWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
  }) async {
    await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    UserModel newUser = UserModel(email: email, uid: currentUser!.uid, name: name);
    Usersdb().addUser(newUser.toJson());
    //await sendConfirmationEmail();
    
  } //TODO obsługa wszystkich kodów błędów

  Future<void> sendPasswordResetEmail({required String email}) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  Future<void> sendConfirmationEmail() async {
    await currentUser!.sendEmailVerification();
  }
}
