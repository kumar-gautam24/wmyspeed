import 'package:flutter/material.dart';

import '../services/location_service.dart';

enum SpeedometerState { loading, error, ready }

class SpeedometerViewModel extends ChangeNotifier {
  final LocationService _locationService;
  SpeedometerState _state = SpeedometerState.loading;
  String _errorMessage = "";
  bool isKmH = true;
  Stream<double>? _speedStream;

  SpeedometerViewModel(this._locationService) {
    _initialize();
  }
  // getters
  SpeedometerState get state => _state;
  String get errorMessage => _errorMessage;
  Stream<double>? get speedStream => _speedStream;
  String get unitLabel => isKmH ? 'km/h' : 'mph';

  double convertSpeed(double speedInKmH) {
    return isKmH ? speedInKmH : speedInKmH / 1.609; // Convert to mph
  }

  void toggleUnit() {
    isKmH = !isKmH;
    notifyListeners();
  }

  Future<void> _initialize() async {
    try {
      bool isServiceEnabled = await _locationService.initialize();
      if (isServiceEnabled) {
        _speedStream = _locationService.speedStream;
        _state = SpeedometerState.ready;
      } else {
        _state = SpeedometerState.error;
        _errorMessage = "Please enable location services.";
      }
    } catch (e) {
      _state = SpeedometerState.error;
      _errorMessage = "An error occurred: ${e.toString()}";
    }
    notifyListeners();
  }

  void retryInitialization() async {
    _state = SpeedometerState.loading;
    _errorMessage = "";
    notifyListeners();
    await _initialize();
  }
}
