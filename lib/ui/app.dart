// ignore_for_file: deprecated_member_use

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:simple_sample_3/data/repositories/auth.dart';
import 'package:simple_sample_3/domain/repositories/auth_interface.dart';
import 'package:simple_sample_3/domain/use_cases/auth_management.dart';
import 'package:simple_sample_3/domain/use_cases/controllers/location_controller.dart';
import 'package:simple_sample_3/domain/use_cases/controllers/permissions_controller.dart';
import 'package:simple_sample_3/domain/use_cases/controllers/themes_controler.dart';
import 'package:simple_sample_3/domain/use_cases/permissions_management.dart';
import 'package:simple_sample_3/domain/use_cases/themes_management.dart';
import 'package:simple_sample_3/ui/pages/authentication/auth_page.dart';
import 'package:simple_sample_3/ui/pages/authentication/forg_paassword/forgote_password.dart';
import 'package:simple_sample_3/ui/pages/content/content_page.dart';
import 'package:simple_sample_3/ui/theme/theme.dart';
import 'package:simple_sample_3/domain/use_cases/controllers/auth_controller.dart';
import 'package:simple_sample_3/domain/use_cases/controllers/conectivity_controller.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:developer';
import 'package:simple_sample_3/domain/use_cases/controllers/status_controller.dart';

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  // Inicializamos FireBase en un futuro
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  // Este widget es la raíz de su aplicación.
  @override
  Widget build(BuildContext context) {
    // Llamamos el método que inicializa el estado
    _stateManagementInit(); //iniciamos controlador de autenticasion
    return FutureBuilder(
      // Initialize FlutterFire:

      future: _initialization,
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          return const MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Center(
              child: Text("Hubo un error con firebase"),
            ),
          );
        }

        if (snapshot.connectionState == ConnectionState.done) {
          _firebaseStateInit();
          return GetMaterialApp(
            title: 'Animex',
            // Quitamos el banner DEBUG
            debugShowCheckedModeBanner: false,
            // Establecemos el tema claro
            theme: MyTheme.ligthTheme,
            // Establecemos el tema oscuro
            darkTheme: MyTheme.darkTheme,
            // Por defecto tomara la seleccion del sistema
            themeMode: ThemeMode.dark,
            home: const AuthenticationPage(),
            // ---------------------------------------
            // 1. Crea las rutas posibles para nuestra app
            // ---------------------------------------
            routes: {
              '/auth': (context) => const AuthenticationPage(),
              '/content': (context) => const ContentPage(),
              '/forgPass': (context) => HomePageWidget(),
            },
          );
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return const MaterialApp(
          home: Center(child: CircularProgressIndicator()),
        );
      },
    );
  }

// Creamos el método que inicializará
// Los manejos de estado _stateManagementInit
  void _stateManagementInit() {
    // Inyectamos el controlador y lo nombramos authController
    AuthController authController = Get.put(AuthController());

    // Con el método ever escuchamos cuando haya cambios en la
    // Variables a través del método reactivo reactiveAuth
    // Y definimos la variable que retorna como "isAuthenticated"
    // La cual es un boolean
    ever(authController.reactiveAuth, (bool isAuthenticated) {
      // En caso de que esté autenticado, nos lleva a la ruta /content,
      // Usamos Get.off que no permite regresar a las vistas anteriores
      // En caso de que no esté autenticado, nos envía inmediatamente a
      // La ruta /auth que muestra el inicio de sesión
      if (isAuthenticated) {
        Get.offNamed('/content');
      } else {
        Get.offNamed('/auth');
      }
      // Esta navegación a las rutas se llevará a cabo inmediatamente
      // Que haya cambios en la autenticación, gracias al método reactivo
    });

    ConnectivityController connectivityController =
        Get.put(ConnectivityController());

    Connectivity().onConnectivityChanged.listen((connectivityStatus) {
      log("connection changed to: $connectivityStatus");
      connectivityController.connectivity = connectivityStatus;

      if (connectivityStatus == ConnectivityResult.mobile) {
        Get.showSnackbar(GetBar(
          message: "Conectado con datos móviles",
          duration: const Duration(seconds: 2),
        ));
      } else if (connectivityStatus == ConnectivityResult.wifi) {
        Get.showSnackbar(GetBar(
          message: "Conectado con WiFi",
          duration: const Duration(seconds: 2),
        ));
      } else if (connectivityStatus == ConnectivityResult.none) {
        Get.showSnackbar(GetBar(
          message: "No está conectado a Internet",
          duration: const Duration(seconds: 2),
        ));
      }
    });

    // Inyectamos el controlador de estados
    StatusController statusController = Get.put(StatusController());

    // Dependency Injection
    ThemesController themesController = Get.put(ThemesController());
    themesController.themeManager = ThemeManager();

    // Reactive
    ever(themesController.reactiveBrightness, (bool isDarkMode) {
      themesController.manager.changeTheme(isDarkMode: isDarkMode);
    });

    // Permisos
    PermissionsController permissionsController =
        Get.put(PermissionsController());
    permissionsController.permissionManager = PermissionManager();

    // Localización

    Get.put(LocationController());
  }

  _firebaseStateInit() {
    AuthController authController = Get.find<AuthController>();
    // Setting manager
    authController.authManagement = AuthManagement(auth: Auth());
    // Watching auth state changes
    AuthInterface.authStream.listen(
      (user) => authController.currentUser = user,
    );
  }
}
