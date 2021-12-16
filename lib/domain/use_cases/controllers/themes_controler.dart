import 'package:get/get.dart';
import 'package:simple_sample_3/domain/use_cases/themes_management.dart';

class ThemesController extends GetxController {
  // Observables
  final _darkMode = false.obs;
  late ThemeManager _manager;

  set themeManager(ThemeManager manager) {
    _manager = manager;
    _initMode(manager);
  }

  // Reactive Getters

  RxBool get reactiveBrightness => _darkMode;

  // Getters

  bool get darkMode => _darkMode.value;

  ThemeManager get manager => _manager;

  // Update app brightness mode with stored value
  _initMode(ThemeManager manager) async {
    _darkMode.value = await _manager.storedTheme;
  }
}
