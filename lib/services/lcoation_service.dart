import 'dart:async';
import 'package:geolocator/geolocator.dart';

class LocationService {
  final StreamController<double> _speedController =
      StreamController.broadcast();
  final KalmanFilter _kalmanFilter = KalmanFilter();

  Stream<double> get speedStream => _speedController.stream;

  Future<bool> initialize() async {
    if (!await Geolocator.isLocationServiceEnabled()) return false;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.always &&
          permission != LocationPermission.whileInUse) {
        return false;
      }
    }

    _startListeningToLocation();
    return true;
  }

 void _startListeningToLocation() {
    Geolocator.getPositionStream(
      locationSettings: LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 0, // Updates for every small movement
      ),
    ).listen((Position position) {
      print("Accuracy: ${position.accuracy} meters");

      if (position.speed >= 0) {
        double rawSpeed = position.speed * 3.6; // Convert m/s to km/h
        double smoothedSpeed = _kalmanFilter.filter(rawSpeed);

        // Log raw and smoothed speeds
        print("Raw Speed: $rawSpeed km/h, Smoothed Speed: $smoothedSpeed km/h");

        _speedController.add(smoothedSpeed);
      } else {
        print("Invalid Speed: ${position.speed}");
      }
    });
  }

  void dispose() {
    _speedController.close();
  }
}


class KalmanFilter {
  final double _q = 0.1; // Process noise covariance
  final double _r = 0.1; // Measurement noise covariance
  double _p = 1.0; // Estimation error covariance
  double _x = 0.0; // Estimated value

  double filter(double measurement) {
    _p += _q;
    double k = _p / (_p + _r); // Kalman gain
    _x += k * (measurement - _x);
    _p *= (1 - k);
    return _x;
  }
}
