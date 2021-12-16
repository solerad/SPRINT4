// Importamos el paquete get
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:simple_sample_3/domain/use_cases/auth_management.dart';

// Creamos la clase y extendemos de GetxController
class AuthController extends GetxController {
  // Definimos la variable Observable que cambiará el valor dependiendo de
  // Si el usuario está autenticado o no
  final _authenticated = false.obs;
  final _currentUser = Rx<User?>(null);
  late AuthManagement _manager;

  set currentUser(User? userAuth) {
    _currentUser.value = userAuth;
    _authenticated.value = userAuth != null;
  }

  set authManagement(AuthManagement manager) {
    _manager = manager;
  }

  // Definimos el método que modificará la variable
  set authenticated(bool state) {
    _authenticated.value = state;
  }

  // Definimos el método get reactivo que notificará
  // inmediatamente que haya un cambio
  RxBool get reactiveAuth => _authenticated;

  // Definimos el método que mostrará el valor de la variable
  bool get authenticated => _authenticated.value;
  User? get currentUser => _currentUser.value;

  AuthManagement get manager => _manager;
}
