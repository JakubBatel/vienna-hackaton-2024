import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'dart:math' as math;
import 'package:flutter_svg/flutter_svg.dart';

class Accelerometer extends StatefulWidget {
  const Accelerometer({super.key});

  @override
  State<Accelerometer> createState() => _AccelerometerState();
}

class _AccelerometerState extends State<Accelerometer> {
  List<AccelerometerEvent> _accelerometerValues = [];
  late StreamSubscription<AccelerometerEvent> _accelerometerSubscription;
  double _rotation = 0.0;

  @override
  void initState() {
    super.initState();

    _accelerometerSubscription = accelerometerEvents.listen((event) {
      setState(() {
        _accelerometerValues = [event];
        _updateRotation(event.y);
      });
    });
  }

  void _updateRotation(double yValue) {
    // Convert accelerometer data to rotation angle
    // Adjust the multiplier to control sensitivity
    _rotation = yValue * 0.5;

    // Limit rotation to a maximum of 45 degrees in either direction
    _rotation = _rotation.clamp(-math.pi / 4, math.pi / 4);
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
        title: const Text('Oida'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Transform.rotate(
              angle: _rotation,
              child: SvgPicture.asset(
                'assets/EggCharacter01.svg',
                width: 200,
                height: 200,
              ),
            ),
            const SizedBox(height: 20),
            if (_accelerometerValues.isEmpty)
              const Text('No accelerometer data available', style: TextStyle(fontSize: 14, color: Colors.red)),
          ],
        ),
      ),
    );
  }
}
