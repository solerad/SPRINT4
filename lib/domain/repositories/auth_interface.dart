import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthInterface {
  Future<bool> signUp(
      //Registro de usuario
      {required String name,
      required String email,
      required String password,
      /*required String confirmpassword*/});

  // Inicio de sesion
  Future<bool> signIn({required String email, required String password});

  // Cerrar sesion
  Future<bool> signOut();
  static Stream<User?> get authStream =>
      FirebaseAuth.instance.authStateChanges();
}
