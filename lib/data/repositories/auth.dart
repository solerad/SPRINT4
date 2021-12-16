import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:simple_sample_3/domain/repositories/auth_interface.dart';

// Implementamos la interfaz en la clase
class Auth implements AuthInterface {
  // Reescribimos cada uno de los métodos de la interfaz
  // Para el inicio de sesión definimos los valores que por ahora serán válidos
  // Para ingresar a la sesión
  @override
  Future<bool> signIn({required String email, required String password}) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        Get.snackbar(
          "Usuario no encontrado",
          "No se encontró un usuario que use ese email.",
        );
      } else if (e.code == 'wrong-password') {
        Get.snackbar(
          "Contraseña equivocada",
          "La contraseña proveida por el usuario no es correcta.",
        );
      }
      return false;
    }
  }

  @override
  Future<bool> signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      return true;
    } catch (e) {
      return false;
    }
  }

  // Para la creación de usuario definimos las condiciones que deben cumplir
  // Las variables de email y passwo

  @override
  Future<bool> signUp(
      {required String name,
      required String email,
      //required String confirmpassword,
      required String password}) async {
    try {
      final userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      userCredential.user!.updateDisplayName(name);
      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        Get.snackbar(
          "Contraseña insegura",
          "La seguridad de la contraseña es muy débil",
        );
      } else if (e.code == 'email-already-in-use') {
        Get.snackbar(
          "Email inválido",
          "Ya existe un usuario con este correo electrónico.",
        );
      }
    } catch (e) {
      log(e.toString());
    }
    return false;
  }

  // We throw an error if someone calls SignInWithGoogle, member of AuthInterface
  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
