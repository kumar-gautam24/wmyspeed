import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

import 'permission_service.dart';

class LocationService {
  final StreamController<double> _speedController = StreamController.broadcast();
  final KalmanFilter _kalmanFilter = KalmanFilter();
  final PermissionService _permissionService = PermissionService();
  // double _lastSpeed = 0.0;

  // Getters
  Stream<double> get speedStream => _speedController.stream;

  Future<bool> initialize() async {
    if (!await Geolocator.isLocationServiceEnabled()) return false;

   bool permissionGranted =
        await _permissionService.requestLocationPermission();
    if (!permissionGranted) return false;

    _startListeningToLocation();
    return true;
  }


  void _startListeningToLocation() {
    Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.bestForNavigation,
        distanceFilter: 0,
      ),
    ).listen((Position position) {
      double rawSpeed = position.speed ;//* 3.6; // Convert m/s to km/h
      double smoothedSpeed = _kalmanFilter.filter(rawSpeed);

      print("Raw Speed: $rawSpeed km/h, Smoothed Speed: $smoothedSpeed km/h");

      _speedController.add(smoothedSpeed);
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
