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

class _AccelerometerState extends State<Accelerometer> with SingleTickerProviderStateMixin {
  List<AccelerometerEvent> _accelerometerValues = [];
  late StreamSubscription<AccelerometerEvent> _accelerometerSubscription;
  late AnimationController _animationController;
  double _targetRotation = 0.0;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200), // Adjust this value to change animation speed
    );

    _accelerometerSubscription = accelerometerEvents.listen((event) {
      _updateRotation(event.y);
    });
  }

  void _updateRotation(double yValue) {
    // Convert accelerometer data to rotation angle
    // Adjust the multiplier to control sensitivity
    _targetRotation = yValue * 0.5;

    // Limit rotation to a maximum of 45 degrees in either direction
    _targetRotation = _targetRotation.clamp(-math.pi / 4, math.pi / 4);

    // Animate to the new rotation
    _animationController.animateTo(
      (_targetRotation + math.pi / 4) / (math.pi / 2),
      curve: Curves.easeOut,
    );
  }

  @override
  void dispose() {
    _accelerometerSubscription.cancel();
    _animationController.dispose();
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
            AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return Transform.rotate(
                  angle: _animationController.value * math.pi / 2 - math.pi / 4,
                  child: child,
                );
              },
              child: SvgPicture.asset(
                'assets/EggCharacter01.svg',
                width: 200,
                height: 200,
              ),
            ),
            const SizedBox(height: 20),
            // if (_accelerometerValues.isEmpty)
            //   const Text('No accelerometer data available', style: TextStyle(fontSize: 14, color: Colors.red)),
          ],
        ),
      ),
    );
  }
}
