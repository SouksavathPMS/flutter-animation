import 'dart:math';

import 'package:flutter/material.dart';

class Example7 extends StatefulWidget {
  const Example7({super.key});

  @override
  State<Example7> createState() => _Example7State();
}

class _Example7State extends State<Example7> with TickerProviderStateMixin {
  late AnimationController _sidesController;
  late AnimationController _radiusController;
  late AnimationController _rotationController;
  late Animation _sideAnimation;
  late Animation _radiusAnimation;
  late Animation _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _sidesController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );
    _sideAnimation = IntTween(
      begin: 3,
      end: 20,
    ).animate(_sidesController);

    _radiusController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );
    _radiusAnimation = Tween(
      begin: 20.0,
      end: 400.0,
    )
        .chain(
          CurveTween(curve: Curves.bounceInOut),
        )
        .animate(_radiusController);

    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );
    _rotationAnimation = Tween(
      begin: 0.0,
      end: 2 * pi,
    )
        .chain(
          CurveTween(curve: Curves.easeInOut),
        )
        .animate(_rotationController);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _sidesController.repeat(reverse: true);
    _radiusController.repeat(reverse: true);
    _rotationController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _sidesController.dispose();
    _radiusController.dispose();
    _rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedBuilder(
        animation: Listenable.merge([
          _sidesController,
          _radiusController,
          _rotationController,
        ]),
        builder: (context, child) {
          return Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..rotateX(_rotationAnimation.value)
              ..rotateY(_rotationAnimation.value)
              ..rotateZ(_rotationAnimation.value),
            child: CustomPaint(
              painter: Polygon(sides: _sideAnimation.value),
              child: SizedBox(
                width: _radiusAnimation.value,
                height: _radiusAnimation.value,
              ),
            ),
          );
        },
      ),
    );
  }
}

class Polygon extends CustomPainter {
  final int sides;
  Polygon({required this.sides});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 3;
    final path = Path();
    final center = Offset(size.width / 2, size.height / 2);
    final angle = (2 * pi) / sides;
    final angles = List.generate(sides, (index) => angle * index);
    final radius = size.width / 2;

    path.moveTo(
      center.dx + radius * cos(0),
      center.dy + radius * sin(0),
    );

    for (final angle in angles) {
      path.lineTo(
        center.dx + radius * cos(angle),
        center.dy + radius * sin(angle),
      );
    }

    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) =>
      oldDelegate is Polygon && oldDelegate.sides != sides;
}
