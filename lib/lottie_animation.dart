import 'dart:async';
import 'dart:math';

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_confetti/blurry_scene.dart';
import 'package:flutter_confetti/utils/constant.dart';
import 'package:lottie/lottie.dart';

class LottieAnimationDemo extends StatefulWidget {
  const LottieAnimationDemo({super.key});

  @override
  State<LottieAnimationDemo> createState() => _LottieAnimationDemoState();
}

class _LottieAnimationDemoState extends State<LottieAnimationDemo>
    with SingleTickerProviderStateMixin {
  late ConfettiController _controllerBottomCenter;
  late AnimationController controller;

  @override
  void initState() {
    super.initState();
    _controllerBottomCenter =
        ConfettiController(duration: const Duration(seconds: 10));
    controller =
        AnimationController(duration: Duration(seconds: 4), vsync: this);
    Timer(Duration(seconds: 1), () {
      _controllerBottomCenter.play();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          InkWell(
            onTapDown: (details) {
              offSet = details.localPosition;
              Navigator.push(
                  context,
                  PageRouteBuilder(
                      opaque: false,
                      pageBuilder: (context, animation, secondaryAnimation) {
                        return const BlurryScreen();
                      }));
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Lottie.asset("assets/giftbox2.json", controller: controller,
                    onLoaded: (p0) {
                  controller.forward();
                }),
              ],
            ),
          ),
          Positioned(
            child: Align(
              alignment: Alignment.center,
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
          ),
        ],
      ),
      // floatingActionButton: Center(
      //   child: FloatingActionButton(
      //     onPressed: () {
      //       Navigator.push(
      //           context,
      //           PageRouteBuilder(
      //               opaque: false,
      //               pageBuilder: (context, animation, secondaryAnimation) =>
      //                   const BlurryScreen()));
      //     },
      //   ),
      // ),
    );
  }
}
