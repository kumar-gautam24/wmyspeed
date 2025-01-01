import 'package:geolocator/geolocator.dart';
import '../models/speed_model.dart';
import 'dart:async';

class LocationService {
  final StreamController<SpeedModel> _speedController =
      StreamController<SpeedModel>();

  Future<bool> initialize() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return false;

    // Request permission.
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.always &&
          permission != LocationPermission.whileInUse) {
        return false;
      }
    }

    Geolocator.getPositionStream().listen((position) {
      double speed = position.speed * 3.6; // Convert m/s to km/h
      _speedController.add(SpeedModel(speed: speed));
    });
    return true;
  }

  Stream<SpeedModel> getSpeedStream() => _speedController.stream;
}
