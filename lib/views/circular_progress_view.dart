import 'package:flutter/material.dart';
import 'package:usuario_inri/constants/constants.dart';
import 'package:usuario_inri/widgets/circle_progress.dart';

class CircularProgress extends StatefulWidget {
  const CircularProgress({super.key});

  @override
  State<CircularProgress> createState() => _CircularProgressState();
}

class _CircularProgressState extends State<CircularProgress> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> animation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 6000),
    );
    //..repeat(reverse: true);

    animation = Tween<double>(begin: 0.0, end: 6.28).animate(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Center(
        child: AnimatedBuilder(
          animation: animation,
          builder: (context, child) {
            return Stack(
              children: [
                CustomPaint(
                  size: const Size(250, 250),
                  painter: CustomCircleWidget(AppConstants.redColor, 1.1 + animation.value),
                ),
                CustomPaint(
                  size: const Size(250, 250),
                  painter: CustomCircleWidget(AppConstants.yellowColor, 1.5 * animation.value),
                ),
                CustomPaint(
                  size: const Size(250, 250),
                  painter: CustomCircleWidget(AppConstants.greenColor, 2.0 * animation.value),
                ),
                CustomPaint(
                  size: const Size(250, 250),
                  painter: CustomCircleWidget(AppConstants.blueColor, 2.5 * animation.value),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
