// Importamos la clase de implementación
import 'package:simple_sample_3/data/repositories/auth.dart';

// Creamos la clase
class AuthManagement {
  // Definimos la clase que importamos como una variable privada _auth
  Auth auth = Auth();

  AuthManagement({required this.auth});

  // Definimos cada uno de los métodos de la implementación
  // Y dentro de un try...catch llamamos a cada uno de los métodos
  // Y retornamos sus respuestas (verdadero o falso) o error

  Future<bool> signIn({required String email, required String password}) async {
    try {
      return await auth.signIn(email: email, password: password);
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      return await auth.signUp(
        name: name,
        email: email,
        password: password,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> signOut() async {
    try {
      return await auth.signOut();
    } catch (e) {
      rethrow;
    }
  }
}
