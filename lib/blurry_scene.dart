import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class BlurryScreen extends StatefulWidget {
  const BlurryScreen({super.key});

  @override
  State<BlurryScreen> createState() => _BlurryScreenState();
}

class _BlurryScreenState extends State<BlurryScreen>
    with SingleTickerProviderStateMixin {
  AnimationController? controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 556),
      upperBound: 1.3,
      // lowerBound: 1.1,
    );

    controller!.forward();
  }

  @override
  void dispose() {
    super.dispose();
    controller!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: controller!,
        child: Scaffold(
          backgroundColor: Colors.purple,
          body: InkWell(
            onTap: () {
              controller!
                  .reverse()
                  .then((value) => Navigator.of(context).pop());
            },
            child: Container(
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(100)),
            ),
          ),
          // floatingActionButton:
          //     Center(child: FloatingActionButton(onPressed: () {
          //   controller!
          //       .reverse()
          //       .then((value) => Navigator.of(context).pop());
          // })),
        ),
        builder: (context, child) {
          return ClipPath(
            clipper: MyClipper(controller?.value),
            child: child,
          );
        });
  }
}

class MyClipper extends CustomClipper<Path> {
  double? value;
  MyClipper(this.value);

  @override
  Path getClip(Size size) {
    var path = Path();
    path.addOval(Rect.fromCircle(
        center: Offset(size.width, size.height), radius: value! * size.height));
    // path.addOval(
    //     Rect.fromLTWH(0, 0, value! * size.width, value! * size.height));

    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}
