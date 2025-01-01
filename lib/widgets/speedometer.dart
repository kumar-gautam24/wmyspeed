import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import '../models/speed_model.dart';

class RadialSpeedometer extends StatefulWidget {
  final SpeedModel speedModel;

  const RadialSpeedometer({super.key, required this.speedModel});

  @override
  _RadialSpeedometerState createState() => _RadialSpeedometerState();
}

class _RadialSpeedometerState extends State<RadialSpeedometer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  double _currentSpeed = 0.0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300), // Adjust for smoothness
    );

    _animateToSpeed(widget.speedModel.speed);
  }

  @override
  void didUpdateWidget(RadialSpeedometer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.speedModel.speed != oldWidget.speedModel.speed) {
      _animateToSpeed(widget.speedModel.speed);
    }
  }

  void _animateToSpeed(double targetSpeed) {
    _animation = Tween<double>(
      begin: _currentSpeed,
      end: targetSpeed,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward(from: 0).then((_) {
      setState(() => _currentSpeed = targetSpeed);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return SfRadialGauge(
          enableLoadingAnimation: false,
          axes: <RadialAxis>[
            RadialAxis(
              minimum: 0,
              maximum: 200,
              axisLineStyle: const AxisLineStyle(
                thickness: 20,
              ),
              ranges: <GaugeRange>[
                GaugeRange(startValue: 0, endValue: 60, color: Colors.green),
                GaugeRange(startValue: 60, endValue: 120, color: Colors.orange),
                GaugeRange(startValue: 120, endValue: 200, color: Colors.red),
              ],
              pointers: <GaugePointer>[
                NeedlePointer(
                  value: _animation.value,
                  needleColor: Colors.black,
                  knobStyle: const KnobStyle(color: Colors.black),
                )
              ],
              annotations: <GaugeAnnotation>[
                GaugeAnnotation(
                  widget: Text(
                    '${_animation.value.toStringAsFixed(1)} km/h',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  angle: 90,
                  positionFactor: 0.8,
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
