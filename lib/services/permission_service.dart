import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  Future<bool> requestLocationPermission() async {
    PermissionStatus status = await Permission.location.request();

    if (status.isGranted) {
      return true;
    } else if (status.isDenied) {
      // Handle case where permission was denied temporarily
      return false;
    } else if (status.isPermanentlyDenied) {
      // Handle case where permission is permanently denied
      await openAppSettings(); // Encourage user to enable permissions in settings
      return false;
    }
    return false;
  }

  Future<bool> checkLocationPermission() async {
    return await Permission.location.isGranted;
  }
}
