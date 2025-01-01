class SpeedModel {
  final double speed;

  SpeedModel({required this.speed});

  String get formattedSpeed => '${speed.toStringAsFixed(1)} km/h';
}
