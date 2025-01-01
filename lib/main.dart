import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/lcoation_service.dart';
import 'viewmodel/speedmeter_viewmodel.dart';

import 'views/speedmeter_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => SpeedometerViewModel(LocationService()),
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SpeedometerScreen(),
    );
  }
}
