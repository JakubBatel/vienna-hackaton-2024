import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';

class Accelerometer extends StatefulWidget {
  const Accelerometer({super.key});

  @override
  State<Accelerometer> createState() => _AccelerometerState();
}

class _AccelerometerState extends State<Accelerometer> {
  List<AccelerometerEvent> _accelerometerValues = [];
  late StreamSubscription<AccelerometerEvent> _accelerometerSubscription;
  String _tiltDirection = 'Center';

  @override
  void initState() {
    super.initState();

    _accelerometerSubscription = accelerometerEvents.listen((event) {
      setState(() {
        _accelerometerValues = [event];
        _updateTiltDirection(event.y);
      });
    });
  }

  void _updateTiltDirection(double yValue) {
    const double threshold = 1.0;

    if (yValue > threshold) {
      _tiltDirection = 'Right';
    } else if (yValue < -threshold) {
      _tiltDirection = 'Left';
    } else {
      _tiltDirection = 'Center';
    }
  }

  @override
  void dispose() {
    _accelerometerSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tilt Detection Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Tilt Direction:',
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 10),
            Text(
              _tiltDirection,
              style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const Text(
              'Accelerometer Data:',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            if (_accelerometerValues.isNotEmpty)
              Text(
                'X: ${_accelerometerValues[0].x.toStringAsFixed(2)}, '
                'Y: ${_accelerometerValues[0].y.toStringAsFixed(2)}, '
                'Z: ${_accelerometerValues[0].z.toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 14),
              )
            else
              const Text('No data available', style: TextStyle(fontSize: 14)),
          ],
        ),
      ),
    );
  }
}
