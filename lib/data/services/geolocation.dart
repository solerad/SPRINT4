import 'package:geolocator/geolocator.dart';
import 'package:simple_sample_3/domain/services/location_interface.dart';

class GpsService implements LocationInterface {
  @override
  Future<Position> getCurrentLocation() async {
    return await Geolocator.getCurrentPosition();
  }
}
