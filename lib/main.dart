import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/lcoation_service.dart';
import 'viewmodel/viewModel.dart';
import 'views/speedmeter_screen.dart';


void main() {
  final locationService = LocationService();
  runApp(SpeedometerApp(locationService: locationService));
}

class SpeedometerApp extends StatelessWidget {
  final LocationService locationService;

  const SpeedometerApp({super.key, required this.locationService});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SpeedometerViewModel(locationService),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData.light(),
        darkTheme: ThemeData.dark(),
        themeMode: ThemeMode.system,
        home: const SpeedometerScreen(),
      ),
    );
  }
}
