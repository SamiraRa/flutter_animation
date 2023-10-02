import 'dart:math';

import 'package:circular_clip_route/circular_clip_route.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_confetti/blurry_scene.dart';
import 'package:flutter_confetti/lottie_animation.dart';
import 'package:flutter_confetti/reveal_animation.dart';
import 'package:page_transition/page_transition.dart';

void main() => runApp(ConfettiSample());

class ConfettiSample extends StatelessWidget {
  const ConfettiSample({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Confetti',
        home: Scaffold(
          backgroundColor: Colors.grey[900],
          body: MyApp(),
        ));
  }
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late ConfettiController _controllerCenter;
  late ConfettiController _controllerCenterRight;
  late ConfettiController _controllerCenterLeft;
  late ConfettiController _controllerTopCenter;
  late ConfettiController _controllerBottomCenter;

  @override
  void initState() {
    super.initState();
    _controllerCenter =
        ConfettiController(duration: const Duration(seconds: 10));
    _controllerCenterRight =
        ConfettiController(duration: const Duration(seconds: 10));
    _controllerCenterLeft =
        ConfettiController(duration: const Duration(seconds: 10));
    _controllerTopCenter =
        ConfettiController(duration: const Duration(seconds: 10));
    _controllerBottomCenter =
        ConfettiController(duration: const Duration(seconds: 10));
  }

  @override
  void dispose() {
    _controllerCenter.dispose();
    _controllerCenterRight.dispose();
    _controllerCenterLeft.dispose();
    _controllerTopCenter.dispose();
    _controllerBottomCenter.dispose();
    super.dispose();
  }

  /// A custom Path to paint stars.
  Path drawStar(Size size) {
    // Method to convert degree to radians
    double degToRad(double deg) => deg * (pi / 180.0);

    const numberOfPoints = 5;
    final halfWidth = size.width / 2;
    final externalRadius = halfWidth;
    final internalRadius = halfWidth / 2.5;
    final degreesPerStep = degToRad(360 / numberOfPoints);
    final halfDegreesPerStep = degreesPerStep / 2;
    final path = Path();
    final fullAngle = degToRad(360);
    path.moveTo(size.width, halfWidth);

    for (double step = 0; step < fullAngle; step += degreesPerStep) {
      path.lineTo(halfWidth + externalRadius * cos(step),
          halfWidth + externalRadius * sin(step));
      path.lineTo(halfWidth + internalRadius * cos(step + halfDegreesPerStep),
          halfWidth + internalRadius * sin(step + halfDegreesPerStep));
    }
    path.close();
    return path;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: <Widget>[
          //CENTER -- Blast
          Align(
            alignment: Alignment.center,
            child: ConfettiWidget(
              confettiController: _controllerCenter,
              blastDirectionality: BlastDirectionality
                  .explosive, // don't specify a direction, blast randomly
              shouldLoop:
                  true, // start again as soon as the animation is finished
              colors: const [
                Colors.green,
                Colors.blue,
                Colors.pink,
                Colors.orange,
                Colors.purple
              ], // manually specify the colors to be used
              createParticlePath: drawStar, // define a custom shape/path.
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: TextButton(
                onPressed: () {
                  _controllerCenter.play();
                },
                child: _display('blast\nstars')),
          ),

          //CENTER RIGHT -- Emit left
          Align(
            alignment: Alignment.centerRight,
            child: ConfettiWidget(
              confettiController: _controllerCenterRight,
              blastDirection: pi, // radial value - LEFT
              particleDrag: 0.05, // apply drag to the confetti
              emissionFrequency: 0.05, // how often it should emit
              numberOfParticles: 20, // number of particles to emit
              gravity: 0.05, // gravity - or fall speed
              shouldLoop: false,
              colors: const [
                Colors.green,
                Colors.blue,
                Colors.pink
              ], // manually specify the colors to be used
              strokeWidth: 1,
              strokeColor: Colors.white,
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
                onPressed: () {
                  _controllerCenterRight.play();
                },
                child: _display('pump left')),
          ),

          //CENTER LEFT - Emit right
          Align(
            alignment: Alignment.centerLeft,
            child: ConfettiWidget(
              confettiController: _controllerCenterLeft,
              blastDirection: 0, // radial value - RIGHT
              emissionFrequency: 0.6,
              minimumSize: const Size(10,
                  10), // set the minimum potential size for the confetti (width, height)
              maximumSize: const Size(50,
                  50), // set the maximum potential size for the confetti (width, height)
              numberOfParticles: 1,
              gravity: 0.1,
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton(
                onPressed: () {
                  _controllerCenterLeft.play();
                },
                child: _display('singles')),
          ),

          //TOP CENTER - shoot down
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _controllerTopCenter,
              blastDirection: pi / 2,
              maxBlastForce: 5, // set a lower max blast force
              minBlastForce: 2, // set a lower min blast force
              emissionFrequency: 0.05,
              numberOfParticles: 50, // a lot of particles at once
              gravity: 1,
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: TextButton(
                onPressed: () {
                  _controllerTopCenter.play();
                },
                child: _display('goliath')),
          ),
          //BOTTOM CENTER
          Align(
            alignment: Alignment.bottomCenter,
            child: ConfettiWidget(
              confettiController: _controllerBottomCenter,
              blastDirection: -pi / 2,
              blastDirectionality: BlastDirectionality.explosive,
              emissionFrequency: 0.001,
              numberOfParticles: 100,
              maxBlastForce: 70,
              minBlastForce: 50,
              gravity: 0.3,
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: TextButton(
                onPressed: () {
                  _controllerBottomCenter.play();
                },
                child: _display('hard and infrequent')),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: TextButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LottieAnimationDemo()));
                },
                child: const Text("Next Page")),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: TextButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const BlurryScreen()));
                },
                child: const Text("Second Page")),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: TextButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const CircularRevealScreen()));
                },
                child: const Text("Third Page")),
          ),
        ],
      ),
    );
  }

  Text _display(String text) {
    return Text(
      text,
      style: const TextStyle(color: Colors.white, fontSize: 20),
    );
  }
}

// -----------------------------------------------------------------------------------------------------------------------------------
// -----------------------------------------------------------------------------------------------------------------------------------
// -----------------------------------------------------------------------------------------------------------------------------------
// -----------------------------------------------------------------------------------------------------------------------------------
// -----------------------------------------------------------------------------------------------------------------------------------
// -----------------------------------------------------------------------------------------------------------------------------------
// -----------------------------------------------------------------------------------------------------------------------------------
// -----------------------------------------------------------------------------------------------------------------------------------

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: CircularTransitionScreen(),
//     );
//   }
// }

// class CircularTransitionScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Circular Transition Example'),
//       ),
//       body: GestureDetector(
//         onTapDown: (TapDownDetails details) {
//           print(details.globalPosition);
//           _startCircularTransition(context, details.localPosition);
//         },
//         child: Container(
//           color: Colors.blue,
//           child: Center(
//             child: Text(
//               'Tap anywhere',
//               style: TextStyle(color: Colors.white),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   void _startCircularTransition(BuildContext context, Offset tapPosition) {
//     Navigator.of(context).push(
//       PageTransition(
//         type: PageTransitionType
//             .scale, // Use the rightToLeftWithFade transition type
//         alignment: Alignment.center,
//         duration: Duration(seconds: 1),
//         child: CircularTransitionPageRoute(tapPosition: tapPosition),
//       ),
//     );
//   }
// }

// class CircularTransitionPageRoute extends StatelessWidget {
//   final Offset tapPosition;

//   CircularTransitionPageRoute({required this.tapPosition});

//   @override
//   Widget build(BuildContext context) {
//     final screenSize = MediaQuery.of(context).size;
//     final maxDiameter = screenSize.width > screenSize.height
//         ? screenSize.width
//         : screenSize.height;

//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Circular Transition Page'),
//       ),
//       body: Center(
//         child: Container(
//           width: maxDiameter,
//           height: maxDiameter,
//           decoration: BoxDecoration(
//             shape: BoxShape.circle,
//             color: Colors.blue,
//           ),
//           child: Center(
//             child: Text(
//               'This is the circular transition page',
//               style: TextStyle(color: Colors.white),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
