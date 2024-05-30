import 'dart:math' show pi;

import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' show Vector3;

class Example3 extends StatefulWidget {
  const Example3({super.key});

  @override
  State<Example3> createState() => _Example3State();
}

class _Example3State extends State<Example3> with TickerProviderStateMixin {
  late AnimationController _xController;
  late AnimationController _yController;
  late AnimationController _zController;
  late Tween<double> _animation;

  final widthAndHeight = 100.0;

  @override
  void initState() {
    _xController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    );
    _yController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 30),
    );
    _zController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 40),
    );

    _animation = Tween<double>(
      begin: 0,
      end: 2 * pi,
    );
    super.initState();
  }

  @override
  void dispose() {
    _xController.dispose();
    _yController.dispose();
    _zController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _xController
      ..reset()
      ..repeat();
    _yController
      ..reset()
      ..repeat();
    _zController
      ..reset()
      ..repeat();
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: widthAndHeight,
            width: double.infinity,
          ),
          AnimatedBuilder(
            animation: Listenable.merge([
              _xController,
              _yController,
              _zController,
            ]),
            builder: (context, child) => Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()
                ..rotateX(_animation.evaluate(_xController))
                ..rotateY(_animation.evaluate(_yController))
                ..rotateZ(_animation.evaluate(_zController)),
              child: Stack(
                children: [
                  // Back
                  Container(
                    width: widthAndHeight,
                    height: widthAndHeight,
                    color: Colors.red,
                  ),
                  // Left
                  Transform(
                    alignment: Alignment.centerLeft,
                    transform: Matrix4.identity()..rotateY(pi / 2),
                    child: Container(
                      width: widthAndHeight,
                      height: widthAndHeight,
                      color: Colors.purple,
                    ),
                  ),
                  // Right
                  Transform(
                    alignment: Alignment.centerRight,
                    transform: Matrix4.identity()..rotateY(-(pi / 2)),
                    child: Container(
                      width: widthAndHeight,
                      height: widthAndHeight,
                      color: Colors.blue,
                    ),
                  ),
                  // Botton
                  Transform(
                    alignment: Alignment.bottomCenter,
                    transform: Matrix4.identity()..rotateX(pi / 2),
                    child: Container(
                      width: widthAndHeight,
                      height: widthAndHeight,
                      color: Colors.amber,
                    ),
                  ),
                  // Top
                  Transform(
                    alignment: Alignment.topCenter,
                    transform: Matrix4.identity()..rotateX(-(pi / 2)),
                    child: Container(
                      width: widthAndHeight,
                      height: widthAndHeight,
                      color: Colors.brown,
                    ),
                  ),
                  // Front
                  Transform(
                    transform: Matrix4.identity()
                      ..translate(Vector3(0, 0, -widthAndHeight)),
                    child: Container(
                      width: widthAndHeight,
                      height: widthAndHeight,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
