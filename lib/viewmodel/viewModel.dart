import 'package:flutter/material.dart';

import '../models/speed_model.dart';
import '../services/lcoation_service.dart';

enum SpeedometerState { loading, error, ready }

class SpeedometerViewModel extends ChangeNotifier {
  final LocationService _locationService;
  Stream<SpeedModel>? _speedStream;
  SpeedometerState _state = SpeedometerState.loading;

  SpeedometerViewModel(this._locationService) {
    _initializeLocation();
  }

  SpeedometerState get state => _state;
  Stream<SpeedModel>? get speedStream => _speedStream;

  Future<void> _initializeLocation() async {
    try {
      bool isServiceEnabled = await _locationService.initialize();
      if (isServiceEnabled) {
        _speedStream = _locationService.getSpeedStream();
        _state = SpeedometerState.ready;
      } else {
        _state = SpeedometerState.error;
      }
    } catch (e) {
      _state = SpeedometerState.error;
    }
    notifyListeners();
  }

  Future<void> retryInitialization() async {
    _state = SpeedometerState.loading;
    notifyListeners();
    await _initializeLocation();
  }
}
