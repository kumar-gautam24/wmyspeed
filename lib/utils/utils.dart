class SpeedUtils {
  static double toKmh(double speedInMs) => speedInMs * 3.6;

  static double toMs(double speedInKmh) => speedInKmh / 3.6;
}
