import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import '../models/speed_model.dart';

class RadialSpeedometer extends StatelessWidget {
  final SpeedModel speedModel;

  const RadialSpeedometer({super.key, required this.speedModel});

  @override
  Widget build(BuildContext context) {
    return SfRadialGauge(
      enableLoadingAnimation: true,
      animationDuration: 1000,
      axes: <RadialAxis>[
        RadialAxis(
          minimum: 0,
          maximum: 200,
          axisLineStyle: const AxisLineStyle(
            thickness: 20,
            cornerStyle: CornerStyle.bothFlat,
          ),
          ranges: <GaugeRange>[
            GaugeRange(
              startValue: 0,
              endValue: 60,
              color: Colors.green,
              startWidth: 20,
              endWidth: 20,
            ),
            GaugeRange(
              startValue: 60,
              endValue: 120,
              color: Colors.orange,
              startWidth: 20,
              endWidth: 20,
            ),
            GaugeRange(
              startValue: 120,
              endValue: 200,
              color: Colors.red,
              startWidth: 20,
              endWidth: 20,
            ),
          ],
          pointers: <GaugePointer>[
            NeedlePointer(
              value: speedModel.speed,
              enableAnimation: true,
              animationType: AnimationType.easeOutBack,
              needleColor: Colors.black,
              knobStyle: const KnobStyle(
                color: Colors.white,
                borderColor: Colors.black,
                borderWidth: 2,
              ),
            )
          ],
          annotations: <GaugeAnnotation>[
            GaugeAnnotation(
              widget: Text(
                speedModel.formattedSpeed,
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
  }
}
