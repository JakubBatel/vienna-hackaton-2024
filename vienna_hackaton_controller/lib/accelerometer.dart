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
  late StreamSubscription<AccelerometerEvent> _accelerometerSubscription;
  late AnimationController _animationController;
  double _targetRotation = 0.0;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _accelerometerSubscription = accelerometerEvents.listen((event) {
      _updateRotation(event.y);
    });
  }

  void _updateRotation(double yValue) {
    _targetRotation = yValue * 0.5;
    _targetRotation = _targetRotation.clamp(-math.pi / 4, math.pi / 4);
    _animationController.animateTo(
      (_targetRotation + math.pi / 4) / (math.pi / 2),
      curve: Curves.easeInOut,
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
      body: Stack(
        fit: StackFit.expand,
        children: [
          SvgPicture.asset(
            'assets/Background-Phone_OIDA.svg',
            fit: BoxFit.cover,
          ),
          Center(
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
                const SizedBox(height: 40),
                SvgPicture.asset(
                  'assets/Sun_collectible.svg',
                  width: 40,
                  height: 40,
                ),
                const Text(
                  '2/5',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    color: Color(0xFF25326E),
                  ),
                ),
                // const SizedBox(height: 20),
                // if (_accelerometerValues.isEmpty)
                //   const Text(
                //     'No accelerometer data available',
                //     style: TextStyle(fontSize: 14, color: Colors.red),
                //   ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
