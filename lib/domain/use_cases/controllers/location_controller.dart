import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:simple_sample_3/domain/models/location.dart';
import 'package:simple_sample_3/domain/use_cases/location_management.dart';

class LocationController extends GetxController {
  // Observables
  final _location = Rx<MyLocation?>(null);
  late LocationManager _manager;

  set locationManager(LocationManager manager) {
    _manager = manager;
  }

  set location(MyLocation? myLocation) {
    _location.value = myLocation;
  }

  // Getters
  LocationManager get manager => _manager;

  MyLocation? get location => _location.value;

  Rx<MyLocation?> get reactiveLocation => _location;
}
