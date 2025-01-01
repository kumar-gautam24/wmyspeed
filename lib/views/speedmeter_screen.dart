import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodel/speedmeter_viewmodel.dart';

class SpeedometerScreen extends StatelessWidget {
  const SpeedometerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<SpeedometerViewModel>(context);

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background gradient
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue.shade800, Colors.blue.shade400],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          Center(
            child: viewModel.state == SpeedometerState.loading
                ? const CircularProgressIndicator()
                : viewModel.state == SpeedometerState.error
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            viewModel.errorMessage,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: viewModel.retryInitialization,
                            child: const Text('Retry'),
                          ),
                        ],
                      )
                    : StreamBuilder<double>(
                        stream: viewModel.speedStream,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return Text(
                              '${snapshot.data!.toStringAsFixed(2)} km/h',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 48,
                                fontWeight: FontWeight.bold,
                              ),
                            );
                          }
                          return const CircularProgressIndicator();
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
