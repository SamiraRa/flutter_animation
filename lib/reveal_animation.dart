import 'package:circular_reveal_animation/circular_reveal_animation.dart';
import 'package:flutter/material.dart';

class CircularRevealScreen extends StatefulWidget {
  const CircularRevealScreen({super.key});

  @override
  State<CircularRevealScreen> createState() => _CircularRevealScreenState();
}

class _CircularRevealScreenState extends State<CircularRevealScreen>
    with SingleTickerProviderStateMixin {
  AnimationController? controller;
  Animation<double>? animation;
  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 556),
      // upperBound: 1.3,
      // lowerBound: 1.1,
    );
    animation = CurvedAnimation(parent: controller!, curve: Curves.easeIn);

    // controller!.forward();
  }

  @override
  void dispose() {
    super.dispose();
    controller!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: InkWell(
        onTap: () {
          if (animation!.status == AnimationStatus.forward ||
              animation!.status == AnimationStatus.completed) {
            controller!.reverse();
          } else {
            controller!.forward();
          }
        },
        child: CircularRevealAnimation(
          animation: animation!,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Center(
                child: FlutterLogo(
                  size: 200,
                ),
              ),
              TextButton(
                  onPressed: () {
                    if (animation!.status == AnimationStatus.forward ||
                        animation!.status == AnimationStatus.completed) {
                      controller!.reverse();
                    } else {
                      controller!.forward();
                    }
                  },
                  child: Text(""))
            ],
          ),
        ),
      ),
    );
  }
}
